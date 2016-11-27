include <cloverplus_v3_utils.scad>;
//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 railstop by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
// This part prevents the rail carriage from slding off of the linear rails - 6 are needed
//---------------------------------------------------------------------------------------------------- 

$fs = 0.25;
$fa = 0.25;

cloverplus_v3_railstop();

module cloverplus_v3_railstop()
{
  nutplate_hole_spacing = 10;
  rail_to_end_spacing = 5;
  length = nutplate_hole_spacing;
  width = rail_w;
  thick = rail_railcar_t - 1;
  corner_r = 2;
  // For M3 x 4mm screws
  m3_socket_depth = 7;

  difference()
  {
    rotate([90,0,0])
      // Only one side should be rounded - extrusion side should be flat
      hull()
      {
        smooth_block(width, thick, length, corner_r);
        translate([0, -thick*0.25, 0])
          cube([width, thick*0.5, length], center=true);
      }

    cylinder(h=thick+ff, d=m3_hole_d, center=true);
    translate([0,0, thick*0.5-m3_socket_depth*0.5])
      cylinder(h=m3_socket_depth+ff, d=m3_socket_inset_d, center=true);
  }
  
}
