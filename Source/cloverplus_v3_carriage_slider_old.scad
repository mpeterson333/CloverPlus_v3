include <cloverplus_v3_utils.scad>;

cloverplus_v3_carriage(0, 0);

//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 Carriage by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
// This version of the carriage slides along a 10mm MicroRAX extrusion.  It consists of 2 parts - 
// the carriage itself that the balls glue to and a belt grip / slider part.  The two parts are
// connected by four M3 x 12mm screws and four M3 lock nuts.
//
// The default extra spacing for smooth sliding is 0.2; this worked well with a 0.4mm nozzle and 2
// perimeters when sliced with simplify3D (0.48mm extrusion width).  Other slicers and nozzle sizes
// may require some trial and error to accomplish smooth sliding.  I recommend printing the sliders
// in PETG for durability with 50% infill.
//
// Note that some variables used in this module can be found in cloverplus_v3_utils.scad.
//---------------------------------------------------------------------------------------------------- 
module cloverplus_v3_carriage(mockup_build = 0, mockup_extras = 0)
{
  $fs = 0.25;
  $fa = 0.25;
  
  //------------------------- 
  // Variables
  //------------------------- 
  
  //** CHANGE THIS if your sliders are too tight or too loose.
  //** Please calibrate your extruder before printing!!
  // With 2 perims in Simplify3D, 0.20mm extra width around the extrusion for sliding worked well
  slider_extra = 0.20;
  //** SET THIS to 1 to produce a smaller part for extrusion slide testing
  fittest = 0;
  //** SET THIS to 1 to render only the slider for printing
  slider_only = 1;
  
  // Carriage base sizing
  carriage_corner_r = 1.5;
  carriage_base_w = 42;
  carriage_base_l = 48;
  carriage_base_t = 6;
  carriage_ext_gap = 4;
  
  // Belt grip to carriage attach screw location 
  m3_screw_x_edge_offset = 4;
  m3_screw_y_edge_offset = 24;
  
  // Ball mount variables
  ball_off = -1; // Offset distance from center of ball_mount_l
  ball_mount_l = 17;
  ball_mount_t = 6;
  ball_recess_big_d = 10;
  ball_recess_small_d = 2.5;
  ball_recess_depth = 6;
  
  // Belt width, belt edge y offset from rod center, belt recess center x offset from carriage center
  belt_w = 6.5;
  belt_center_x_off = -5;
  // Belt thickness (without teeth), additional tooth thickness, tooth width, number of teeth
  belt_recess = 0.8;
  belt_tooth_recess = 0.5;
  belt_tooth_w = 1;
  num_teeth = 8;
  
  // Calculated belt clamp block height
  belt_block_l = num_teeth*belt_tooth_w*2+1;
  // Belt clamp block width
  belt_block_w = 5.5;
  // Calculated belt block depth (Z size)
  belt_block_h = ext_center_to_belt_edge - ext_width*0.5 - carriage_ext_gap + belt_w;

  // Belt Grip part sizing
  belt_grip_mount_l = 40;
  belt_grip_mount_h = ext_width + carriage_ext_gap*2;

  // Belt grip part
  belt_grip_part_w = ext_width + carriage_ext_gap*2 + m3_screw_x_edge_offset*2 + 6;
  belt_grip_part_attach_screw_spacing_x = belt_grip_part_w - m3_screw_x_edge_offset*2;
  belt_grip_part_attach_screw_spacing_y = belt_grip_mount_l - m3_screw_y_edge_offset;
  belt_grip_part_mount_t = 5;
  
  echo("extrusion center to balljoint center spacing", ext_width*0.5 + carriage_ext_gap + carriage_base_t + ball_mount_l*0.5 + ball_off);
  
  
  //------------------------- 
  // Instantiation
  //------------------------- 
  
  // For fit testing
  if (fittest)
  {
    intersection()
    {
      rotate([-90,0,0])
        belt_grip_part();
      translate([0,belt_grip_mount_h*0.5,-belt_grip_mount_l*0.5])
        cube([belt_grip_mount_h,belt_grip_mount_h,40],center=true);
    }
  } 
  // For mockup
  else if (mockup_build)
  {
    rotate([90,0,0])
    {
      translate([0, 0, -carriage_ext_gap-ext_width*0.5])
      {
        // For alignment / mockup
        translate([0,0,-carriage_base_t*0.5])
          rotate([0,180,0])
            carriage_part();
        
        translate([0, 
                   -carriage_base_l*0.5+belt_grip_mount_l*0.5, 
                   0])
          belt_grip_part();
        
      }
      if (mockup_extras)
        mockup_extra();
    }
  }
  // For printing...
  else
  {
    translate([0, 50, belt_grip_mount_l*0.5])
      rotate([-90,0,0])
        belt_grip_part();
    if (!slider_only)
    {
      translate([0, 0, carriage_base_t*0.5])
        carriage_part();
    }
  }
  
