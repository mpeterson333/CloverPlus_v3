//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 Utilities by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
// This file contains shared variables and modules used by many of the CloverPlus v3 parts.
//---------------------------------------------------------------------------------------------------- 
 
//------------------------- 
// Top/Bottom/General Variables
//------------------------- 

// Extrusion width - this should be 10mm or 15mm
ext_width = 15;
// Extra extrusion width for easier insert / remove
ext_extra = 0.25;

ext_len = 350;

// How deep the extrusions recess into the design
ext_hole_depth = 10;
// Extrusion offsets with respect to center (don't change)
ext_hole_x_offset = 0;
// -2 for 10mm extrusions, -1 for 15mm
ext_hole_y_offset = (ext_width == 15) ? -1 : -2;

ext_mount_hole_d = 3.4;
ext_mount_hole_spacing = 10;

// Rod clamp screw hole diameter (tight M5)
rod_secure_hole_d = 4.7;

// Idler pulley screw hole diameter (M5)
idler_pulley_hole_d = 4.85;
// Straight belt path with 608ZZ bearing requires an offset
// 7.5 for 10mm extrusions, 10.5 for 15mm
idler_pulley_x_offset = (ext_width == 15) ? 10.5 : 7.5;

// 46 for 10mm extrusions, 51 for 15mm
base_length = (ext_width == 15) ? 51 : 46;
// 22mm for 10mm extrusions, 24mm for 15mm
base_width = 24;
// Original was 17, adding 1mm to make it a bit tougher
top_base_thick = 17;
// Original was 13
bottom_base_thick = 17;

// 85mm for 10mm extrusions, 87 for 15mm
leg_length = (ext_width == 15) ? 87 : 85;
// Leg width == base_width

m3_nuttrap_d = 6.6;
m3_hole_d = 3.4;
m3_tight_hole_d = 2.8;
m3_socket_inset_d = 5.7;
carriage_m3_nuttrap_depth = 3;

m4_nuttrap_d = 8.2;
m4_hole_d = 4.4;
leg_m4_nuttrap_depth = 3;

// Sizing for the male/female couplers on the ends of the arms
leg_coupler_length_male = 8;
leg_coupler_width_male = 6;
leg_coupler_length_female = 8.1;
leg_coupler_width_female = 6.2;
leg_coupler_height = 6;

// Sizing for the leg edges that extend up to the connectors on both sides of each leg
leg_edge_thick = 2.5;  // Slightly thicker than original
leg_edge_start_inner_top = 35;
leg_edge_start_outer = 20;
leg_edge_start_inner_bottom = 45;

// Sizing for the M5 connectors on either side of the leg ends
leg_connector_thick = 4;
leg_connector_width = 11;
leg_connector_hole_d = 5.4;
leg_connector_far_height = 17;
// Angle-back means less cleaning of the M5 holes after printing
leg_connector_setback = 0.30;

// Sizing and placement for the endstop switch (omron SS-5 plunger style)
// M2.5 screw size
leg_switch_hole_d = 2.2;
leg_switch_hole_depth = 12;
leg_switch_hole_spacing = 9.5;
// Distance from top (bottom when assembled) edge
leg_switch_hole_z_offset = 7.5;
leg_switch_hole_y_offset = 30;

// Y offset to start of curved cutout - 21mm for 10mm extrusions, 24mm for 15mm
leg_cutout_start = (ext_width == 15) ? 24 : 21;
// This has to accomodate the M4 screw traps
leg_cutout_curve_radius = 4;

// Controller, extruder, and bed clamp mounting holes with nut traps (M4)
leg_hole_x_offset = 0;
leg_hole_y_offset = 14;

// For extruder mount
// 48 for 10mm extrusions, 47mm for 15mm
bottom_leg_extruder_mount_holes_y_offset = (ext_width == 15) ? 47 : 48;
bottom_leg_extruder_mount_holes_spacing = 24;

// Leg wire guide ziptie holes
leg_wire_guide_hole_d = 3;
leg_wire_guide_hole_y_offset = leg_connector_thick+9;
leg_wire_guide_top_z_offset = -4;
leg_wire_guide_bottom_z_offset = -4;

// Nema 17 motor mount shaft and screw holes, plate size, placement offset (for proper belt path)
motor_mount_hole_d = 24;
motor_mount_screw_hole_d = 3.2;
motor_mount_screw_spacing = 31;
// 46 for 10mm extrusions, 51 for 15mm
motor_mount_size = (ext_width == 15) ? 51 : 46;
motor_mount_thick = 4;
// 0.75 for 10mm extrusions, 3.75 for 15mm
motor_mount_x_offset = (ext_width == 15) ? 3.75 : 0.75;

// First layer smash compensation and fudge factor
smash_comp = 0.8;

// Fudge Factor
ff = 0.01;

// Print layer height (use for bridging membranes)
layer_height = 0.2;

// Delta variables calculations
calc_arm_t_len = leg_length + (base_length*0.5)/sin(30);
calc_tip_to_base_len = (base_length*0.5)/tan(30);
calc_tip_to_center_len = calc_arm_t_len/cos(30);
ext_center_to_center_len = calc_tip_to_center_len - calc_tip_to_base_len-base_width*0.5 - ext_hole_y_offset;
center_base_to_center_len = calc_tip_to_center_len - calc_tip_to_base_len-base_width*0.5;

// 1.2mm is pullywasher thickness, 1mm is the m5 washer between the pullywasher and the frame
// extra 1mm is to put it in the center of the pulley
ext_center_to_belt_edge = (base_width - ext_width)*0.5 - ext_hole_y_offset + 1.2 + 1 + 1;

