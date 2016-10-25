include <cloverplus_v3_utils.scad>;
$fs = 0.5;
$fa = 0.5;
//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 extruder mount by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
// This is a bracket that mounts a Compact Extruder to the cloverplus bottom base part.
//
// Note that this part uses variables from cloverplus_v3_utils.scad
//---------------------------------------------------------------------------------------------------- 
cloverplus_v3_extruder_mount();

module cloverplus_v3_extruder_mount(mockup = false)
{

  extruder_mount();

  
  module extruder_mount(mockup = false)
  {
    difference()
    {
      union()
      {
        // Base mount
        hull()
          for(i = [-1,1])
            translate([i*bottom_leg_extruder_mount_holes_spacing*0.5, 0, 0])
              cylinder(h=extruder_mount_base_t, d=base_width, center=true);
  
        // overhang
        translate([0, -base_width*0.5-extruder_mount_overhang*0.5, 0])
          cube([extruder_mount_w, extruder_mount_overhang, extruder_mount_base_t], center=true);
  
        // Upright part the extruder mounts to
        rotate([0, -extruder_mount_angle, 0])
        difference()
        {

          union()
          {
            // Supports
            for(i = [-1,1])
              translate([i*(extruder_mount_w*0.5-extruder_mount_t*0.25), -extruder_mount_overhang, 0])
                hull()
                {
                  translate([0,extruder_mount_overhang-base_width-extruder_mount_t*0.5,0])
                    cube([extruder_mount_t*0.5, base_width*0.5+extruder_mount_overhang*0.5, extruder_mount_base_t], center=true);
                  translate([0, -base_width*0.5 + extruder_mount_t*0.5, base_width*0.5+extruder_mount_t*0.5])
                    cube([extruder_mount_t*0.5, extruder_mount_t, base_width], center=true);
                }
            // Upright
            translate([0, -extruder_mount_overhang, 0])
              hull()
              {
                translate([0, -base_width*0.5 + extruder_mount_t*0.5, 0])
                  cube([extruder_mount_w, extruder_mount_t, 1], center=true);
                translate([0, -base_width*0.5+extruder_mount_t*0.5, extruder_mount_t*0.5+extruder_mount_h-extruder_mount_w*0.5])
                  rotate([90,0,0])
                    cylinder(h=extruder_mount_t, d=extruder_mount_w, center=true);
            }
          }
          // Nuttraps for extruder attach
          translate([0, -extruder_mount_overhang, 0])
            for(i = [-1,1])
              translate([0, 
                         -base_width*0.5+extruder_mount_t, 
                         extruder_mount_base_t*0.5+extruder_mount_h-extruder_mount_w*0.5-extruder_mount_screw_spacing*0.5
                           +i*extruder_mount_screw_spacing*0.5])
                rotate([90,0,0])
                  nuttrap(m4_hole_d, extruder_mount_t*0.5, m4_nuttrap_d, extruder_m4_nuttrap_depth, smash_comp=false);
        }
      }
  
      // Chop off the bottom and side extras from the rotate
      translate([0, 0, -extruder_mount_base_t])
        cube([100,100,extruder_mount_base_t], center=true);
      translate([extruder_mount_w, -base_width*0.5-extruder_mount_overhang*0.5, 0])
        cube([extruder_mount_w, extruder_mount_overhang, extruder_mount_base_t], center=true);
      // Screw holes for base attach
      for(i = [-1,1])
        translate([i*bottom_leg_extruder_mount_holes_spacing*0.5, 0, 0])
        {
          cylinder(h=extruder_mount_t*2, d=m4_hole_d, center=true);
          translate([0, 0, -extruder_mount_base_t*0.5])
            hole_smash_comp(m4_hole_d);
        }
  

    }
  }
}
