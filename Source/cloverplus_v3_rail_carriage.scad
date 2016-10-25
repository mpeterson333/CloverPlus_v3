include <cloverplus_v3_utils.scad>;

//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 Carriage for linear rails by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
// This version of the carriage is designed to attach to MGN9C linear rail carriages riding on MR9 
// linear rails which are mounted to 10mm extrusions (MicroRAX).
// It consists of two parts - a belt grip part and the carriage base that the balls attach to.
//
// This part is as of yet untested, but everything lines up correctly in an OpenSCAD mockup.
// 4 M3x26mm screws are used to connect the belt grip part to the carriage and 4 M3 x 6mm screws
// are used to attach the carriage to the MGN9C linear rail carriage.
//
// Note that some variables used in this module can be found in cloverplus_v3_utils.scad.
//---------------------------------------------------------------------------------------------------- 

cloverplus_v3_rail_carriage(1, 1);

module cloverplus_v3_rail_carriage(mockup_build = 0, mockup_extras = 0)
{
  $fs = 0.25;
  $fa = 0.25;

  //------------------------- 
  // Variables
  //------------------------- 
  
  // Carriage base sizing
  carriage_corner_r = 1.5;
  carriage_base_w = 42;
  carriage_base_l = 48;
  carriage_base_t = 6;
  carriage_ext_gap = 1;
  
  // Grip mounts
  belt_grip_base_t = 3;
  carriage_belt_grip_mount_w = 10;
  carriage_belt_grip_mount_l = 30;
  carriage_belt_grip_mount_h = ext_width + rail_railcar_t + carriage_ext_gap;
  
  belt_grip_part_attach_screw_spacing_x = carriage_base_w - carriage_belt_grip_mount_w;
  belt_grip_part_attach_screw_spacing_y = carriage_belt_grip_mount_l - m3_hole_d*2.5;
  belt_grip_attach_m3_inset_depth = 14;
  
  belt_grip_part_w = carriage_base_w;
  
  // Ball mount variables
  ball_off = -1; // Offset distance from center of ball_mount_l
  ball_y_off = carriage_base_l*0.5-9;
  ball_mount_l = 17;
  ball_mount_t = 6;
  ball_recess_big_d = 10;
  ball_recess_small_d = 2.5;
  ball_recess_depth = 6;
  
  // Belt width, belt edge y offset from rod center, belt recess center x offset from carriage center
  belt_w = 6.5;
  belt_center_x_off = -5;
  // Belt thickness (without teeth), additional tooth thickness, tooth width (z size), number of teeth
  belt_recess = 0.8;
  belt_tooth_recess = 0.5;
  belt_tooth_w = 1;
  num_teeth = 8;
  
  // Calculated belt clamp block height
  belt_block_l = num_teeth*belt_tooth_w*2+1;
  // Belt clamp block width
  belt_block_w = 5.5;
  // Calculated belt block depth (Z size)
  ext_center_to_belt_edge = 12.2;
  belt_block_h = ext_center_to_belt_edge - ext_width*0.5 - carriage_ext_gap - belt_grip_base_t + belt_w;
  
  echo("extrusion center to balljoint center spacing", ext_width*0.5 + rail_railcar_t + carriage_base_t + ball_mount_l*0.5 + ball_off);
  echo("belt grip part attach screw len", carriage_belt_grip_mount_h + belt_grip_base_t + carriage_base_t-belt_grip_attach_m3_inset_depth);
  echo("railcar carriage mount screw len", 3 + carriage_base_t - railcar_screw_inset_depth);
  
  
  //------------------------- 
  // Instantiation
  //------------------------- 
  
  
  if (mockup_build)
  {
  
    rotate([90,0,0])
      translate([0, 0, -carriage_base_t - rail_railcar_t -ext_width*0.5])
      {
        // For alignment / mockup
        translate([0,0,carriage_base_t*0.5])
          rotate([0,180,0])
            carriage_part();
        
        translate([0, 
                   -carriage_base_l*0.5+carriage_belt_grip_mount_l*0.5, 
                   carriage_base_t+carriage_belt_grip_mount_h])
          belt_grip_part();
        
        // MGN9C Carriage mockup
        color("red")
          translate([0,railcar_mount_offset,carriage_base_t+railcar_t*0.5])
            cube([railcar_w, railcar_l, railcar_t], center=true);
    
        if (mockup_extras)
          mockup_extra();
      }
  }
  else
  {
    // For printing...
    translate([0, 0, carriage_base_t*0.5])
      carriage_part();
    translate([0, 50, carriage_belt_grip_mount_l*0.5])
      rotate([-90,0,0])
        belt_grip_part();
  }
  //------------------------- 
  // Module
  //------------------------- 
  
  // Carriage, rail, and extrusion for positioning purposes
  module mockup_extra()
  {
  
    // MR9 Rail mockup
    color("green")
      translate([0,0,carriage_base_t+railcar_t+rail_t*0.5-railcar_rail_inset])
        cube([rail_w, rail_l, rail_t], center=true);
    
