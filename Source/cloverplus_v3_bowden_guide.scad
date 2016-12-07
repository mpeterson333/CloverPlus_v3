include <cloverplus_v3_utils.scad>;
//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 bowden guide by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
// This part keeps the bowden tube centered to minimize torque applied to the effector thus reducing
// print deformation.  This mounts to the top front of the printer using 2 M4x10mm screws
// and a M3x16mm with M3 nyloc nut
//---------------------------------------------------------------------------------------------------- 


$fs = 0.25;
$fa = 0.25;

bowden_guide();

module bowden_guide()
{

  // Lengto from screw mount to center of bowden guide
  mount_to_center_l = 65;
  // Mounting arm width
  arm_w = 20;
  // Screw mount width
  mount_w = 20;
  
  // Strength rib width and height
  rib_w = 3;
  rib_h = 4;

  // Amount ribs overlap with screw mount
  rib_mount_overlap = 3;
  
  // Uses leg_hole_y_offset * 2 for mount screw spacing
  mount_t = 4;
  
  // Guide to arm attach variables
  attach_depth = 7;
  attach_extra = 0.25;
  attach_w = 5;
  attach_h = rib_h + mount_t;
  attach_hole_d = 3.4;
  
  // Guide taper sizing
  guide_id_1 = 12;
  guide_od_1 = 14;
  
  guide_id_2 = 28;
  guide_od_2 = 30;
  
  guide_t = guide_od_1 - guide_id_1;
  
  guide_h = 60;
  // Guide taper gap for tube insertion
  cutout_t = 1;
  
  // calculated rib / guide connector length
  rib_l = mount_to_center_l - mount_w*0.5 + rib_mount_overlap - guide_od_1*0.5;
  

  // Instantiation
  mount();
  
  translate([-mount_w*1.5, 0, guide_h*0.25])
    guide();
  
  // Mount + arm
  module mount()
  {
    difference()
    {
      union()
      {
    
        // Mount and arm
        rounded_arm((leg_hole_y_offset) * 2, mount_w, mount_t);
        translate([0, -mount_w*0.5, -mount_t*0.5])
          cube([mount_to_center_l - guide_od_1*0.5 - attach_depth - attach_extra, arm_w, mount_t]);
    
        // Ribs
        for (i = [-1,1])
        {
          translate([rib_l*0.5 + mount_w*0.5 - rib_mount_overlap, i*(attach_w*0.5+rib_w*0.5), rib_h*0.5])
            cube([rib_l, rib_w, rib_h + mount_t], center=true);
        }
    
    
      }
      // Frame mount holes
      for(i=[-1,1])
        translate([0, leg_hole_y_offset*i, 0])
          cylinder(h=mount_t+ff, d=m4_hole_d, center=true);
  
      // Guide attach hole
      translate([mount_to_center_l - guide_od_1*0.5 - attach_depth*0.5, 0, (rib_h)*0.5])
        rotate([90, 0, 0])
          cylinder(h=mount_w, d=attach_hole_d, center=true);
    }
  }
  
  // Bowden tube guide and attach point
  module guide()
  {
    difference()
    {
      union()
      {
        // Guide
        translate([0, 0, guide_h*0.75*0.5-mount_t*0.5])
          cylinder(h=guide_h*0.75, d=guide_od_1, center=true);
        translate([0, 0, guide_h*0.75 + guide_h*0.25*0.5 - mount_t*0.5])
          guide_taper();
        translate([0, 0, -guide_h*0.25*0.5-mount_t*0.5])
        rotate([180, 0, 0])
          guide_taper();
  
        // Attach point
        translate([0, 0, guide_h*0.1])
          hull()
          {
            translate([-guide_id_1*0.5 - attach_depth*0.5, 0, attach_depth*2])
              cube([attach_depth + guide_t, attach_w - attach_extra, attach_depth], center=true);
            translate([-guide_id_1*0.5 - 0.5, 0, attach_depth*1.25])
              cube([1, attach_w - attach_extra, attach_depth*2.5], center=true);
          }
      }
  
    // Guide recess
    translate([0, 0, guide_h*0.25-mount_t*0.5])
      cylinder(h=guide_h+ff, d=guide_id_1, center=true);
  
    // Side cutout
    translate([0, 0, -guide_h])
      cube([cutout_t, guide_od_2, guide_h*3]);
  
    // Guide attach screw hole
    translate([-guide_od_1*0.5 - attach_depth*0.5, 0, attach_depth*2+guide_h*0.1])
      rotate([90, 0, 0])
        cylinder(h=mount_w, d=attach_hole_d, center=true);
    }
  
  }
  
  // Tapered guide section
  module guide_taper()
  {      
    difference()
    {
      linear_extrude(height=guide_h*0.25, center=true, scale=guide_od_2/guide_od_1)
        circle(d=guide_od_1, center=true);
      linear_extrude(height=guide_h*0.25+ff, center=true, scale=guide_id_2/guide_id_1)
        circle(d=guide_id_1, center=true);
    }
  }
}
