include <cloverplus_v3_utils.scad>;
$fs = 0.25;
$fa = 0.25;
//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 Geeetech GLCD case and mount (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
// This is a modification of http://www.thingiverse.com/thing:665671 that adds a bracket and matching
// mount holes to mount a Geeetech full graphic GLCD display to the top of the CloverPlus v3 frame
//---------------------------------------------------------------------------------------------------- 

cloverplus_v3_glcd_case_back_and_mount();

module cloverplus_v3_glcd_case_back_and_mount()
{
  
  // translating up by this amount puts the back at Z0
  case_thick = 2.5;
  case_outer_size = 100;
  case_inner_size = 95;

  case_back_recess_y_offset = -12;
  case_back_recess_x_offset = -15;
  case_back_recess_size = 10;
  case_back_recess_depth = 2;

  case_top_depth = 17;
  case_top_hole_x_offset = 6;
  case_top_bottom_hole_y_offset = 7.5;
  case_top_mid_hole_y_offset = 27.5;
  case_top_top_hole_y_offset = 92.5;
  
  case_nuttrap_depth = 3;
  case_nuttrap_size = 12;
  m4_case_nuttrap_d = 8.2;
  m4_hole_d = 4.4;
  case_hole_spacing = 35;
  case_hole_y_offset = -30;
  m3_tight_hole_d = 2.7;
  
  frame_hole_spacing = 28;
  lcd_mount_bracket_t = 5;
  lcd_mount_bracket_w = 12;
  lcd_mount_bracket_angle = -20;
  lcd_mount_y_off = -10;

  case_mount_z_offset = case_outer_size*0.5+case_hole_y_offset;

  ff = 0.1;
  
  case_back();

  *translate([0,60,0])
    case_front();

  translate([80, 0, lcd_mount_bracket_t*0.5])
    mount_bracket();
  
  module mount_bracket()
  {
    difference()
    {
      union()
      {
        // Case mount part
        translate([0, lcd_mount_y_off, 0])
          rotate([lcd_mount_bracket_angle, 0, 0])
          {
            translate([0, 0, case_mount_z_offset])
              rotate([0,90,90])
                rounded_arm(case_hole_spacing, lcd_mount_bracket_w, lcd_mount_bracket_t);
            for(i = [-1,1])
            {
              hull()
              {
                translate([i*case_hole_spacing*0.5, 0, 0])
                {
                  rotate([0,90,0])
                    cylinder(h=lcd_mount_bracket_w, d=lcd_mount_bracket_t, center=true);
                  translate([0, 0, case_mount_z_offset])
                    rotate([90,0,0])
                      cylinder(d=lcd_mount_bracket_w, h=lcd_mount_bracket_t, center=true);
                }
              }
            }
          }
        // Center support bar
        hull()
        {
          cube([lcd_mount_bracket_t, lcd_mount_bracket_w,
                lcd_mount_bracket_t], center=true);
          translate([0, lcd_mount_y_off, 0])
            rotate([lcd_mount_bracket_angle, 0, 0])
            {
              translate([0, 0, case_mount_z_offset])
                cube([lcd_mount_bracket_t, lcd_mount_bracket_t, lcd_mount_bracket_w], center=true);
              rotate([0,90,0])
                cylinder(h=lcd_mount_bracket_t, d=lcd_mount_bracket_t, center=true);
            }
        }

        // Frame mount part
        rotate([0,0,90])
          rounded_arm(case_hole_spacing, lcd_mount_bracket_w, lcd_mount_bracket_t);
        for(i = [-1,1])
        {
          hull()
          {
            translate([i*case_hole_spacing*0.5, 0, 0])
            {
              cylinder(d=lcd_mount_bracket_w, h=lcd_mount_bracket_t, center=true);
              translate([0, lcd_mount_y_off, 0])
                rotate([0,90,0])
                  cylinder(h=lcd_mount_bracket_w, d=lcd_mount_bracket_t, center=true);
            }
          }
        }
      }
      // subtract case mount holes
      translate([0, lcd_mount_y_off, 0])
        rotate([lcd_mount_bracket_angle, 0, 0])
          translate([0, 0, case_outer_size*0.5+case_hole_y_offset])
            rotate([90,0,0])
              for(i = [-1,1])
                translate([i*case_hole_spacing*0.5, 0, 0])
                  cylinder(h=lcd_mount_bracket_t+ff, d=m4_hole_d, center=true);

      // subtract frame mount holes
      for(i = [-1,1])
        translate([i*frame_hole_spacing*0.5, 0, 0])
          cylinder(h=lcd_mount_bracket_t+ff, d=m4_hole_d, center=true);


    }
  }
  
  module case_back()
  {
    difference()
    {
      union()
      {
        import("gfx-case-back_fixed_centered.stl", convexity=4);
        
        translate([0, case_hole_y_offset, case_thick+case_nuttrap_depth*0.5])
          cube([case_inner_size, case_nuttrap_size, case_nuttrap_depth], center=true);
        for(i=[-1,1])
          translate([i*case_hole_spacing*0.5, 
                     -(case_inner_size*0.5+case_hole_y_offset)*0.5+case_hole_y_offset -1, 
                     case_thick+case_nuttrap_depth*0.5])
            cube([case_nuttrap_size, case_inner_size*0.5+case_hole_y_offset+1, case_nuttrap_depth], center=true);
      }
      // Case back M4 nuttraps
      for(i=[-1,1])
        translate([i*case_hole_spacing*0.5, case_hole_y_offset, case_thick+case_nuttrap_depth*0.5])
        {
          cylinder(h=case_nuttrap_depth+ff, d=m4_case_nuttrap_d, $fn=6, center=true);
          cylinder(h=case_nuttrap_depth*3, d=m4_hole_d, center=true);
        }
      translate([case_back_recess_x_offset, case_back_recess_y_offset, case_thick-case_back_recess_depth*0.5])
        cube([case_back_recess_size, case_back_recess_size, case_back_recess_depth], center=true);
        
        
    }
  }

  module case_front()
  {
    difference()
    {
      translate([0, case_outer_size*0.5, 0])
        import("gfx-case-top_centered_fixed.stl", convexity=4);
      for(i=[-1,1])
        translate([i*(case_outer_size*0.5-case_top_hole_x_offset), 0, 0])
          for(j=[case_top_bottom_hole_y_offset, case_top_mid_hole_y_offset, case_top_top_hole_y_offset])
            translate([0, j, case_top_depth*0.5+case_thick])
              cylinder(h=case_top_depth, d=m3_tight_hole_d, center=true);
    }
  }
}