    // Extrusion mockup
    color("grey")
      translate([0,0,carriage_base_t+railcar_t+rail_t-railcar_rail_inset+ext_width*0.5])
        cube([ext_width, ext_len, ext_width], center=true);
  }
  
  module carriage_part()
  {
    difference()
    {
      union()
      {
        // Carriage body
        smooth_block(carriage_base_w, carriage_base_l, carriage_base_t, carriage_corner_r);
  
        // Ball mount
        translate([0, carriage_base_l*0.5-ball_mount_t*0.5, carriage_base_t*0.5+ball_mount_l*0.5])
          hull()
          {
            smooth_block(carriage_base_w, ball_mount_t, ball_mount_l, carriage_corner_r);
            translate([0, -ball_mount_t*0.25, 0])
              cube([carriage_base_w, ball_mount_t*0.5, ball_mount_l], center=true);
            
          }
      }
  
      // Ball recesses
      for(i = [-1,1])
        translate([i*ball_spacing*0.5, carriage_base_l*0.5, carriage_base_t*0.5+ball_mount_l*0.5+ball_off])
          rotate([90,0,0])
            linear_extrude(height=ball_recess_depth+ff, scale = ball_recess_big_d/ball_recess_small_d)
              circle(d=ball_recess_small_d, center=true);
  
      // Screws for MGN9C carriage attach
      for (i = [-1,1])
        for (j = [-1,1])
          translate([i*railcar_screw_spacing_x*0.5, railcar_mount_offset + j*railcar_screw_spacing_y*0.5, 0])
          {
            cylinder(h=carriage_base_t+ff*2, d=railcar_screw_hole_d, center=true);
            translate([0, 0, carriage_base_t*0.5-railcar_screw_inset_depth*0.5])
              cylinder(h=railcar_screw_inset_depth+ff, d=railcar_screw_inset_d, center=true);
          }
  
      // Nuttraps for belt grip part attach
      for (i = [-1,1])
        for (j = [-1,1])
          translate([i*belt_grip_part_attach_screw_spacing_x*0.5, 
                     j*belt_grip_part_attach_screw_spacing_y*0.5 - carriage_base_l*0.5 + carriage_belt_grip_mount_l*0.5, 
                     carriage_base_t-carriage_m3_nuttrap_depth])
            rotate([180,0,0])
              nuttrap(m3_hole_d, carriage_base_t*2, m3_nuttrap_d, carriage_m3_nuttrap_depth, true);
    }
  }
  
  module belt_grip_part()
  {
    difference()
    {
      union()
      {
        // Belt block
        translate([belt_center_x_off, carriage_belt_grip_mount_l*0.5-belt_block_l*0.5, belt_block_h*0.5+belt_grip_base_t])
          cube([belt_block_w, belt_block_l, belt_block_h], center=true);
        // Cross piece
        translate([0, 0, belt_grip_base_t*0.5])
          smooth_block(belt_grip_part_w, carriage_belt_grip_mount_l, belt_grip_base_t, carriage_corner_r);
        // Base Standoffs / belt grip mounts
        for(i=[-1,1])
          translate([i*(belt_grip_part_w*0.5-carriage_belt_grip_mount_w*0.5), 
                     0, 
                     -carriage_belt_grip_mount_h*0.5])
            smooth_block(carriage_belt_grip_mount_w, carriage_belt_grip_mount_l, carriage_belt_grip_mount_h, 
                         carriage_corner_r);
      }
  
      // Belt clamp recess
      translate([belt_center_x_off-belt_recess*0.5, 
                 carriage_belt_grip_mount_l*0.5-belt_block_l*0.5-((num_teeth+1)*belt_tooth_w), 
                 belt_block_h+belt_grip_base_t-belt_w+ff])
        for(i = [0:num_teeth])
        {
          translate([0,i*belt_tooth_w*2,0])
            cube([belt_recess,belt_tooth_w,belt_w]);
          translate([0,i*belt_tooth_w*2+belt_tooth_w,0])
            cube([belt_recess+belt_tooth_recess,belt_tooth_w,belt_w]);
          if (i == num_teeth)
            translate([0,(i+1)*belt_tooth_w*2,0])
              cube([belt_recess,belt_tooth_w,belt_w]);
        }
  
      // M3 Screw Holes
      for (i = [-1,1])
        for (j = [-1,1])
          translate([i*belt_grip_part_attach_screw_spacing_x*0.5, 
                     j*belt_grip_part_attach_screw_spacing_y*0.5, 
                     0])
          {
            translate([0,0,-carriage_belt_grip_mount_h*0.5+belt_grip_base_t*0.5])
              cylinder(h=carriage_belt_grip_mount_h+belt_grip_base_t+ff, d=m3_hole_d, center=true);
            translate([0,0,belt_grip_base_t-belt_grip_attach_m3_inset_depth*0.5])
              cylinder(h=belt_grip_attach_m3_inset_depth+ff, d=m3_socket_inset_d, center=true);
          }
    }
  }
  
  
}
