include <cloverplus_v3_utils.scad>;

//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 Top and Bottom frame parts by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
// This file contains the top and bottom frame parts.  These can print in 3 separate parts each
// (3 top and 3 bottom) or in a single piece top and single piece bottom.  I recommend the latter if
// you have a larger printer available to you (220mm diameter should do it).
//---------------------------------------------------------------------------------------------------- 

cloverplus_v3_topbottom(mockup_build=0, one_piece_top_and_bottom=0);

module cloverplus_v3_topbottom(mockup_build = 0, one_piece_top_and_bottom = 0)
{
  $fs = 0.5;
  $fa = 0.5;

  
  // See cloverplus_v3_utils.scad for variables
  
  //------------------------- 
  // Part Instantiation 
  //------------------------- 
  
  // For mockup and/or one piece top/bottom build
  if (one_piece_top_and_bottom || mockup_build)
  {
  
    // Pieces for printing
    if (!mockup_build)
    {
      // For printing
      for(i = [0, 120, 240])
        rotate([0,0,i])
          translate([0,-center_base_to_center_len,0])
            top_piece(noconnects=1);
    
      translate([center_base_to_center_len*3, 0, 0])
        for(i = [0, 120, 240])
          rotate([0,0,i])
            translate([0,-center_base_to_center_len,0])
              if (i == 240)
              {
                bottom_piece(noconnects=true, big_connect_left=true);
              }
              else if (i == 0)
              {
                bottom_piece(noconnects=true, big_connect_left=true, bottom_extruder_mount_holes=true);
              }
              else if (i == 120)
              {
                bottom_piece(noconnects=true);
              }
    }
    // Mockup including extrusions and rails
    else
    {
      // Top parts all together
      translate([0,0,ext_len-top_base_thick])
        for(i = [0, 120, 240])
          rotate([180,0,i])
            translate([0,-center_base_to_center_len,0])
              top_piece(1);
    
        // Bottom parts all together
        for(i = [0, 120, 240])
          rotate([180,0,i])
            translate([0,-center_base_to_center_len,0])
              if (i == 240)
              {
                bottom_piece(noconnects=true, big_connect_left=true, bottom_extruder_mount_holes=true);
              }
              else if (i == 0)
              {
                bottom_piece(noconnects=true, big_connect_left=true);
              }
              else if (i == 120)
              {
                bottom_piece(noconnects=true);
              }
  
          // Extrusions in grey, rails in green
          for(i = [60, 180, 300])
            rotate([0,0,i])
            {
              translate([0, -ext_center_to_center_len, ext_len*0.5-bottom_base_thick*0.5])
                color("grey")
                  cube([10, 10, ext_len], center=true);
              *translate([0, -ext_center_to_center_len+ext_width*0.5+rail_t*0.5, ext_len-rail_l*0.5-top_base_thick-bottom_base_thick*0.5-15])
                color("green")
                  cube([rail_w, rail_t, rail_l], center=true);
            }
    }
  }
  
  // Separate pieces (3 for top, 3 for bottom)
  else
  {
    top_piece();
  
    *translate([0,-80,0])
      bottom_piece();
  }
  
  module ext_fit_test()
  {
    difference()
    {
      // Frame body
      cube([base_length*0.5, base_width, top_base_thick], center=true);
      // Extrusion hole
      translate([ext_hole_x_offset, ext_hole_y_offset, 0])
      {
        cube([ext_width+ext_extra, ext_width+ext_extra, bottom_base_thick+ff*2], center=true);
        // Smash compensation
        translate([0, 0, -bottom_base_thick*0.5-ff])
          linear_extrude(height=smash_comp, scale=(ext_width+ext_extra)/(ext_width+ext_extra+smash_comp*2))
            square([ext_width+ext_extra+smash_comp*2, ext_width+ext_extra+smash_comp*2], center=true); 
        translate([0, 0, bottom_base_thick*0.5+ff])
        rotate([180,0,0])
          linear_extrude(height=smash_comp, scale=(ext_width+ext_extra)/(ext_width+ext_extra+smash_comp*2))
            square([ext_width+ext_extra+smash_comp*2, ext_width+ext_extra+smash_comp*2], center=true); 
      }
      // Extrusion mount holes
      for(i = [-1,1])
        translate([0,base_width*0.5,i*ext_mount_hole_spacing*0.5])
          rotate([90,0,0])
            cylinder(h=base_width, d=ext_mount_hole_d, center=true);
    }
  }

  
  //------------------------- 
  // Modules
  //------------------------- 
  
