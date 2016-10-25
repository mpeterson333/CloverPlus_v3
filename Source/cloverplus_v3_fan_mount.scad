$fs = 0.5;
$fa = 0.5;
//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 fan mount by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
// These parts attach a 100mm or 120mm PC case fan to the side of the printer for part cooling 
// purposes.
//---------------------------------------------------------------------------------------------------- 


cloverplus_v3_fan_mount();

module cloverplus_v3_fan_mount()
{
  // This is the link that connects the fanmount to the frame.
  // It secures via an M5 screw on the frame side and a M3 screw on the fan side
  // Default screw size is M5 x 20mm and M3 x 16mm
  link_length = 20;
  link_height = 10.5;
  link_thick = 5;
  
  link_hole1_d = 5.4;
  link_hole2_d = 3.6;
  
  // Change this as needed
  // Hole spacing (for 100mm PC case fan)
  fanmount_length = 91;
  // Hole spacing (for 120mm PC case fan)
  //fanmount_length = 105;
  
  
  fanmount_height = 12;
  fanmount_thick = 5;
  fanmount_hole_d = 4.6;
  fanmount_link_offset = 0;
  fanmount_link_height = 6;
  fanmount_link_width = 12;
  fanmount_link_thick = 5;
  fanmount_link_hole_d = 3.4;
  fanmount_y_offset = -8;
  
  fanmount();
  
  translate([0,20,0])
    link();
  
  
  module fanmount()
  {
    difference()
    {
      union()
      {
        // Fan mount body
        for(i=[-1,1])
          hull()
          {
            cylinder(d=fanmount_height, h=fanmount_thick, center=true);
            translate([i*fanmount_length*0.5, 0, 0])
              cylinder(d=fanmount_height, h=fanmount_thick, center=true);
            translate([i*fanmount_length*0.5, fanmount_y_offset, 0])
              cylinder(d=fanmount_height, h=fanmount_thick, center=true);
          }
      }
      // Minus fan mount holes
      for(i=[-1,1])
        translate([i*fanmount_length*0.5, fanmount_y_offset, 0])
          cylinder(d=fanmount_hole_d, h=fanmount_thick+0.2, center=true);
    }
  
    // Fan mount to link connection
    translate([fanmount_link_offset+fanmount_link_thick*0.5, 
               0, 
               fanmount_link_thick*0.5+fanmount_link_height*0.5])
    {
      difference()
      {
        // Vertical part
        union()
        {
          cube([fanmount_link_thick, fanmount_link_width, fanmount_link_height], center=true);
          translate([0,0,fanmount_link_height*0.5])
          rotate([0,90,0])
            cylinder(h=fanmount_link_thick, d=fanmount_link_width, center=true);
        }
        // Minus hole
        translate([0,0,fanmount_link_height*0.5])
          rotate([0,90,0])
            cylinder(h=fanmount_link_thick+0.2, d=fanmount_link_hole_d, center=true);
      }
    }
  }
  
  
  module link()
  {
    difference()
    {
      // Link body
      hull()
      {
        for(i=[-1,1])
          translate([i*link_length*0.5, 0, 0])
            cylinder(d=link_height, h=link_thick, center=true);
      }
      // Mount holes
      translate([-link_length*0.5, 0, 0])
        cylinder(d=link_hole1_d, h=link_thick+0.2, center=true);
      translate([link_length*0.5, 0, 0])
        cylinder(d=link_hole2_d, h=link_thick+0.2, center=true);
    }
  }
}
