include <cloverplus_v3_utils.scad>;

//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 Bed Clamp by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
// This part secures a glass plate of about 2mm thickness to the CloverPlus 3D printer.  3 parts are 
// required to mount the bed and each part requires two M4 x 12mm screws and 2 M4 lock nuts to secure
// to the bottom frame part.
//
// Recommended glass sizing for the standard top and bottom part sizing is 115 - 120mm in diameter.
//
// Note that some variables used in this module can be found in cloverplus_v3_utils.scad.
//---------------------------------------------------------------------------------------------------- 

cloverplus_v3_bedclamp();

module cloverplus_v3_bedclamp(mockup_build = false)
{
  $fs = 0.5;
  $fa = 0.5;
  
  base_mount_hole_d = 4.4;
  slot_length = 9;
  slot_offset = 0.5;
  
  base_mount_thick = 4;
  base_mount_hole_spacing = leg_hole_y_offset * 2;
  base_mount_width = 16;
  
  glass_thick = 2;
  
  clamp_tab_length = 4;
  clamp_tab_thick = 2;
  clamp_tab_width = 10;
  
  // Flip it over for modeling
  if (mockup_build)
  {
    rotate([0, 180, 0])
      bed_clamp();
  }
  else
  {
      bed_clamp();
  }
  
  module bed_clamp()
  {
    // Bed mount
    difference()
    {
      union()
      {
        // base shape and tabs with slots
        for (i = [-1,1])
        {
          hull()
          {
            translate([i*base_mount_hole_spacing*0.5, 0, 0])
              cylinder(d=base_mount_width, h=base_mount_thick, center=true);
            translate([0, -base_mount_width*0.25, 0])
              cylinder(d=base_mount_width*0.5, h=base_mount_thick, center=true);
          }
          hull()
          {
            translate([i*base_mount_hole_spacing*0.5, 0, -base_mount_thick*0.5+clamp_tab_thick*0.5])
            {
              cylinder(d=base_mount_width, h=clamp_tab_thick, center=true);
              translate([0, base_mount_width*0.5+clamp_tab_length-clamp_tab_width*0.5, 0])
                cylinder(d=clamp_tab_width, h=clamp_tab_thick, center=true);
            }
          }
        }
      
      }
    
      // Slots
      for (i = [-1,1])
        translate([i*base_mount_hole_spacing*0.5, slot_offset, 0])
          mount_slot(base_mount_hole_d, base_mount_thick+1, slot_length, smash_comp=true, smash_comp_invert=true);
    }
  }
}
