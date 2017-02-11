include <cloverplus_v3_utils.scad>;

$fs = 0.5;
$fa = 0.5;
//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 Effector and Hotend mount by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
// This contains the effector and hotend mount parts.  The effector mounts 6 15mm chrome steel balls
// and attaches to the hotend mount with three M3x8mm screws and three M3 jam nuts (std nuts may also
// work; locknuts will protrude into the hotend fan mount area for E3Ds).
//
// By default the hotend mount is setup for an old style E3D with an external M5 push-fit bowden tube 
//   adapter that threads into the hotend mount part itself.
// Comment / Uncomment "Hotend-specific Variables" sections below for E3D with bowden tube collet and 
//  J-head mounts respectively.  Note that the j-head mount does not presently provide enough clearance 
//  for a hotend fan.  The j-head t
// The j-head mount utilizes an M4 nut trapped in the hotend mount to hold the bowden tube in place.
//   The outside of the bowden tube will have to be shaved down a bit where it threads through the 
//   M4 nut to prevent clamping the filament.  Only 1.75mm filament is currently supported; 3mm will 
//   require a larger than M4 nut to hold a larger bowden tube in place.
//
// Note that some variables used in this module can be found in cloverplus_v3_utils.scad.
//---------------------------------------------------------------------------------------------------- 

cloverplus_v3_effector_and_hotend_mount(mockup=false);

module cloverplus_v3_effector_and_hotend_mount(mockup = false)
{
  //------------------------- 
  // Effector Variables
  //------------------------- 
  
  // The ball mount recess (cone-shaped)
  ball_recess_big_d = 10;
  ball_recess_small_d = 5;
  ball_recess_depth = 4;
  
  // How far down into the effector the ball recesses go
  ball_inset = 3;
  // How big the relief hole is (allows glue to escape if necessary for a better fit
  ball_relief_hole_d = 5;
  
  effector_d = 72;
  effector_ball_stud_d = 50;
  // How far out the ball pairs are from the center
  ball_pair_radius = 23;
  ball_stud_pair_radius = 17;
  effector_thick = 4;
  // Extra ball_stud height so the ball studs seat without gaps
  ball_stud_extra_h = 3;
  
  // rotated cutout diameter and max radius
  cutout_d = 18;
  cutout_center_offset = 21;
  ball_stud_cutout_center_offset = 16;
  
  // Hex-shaped center cutout to square off the edges
  center_cutout_d = 34;
  
  //------------------------- 
  // Shared Variables
  //------------------------- 
  
  hotend_mount_r = 19;
  hotend_nuttrap_depth = 2;
  hotend_mount_d = 6;
  hotend_mount_h = 2;
  hotend_nuttrap_bridge_thick = 0.31;
  hotend_m3_hole_depth = effector_thick - hotend_nuttrap_depth + hotend_mount_h;
  
  //------------------------- 
  // Hotend Mount Variables
  //------------------------- 
  
  hm_stud_recess_d = hotend_mount_d + 0.4;
  hm_stud_recess_h = hotend_mount_h + 0.5;
  hm_stud_block_size = hotend_mount_d + 5;
  hm_stud_block_height = 4;
  hm_stud_taper_thick = 2;
  hm_stud_block_bridge_gap = 0.32;
  
  //------------------------- 
  // Hotend-specific Variables
  //------------------------- 
  // J-head off by default
  hm_jhead = false;
  hm_hexagon = false;
  hm_deltaprintr_mini = false;
  
  // E3D v6 collet-mount variables
  hm_height = 14;
  hm_center_height = 14;
  // This is how far up into the mount body the hotend recesses
  hm_hotend_recess_h = 11.7;
  hm_hotend_recess_d = 16.4;
  hm_secure_screw_offset_from_top = 5.0;
  hm_hotend_tube_d = 12;
  // End of E3D variables
  
  
  // E3D with external M5 push-fit variables
  /*
  hm_height = 16.7;
  hm_center_height = 16.7;
  // This is how far up into the mount body the hotend recesses
  hm_hotend_recess_h = 11.7;
  hm_hotend_recess_d = 16.4;
  hm_secure_screw_offset_from_top = 5.0;
  hm_hotend_tube_d = 4.9;
  // End of E3D variables
  */
  
