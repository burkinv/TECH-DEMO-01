###################################################################################
##                                                                               ##
## Aircraft: TECH-DEMO-01                                                        ##
## Module: Vehicle Management System (VMS)                                       ##
## Author: Flightec Labs(c)                                                      ##
##                                                                               ##
## Version 1.01                                                                  ##
## License: GPL 2.0                                                              ##
###################################################################################


var MODULE_NAME = "Vehicle Management System (WMS)";
var NWS_light = 0;
var VMS_MAX_GEAR_COMPRESSION = 3.0;

var getModuleName = func()
{
    return MODULE_NAME;
}

var Init = func() 
{
   	#settimer (Process, 1.0);

    setlistener("fdm/jsbsim/fcs/steer-pos-deg", noseWheelSteeringHandler, 1);  
    setlistener("/controls/gear/nose-wheel-steering", noseWheelSteeringSwitchHandler, 1);  
    setlistener("gear/gear[1]/position-norm", leftGearPositionHandler, 1);  
    setlistener("gear/gear[2]/position-norm", rightGearPositionHandler, 1);  

    return 1;
}

var Process = func()
{
    return 1;
}

var noseWheelSteeringHandler = func 
{
    NWS_light = getprop("fdm/jsbsim/systems/NWS/engaged");
    setprop("controls/flight/NWS", getprop("fdm/jsbsim/fcs/steer-pos-deg")/85.0);
    #print("VMS: controls/flight/NWS updated");
    if(getprop("fdm/jsbsim/systems/holdback/launchbar-engaged"))
    {
        setprop("gear/launchbar/position-norm",1);
        setprop("gear/launchbar/state","Engaged");
        setprop("models/carrier/controls/jbd",1);
    }
    else
    {
        setprop("gear/launchbar/position-norm",0);
        setprop("gear/launchbar/state","Disengaged");
        setprop("models/carrier/controls/jbd",0);
    }

    setprop("sim/model/TECH-DEMO-01/instrumentation/gears/nose-wheel-steering-warnlight", NWS_light);
}

var noseWheelSteeringSwitchHandler = func
{
    if (getprop("fdm/jsbsim/fcs/steer-maneuver"))
    {
        gui.popupTip("Maneuver NWS disabled");
        setprop("fdm/jsbsim/fcs/steer-maneuver",0)
    }
    else
    {
        gui.popupTip("Maneuver NWS enabled");
        setprop("fdm/jsbsim/fcs/steer-maneuver",1)
    }
}

var leftGearPositionHandler = func(gearPosition)
{
    var fGearPositionValue = gearPosition.getValue();
    if (fGearPositionValue < 1.0)
    {
        setprop("/gears/l-gear-comression", (VMS_MAX_GEAR_COMPRESSION - (VMS_MAX_GEAR_COMPRESSION * fGearPositionValue)));
    }
    else
    {
        setprop("/gears/l-gear-comression", getprop("gear/gear[1]/compression-norm"));
    }
}

var rightGearPositionHandler = func(gearPosition)
{
    var fGearPositionValue = gearPosition.getValue();
    if (fGearPositionValue < 1.0)
    {
        setprop("/gears/r-gear-comression", (VMS_MAX_GEAR_COMPRESSION - (VMS_MAX_GEAR_COMPRESSION * fGearPositionValue)));
    }
    else
    {
        setprop("/gears/r-gear-comression", getprop("gear/gear[2]/compression-norm"));
    }
}