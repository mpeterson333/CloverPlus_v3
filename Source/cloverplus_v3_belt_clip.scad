
$fs = 0.25;
$fa = 0.25;

//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 belt clip by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
// This part is designed to connect 2 ends of a GT2 timing belt together and hold them tensioned.
// It sort of works.. maybe..
//---------------------------------------------------------------------------------------------------- 

cloverplus_v3_belt_clip();

module cloverplus_v3_belt_clip()
{

  belt_channel_w = 2.1;
  belt_channel_l = 7;
  belt_t = 1.5;
  belt_extra = 0.5;
  
  loop_d = 5;
  loop_h = 10;
  loop_to_channel_offset = loop_d*0.5+belt_channel_w*2;
  loop_to_loop_offset = loop_d+belt_channel_w*1.5;
  
  wall_h = 6;
  
  clip_t = 2.5;
  clip_h = 6;
  
  block_w = belt_channel_w + clip_t*2;
  block_h = clip_h+clip_t;
  block_l = belt_channel_l*2+loop_to_channel_offset*2 + loop_to_loop_offset;
  mid_inner_d = loop_d+(belt_t+belt_extra)*2;
  mid_outer_d = mid_inner_d+clip_t*2;
  
  ff = 0.1;
  
  difference()
  {
    union()
    {
      // Main block
      cube([block_l, block_w, block_h], center=true);
      // Middle cylinders
      for(i=[-1,1])
        translate([i*loop_to_loop_offset*0.5, 0, 0])
        {
          cylinder(h=block_h, d=mid_outer_d, center=true);
          translate([0, 0, -block_h*0.5+clip_h*0.5+clip_t])
            cylinder(h=clip_h, d=loop_d, center=true);
        }
    }
    // Belt channels around loop pegs
    for(i=[-1,1])
      translate([i*loop_to_loop_offset*0.5, 0, clip_t])
        cylinder(h=block_h+ff, d=mid_inner_d, center=true);
    // Straight Belt channel
    translate([0, 0, clip_t])
      cube([block_l+ff, belt_channel_w, block_h+ff], center=true);
    // Make channels smoother for easier insertion
    for(i=[-1,1])
      hull()
      {
        translate([i*(belt_channel_l*0.25+loop_to_loop_offset*0.5+loop_to_channel_offset), 
                   0, 
                   clip_h*0.5-block_h*0.5+clip_t])
          cube([1, belt_channel_w, clip_h+ff], center=true);
        translate([i*(loop_to_loop_offset*0.5), 0, clip_h*0.5-block_h*0.5+clip_t])
          cube([1, mid_inner_d*0.75, clip_h+ff], center=true);
      }
  }
  
  // Loop pegs
  for(i=[-1,1])
    translate([i*loop_to_loop_offset*0.5, 0, -block_h*0.5+loop_h*0.5+clip_t])
      cylinder(h=loop_h, d=loop_d, center=true);
}