  // Top Piece
  module top_piece(noconnects = false)
  {
    difference()
    {
      union()
      {
        // Frame body
        cube([base_length, base_width, top_base_thick], center=true);
    
        // Left leg
        leg(top_base_thick, leg_edge_start_inner_top, leg_edge_start_outer, 0, 0,
            leg_wire_guide_top_z_offset, right=false, switch=true, noconnects = noconnects, top = true);
        // Right leg
        leg(top_base_thick, leg_edge_start_inner_top, leg_edge_start_outer, 0, 0,
            leg_wire_guide_top_z_offset, right=true, switch=true, noconnects = noconnects, top = true);
      }
  
      // Extrusion hole
      translate([ext_hole_x_offset, ext_hole_y_offset, 0])
      {
        cube([ext_width+ext_extra, ext_width+ext_extra, bottom_base_thick+ff*2], center=true);
        // Smash compensation
        translate([0, 0, -top_base_thick*0.5-ff])
          linear_extrude(height=smash_comp, scale=(ext_width+ext_extra)/(ext_width+ext_extra+smash_comp*2))
            square([ext_width+ext_extra+smash_comp*2, ext_width+ext_extra+smash_comp*2], center=true);
      }
    
      // Idler Pulley hole
      translate([-idler_pulley_x_offset, 0, 0])
        rotate([90,0,0])
          cylinder(h=base_width+0.2, d=idler_pulley_hole_d, center=true);
  
      // Extrusion mount holes
      for(i = [-1,1])
        translate([0,base_width*0.5,i*ext_mount_hole_spacing*0.5])
          rotate([90,0,0])
            cylinder(h=base_width, d=ext_mount_hole_d, center=true);
    }
  }
  
  // Bottom Piece
  // noconnects turns off multi-piece connectors
  // big_connect_left puts a single solid big connector on the left side of the
  //   leg
  // bottom_extruder_mount_holes enables extruder mount holes just right of
  //   center on one side
  module bottom_piece(noconnects = false, big_connect_left = false, bottom_extruder_mount_holes = false)
  {
    difference()
    {
      union()
      {
        // Frame body
        cube([base_length, base_width, bottom_base_thick], center=true);
    
        // Left leg
        leg(bottom_base_thick, leg_edge_start_inner_bottom, 0, 0, motor_mount_size, 
            leg_wire_guide_bottom_z_offset, right=false, switch=false, noconnects = noconnects, top = false, big_connect_left = big_connect_left, bottom_extruder_mount_holes = bottom_extruder_mount_holes);
        // Right leg
        leg(bottom_base_thick, leg_edge_start_inner_bottom, 0, 0, motor_mount_size, 
            leg_wire_guide_bottom_z_offset, right=true, switch=false, noconnects = noconnects, top = false, big_connect_left = false, bottom_extruder_mount_holes = bottom_extruder_mount_holes);
    
        // Motor mount
        translate([0, -base_width*0.5+motor_mount_thick*0.5, motor_mount_size*0.5+bottom_base_thick*0.5])
          motor_mount(motor_mount_size, motor_mount_thick, motor_mount_hole_d, 
                      motor_mount_screw_hole_d, motor_mount_screw_spacing,
                      -motor_mount_x_offset);
      }
    
      // Extrusion hole
      translate([ext_hole_x_offset, ext_hole_y_offset, 0])
      {
        cube([ext_width+ext_extra, ext_width+ext_extra, bottom_base_thick+ff*2], center=true);
        // Smash compensation
        translate([0, 0, -bottom_base_thick*0.5-ff])
          linear_extrude(height=smash_comp, scale=(ext_width+ext_extra)/(ext_width+ext_extra+smash_comp*2))
            square([ext_width+ext_extra+smash_comp*2, ext_width+ext_extra+smash_comp*2], center=true); 
      }
  
      // Extrusion mount holes
      for(i = [-1,1])
        translate([0,base_width*0.5,i*ext_mount_hole_spacing*0.5])
          rotate([90,0,0])
            cylinder(h=base_width, d=ext_mount_hole_d, center=true);
    }
  }
  
