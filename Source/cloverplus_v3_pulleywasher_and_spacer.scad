
$fs = 0.5;
$fa = 0.5;
//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 Pullerywasher & 5mm spacer by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 

cloverplus_v3_pulleywasher_and_spacer();

module cloverplus_v3_pulleywasher_and_spacer()
{
  //------------------------- 
  // Variables
  //------------------------- 
  
  // Pulley washer
  large_d = 30;
  small_d = 14;
  large_thick = 1;
  small_thick = 0.2;
  hole_d = 5;
  
  // Spacer
  spacer_outer_d = 8;
  spacer_inner_d = 5.2;
  spacer_height = 7;
  
  
  //------------------------- 
  // Instantiation
  //------------------------- 
  
  translate([0,0,large_thick*0.5])
    pulleywasher(large_d, small_d, large_thick, small_thick, hole_d);
  translate([-large_d-2,0,large_thick*0.5])
    pulleywasher(large_d, small_d, large_thick, small_thick, hole_d);
  translate([large_d*0.5+spacer_outer_d*0.5+2,0,spacer_height*0.5])
    spacer(spacer_outer_d, spacer_inner_d, spacer_height);
  
  //------------------------- 
  // Module
  //------------------------- 
  
  module pulleywasher(large_d, small_d, large_thick, small_thick, hole_d)
  {
    difference()
    {
      union()
      {
        cylinder(h=large_thick, d=large_d, center=true);
        translate([0,0,small_thick*0.5])
          cylinder(h=small_thick+large_thick, d=small_d, center=true);
      }
      cylinder(h=large_thick*2, d=hole_d, center=true);
    }
  }
  
  module spacer(outer_d, inner_d, height)
  {
    difference()
    {
      cylinder(h=height, d=outer_d, center=true);
      cylinder(h=height+0.2, d=inner_d, center=true);
    }
  }
}
