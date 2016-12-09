include <cloverplus_v3_utils.scad>;
$fs = 0.5;
$fa = 0.5;
//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 vesa mount (connects to top or bottom frame connector) by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
cloverplus_v3_vesa_mount();

module cloverplus_v3_vesa_mount()
{
  //------------------------- 
  // Variables
  //------------------------- 
  
  // Base thickness and width
  mount_spacing = 75;
  mount_t = 4;
  mount_l = mount_spacing + 10;
  mount_w = 15;
  mount_hole_d = m3_hole_d;
  mount_hole_nut_d = m3_nuttrap_d;
  mount_nuttrap_depth = 2;
  mount_hole_h = mount_t - mount_nuttrap_depth;

  arm_w = 10;
  arm_l = mount_spacing + arm_w;
  
  // Frame connect
  fc_h = 11;
  fc_t = 6;
  // bottom frame connection point
  fc_inner_gap = leg_connector_thick*2 + leg_connector_setback*2 + 0.5;
  fc_w = mount_w;
  fc_hole_off = 5.5;
  fc_hole_d = 5.4;
  fc_nuttrap_d = 9.4;
  fc_nuttrap_depth = 3;
  fc_center_to_base_bottom = 37.5;
  fc_off = (fc_center_to_base_bottom - arm_l*0.5) * 0.5;
  
  ziptie_slot_w = 4.4;
  ziptie_slot_depth = 4;
  
  
  ff = 0.1;
  
  //------------------------- 
  // Instantiation
  //------------------------- 
  
  ps_mount();
  
  //------------------------- 
  // Module
  //------------------------- 
  
  module ps_mount()
  {
    difference()
    {
      union()
      {
        // Base
        translate([0, fc_off, 0])
          cube([mount_l, mount_w, mount_t], center=true);
  
        for(i=[-1,1])
        {
          // Arms with ziptie slots
          translate([i*mount_spacing*0.5, 0, 0])
            difference()
            {
              cube([arm_w, arm_l, mount_t], center=true);
              for(j=[-1,1])
                translate([0, j*mount_spacing*0.5, mount_t*0.5])
                  rotate([180,0,0])
                    nuttrap(mount_hole_d, mount_hole_h, mount_hole_nut_d, mount_nuttrap_depth, true, layer_height);
            }
  
          // Frame connection with nuttrap and screw holes
          translate([i*(fc_t+fc_inner_gap)*0.5, fc_off, fc_h*0.5+mount_t*0.5])
            difference()
            {
              cube([fc_t, fc_w, fc_h], center=true);
                translate([-fc_t*0.5+fc_nuttrap_depth*0.5-ff*0.5,0,0])
                  rotate([0,90,0])
                  {
                    cylinder(h=fc_t*2, d=fc_hole_d, center=true);
                    if (i == 1)
                      translate([0, 0, fc_t*0.5+ff])
                      rotate([0,0,30])
                        cylinder(h=fc_nuttrap_depth, d=fc_nuttrap_d, $fn=6, center=true);
                  }
            }
        }
      }
    }
  }
}
