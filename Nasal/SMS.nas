###################################################################################
##                                                                               ##
## TECH-DEMO-01 Stores Management System (SMS)                                   ##
##                                                                               ##
## Author: Flightec Labs(c)                                                      ##
##                                                                               ##
## Version 1.01                                                                  ##
## License: GPL 2.0                                                              ##
###################################################################################

var WeaponsSet = props.globals.getNode("sim/model/TECH-DEMO-01/systems/external-loads/external-load-set");
var WeaponsWeight = props.globals.getNode("sim/model/TECH-DEMO-01/systems/external-loads/weapons-weight", 1);
var PylonsWeight = props.globals.getNode("sim/model/TECH-DEMO-01/systems/external-loads/pylons-weight", 1);
var TanksWeight = props.globals.getNode("sim/model/TECH-DEMO-01/systems/external-loads/tankss-weight", 1);

var SMS_NUM_STATIONS = 12;
var Stations = [];

var MODULE_NAME = "Stores Management System (SMS)";

var getModuleName = func()
{
    return MODULE_NAME;
}

var ext_loads_dlg = gui.Dialog.new("dialog","Aircraft/TECH-DEMO-01/Dialogs/external-loads.xml");

Station =
{
	new : func (number)
    {
		var obj = {parents : [Station] };
		obj.prop = props.globals.getNode("sim/model/TECH-DEMO-01/systems/external-loads/").getChild ("station", number , 1);
		obj.index = number;
		obj.type = obj.prop.getNode("type", 1);
		obj.bcode = 0;
        obj.set_type(getprop("payload/weight["~number~"]/selected"));
        obj.encode_length = 3; # bits for transmit
		obj.display = obj.prop.initNode("display", 0, "INT");

        # the jsb external loads from 0-9 match the indexes used here incremented by 1 as the first element
        # in jsb sim doesn't have [0]
        var propname = sprintf( "fdm/jsbsim/inertia/pointmass-weight-lbs[%d]",number);

    	obj.weight_lb = props.globals.getNode(propname , 1);

		obj.selected = obj.prop.getNode("selected",1);
		append(Station.list, obj);
        #
        # set listener to detect when stores changed and update
        setlistener("payload/weight["~obj.index~"]/selected", func(prop){
                        var v = prop.getValue();
                        obj.set_type(v);
                        if (v == "AIM-9")
                        {
                            prop.getParent().getNode("weight-lb").setValue(190);
                            prop.getParent().getNode("launched").setValue(0);
                            print("Store selected ", v);
                       }
                        elsif (v == "AIM-120")
                        {
                            prop.getParent().getNode("weight-lb").setValue(335);
                            prop.getParent().getNode("launched").setValue(0);
                            print("Store selected ", v);
                       }
                        elsif (v == "AGM-88E")
                        {
                            prop.getParent().getNode("weight-lb").setValue(783);
                            prop.getParent().getNode("launched").setValue(0);
                            print("Store selected ", v);
                        }
                        elsif (v == "AGM-114")
                        {
                            prop.getParent().getNode("weight-lb").setValue(670);
                            prop.getParent().getNode("launched").setValue(0);
                            print("Store selected ", v);
                        }
                        elsif (v == "Droptank")
                        {
                            prop.getParent().getNode("weight-lb").setValue(271);
                            print("Store selected ", v);
                        }
                        else
                        {
                            prop.getParent().getNode("weight-lb").setValue(0);
                            print("Store selected ", v);
                        }
                        updateWeights();
                        #update_wpstring();
                    });

		return obj;
	},
    set_type : func (t) 
    {
		me.type.setValue(t);
		me.bcode = 0;
		if ( t == "AIM-9" )
        {
			me.bcode = 1;
		}
        elsif ( t == "AIM-7" )
        {
			me.bcode = 2;
		} 
        elsif ( t == "AIM-120" )
        {
			me.bcode = 3;
		} 
        elsif ( t == "MK-83" )
        {
			me.bcode = 4;
		} 
        elsif ( t == "Droptank" )
        {
			me.bcode = 5; # although 5 only bit 0 will be used
		}
	},
    get_type : func ()
    {
		return me.type.getValue();	
	},
    set_display : func (n)
    {
		me.display.setValue(n);
	},
    add_weight_lb : func (t)
    {
		w = me.weight_lb.getValue();
		me.weight_lb.setValue( w + t );
	},
    set_weight_lb : func (t)
    {
		me.weight_lb.setValue(t);	
	},
    get_weight_lb : func ()
    {
		return me.weight_lb.getValue();	
	},
    get_selected : func ()
    {
		return me.selected.getBoolValue();	
	},
    set_selected : func (n)
    {
		me.selected.setBoolValue(n);
	},
    toggle_selected : func ()
    {
		me.selected.setBoolValue( !me.get_selected() );
	},
    list : [],
};

