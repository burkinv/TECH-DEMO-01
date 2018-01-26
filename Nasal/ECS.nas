###################################################################################
##                                                                               ##
## TECH-DEMO-01 Engine Control System (ECS)                                      ##
##                                                                               ##
## Author: Flightec Labs(c)                                                      ##
##                                                                               ##
## Version 1.01                                                                  ##
## License: GPL 2.0                                                              ##
###################################################################################

var MODULE_NAME = "Engine Control System (ECS)";
var tTimer = 0;

var getModuleName = func()
{
    return MODULE_NAME;
}

var Init = func() 
{
    setprop("engines/engine[0]/augmentation-burner", 0);
    setprop("engines/engine[0]/afterburner", 0);

    #setlistener("/controls/engines/engine[0]/throttle", throttleSignalHandler, 1);
    tTimer = maketimer(0.1, timerSignalHandler);
    tTimer.start();

    return 1;
}

var throttleSignalHandler = func(throttle)
{
	throttleValue = throttle.getValue();

    augmentationBurnerValue = getprop("engines/engine[0]/augmentation-burner");
    print("ECS: engine[0] augmentation-burner: ", augmentationBurnerValue);

    afterburnerValue = getprop("engines/engine[0]/afterburner");
    print("ECS: engine[0] afterburner: ", afterburnerValue);

 
    if  (throttleValue >= 0.95)
    {
        if (augmentationBurnerValue == 0)
        {
            setprop("engines/engine[0]/augmentation-burner", 10);
            #print("ECS: engine[0] augmentation-burner 1 ");
        }      
        if (afterburnerValue == 0)
        {
            setprop("engines/engine[0]/afterburner", 5);
            #print("ECS: engine[0] afterburner 1 ");
        }      
    }
    else
    {
        if (augmentationBurnerValue == 10)
        {
            setprop("engines/engine[0]/augmentation-burner", 0);
            #print("ECS: engine[0] augmentation-burner 0 ");
        }
        if (afterburnerValue == 5)
        {
            setprop("engines/engine[0]/afterburner", 0);
            #print("ECS: engine[0] afterburnerValue 0 ");
        }
    }

    return 1;
}


var timerSignalHandler = func()
{
    setprop("engines/engine[0]/PB",getprop("fdm/jsbsim/propulsion/engine[0]/PB"));
    #setprop("engines/engine[1]/PB",getprop("fdm/jsbsim/propulsion/engine[1]/PB"));

    setprop("engines/engine[0]/afterburner", getprop("fdm/jsbsim/propulsion/engine[0]/augmentation-alight"));
    #setprop("engines/engine[1]/afterburner", getprop("fdm/jsbsim/propulsion/engine[1]/augmentation-alight"));
    setprop("engines/engine[0]/augmentation-burner", getprop("fdm/jsbsim/propulsion/engine[0]/augmentation-burner"));
    #setprop("engines/engine[1]/augmentation-burner", getprop("fdm/jsbsim/propulsion/engine[1]/augmentation-burner"));

    #fterburnerValue = getprop("engines/engine[0]/afterburner");
    #augmentationBurnerValue = getprop("engines/engine[0]/augmentation-burner");

    #print("ECS: engine[0] afterburner: ", afterburnerValue);
    #print("ECS: engine[0] augmentation-burner: ", augmentationBurnerValue);


    return 1;
}