  // J-Head variables
  /*
  hm_height = 18;
  hm_center_height = 16;
  // This is how far up into the mount body the hotend recesses
  hm_hotend_recess_h = 9.6;
  hm_hotend_recess_d = 16.3;
  hm_secure_screw_offset_from_top = 6.1;
  hm_hotend_tube_d = 5;
  hm_jhead_nuttrap_d = m4_nuttrap_d;
  hm_jhead_nuttrap_h = 6;
  hm_jhead_nuttrap_offset_from_top = 3;
  hm_jhead = true;
  // End of j-head variables
  */

  // Hexagon
  /*
  hm_height = 14;
  hm_center_height = 18;
  // This is how far up into the mount body the hotend recesses
  hm_hotend_recess_h = 9.2;
  hm_hotend_recess_d = 16.4;
  hm_secure_screw_offset_from_top = 5.8;
  hm_hotend_tube_d = 12;
  hm_hexagon = 1;
  // End of Hexagon variables
  */

  // Deltaprintr mini hot end
  /*
  hm_height = 4;
  hm_center_height = 8;
  // This is how far up into the mount body the hotend recesses
  hm_hotend_recess_h = 11.7;
  hm_hotend_recess_d = 0; 
  hm_secure_screw_offset_from_top = 5.0;
  hm_hotend_tube_d = 10;
  hm_deltaprintr_mini_mount_spacing = 16;
  // End of Deltaprintr mini hot end variables
  */
  
  hm_stud_taper_height = hm_height-hm_stud_block_height;
  hm_secure_screw_spacing = 14.5;
  hm_secure_screw_d = 3.2;
  hm_secure_screw_inset_depth = 4;
  // This is how far from the top of the recess the secure screw centers are
  
  ff = 0.1;
  
  echo("balljoint to center spacing", ball_pair_radius);
  
  //------------------------- 
  // Instantiations
  //------------------------- 
  
  if (mockup)
  {
    effector();
    // Hotend is printed upside down
    translate([0,0,hm_height])
        hotend_mount();
  }
  else
  {
    effector();
    //effector_ball_stud();
    // Hotend is printed upside down
    translate([0,55,0])
      rotate([0,180,0])
        hotend_mount();
  }
  
  
  //------------------------- 
  // Modules
  //------------------------- 
  module effector()
  {
    difference()
    {
      // Effector
      union()
      {
        cylinder(h=effector_thick, d=effector_d, center=true);
        // Hotend mount studs
        for(i = [0,120,240])
          rotate([0,0,i])
            translate([0,hotend_mount_r,effector_thick*0.5+hotend_mount_h*0.5])
              cylinder(h=hotend_mount_h, d=hotend_mount_d, center=true);
      }
    
      // Center cutout
      cylinder(h=effector_thick+0.2, d=center_cutout_d, $fn = 6, center=true);
    
      for(i = [0,120,240])
      {
        rotate([0,0,i])
        {
          // Ball recesses
          translate([0,ball_pair_radius,effector_thick*0.5-ball_recess_depth-ff*0.5])
            for(j = [-ball_spacing*0.5, ball_spacing*0.5])
              translate([j,0,0])
                linear_extrude(height=ball_recess_depth+ff, scale = ball_recess_big_d/ball_recess_small_d)
                  circle(d=ball_recess_small_d, center=true);
    
          translate([0,hotend_mount_r,0])
          {
            // Nuttraps
            translate([0,0,-effector_thick*0.5+hotend_nuttrap_depth*0.5-ff])
              cylinder(h=hotend_nuttrap_depth+ff, d=m3_nuttrap_d, center=true, $fn=6);
            // Screw holes
            translate([0,0,hotend_m3_hole_depth*0.5+effector_thick*0.5-(effector_thick-hotend_nuttrap_depth)+hotend_nuttrap_bridge_thick])
              cylinder(h=hotend_m3_hole_depth, d=m3_hole_d, center=true);
          }
        }
        // Cutouts
        rotate([0,0,i+60])
          hull()
          {
            cylinder(h=effector_thick+0.2, d=cutout_d, center=true);
            translate([0,cutout_center_offset-cutout_d*0.5,0])
              cylinder(h=effector_thick+0.2, d=cutout_d, center=true);
          }
      }
    }
  }

