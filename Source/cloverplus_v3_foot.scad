$fs = 0.25;
$fa = 0.25;
//---------------------------------------------------------------------------------------------------- 
// CloverPlus v3 foot by pbmax (mpeterson333/@/gmail.com)
//---------------------------------------------------------------------------------------------------- 
// These support the printer and isolate vibrations from the surface below it.
//---------------------------------------------------------------------------------------------------- 

cloverplus_v3_foot();

module cloverplus_v3_foot()
{
  d = 15;
  l = 40;
  w = 30;
  t = 1.5;
  
  ff = 0.1;
  
  
  grip_w = 4.5;
  grip_h = 2.75;
  
  difference()
  {
    union()
    {
      foot_shape(l,w,d);
      for(i = [-1,1])
        translate([i*(grip_w*0.5+t*0.5), d*0.5, w*0.5])
          cube([t, grip_h, w], center=true);
    }
    foot_shape(l-t*2,w,d-t*2, t*0.5);
  }
  
  module foot_shape(l, w, d, cube_y_off = 0)
  {
    translate([0, d*0.125 + cube_y_off*0.5, w*0.5])
    cube([l-d, d*0.75 - cube_y_off, w], center=true);
    linear_extrude(height=w)
    {
      for(i = [-1,1])
        translate([i*(l*0.5-d*0.5), 0, 0])
          circle(d=d, center=true);
    }
  }
}