  // Leg (2 per piece, a right and a !right)
  module leg(base_thick, edge_start_inner, edge_start_outer, edge_near_height_inner, 
             edge_near_height_outer, wire_guide_hole_z_offset, right = false, switch = true,
             noconnects = false, big_connect_left = false, bottom_extruder_mount_holes = false)
  {
      translate([right ? base_length*0.5 : -base_length*0.5,-base_width*0.5,-base_thick*0.5])
        rotate([0,0,right ? -30 : 30])
          translate([right ? -base_width : 0,0,0])
            difference()
            {
              union()
              {
                // Leg body
                cube([base_width, leg_length, base_thick]);
  
                // Edges rise to connectors
                leg_edges(base_thick, edge_start_inner, edge_start_outer, edge_near_height_inner, 
                          edge_near_height_outer, right, edge_length=40);
  
                if (!noconnects)
                {
      
                  // Left and right connectors
                  translate([0, leg_length-leg_connector_thick-leg_connector_setback, 0])
                    leg_connector(leg_connector_far_height, leg_connector_width, leg_connector_thick, 
                                  leg_edge_thick, leg_connector_hole_d, right=false);
                  translate([base_width, leg_length-leg_connector_thick-leg_connector_setback, 0])
                    leg_connector(leg_connector_far_height, leg_connector_width, leg_connector_thick, 
                                  leg_edge_thick, leg_connector_hole_d, right=true);
                }
  
                if (big_connect_left && !right)
                {
                  // single big connector on the left
                  translate([0, leg_length-leg_connector_thick-leg_connector_setback, 0])
                    leg_connector(leg_connector_far_height, leg_connector_width, leg_connector_thick*2 + leg_connector_setback*2, 
                                  leg_edge_thick, leg_connector_hole_d, right=false);
                }
    
                // Male coupler
                if (!right && !noconnects)
                {
                  translate([base_width*0.5-leg_coupler_width_male*0.5, leg_length, 0])
                    cube([leg_coupler_width_male, leg_coupler_length_male, leg_coupler_height]);

                }
              }

              // smash comp for male coupler
              if (!right && !noconnects)
              {
                side_smash_width = base_width+leg_connector_width*2-leg_coupler_width_male*0.5;
                // Smash comp for sides of male coupler and edge of leg
                for(i=[-1,1])
                  translate([
                             base_width*0.5+i*(side_smash_width*0.5+leg_coupler_width_male*0.5),
                             leg_length+leg_coupler_length_male*0.5,
                             smash_comp
                            ])
                    rotate([0,180,0])
                      linear_extrude(height=smash_comp, 
                        scale=[
                               (side_smash_width+smash_comp*2)/side_smash_width,
                               (leg_coupler_length_male+smash_comp*2)/leg_coupler_length_male
                              ])
                        square([side_smash_width, leg_coupler_length_male], center=true);
                // Smash comp for male coupler end
                translate([
                           base_width*0.5,
                           (leg_coupler_width_male)*0.5+leg_length+leg_coupler_length_male,
                           smash_comp
                          ])
                  rotate([0,180,0])
                    linear_extrude(height=smash_comp, scale=(leg_coupler_width_male+smash_comp*2)/leg_coupler_width_male)
                      square([leg_coupler_length_male, leg_coupler_width_male], center=true);
              }
    
              if (right)
              {
                // Female coupler end
                if (!noconnects)
                {
                  translate([base_width*0.5-leg_coupler_width_female*0.5, leg_length-leg_coupler_length_female, 0])
                    cube([leg_coupler_width_female, leg_coupler_length_female, leg_coupler_height*10]);

                  // Smash comp for the female slot
                  translate([base_width*0.5,leg_length-leg_coupler_length_female*0.5,smash_comp])
                    rotate([0,180,0])
                      linear_extrude(height=smash_comp, 
                                     scale=[
                                            (leg_coupler_width_female+smash_comp*2)/leg_coupler_width_female,
                                            (leg_coupler_length_female+smash_comp*2)/leg_coupler_length_female
                                           ])
                        square([leg_coupler_width_female, leg_coupler_length_female], center=true);
                  // Smash comp for the end
                  smash_width = base_width+leg_connector_width*2;
                  translate([base_width*0.5,leg_length+smash_width*0.5,smash_comp])
                    rotate([0,180,0])
                      linear_extrude(height=smash_comp, scale=(smash_width+smash_comp*2)/smash_width)
                        square([smash_width, smash_width], center=true);
                }
    
                // Switch holes
                if (switch)
                  translate([-ff, leg_switch_hole_y_offset, base_thick-leg_switch_hole_z_offset])
                    switch_holes(leg_switch_hole_d, leg_switch_hole_depth+0.2, leg_switch_hole_spacing);
              }
    
              // Hollow out the leg
              translate([leg_edge_thick, leg_cutout_start, leg_coupler_height])
                leg_hollow(leg_cutout_curve_radius, leg_length, base_width-leg_edge_thick*2, 100);
    
              // Controller / extruder mount holes with nut traps
              translate([base_width*0.5+leg_hole_x_offset, leg_length-leg_hole_y_offset, leg_coupler_height])
                rotate([180,0,0])
                  nuttrap(m4_hole_d, leg_coupler_height, m4_nuttrap_d, leg_m4_nuttrap_depth);
  
              // Extra holes for mounting extruder on bottom, for example, on the right only
              if (bottom_extruder_mount_holes && right)
                translate([base_width*0.5, leg_length-bottom_leg_extruder_mount_holes_y_offset, leg_coupler_height])
                  for (i = [-bottom_leg_extruder_mount_holes_spacing*0.5, bottom_leg_extruder_mount_holes_spacing*0.5])
                    translate([0,i,0])
                      rotate([180,0,0])
                        nuttrap(m4_hole_d, leg_coupler_height, m4_nuttrap_d, leg_m4_nuttrap_depth);

              // Wire guide hole
              translate([(leg_edge_thick+0.2)*0.5-ff, leg_length-leg_wire_guide_hole_y_offset,
                         leg_connector_far_height+wire_guide_hole_z_offset])
                rotate([0,90,0])
                  cylinder(h=leg_edge_thick+0.2, d=leg_wire_guide_hole_d, center=true);
            }
   
  }
  