  module effector_ball_stud()
  {
    difference()
    {
      // Effector
      union()
      {
        cylinder(h=effector_thick, d=effector_ball_stud_d, center=true);
        // Hotend mount studs
        for(i = [0,120,240])
          rotate([0,0,i])
            translate([0,hotend_mount_r,effector_thick*0.5+hotend_mount_h*0.5])
              cylinder(h=hotend_mount_h, d=hotend_mount_d, center=true);

        // Ball stud mounts
        for(i = [0,120,240])
          rotate([0,0,i])
            translate([0, ball_stud_pair_radius, effector_thick*0.5-ball_stud_extra_h*0.25])
              for(j = [-ball_spacing*0.5, ball_spacing*0.5])
                translate([j,0,0])
                  rotate([-45, 0, 0])
                    cylinder(h=ball_stud_mount_h+ball_stud_extra_h, d=ball_stud_mount_d, center=true);
      }
    
      // Center cutout
      cylinder(h=effector_thick+0.2, d=center_cutout_d, $fn = 6, center=true);
    
      for(i = [0,120,240])
      {
        rotate([0,0,i])
        {
          // Ball recesses
          translate([0, ball_stud_pair_radius, effector_thick*0.5-ball_stud_extra_h*0.25])
            for(j = [-ball_spacing*0.5, ball_spacing*0.5])
              translate([j,0,0])
                rotate([-45, 0, 0])
                  translate([0, 0, -ball_stud_mount_h*0.5-ball_stud_nuttrap_extra + ball_stud_extra_h + ff ])
                    nuttrap(ball_stud_m3_hole_d, ball_stud_hole_h, ball_stud_m3_nuttrap_d, ball_stud_nuttrap_h, false);
    
          translate([0,hotend_mount_r,0])
          {
            // Nuttraps
            translate([0,0,-effector_thick*0.5+hotend_nuttrap_depth*0.5-ff])
              cylinder(h=hotend_nuttrap_depth+ff, d=m3_nuttrap_d, center=true, $fn=6);
            // Screw holes
            translate([0,0,hotend_m3_hole_depth*0.5+effector_thick*0.5-(effector_thick-hotend_nuttrap_depth)+hotend_nuttrap_bridge_thick])
              cylinder(h=hotend_m3_hole_depth, d=m3_hole_d, center=true);
          }
        }

        // Cutouts
        rotate([0,0,i+60])
          hull()
          {
            cylinder(h=effector_thick+0.2, d=cutout_d, center=true);
            translate([0,ball_stud_cutout_center_offset-cutout_d*0.5,0])
              cylinder(h=effector_thick + ball_stud_mount_h * 2, d=cutout_d, center=true);
          }
      }

      // Slice off the bottom of the ball stud mounts
      translate([0, 0, -effector_thick*1.5])
        cylinder(h=effector_thick*2, d=effector_ball_stud_d*2, center=true);



    }
  } 

