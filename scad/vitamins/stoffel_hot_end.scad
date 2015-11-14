//
// Mendel90
//

include <../conf/config.scad>



nozzle_h = 5;

resistor_len = 22;
resistor_dia = 6;

heater_width  = 16;
heater_length = 20;
heater_height = 11.5;

heater_x = 4.5;
heater_y = heater_width / 2;



module stoffelv2_nozzle(type) {
    color("gold")
    difference() {
        union() {
            //cylinder(r1=1.3/2, r2=3/2, h=2);
            translate([0, 0, 2]) cylinder(r = 8/2, h=nozzle_h-2, $fn=6);
        }
       // translate([0, 0, -eta]) cylinder(r =0.5 / 2, h=nozzle_h+ 2*eta);
    }
}


module stoffelv2_resistor(type) {
    translate([11-heater_x, -3-heater_y, heater_height/2+nozzle_h]) {
        color("grey") rotate([-90, 0, 0]) cylinder(r=resistor_dia / 2, h=resistor_len);
        color("red") translate([-3.5/2, resistor_len  + 3.5/2  +1, 0]) {
            cylinder(r=3.5 / 2, h=36);
            translate([3.5, 0, 0]) cylinder(r=3.5 / 2, h=36);
        }


    }
}

module heater_block(type) {
    translate([0, 0, -hot_end_length(type)])  {
        translate([0, 0, nozzle_h]) difference() {
            color("lightgrey") union() {
                // Heat break
                cylinder(r=2, h=heater_height + 10);
                translate([-heater_x, -heater_y, 0])  {
                    cube([heater_length, heater_width, heater_height]);
                }
            }
            //cylinder(r=3/ 2, h=heater_height + 10 + eta); // Filament hole
        }

        stoffelv2_resistor(type);
        stoffelv2_nozzle(type);
    }
}




module stoffel_hot_end(type) {
    insulator_length = hot_end_insulator_length(type);
    inset = hot_end_inset(type);
    barrel_length = hot_end_total_length(type) - insulator_length;
    cone_length = 2;
    cone_end = 1;

    vitamin(hot_end_part(type));

    translate([0, 0, inset - insulator_length]) {
        color(hot_end_insulator_colour(type)) render()
            difference() {
                cylinder(r = hot_end_insulator_diameter(type) / 2, h = insulator_length);
                cylinder(r = 3.2 / 2, h = insulator_length * 2 + 1, center = true);
                translate([0, 0, insulator_length - 4.6 - 1.75 / 2])
                    tube(ir = 13.66 / 2, or = 17 / 2, h = 1.75);
            }

        color("gold")  render() union() {
            translate([0, 0, -20])
                cylinder(r = 10.8 / 2, h = 20);

            translate([0, 0, -barrel_length + cone_length + eta]) {
                cylinder(r = 3, h = barrel_length - cone_length);
                translate([0, 0, -cone_length + eta])
                    cylinder(r1 = cone_end / 2, r = 3, h = cone_length);
            }
        }
    }
    rotate([0, 0, 90])
        translate([-nozzle_x, 0, -hot_end_length(type) + 10 -heater_height / 2]) {
            heater_block(StoffelV2);
    }
}

stoffel_hot_end(StoffelV2);
