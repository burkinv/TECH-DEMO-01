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

var Stations = [];

var MODULE_NAME = "Stores Management System (SMS)";

var getModuleName = func()
{
    return MODULE_NAME;
}

var Init = func() 
{
    return 1;
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
                            print("Store selected ", v);
                        }
                        elsif (v == "AIM-7")
                        prop.getParent().getNode("weight-lb").setValue(510);
                        elsif (v == "AIM-120")
                        prop.getParent().getNode("weight-lb").setValue(335);
                        elsif (v == "Droptank")
                        {
                            prop.getParent().getNode("weight-lb").setValue(271);
                        }
                        else
                            prop.getParent().getNode("weight-lb").setValue(0);
                        calculate_weights();
                        update_wpstring();
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
