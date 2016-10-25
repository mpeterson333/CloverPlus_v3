include <cloverplus_v3_utils.scad>;
$fs = 0.5;
$fa = 0.5;
//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 power supply zip-tie mount by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
cloverplus_v3_ps_mount();

module cloverplus_v3_ps_mount()
{
  //------------------------- 
  // Variables
  //------------------------- 
  
  // Base thickness and width
  base_t = 6;
  base_w = 20;
  
  // Power supply sizing 

  // 12V 6A brick from ebay or amazon
  ps_l = 132;
  ps_w = 58;
  
  // 24V 5A brick from ebay or aazon
  //ps_l = 165;
  //ps_w = 65;
  
  base_x_ratio = 0.7;
  
  // Base length depends on power supply length
  base_l = ps_l*base_x_ratio;
  
  arm_mount_off = 1;
  arm_w = 15;
  arm_l = ps_w;
  
  // Frame connect
  fc_h = 11;
  fc_t = 6;
  // bottom frame connection point
  fc_inner_gap = leg_connector_thick*2 + leg_connector_setback*2 + 0.3;
  fc_w = base_w;
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
          cube([base_l, base_w, base_t], center=true);
  
        for(i=[-1,1])
        {
          // Arms with ziptie slots
          translate([i*(base_l*0.5-arm_w*0.5),0,0])
            difference()
            {
              cube([arm_w, arm_l, base_t], center=true);
              for(j=[-1,1])
                translate([0,j*(arm_l-ziptie_slot_depth+ff)*0.5,0])
                  cube([ziptie_slot_w, ziptie_slot_depth+ff, base_t*2], center=true);
            }
  
          // Frame connection with nuttrap and screw holes
          translate([i*(fc_t+fc_inner_gap)*0.5, fc_off, fc_h*0.5+base_t*0.5])
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
