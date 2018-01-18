###################################################################################
##                                                                               ##
## TECH-DEMO-01 On-Board Systems Manager                                         ##
##                                                                               ##
## Author: Flightec Labs(c)                                                      ##
##                                                                               ##
## Version 1.01                                                                  ##
## License: GPL 2.0                                                              ##
###################################################################################

var AIRCRAFT_ID = "TECH-DEMO-01 ";

var Init = func() 
{
    print(AIRCRAFT_ID, "Systems Initialization...");

    if (VMS.Init())   print(AIRCRAFT_ID, VMS.getModuleName(),  "... ON") else print(AIRCRAFT_ID, VMS.getModuleName(),  "... FAILED!");
    if (FLCS.Init())  print(AIRCRAFT_ID, FLCS.getModuleName(), "... ON") else print(FAIRCRAFT_ID, LCS.getModuleName(), "... FAILED!");
    if (ECS.Init())   print(AIRCRAFT_ID, ECS.getModuleName(),  "... ON") else print(AIRCRAFT_ID, ECS.getModuleName(),  "... FAILED!");
    if (SMS.Init())   print(AIRCRAFT_ID, SMS.getModuleName(),  "... ON") else print(AIRCRAFT_ID, SMS.getModuleName(),  "... FAILED!");   
}

setlistener("sim/signals/fdm-initialized", Init);