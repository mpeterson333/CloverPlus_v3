include <cloverplus_v3_utils.scad>;
$fs = 0.5;
$fa = 0.5;
//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 extruder mount by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
// This is a bracket that mounts a PG35L extruder to the cloverplus bottom base part.
//
// Note that this part uses variables from cloverplus_v3_utils.scad
//---------------------------------------------------------------------------------------------------- 
cloverplus_v3_extruder_mount();

module cloverplus_v3_extruder_mount(mockup = false)
{

  extruder_mount_lower();

  translate([0, 20, 0])
  extruder_mount_upper();

  gap_ff = 0.2;

  mount_gap_x = extruder_mount_w - extruder_mount_t - gap_ff;
  mount_gap_y = base_width*0.5-extruder_mount_base_t*0.5-extruder_mount_t*0.5 - gap_ff;
  
  module extruder_mount_lower(mockup = false)
  {
    translate([0, 0, extruder_mount_base_t*0.5])
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
        translate([0, -base_width*0.5-extruder_mount_overhang*0.5+ff, 0])
          cube([extruder_mount_w, extruder_mount_overhang, extruder_mount_base_t], center=true);
  
        // Upright part the extruder mounts to
        difference()
        {

          union()
          {
            // Supports
            for(i = [-1,1])
              translate([i*(extruder_mount_w*0.5-extruder_mount_t*0.25), 
                         -extruder_mount_overhang*0.5-base_width*0.5, 
                         0])
                hull()
                {
                  translate([0,0, base_width*0.25])
                    cube([extruder_mount_t*0.5, extruder_mount_overhang, base_width*0.5], center=true);
                  translate([0, extruder_mount_overhang*0.5-extruder_mount_t*0.5, base_width*0.5+extruder_mount_t*0.5])
                    cube([extruder_mount_t*0.5, extruder_mount_t, base_width], center=true);
                }
            // Crossbrace
            translate([0, 
                       -extruder_mount_overhang+extruder_mount_t*0.5-base_width*0.5, 
                       base_width*0.5 - extruder_mount_t*0.25])
              cube([extruder_mount_w, extruder_mount_t, extruder_mount_t*0.5], center=true);
          }
        }
      }
      // Nuttrap for extruder upper mount attach
      translate([0, 
                 -base_width*0.5-extruder_mount_overhang*0.75, 
                 -extruder_m4_nuttrap_depth*0.5-extruder_mount_base_t*0.5])
          nuttrap(m4_hole_d, extruder_mount_t, m4_nuttrap_d, extruder_m4_nuttrap_depth, smash_comp_enable=true);

      // Screw holes for base attach
      for(i = [-1,1])
        translate([i*bottom_leg_extruder_mount_holes_spacing*0.5, 0, 0])
        {
          cylinder(h=extruder_mount_t*2, d=m4_hole_d, center=true);
          translate([0, 0, -extruder_mount_base_t*0.5-ff])
            hole_smash_comp(m4_hole_d);
        }

    }
  }

  module extruder_mount_upper()
  {
    mount_thick_mult = 2;
    difference()
    {
      union()
      {
        // Lower part of the mount
        translate([-extruder_mount_w*0.5, 0, 0])
          cube([extruder_mount_w, base_width+extruder_mount_w*0.5, extruder_mount_base_t*mount_thick_mult]);
        // Gap tab
        translate([-mount_gap_x*0.5, extruder_mount_t*0.5+gap_ff*0.5, extruder_mount_base_t*mount_thick_mult])
          cube([mount_gap_x, mount_gap_y, extruder_mount_overhang*0.25+extruder_mount_base_t*mount_thick_mult*0.75]);
        // Extruder mount
        translate([0, base_width+extruder_mount_w*0.5, extruder_mount_base_t*mount_thick_mult*0.5])
          //rotate([0, 0, -extruder_mount_angle])
            difference()
            {
              hull()
              {
                translate([0, extruder_mount_h-extruder_mount_w*0.5, 0])
                  cylinder(h=extruder_mount_base_t*mount_thick_mult, d=extruder_mount_w, center=true);
                cylinder(h=extruder_mount_base_t*mount_thick_mult, d=extruder_mount_w, center=true);
              }
              //for(i= [0, extruder_mount_screw_spacing])
              //  translate([0, extruder_mount_h-extruder_mount_w*0.5-i, extruder_mount_base_t*mount_thick_mult*0.6])
              //    rotate([180,0,0])
              translate([0, extruder_mount_h-extruder_mount_w*0.5, -extruder_mount_base_t*mount_thick_mult*0.5])
                nuttrap(m4_hole_d, extruder_mount_t*mount_thick_mult, m4_nuttrap_d, extruder_m4_nuttrap_depth, 
                          smash_comp_enable=true, membrane_bridge=0.25);
            }
      }


      translate([0, 
                 extruder_mount_t*0.5+gap_ff*0.5+mount_gap_y*0.5, 
                 extruder_mount_base_t*mount_thick_mult+extruder_mount_overhang*0.25])
        rotate([90,0,0])
          cylinder(h=mount_gap_y+ff, d=m4_hole_d, center=true);
    }
  }
}
