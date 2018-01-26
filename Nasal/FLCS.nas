###################################################################################
##                                                                               ##
## TECH-DEMO-01 Flight Control System (FLCS)                                     ##
##                                                                               ##
## Author: Flightec Labs(c)                                                      ##
##                                                                               ##
## Version 1.01                                                                  ##
## License: GPL 2.0                                                              ##
###################################################################################

var MODULE_NAME = "Flight Control System (FLCS)";
var tTimer = 0;

var getModuleName = func()
{
    return MODULE_NAME;
}

var Init = func() 
{
    tTimer = maketimer(0.05, timerSignalHandler);
    tTimer.start();

    return 1;
}

var timerSignalHandler = func()
{
    # wing slats are driven by inlet ramp values (to be fixed)
    setprop("surface-positions/l-ramp1-position-norm", getprop("fdm/jsbsim/propulsion/inlet/l-ramp1-position-deg") / 16.0);
    setprop("surface-positions/r-ramp1-position-norm", getprop("fdm/jsbsim/propulsion/inlet/r-ramp1-position-deg") / 16.0);

    #print("FLCS: l-ramp1-position-norm: ", getprop("surface-positions/l-ramp1-position-norm"));
    #print("FLCS: r-ramp1-position-norm: ", getprop("surface-positions/r-ramp1-position-norm"));


    return 1;
}
