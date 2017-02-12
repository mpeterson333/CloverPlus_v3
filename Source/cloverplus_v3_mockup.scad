include <cloverplus_v3_utils.scad>;
use <cloverplus_v3_topbottom.scad>;
use <cloverplus_v3_rail_carriage.scad>;
use <cloverplus_v3_bedclamp.scad>;
use <cloverplus_v3_effector_and_hotend_mount.scad>;

cloverplus_v3_topbottom(1, 1);


for(i = [60, 180, 300])
  rotate([0,0,i])
    translate([0, -ext_center_to_center_len, ext_len-175])
      cloverplus_v3_rail_carriage(mockup_build=true);
color("yellow")
  translate([0, 0, 17*0.5+1])
    cylinder(h=2, d=120, center=true, $fn=60);
for(i = [0, 120, 240])
  rotate([0,0,i])
    translate([0, -66.4, top_base_thick*0.5 + 2])
      cloverplus_v3_bedclamp(mockup_build = true);

translate([0, 0, 100])
  cloverplus_v3_effector_and_hotend_mount(mockup=true);