var Init = func() 
{
    if (size(Stations) == 0)
    {
        Stations = setsize([], SMS_NUM_STATIONS);

        for (var i = 0; i < size(Stations); i = i + 1)
        {
            Stations[i] = Station.new(i);
            setprop(sprintf("payload/weight[%i]/launched", i), 0);
        }        
    }

    setlistener("sim/model/TECH-DEMO-01/systems/external-loads/external-load-set", func(v)
    {
                print("External load set ",v.getValue());
                payloadSet(v.getValue());
    });


    return (size(Stations) == SMS_NUM_STATIONS);
}

var payloadSet = func(s)
{
	WeaponsSet.setValue(s);
    if ( s == "Clean" )
    {
        b_set = 0;
        setprop("payload/weight[0]/selected","none");
        setprop("payload/weight[1]/selected","none");
        setprop("payload/weight[2]/selected","none");
        setprop("payload/weight[3]/selected","none");
        setprop("payload/weight[4]/selected","none");
        setprop("payload/weight[5]/selected","none");
        #
        setprop("payload/weight[6]/selected","none");
        setprop("payload/weight[7]/selected","none");
        setprop("payload/weight[8]/selected","none");
        setprop("payload/weight[9]/selected","none");
        setprop("payload/weight[10]/selected","none");
        setprop("payload/weight[11]/selected","none");

        #setprop("consumables/fuel/tank[5]/selected",false);
        #setprop("consumables/fuel/tank[6]/selected",false);
        #setprop("consumables/fuel/tank[7]/selected",false);

    } 
    elsif ( s == "Standard Combat" )
    {
        print(s);

        b_set = 1;
        setprop("payload/weight[0]/selected","AIM-120");
        setprop("payload/weight[1]/selected","AIM-120");
        setprop("payload/weight[2]/selected","AGM-88E");
        setprop("payload/weight[3]/selected","none");
        setprop("payload/weight[4]/selected","AGM-114");
        setprop("payload/weight[5]/selected","AIM-120");
        #
        setprop("payload/weight[6]/selected","AIM-120");
        setprop("payload/weight[7]/selected","AGM-114");
        setprop("payload/weight[8]/selected","none");
        setprop("payload/weight[9]/selected","AGM-88E");
        setprop("payload/weight[10]/selected","AIM-120");
        setprop("payload/weight[11]/selected","AIM-120");

        #setprop("consumables/fuel/tank[5]/selected",false);
        #setprop("consumables/fuel/tank[6]/selected",false);
        #setprop("consumables/fuel/tank[7]/selected",false);
    } 
     
    #update_dialog_checkboxes();
	#update_wpstring();
    #arm_selector();
}

var updateWeights = func()
{
    var pw = 0;
    var ww = 0;
    var tw = 0;
    for (var payload_item=0; payload_item <= 10; payload_item = payload_item+1)
    {
        var w = getprop("payload/weight["~payload_item~"]/weight-lb");
        if (payload_item == 1 or payload_item == 9) # Pylons
            pw = pw + w;
        else if (payload_item == 1 or payload_item == 5 or payload_item == 9) # Fuel
            tw = tw + w;
        else
            ww = ww + w;
    }
    PylonsWeight.setValue(pw);
    WeaponsWeight.setValue(ww);
    TanksWeight.setValue(tw);
}
