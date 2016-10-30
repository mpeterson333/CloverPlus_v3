$fn=32;

// Note that this version uses 624ZZ bearings instead of 603ZZ bearings to support the main shaft
// Also, this version has been modified to use an M5 push-fit adapter and a M4 mount screw.

nut_slop = .3;
bolt_slop = .2;
m3_diameter = 3+bolt_slop;
m4_diameter = 4+bolt_slop;
m5_diameter = 5+bolt_slop;
m3_nut_diameter = 5.5/cos(30)+nut_slop;
m4_nut_diameter = 6.87/cos(30)+nut_slop;
m5_nut_diameter = 7.85/cos(30)+nut_slop;
idler_m3_nut_d = 5.4 + bolt_slop;

filament_r = 1.75;
filament_angle = 25;
filament_x = 25;
filament_y = 13;

id_bearing_x = 1.75;
id_bearing_y = 0;
id_bearing_z = 0;

sup_bearing_x = 15.2;
sup_bearing_y = -8.75;
sup_bearing_z = 15;

PG35L_ofset_x = 0;
PG35L_ofset_y = 0;
PG35L_ofset_z = 0;

sup_bearing_ofset_x = -0.4;
sup_bearing_ofset_y = -0.1;
sup_bearing_ofset_z = 0.75;
sup_bearing_sp = 7.25;

echo("m3_nut_d", m3_nut_diameter);


// pg35l&drive_gear
translate([-21.2,-18.5,-2.2])rotate([90,0,99.5])
translate([PG35L_ofset_y,PG35L_ofset_z,PG35L_ofset_x]){
	//%rotate([270,90+35.5,0])translate([-53,11,-39.3-4.5])import("PG35L-048_fix.STL", convexity = 100);
	%rotate([90,0,0])translate([-13.1,33.1,-18.16])import("drive_wheel_fix.STL", convexity = 100);
	//%rotate([90,0,180])translate([0.4,33.2,12.2])import("drive_wheel_fix.STL", convexity = 100);
}