  module hotend_mount()
  {
    translate([0,0,effector_thick*0.5-hm_height])
      difference()
      {
        union()
        {
          // Mount blocks
          for(i = [0,120,240])
            rotate([0,0,i])
            {
              translate([0,hotend_mount_r,hm_stud_block_height*0.5])
              {
                // Stud blocks
                cube([hm_stud_block_size, hm_stud_block_size, hm_stud_block_height], center=true);
                // Stud block tapers
                for(j =  [-hm_stud_block_size*0.5+hm_stud_taper_thick*0.5, hm_stud_block_size*0.5-hm_stud_taper_thick*0.5])
                  translate([j,0,0])
                    hull()
                    {
                      translate([0,0,hm_stud_block_height*0.5-0.5])
                        cube([hm_stud_taper_thick, hm_stud_block_size, 1], center=true);
                      translate([0,(-hm_stud_block_size*0.5-0.5),(hm_stud_block_height*0.5+hm_stud_taper_height*0.5)])
                        cube([hm_stud_taper_thick, 1, hm_stud_taper_height], center=true);
                    }
               }

            }
          // Mount body
          hull()
          {
            for(i = [0,120,240])
              rotate([0,0,i])
                translate([0, hotend_mount_r-hm_stud_block_size*0.5-0.5, hm_center_height*0.5+(hm_height-hm_center_height)])
                  cube([hm_stud_block_size, 1, hm_center_height], center=true);
          }
          // cable attach
          cable_attach_l = m3_hole_d*2;
          cable_attach_t = 3;
          translate([cable_attach_t*0.5, -hm_stud_block_size-cable_attach_l*0.5-0.5, hm_height-cable_attach_l*0.5])
            difference()
            {
              cube([cable_attach_t, cable_attach_l, cable_attach_l], true);
              rotate([0,90,0])
              cylinder(h=m3_hole_d+ff, d=m3_hole_d, center=true);
            }
        }
        // Mount stud recess and mount screw holes
        for(i = [0,120,240])
          rotate([0,0,i])
          {
            translate([0,hotend_mount_r,0])
            {
              // Stud recess
              translate([0,0,hm_stud_recess_h*0.5-ff])
                cylinder(h=hm_stud_recess_h+ff, d=hm_stud_recess_d, center=true);
              // M3 screw hole
              translate([0,0,hm_stud_block_height*0.5-hm_stud_block_bridge_gap])
                cylinder(h=hm_stud_block_height, d=m3_hole_d, center=true);
            }
          }

        // Hotend recess
        translate([0,0, hm_hotend_recess_h*0.5+(hm_height-hm_center_height)-ff])
          cylinder(h=hm_hotend_recess_h+ff, d=hm_hotend_recess_d, center=true);

        // Pass-through for bowdent tube and tube collet
        cylinder(h=hm_height*3, d=hm_hotend_tube_d, center=true);

        // Hotend securing screw holes (horizontal)
        if (hm_deltaprintr_mini == false)
          for(i = [-hm_secure_screw_spacing*0.5,hm_secure_screw_spacing*0.5])
            translate([i,0,hm_hotend_recess_h-hm_secure_screw_offset_from_top+(hm_height-hm_center_height)])
            {
              rotate([90,0,0])
                cylinder(h=effector_d, d=hm_secure_screw_d, center=true);
              if (hm_hexagon)
                translate([0,-hotend_mount_r*0.5-0.5,0])
                  rotate([90,0,0])
                    cylinder(h=hm_secure_screw_inset_depth, d=m3_socket_inset_d, center=true);
            }

        // J-head mount nut trap to secure the bowden tube
        if (hm_jhead)
          translate([0,0, -hm_jhead_nuttrap_h*0.5+(hm_height-hm_jhead_nuttrap_offset_from_top)])
            cylinder(h=hm_jhead_nuttrap_h, d=hm_jhead_nuttrap_d, $fn = 6, center=true);
    
        // Vertical screws to secure mini hotend
        if (hm_deltaprintr_mini)
            rotate([0, 0, 0])
              for(i = [-1,1])
                translate([hm_deltaprintr_mini_mount_spacing*0.5*i, 0, 0])
                  cylinder(h=hm_center_height*2, d=m3_hole_d, center=true);
      }
            
  }
}
