include <cloverplus_v3_utils.scad>;

//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 Panucatt Viki2 GLCD case (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
// This is a case for the Panucatt Viki2 GLCD that mounts to the top frame using mount_bracket()
// from cloverplus_v3_glcd_case_back_and_mount.scad
// 2x M4x12 screws and 2x M4 lock nuts are used to fix the case to the mount and 2x M4x16 screws are 
// used to fix the mount to the frame.  4x M3x6mm - M3x10 screws are used to fix the Viki2 to the case.
//---------------------------------------------------------------------------------------------------- 

$fs = 1;
$fa = 1;

// Screw spacing for the viki2 M3 screw holes
screw_spacing_x = 132.5;
screw_spacing_y = 55.5;

// Case frame thickness
edge_thick = 3;

// Bottom thickness
bottom_t = 2;

// Bracing thickness
brace_t = 4;

post_d = 10;

// Height not including bottom_t
height = 31;

// Cable pass-through hole sizing
cable_pass_hole_x = 10;
cable_pass_hole_y = 30;

// cable pass-through offsets from case center
cable_pass_hole_x_offset = 29;
cable_pass_hole_y_offset = 7.5;

// Spacing of the case to mount holes
mount_hole_spacing = 35;

// Offset from bottom of case to locate frame mount bracket holes
mount_hole_y_offset = 40;

// Mount hole and nuttrap depth
mount_hole_depth = bottom_t+1;
mount_nuttrap_depth = brace_t-1;

ff = 0.01;

case_frame();


module case_frame()
{
  difference()
  {
    union()
    {
      for(i = [-1,1])
      {
        // Viki M3 mount posts
        for(j = [-1,1])
          translate([i*screw_spacing_x*0.5, j*screw_spacing_y*0.5, height*0.5+bottom_t])
            difference()
            {
              cylinder(h=height, d=post_d, center=true);
              translate([0, 0, height*0.25+ff])
                cylinder(h=height*0.5, d=m3_tight_hole_d, center=true);
            }
        // Bracing
        translate([0, i*screw_spacing_y*0.5, brace_t*0.5+bottom_t])
          hull()
            for(j = [-1,1])
              translate([j*screw_spacing_x*0.5, 0, 0])
                cylinder(h=brace_t, d=post_d, center=true);
        translate([i*screw_spacing_x*0.5, 0, brace_t*0.5+bottom_t])
          hull()
            for(j = [-1,1])
              translate([0, j*screw_spacing_y*0.5, 0])
                cylinder(h=brace_t, d=post_d, center=true);
        translate([i*mount_hole_spacing*0.5, 0, brace_t*0.5+bottom_t])
          hull()
            for(j = [-1,1])
              translate([0, j*screw_spacing_y*0.5, 0])
                cylinder(h=brace_t, d=post_d, center=true);
      }

      // Mount hole brace
      translate([0, -(screw_spacing_y*0.5+post_d)+mount_hole_y_offset, ])
        hull()
          for(i = [-1, 1])
            translate([i*mount_hole_spacing*0.5, 0, brace_t*0.5+bottom_t])
              cylinder(h=brace_t, d=post_d, center=true);

      // Frame shell
      difference()
      {
        basic_frame(screw_spacing_x, screw_spacing_y, post_d, height + bottom_t);
        translate([0, 0, bottom_t+ff])
          basic_frame(screw_spacing_x, screw_spacing_y, post_d-edge_thick*2, height);
      }
    }

    // nuttraps for case to mount
    for(i = [-1, 1])
      translate([i*mount_hole_spacing*0.5, -(screw_spacing_y*0.5+post_d)+mount_hole_y_offset, bottom_t+brace_t])
        rotate([180,0,0])
          nuttrap(m4_hole_d, mount_hole_depth, m4_nuttrap_d, mount_nuttrap_depth);

    // Cable pass-through
    translate([cable_pass_hole_x_offset, cable_pass_hole_y_offset, brace_t])
      cube([cable_pass_hole_x, cable_pass_hole_y, (brace_t+bottom_t)*2], center=true);
  }
}


module basic_frame(x_spacing, y_spacing, edge_d, height)
{
  hull()
  {
    for(i = [-1,1])
      for(j = [-1,1])
        translate([i*x_spacing*0.5, j*y_spacing*0.5, height*0.5])
          cylinder(h=height, d=edge_d, center=true);
  }
      
}

