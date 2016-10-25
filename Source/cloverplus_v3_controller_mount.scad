include <cloverplus_v3_utils.scad>;
$fs = 0.5;
$fa = 0.5;

//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 Controller Mount by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
// This part provides mounting brackets that attach a controller board to the top of the printer
// frame.
//
//---------------------------------------------------------------------------------------------------- 

cloverplus_v3_controller_mount();

module cloverplus_v3_controller_mount()
{
  //------------------------- 
  // Variables
  // 
  // Note: Comment / Uncomment controller profiles to generate desired controller mount
  //------------------------- 
  
  // frame mount parameters
  mount_hole_d = 4.4;
  mount_hole_spacing = 28;
  mount_outer_hole_d = mount_hole_d + 4;
  mount_outer_hole_depth = 3;
  mount_height = 3;
  mount_total_height = mount_height + mount_outer_hole_depth;
  
  mount_length = mount_hole_spacing + mount_hole_d;
  mount_width = mount_outer_hole_d + 8;
  
  // v1 CloverPlus frame spacing
  //mount_center_spacing = 110.85;
  
  // v2 top/bottom CloverPlus frame spacing
  mount_center_spacing = 111.95;
  
  // Controller mount parameters
  controller_mount_height = 3;
  controller_mount_hole_d = 3.0;
  controller_stud_height = 12;
  controller_stud_d = 9;
  // 0 by default; only ramps uses an out-of-square mount setup
  controller_far_hole_x_offset = 0;
  // Default no Y offset
  controller_mount_y_offset = 0;
  ramps = false;
  
  //------------------------- 
  // Variables - Controller Profiles
  //------------------------- 
  
  // Azteeg X5 v1.1
  /* 
  controller_x_spacing = 89;
  controller_y_spacing = 43;
  controller_mount_y_offset = 0;
  */
  
  // Azteeg X5 v2.0
  
  controller_x_spacing = 92.2;
  controller_y_spacing = 48.2;
  controller_mount_y_offset = 0;
  
  
  // OSOYOO MKS BASE v1.3
  /*
  controller_x_spacing = 100;
  controller_y_spacing = 80;
  controller_mount_y_offset = -25;
  */
  
  // Ramps 1.4
  /*
  controller_x_spacing = 82.55;
  controller_far_hole_x_offset = 1.27;
  controller_y_spacing = 48.26;
  controller_stud_d = 7;
  controller_mount_y_offset = -10;
  ramps = true;
  */
  
  // Change these at your own risk. :)
  controller_mount_x_offset = (mount_center_spacing-controller_x_spacing)*0.5;
  controller_mount_x_length = controller_mount_x_offset;//+controller_mount_hole_d;
  controller_mount_y_length = controller_y_spacing+controller_mount_hole_d;
  
  //------------------------- 
  // Instantiation
  //------------------------- 
  
  union()
  {
    // Frame mounts for both sides
    translate([0,0,mount_total_height*0.5])
      frame_mount(reverse=false);
    translate([controller_mount_x_offset+mount_width*2,0,mount_total_height*0.5])
      frame_mount(reverse=true, far_hole_delete=ramps);
  }
  
  //------------------------- 
  // Modules
  //------------------------- 
  
  // Creates one side of the frame mount
  module frame_mount(reverse=false, far_hole_delete=false)
  {
    controller_hole_offsets =
      [
        [(reverse?-1:1)*controller_mount_x_offset, 
         controller_mount_y_offset, 
         controller_stud_height*0.5-controller_mount_height*0.5],
  
        [(reverse?-1:1)*controller_mount_x_offset+controller_far_hole_x_offset, 
         controller_y_spacing+controller_mount_y_offset,
         controller_stud_height*0.5-controller_mount_height*0.5]
      ];
      
    difference()
    {
      union()
      {
        // Frame mount
        rotate([0,0,(reverse?30:-30)])
        {
  
          rounded_arm(mount_length, mount_width, mount_total_height);
        }
        // X controller mount arm
        translate([(reverse?-1:1)*controller_mount_x_length*0.5, 0, (-mount_total_height+controller_mount_height)*0.5])
        {
          rotate([0,0,90])
            rounded_arm(controller_mount_x_length, mount_width, controller_mount_height);
        }
        // Y controller mount arm
        translate([(reverse?-1:1)*controller_mount_x_offset, 
                   far_hole_delete ? controller_mount_y_offset*0.5 
                     : (controller_mount_y_length*0.5+controller_mount_y_offset), 
                   (-mount_total_height+controller_mount_height)*0.5])
        {
          rounded_arm(far_hole_delete ? abs(controller_mount_y_offset) : controller_mount_y_length, 
                      mount_width, controller_mount_height);
        }
  
        // Controller mount studs
        for (i = [0:1])
          if (far_hole_delete == false || i == 0)
            translate(controller_hole_offsets[i])
              cylinder(h=controller_stud_height, d=controller_stud_d, center=true);
  
      }
  
      // Frame mount holes - we do these afterwards to punch holes in the controller mount arms
      rotate([0,0,(reverse?30:-30)])
      {
        translate([0, -mount_hole_spacing*0.5, 0])
        {
          cylinder(h=mount_total_height+0.2, d=mount_hole_d, center=true);
          translate([0,0,mount_height])
            cylinder(h=mount_total_height, d=mount_outer_hole_d, center=true);
        }
        translate([0, mount_hole_spacing*0.5, 0])
        {
          cylinder(h=mount_total_height+0.2, d=mount_hole_d, center=true);
          translate([0,0,mount_height])
            cylinder(h=mount_total_height, d=mount_outer_hole_d, center=true);
        }
      }
  
      // Controller mount holes
      for (i = [0:1])
        if (far_hole_delete == false || i == 0)
          translate(controller_hole_offsets[i])
            cylinder(h=controller_stud_height*3, d=controller_mount_hole_d, center=true);
  
    }
  }

}
