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

var getModuleName = func()
{
    return MODULE_NAME;
}

var throttleSignalHandler = func(throttle)
{
	throttleValue = throttle.getValue();
    augmentationBurnerValue = getprop("engines/engine[0]/augmentation-burner");
    #print("ECS: engine[0] augmentation-burner: ", augmentationBurnerValue);

    afterburnerValue = getprop("engines/engine[0]/afterburner");
    #print("ECS: engine[0] afterburner: ", afterburnerValue);

 
    if  (throttleValue >= 0.95)
    {
        if (augmentationBurnerValue == 0)
        {
            setprop("engines/engine[0]/augmentation-burner", 1);
            #print("ECS: engine[0] augmentation-burner 1 ");
        }      
        if (afterburnerValue == 0)
        {
            setprop("engines/engine[0]/afterburner", 1);
            #print("ECS: engine[0] afterburner 1 ");
        }      
    }
    else
    {
        if (augmentationBurnerValue == 1)
        {
            setprop("engines/engine[0]/augmentation-burner", 0);
            #print("ECS: engine[0] augmentation-burner 0 ");
        }
        if (afterburnerValue == 1)
        {
            setprop("engines/engine[0]/afterburner", 0);
            #print("ECS: engine[0] afterburnerValue 0 ");
        }
    }

    return 1;
}

var Init = func() 
{
    setprop("engines/engine[0]/augmentation-burner", 0);
    setprop("engines/engine[0]/afterburner", 0);

    setlistener("/controls/engines/engine[0]/throttle", throttleSignalHandler, 1);  
    return 1;
}