  // Carriage, rail, and extrusion for positioning purposes
  module mockup_extra()
  {
  
    // Extrusion mockup
    color("grey")
    translate([0,0,0])
      cube([ext_width, ext_len, ext_width], center=true);
  }
  
  // The carriage part (balls glue to this)
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
  
      // Nuttraps for belt grip part attach
      for (i = [-1,1])
        for (j = [-1,1])
          translate([i*belt_grip_part_attach_screw_spacing_x*0.5, 
                     j*belt_grip_part_attach_screw_spacing_y*0.5 - carriage_base_l*0.5 + belt_grip_mount_l*0.5, 
                     carriage_base_t-carriage_m3_nuttrap_depth])
            rotate([180,0,0])
              nuttrap(m3_tight_hole_d, carriage_base_t*2, m3_nuttrap_d, carriage_m3_nuttrap_depth, true);
    }
  }
  
  // The belt grip and slider part
  module belt_grip_part()
  {
    belt_block_z_offset = belt_block_h*0.5+belt_grip_mount_h - ext_width*0.5-carriage_ext_gap;
    translate([0, 0, belt_grip_mount_h*0.5])
    difference()
    {
      union()
      {
        // Belt block
        translate([belt_center_x_off, belt_grip_mount_l*0.5-belt_block_l*0.5, belt_block_z_offset])
          cube([belt_block_w, belt_block_l, belt_block_h], center=true);
        // Slider Body
        smooth_block(belt_grip_mount_h, belt_grip_mount_l, belt_grip_mount_h, carriage_corner_r);
        // Mount tabs
        translate([0, 0, -belt_grip_mount_h*0.5+belt_grip_part_mount_t*0.5])
          smooth_block(belt_grip_part_w, belt_grip_mount_l, belt_grip_part_mount_t, carriage_corner_r);
      }

      // Slider
      rotate([90,0,0])
      {
        translate([0, 0, 0])
        {
          // primary slider square recess
          cube([ext_width+slider_extra, ext_width+slider_extra, belt_grip_mount_l+ff*2], center=true);
          // Smash compensation
          translate([0, 0, -belt_grip_mount_l*0.5-ff])
            linear_extrude(height=smash_comp, scale=(ext_width+ext_extra)/(ext_width+ext_extra+smash_comp*2))
              square([ext_width+ext_extra+smash_comp*2, ext_width+ext_extra+smash_comp*2], center=true); 
          translate([0, 0, belt_grip_mount_l*0.5+ff])
            rotate([180,0,0])
              linear_extrude(height=smash_comp, scale=(ext_width+ext_extra)/(ext_width+ext_extra+smash_comp*2))
                square([ext_width+ext_extra+smash_comp*2, ext_width+ext_extra+smash_comp*2], center=true); 
        }
        // Oval cutouts on all 4 sides
        for(i = [-1,1])
        {
          translate([i*ext_width*0.5,0,0])
            scale([0.5,1,1])
              cylinder(h=belt_grip_mount_l+ff*2, d=ext_width-2, center=true);
          translate([0,i*ext_width*0.5,0])
            scale([1,0.5,1])
              cylinder(h=belt_grip_mount_l+ff*2, d=ext_width-2, center=true);
        }
      }
  
      // Belt clamp recess
      translate([belt_center_x_off-belt_recess*0.5, 
                 belt_grip_mount_l*0.5-belt_block_l*0.5-((num_teeth+1)*belt_tooth_w), 
                 belt_block_z_offset+belt_block_h*0.5-belt_w+ff])
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
  
      // M3 inset screw holes
      for (i = [-1,1])
        for (j = [-1,1])
          translate([i*belt_grip_part_attach_screw_spacing_x*0.5, 
                     j*belt_grip_part_attach_screw_spacing_y*0.5, 
                     belt_grip_mount_h*0.5])
            cylinder(h=belt_grip_mount_h+belt_grip_mount_h+ff, d=m3_tight_hole_d, center=true);
    }
  }
  
  
}