echo("extrusion center to bed center distance", ext_center_to_center_len);
echo("extrusion center to belt edge", ext_center_to_belt_edge); 

//------------------------- 
// Carriage Variables
//------------------------- 
ball_spacing = 30;

// MGN9C carriage sizing
railcar_l = 28.9;
railcar_w = 20;
railcar_t = 8; // Rail included
railcar_rail_inset = 4.5;

railcar_screw_spacing_x = 15;
railcar_screw_spacing_y = 10;
railcar_screw_hole_d = 3.4;
railcar_mount_offset = -5;
railcar_screw_inset_depth = 3;
railcar_screw_inset_d = 6;
// Total rail and carriage height / thickness
rail_railcar_t = 10;

//------------------------- 
// Ball stud Variables for 
// carriages and effector
//------------------------- 
ball_stud_mount_d = 12;
ball_stud_mount_h = 8;
ball_stud_hole_h = 5;
ball_stud_nuttrap_extra = 7;
ball_stud_nuttrap_h = ball_stud_mount_h - ball_stud_hole_h + ball_stud_nuttrap_extra;
ball_stud_z_off = -2;
ball_stud_y_off = 0;
ball_stud_m3_hole_d = 2.85;
ball_stud_m3_nuttrap_d = 6.5;

//------------------------- 
// Extruder mount Variables
//------------------------- 
extruder_mount_screw_spacing = 28;
extruder_mount_screw_z_off = 40;
extruder_mount_w = 16;
extruder_mount_base_t = 5;
extruder_mount_t = 5;
extruder_mount_h = 30;
extruder_mount_overhang = 35;
extruder_m4_nuttrap_depth = 3;
extruder_mount_angle = 40;

//------------------------- 
// Mockup Variables
//------------------------- 


rail_w = 9;
rail_l = 250;
rail_t = 6.5;

// For mockup purposes
mockup_rail_w = 9;
mockup_rail_t = 6.5;
mockup_rail_l = 250;

// Nuttrap with trap bottom at z 0, trap up - subtract this from part
// Optional Smash compensation for the screw hole
module nuttrap(hole_d, hole_h, trap_d, trap_h, smash_comp_enable=true, membrane_bridge=0)
{ 
  difference()
  {
    union()
    {
      translate([0,0,trap_h*0.5])
        cylinder(d=trap_d, $fn=6, h=trap_h+ff, center=true);
      // Nut side smash compensation
      if (smash_comp_enable)
        translate([0, 0, -ff])
          linear_extrude(height=smash_comp, scale=trap_d/(trap_d+smash_comp*2))
            circle(d=trap_d+smash_comp*2, $fn=6, center=true);
      translate([0,0,hole_h*0.5+trap_h])
      {
        cylinder(d=hole_d, h=hole_h, center=true);
        // screw-side smash compensation
        if (smash_comp_enable)
          translate([0, 0, hole_h*0.5-smash_comp+ff])
            linear_extrude(height=smash_comp, scale=(hole_d+smash_comp*2)/hole_d)
              circle(d=hole_d, center=true);
      }
    }
    if (membrane_bridge > 0)
      translate([0,0,trap_h+membrane_bridge*0.5])
        cylinder(h=membrane_bridge+ff, d=trap_d, center=true);

  }
}

// Test module for extrusion mounts
module ext_fit_test()
{
  difference()
  {
    // Frame body
    cube([base_length*0.5, base_width, top_base_thick], center=true);
    // Extrusion hole
    translate([ext_hole_x_offset, ext_hole_y_offset, -top_base_thick*0.5+ext_hole_depth*0.5])
      cube([ext_width+ext_extra, ext_width+ext_extra, bottom_base_thick*2], center=true);
    // Extrusion mount holes
    for(i = [-1,1])
      translate([0,base_width*0.5,i*ext_mount_hole_spacing*0.5])
        rotate([90,0,0])
          cylinder(h=base_width, d=ext_mount_hole_d, center=true);
  }
}

module smooth_block(width, length, height, corner_r)
{
  hull()
    for(i=[-1,1])
      for(j=[-1,1])
        translate([i*(width*0.5-corner_r), 
                   j*(length*0.5-corner_r), 
                   0])
          cylinder(h=height, r=corner_r, center=true);
}

// Subtract this module
module mount_slot(hole_d, height, length, smash_comp=false, smash_comp_size = 0.5, smash_comp_invert=false)
{
  hull()
    for (i = [-1,1])
      translate([0, i*length*0.5, 0])
        cylinder(h=height, d=hole_d, center=true);

  if (smash_comp)
    rotate([(smash_comp_invert ? 180 : 0), 0, 0])
      translate([0, 0, height*0.5 - smash_comp_size])
        linear_extrude(height=smash_comp_size, center=true, scale=(smash_comp_size*2+hole_d)/hole_d)
          hull()
          for (j = [-1,1])
            translate([0, j*length*0.5, 0])
              circle(d=hole_d, center=true);
}
  
module rounded_arm(length, width, height)
{          
  hull()
  {
    translate([0, -length*0.5, 0])
      cylinder(h=height, d=width, center=true);
    translate([0, length*0.5, 0])
      cylinder(h=height, d=width, center=true);
  }
}

module hole_smash_comp(hole_d)
{
  // Smash compensation
  translate([0,0,smash_comp])
    rotate([180,0,0])
      linear_extrude(height=smash_comp, scale=(hole_d+smash_comp*2)/hole_d)
        circle(d=hole_d, center=true);
}
