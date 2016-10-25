include <cloverplus_v3_utils.scad>;

cloverplus_v3_carriage(0, 0);

//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 Carriage by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
// This version of the carriage slides along a 10mm MicroRAX extrusion.  It consists of 2 parts - 
// the carriage itself that the balls glue to and a belt grip / slider part.  The two parts are
// connected by four M3 x 12mm screws and four M3 lock nuts.
//
// The default extra spacing for smooth sliding can be found in the "Slider extra spacing variables"
// section below.  This spacing worked well with a 0.4mm nozzle and 2 perimeters when sliced with 
// Simplify3D (0.48mm extrusion width).  Other slicers and nozzle sizes may require some trial and 
// error to accomplish smooth sliding.  I printed the sliders in PETG with 50% infill.  After working 
// the sliders by hand to loosen them up (on and off the extrusion in all orientations repeatedly), 
// use a thin, oil type lubricant on the extrusions to reduce wear.  They should be snug, but move 
// nearly freely when pushed by hand.
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
  
  // MicroRAX extrusion slider fixed sizing 
  // extrusion tips width (diameter)
  slider_end_d = 0.7;
  // width of the inside of the extrusion
  slider_inside_size = 4;

  //------------------------- 
  // Slider extra spacing variables
  //------------------------- 
  //** Change these if your sliders are too tight or too loose.
  //** Please calibrate your extruder before printing!!
  // The below settings work well with 2 perims in Simplify3D and a print speed of 40mm/s

  // Extra sizing around basic square extrusion recess
  slider_extra = 0.17;
  // Extra diameter size for extrusion tips
  slider_end_d_extra = 0.18;
  // Extra distance beyond 45degree tip radii 
  slider_end_corner_extra = 0.2;
  // Extra spacing around the extrusion center for 90degree grips
  slider_inside_extra = 0.10;
  // Width of the 90degree grips
  slider_inside_guide_w = 2.6;
  // Cut-ins that increase extrusion tip grip
  slider_cut_in_major = 1;
  slider_cut_in_minor = 2.75;
  //------------------------- 

  //** SET THIS to 1 to produce a smaller part for extrusion slide testing
  fittest = 0;
  //** SET THIS to 1 to render only the slider for printing
  slider_only = 0;

  // Override smash comp here
  smash_comp = 0.5;
  
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
    translate([0, 30, belt_grip_mount_l*0.5])
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
    {
      difference()
      {
        union()
        {
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
              // 4 corners
              for(i=[-1,1])
                rotate([0, 0, i*45])
                  hull()
                    for(j=[-1,1])
                      translate([0, j*(sqrt(pow(ext_width+slider_extra,2)*2)*0.5-slider_end_d*0.5+slider_end_corner_extra*0.5), 0])
                        cylinder(h=belt_grip_mount_l+ff*2, d=slider_end_d+slider_end_d_extra, center=true, $fn=30);

              // Center cube-shaped cutout that opens the corners
              cube([ext_width-slider_cut_in_major, ext_width-slider_cut_in_major, belt_grip_mount_l+ff*2], center=true);
              // Cutbacks to clear the inner prongs
              cube([ext_width-slider_cut_in_minor, 
                    ext_width+slider_extra,
                    belt_grip_mount_l+ff*2], center=true);
              cube([ext_width+slider_extra, 
                    ext_width-slider_cut_in_minor, 
                    belt_grip_mount_l+ff*2], center=true);
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
      
          // Create slider tabs
          rotate([90,0,0])
          {
            difference()
            {
              union()
              {
                cube([slider_inside_guide_w, ext_width+slider_extra, belt_grip_mount_l-ff], center=true);
                cube([ext_width+slider_extra, slider_inside_guide_w, belt_grip_mount_l-ff], center=true);
              }
              cube([slider_inside_size+slider_inside_extra, slider_inside_size+slider_inside_extra, 
                    belt_grip_mount_l+ff+2], center=true);
            }
          }
        }
        // Subtract smash compensation from bottom AND top for easier extrusion sliding
        rotate([90,0,0])
        {
            corner_sc_size = (ext_width+slider_extra-slider_inside_guide_w)*0.5;
            for(i=[-1,1])
              for(j=[-1,1])
                for(k=[-1,1])
                  translate([i*((ext_width+slider_extra)*0.5-(corner_sc_size*0.5)), 
                           j*((ext_width+slider_extra)*0.5-(corner_sc_size*0.5)), 
                           k*belt_grip_mount_l*0.5 + k*ff])
                    rotate([(k == 1 ? 180 : 0), 0, 0])
                      linear_extrude(height=smash_comp, scale=corner_sc_size/(corner_sc_size+smash_comp*2))
                        square([corner_sc_size+smash_comp*2, corner_sc_size+smash_comp*2], center=true);
            for(k=[-1,1])
              translate([0, 0, k*belt_grip_mount_l*0.5 + k*ff])
                rotate([(k == 1 ? 180 : 0), 0, 0])
                  linear_extrude(height=smash_comp, 
                                 scale=(slider_inside_size+slider_inside_extra)/
                                       (slider_inside_size+slider_inside_extra+smash_comp*2))
                    square([slider_inside_size+slider_inside_extra+smash_comp*2, 
                            slider_inside_size+slider_inside_extra+smash_comp*2], center=true);
        }
      }
    }
  }
}