//mount base
difference() {
	translate([35.25/2+1.5,-35.25/2-1.5,4.0]){
		union(){
			difference() {
				union(){
					// base
					translate([0,0,0.5])roundedBox([35.25,35.25,9],3,true);
					translate([-35.25/2-1.5,35.25/2+1.5,-4.0]){
						// PG35 mount bace
						translate([33.85+PG35L_ofset_x,-3.75+PG35L_ofset_z,4.5])
							cylinder(h=9, r=m3_nut_diameter/3*2, $fn=6, center=true);
						translate([4.15+PG35L_ofset_x,-33.45+PG35L_ofset_z,4.5])
							cylinder(h=9, r=m3_nut_diameter/3*2, $fn=6, center=true);
						// support bearing bace
						rotate([0,0,-filament_angle]){
							for (axis_z = [-1:2:1]) {
								translate([sup_bearing_ofset_x+sup_bearing_x,
									sup_bearing_sp*axis_z+sup_bearing_ofset_y+sup_bearing_y,
									sup_bearing_ofset_z/2+sup_bearing_z-5.25])
									cylinder(r=7.5/2, h=5+sup_bearing_ofset_z, center=true);
							}
						}
						// filament guide cube
						translate([29.5,-10,10])
							rotate([0,0,90-filament_angle])cube([8,12,20],center=true);
						difference() {
							translate([17.355,-32.5,13])
								rotate([0,0,90-filament_angle])cube([12,15,26],center=true);
							translate([14,-22,13])cube([12,7.5,27],center=true);
						}
                        hull()
                        {
				          translate([8,-8,9/2])
                            cube([11.25, 11.25, 9], center=true);
				          translate([0,0,9/2])
                            cylinder(h=9, d=16, center=true);
                        }
					}
				}
				// bace cut
				rotate([0,0,-filament_angle]){
					hull(){
						translate([-0.25,0.4,0])cylinder(r=13.75/2,h=15,center=true);
						translate([15,1,0])cylinder(r=15/2,h=15,center=true);
					}
					translate([17.545,0,10])cube([12,38,30],center=true);
				}
				// extruder mount hole
				translate([-19.25,19.25,0])cylinder(r=m4_diameter/2, h=30, center=true);
				//*translate([-14.1,14.1,-2.4])cube([8,8,5.35],center=true);
			}
			// idler joint hole
			rotate([0,0,-filament_angle])translate([-0.25,12.65,13-4]){
				difference() {
					hull(){
						for (axis_x = [-1:2:1]) {
							#translate([5*axis_x+12,0,0])cylinder(r=8/2, h=5, center=true);
						}
					}
					translate([16.2,-0.15,0])cylinder(r=m3_diameter/2, h=30, center=true);
				}
			}
		}
	}
	// PG35 mount
	translate([33.85+PG35L_ofset_y,-3.75+PG35L_ofset_z,-0.0+PG35L_ofset_x]){
		cylinder(r=m3_diameter/2, h=30, center=true);
		translate([0,0,7.5])cylinder(h=3.5, r=(m3_nut_diameter-0.2)/2, $fn=6, center=true);
	}
	translate([4.15+PG35L_ofset_x,-33.45+PG35L_ofset_z,-0.0]){
		cylinder(r=m3_diameter/2, h=30, center=true);
		translate([0,0,7.5])cylinder(h=3.5, r=(m3_nut_diameter-0.2)/2, $fn=6, center=true);
	}
	// support bearing
	// 603ZZ 3x 9x 5(mm) 
	rotate([0,0,-filament_angle]){
		for (axis_z = [-1:2:1]) {
			#translate([sup_bearing_ofset_x+sup_bearing_x,
				sup_bearing_sp*axis_z+sup_bearing_ofset_y+sup_bearing_y,sup_bearing_z]){
					%translate([0,0,sup_bearing_ofset_z])cylinder(r=13/2, h=5, center=true, $fn=32);
					cylinder(r=m4_diameter/2, h=30, center=true);
					rotate([0,0,55])translate([0,0,-13])
						cylinder(h=4.75, r=m4_nut_diameter/2, $fn=6, center=true);
			}
		}
	}
	// filament
	translate([filament_x,-20,filament_y])rotate([-90,0,-filament_angle]){
		#cylinder(r=filament_r/2*1.00, h=100, center=true);
		
		// Pneumatic fitting hole
		union(){
			translate([0,0,-11.1])rotate([0,0,90])cylinder(h=10, r=m5_nut_diameter/2, $fn=6, center=true);
			translate([0,0,-17.1])cylinder(h=2.01, r=m5_diameter/2, center=true);
			translate([0,0,-23.1])cylinder(h=10.0, r=9/2, center=true);
            // y = -25.6 puts this flush with the end
		}
	}
	// idler mount hole
	translate([-10,-20,13])rotate([90,0,-filament_angle-90]){
		for (axis_z = [-1:2:1]) {
			translate([0,8.5*axis_z,0]){
				cylinder(h=150, r=m3_diameter/2, center=true);
				translate([0,1*axis_z,-27.5])cube([idler_m3_nut_d,10,3],center=true);
			}
		}
	}
}
// idler 
// 624ZZ ì‡åa4xäOåa13xïù5(mm)
*translate([-5,-60,-11.15])rotate([0,90,0])
//translate([30.5,-68.5,28])rotate([0,0,-filament_angle])
difference(){
	// base
	union(){
		translate([id_bearing_x,id_bearing_y,id_bearing_z]){
			translate([-20-0.5,40.65-0.5,-15.00])cylinder(r=11/2, h=17, center=true, $fn=32);
			hull(){
				translate([-16.65,26,-15.00])cube([7.5,10,26],center=true);
				translate([-16.65,51.5,-15.00])cube([7.5,10,16],center=true);
			}
		}
	}
	//rotate([0,0,filament_angle])translate([15,55,-15])cube([5,9,20],center=true);
	rotate([0,0,-45])translate([-54,26,-15])cube([5,9,20],center=true);
	// idler joint hole
	for (axis_z = [-1:2:1]) {
		translate([-15,52.45,-15]){
			cube([10,9,6],center=true);
			cylinder(h=20, r=m3_diameter/2,center=true);
			translate([0,0,10*axis_z])cylinder(h=4, r=m3_nut_diameter/2,center=true);
		}
	}
	// idler mount hole
	translate([10,27,-15])rotate([90,0,90]){
		for (axis_z = [-1:2:1]) {
			hull(){
				for (axis_y = [-1:2:1]) {
					translate([4*axis_y-3.5,8.5*axis_z,0])cylinder(h=150, r=m3_diameter/2, center=true);
				}
			}
		}
	}
	// idler bearing
	translate([id_bearing_x-0.5,id_bearing_y-0.5,id_bearing_z+PG35L_ofset_z]){
		%translate([-20,40.65,-15.00])cylinder(r=13/2, h=5, center=true, $fn=32);
		translate([-20,40.65,-15.00])cylinder(r=14.0/2, h=5.75, center=true, $fn=32);
		translate([-20,50,-15.00])cube([6,10,5.75],center=true);	
		translate([-20,40.65,-17.5]){
			cylinder(r=m4_diameter/2, h=30, center=true);
//			rotate([0,0,90])translate([0,0,-4.0])
//				cylinder(h=3.5, r=m4_nut_diameter/2, $fn=6, center=true);
			for (axis_z = [-1:2:1]) {
				translate([0,0,10*axis_z+2.5])cylinder(h=4.51, r=m4_nut_diameter/2,center=true);
			}
		}
	}
}
// size is a vector [w, h, d]
module roundedBox(size, radius, sidesonly)
{
	rot = [ [0,0,0], [90,0,90], [90,90,0] ];
	if (sidesonly) {
		cube(size - [2*radius,0,0], true);
		cube(size - [0,2*radius,0], true);
		for (x = [radius-size[0]/2, -radius+size[0]/2],
				 y = [radius-size[1]/2, -radius+size[1]/2]) {
			translate([x,y,0]) cylinder(r=radius, h=size[2], center=true,$fn=32);
		}
	}
	else {
		cube([size[0], size[1]-radius*2, size[2]-radius*2], center=true);
		cube([size[0]-radius*2, size[1], size[2]-radius*2], center=true);
		cube([size[0]-radius*2, size[1]-radius*2, size[2]], center=true);

		for (axis = [0:2]) {
			for (x = [radius-size[axis]/2, -radius+size[axis]/2],
					y = [radius-size[(axis+1)%3]/2, -radius+size[(axis+1)%3]/2]) {
				rotate(rot[axis]) 
					translate([x,y,0]) 
					cylinder(h=size[(axis+2)%3]-2*radius, r=radius, center=true,$fn=32);
			}
		}
		for (x = [radius-size[0]/2, -radius+size[0]/2],
				y = [radius-size[1]/2, -radius+size[1]/2],
				z = [radius-size[2]/2, -radius+size[2]/2]) {
			translate([x,y,z]) sphere(radius);
		}
	}
}

