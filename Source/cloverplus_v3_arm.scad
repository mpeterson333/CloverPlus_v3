
$fs = 0.5;
$fa = 0.5;
//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 Arm by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
// This is the arm part - default sizing is 100mm for 10mm x 6mm(diameter) N50 cylinder magnets.
// The arms can be either triangular or square - triangular is recommended as they require less cleanup
// for wobble-free ball contact.
//---------------------------------------------------------------------------------------------------- 

//------------------------- 
// Variables
//------------------------- 

arm_len = 100;
ball_d = 15;
arm_width = 9;
triangle_add = 0.9;
arm_magnet_recess_d = 6.2;
// This should be as close as possible to the actual magnet length - measure a few with 
// calipers.
arm_magnet_recess_len = 9.8;
// I've found 0.2mm gap to be optimal - close, but not contacting.
// Make sure your extrusion width is calibrated!!
arm_magnet_to_ball_gap = 0.2;

tri_arm_cutoff_r = 5;


//------------------------- 
// Instantiation
//------------------------- 

//arm(arm_len, ball_d, arm_width, arm_magnet_recess_d, arm_magnet_recess_len, arm_magnet_to_ball_gap);
arm(arm_len, ball_d, arm_width, arm_magnet_recess_d, arm_magnet_recess_len, arm_magnet_to_ball_gap, true);

//------------------------- 
// Module
//------------------------- 

module arm(len, ball_d, width, magnet_d, magnet_len, magnet_gap, triangle=false)
{
  arm_end_cutoff_offset = (triangle ? 5 : 5.75);
  len_total = len+ball_d;
  slot_len = magnet_len + magnet_gap - 3.2;
  magnet_recess_cyl_h = magnet_len+ball_d*0.5+magnet_gap;
  width = (triangle ? width + 4.5 : width);

  difference()
  {
    // Arm
    if (triangle)
    {
      // Triangular arm
      translate([-len_total*0.5,0,width*0.5/cos(30)])
        rotate([0,90,0])
          rotate([0,0,-30])
            linear_extrude(height=len_total)
              polygon(points=[ [0,0], [width*0.5, width*sin(60)], [width,0] ]);
    }
    else
    {
      // Square arm
      cube([len_total, width, width], center=true);
    }

    // Sphere cutouts
    for(i = [-len_total*0.5, len_total*0.5])
      translate([i, 0, 0])
        sphere(d=ball_d, center=true);

    for(i = [-1,1])
    {
      translate([i*((len_total)*0.5-magnet_recess_cyl_h*0.5),0,0])
      {
        // Magnet recess
        rotate([0,90,0])
          cylinder(h=magnet_recess_cyl_h, d=magnet_d, center=true);
        // Side slot for gluing
        translate([i*(slot_len*0.5-(magnet_len+ball_d*0.5+magnet_gap)*0.5),0,-width*0.5])
          cube([slot_len, width*0.5, width], center=true);
      }
      // End cutoff
      translate([i*(len_total*0.5-arm_end_cutoff_offset*0.5), 0, 0])
      {
        cube([arm_end_cutoff_offset,width*4,width*4], center=true);
      }
    }

    if (triangle)
    {
      // Triangle edge cutoffs
      for(i = [0, 120, 240])
        rotate([i,0,0])
          translate([0, 0, tri_arm_cutoff_r*1.5])
            cube([len*2, tri_arm_cutoff_r, tri_arm_cutoff_r], center=true);
    }
  }
}