  // Leg edges that extend from base and then up or down to connector ends
  module leg_edges(base_thick, edge_start_inner, edge_start_outer, edge_near_height_inner, edge_near_height_outer, right = false, edge_length=20, end_len=10)
  {
    for(i = [0, base_width-leg_edge_thick])
      hull()
      {
        translate([i, edge_length, leg_connector_far_height-1])
          cube([leg_edge_thick, end_len, 1]);
        translate([i, edge_length, base_thick-1])
          cube([leg_edge_thick, end_len, 1]);
        translate([i, ((right && i == 0) || (!right && i)) ? edge_start_inner : edge_start_outer, 
          ((right && i == 0) || (!right && i)) ? edge_near_height_inner+base_thick-1 : edge_near_height_outer+base_thick-1])
          cube([leg_edge_thick, end_len, 1]);
        translate([i, ((right && i == 0) || (!right && i)) ? edge_start_inner : edge_start_outer, base_thick-1])
          cube([leg_edge_thick, end_len, 1]);
      }
  }
  
  // Curved leg cutout
  module leg_hollow(edge_radius, length, width, height)
  {
    rotate([90,0,0])
      translate([width*0.5,edge_radius,-height])
        linear_extrude(h=length)
        {
          for(i = [-width*0.5+edge_radius, width*0.5-edge_radius])
            translate([i,0,0])
              circle(r=edge_radius, center=true);
          square([width-edge_radius*2, edge_radius*2], center=true);
          translate([0, (height-edge_radius)*0.5,0])
            square([width, height-edge_radius], center=true);
        }
  }
  
  // Connector ends with screw holes
  module leg_connector(height, size, thick, edge_thick, hole_d, right = false)
  {
    difference()
    {
      hull()
      {
        translate([right ? -edge_thick : -size, 0, height-size])
          cube([size+edge_thick, thick, size]);
        translate([right ? -edge_thick : -edge_thick*2, 0, 0])
          cube([edge_thick*3, thick, size]);
      }
      translate([right ? size*0.5 : -size*0.5, thick*0.5, height - size*0.5])
      rotate([90,0,0])
        cylinder(h=thick+0.2, d=hole_d, center=true);
    }
  }
  
  // Motor mount plate with holes
  module motor_mount(size, thick, mount_d, screw_d, spacing, x_offset)
  {
  
    difference()
    {
      // Motor mount plate
      cube([size,thick,size], center=true);
      // x offset for holes allows for belt path adjustment
      translate([x_offset,0,0])
      {
        // Motor shaft hole
        rotate([90,0,0])
          cylinder(h=thick+0.2, d=mount_d, center=true);
        // Motor screw holes
        for (i = [-spacing*0.5,spacing*.5])
          for (j = [-spacing*0.5,spacing*.5])
            translate([i,0,j])
              rotate([90,0,0])
                cylinder(h=thick+0.2, d=screw_d, center=true);
      }
    }
  }
  
  // Holes for endstop switch
  module switch_holes(hole_d, depth, spacing)
  {
    translate([depth*0.5+0.1, 0, 0])
      rotate([0,90,0])
        cylinder(h=depth+0.2, d=hole_d, center=true);
    translate([depth*0.5+0.1, spacing, 0])
      rotate([0,90,0])
        cylinder(h=depth+0.2, d=hole_d, center=true);
  }
  
  

}
