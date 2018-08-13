// Makerbot Flextion Duct Mount
// Developed by: Michael McCool
// Depends on: 
//   https://github.com/mmccool/openscad-library (put in OPENSCADPATH)

include <tols.scad>
include <smooth.scad>

echo("Smoothing: ",sm_base);

// Dependencies
include <bolt_params.scad>
use <bolts.scad>

duct_hole_sh = 38;
duct_hole_sw = 41;
duct_fan_w = 48;
duct_fan_h = 52;
mount_d = 10; // original is 8.3, but a little extra clearance is needed for flextion
mount_t = 2; // thickness of mounting points
mount_cs_r = 7.5/2; // radius of countersink
motor_heat_sink_t = 2; // add heat sink to motor
mount_wc = 67.3; // distance from inside mounting faces (outside of fan, to outside of motor)
mount_wi = mount_wc + motor_heat_sink_t;
mount_fan_cb_s = 17.25; // distance from outside of fan to cold block slot
mount_fan_lower_hole_h = 5.34; // height of center of lower duct fan hole from platform
motor_w = 34;  // width of motor (distance from cb to back of motor)
motor_h = 42;  // height of motor (square)
mount_fan_hole_cb_s = 21; // distance of center of lower fan hole from cold block
mount_fan_hole_r = 2.8/2;
cb_w = mount_wc - motor_w - mount_fan_cb_s;
motor_hole_s = 31; // spacing between motor bolts
motor_hole_i = (motor_h - motor_hole_s)/2;
mount_r = 5/2;  // corner rounding
mount_sm = 4*sm_base;
platform_w = 89; // max width of platform
platform_i = 5; // platform wiring inset
wire_hole_r1 = 35/2;
wire_hole_r2 = 40/2;
mount_hole_r = 3.5/2;

mount_w = mount_wi + 2*mount_t; 
mount_h = 50;

module connector() {
  difference() {
    union() {
      hull() {
        translate([0,motor_hole_i,mount_d+platform_i+motor_hole_i])
          rotate([0,90,0])
            cylinder(r=motor_hole_i,2*mount_t,$fn=2*mount_sm);
        translate([0,0,0])
          cube([2*mount_t,2*motor_hole_i,platform_i+2*motor_hole_i]);
      }
      translate([0,motor_hole_s,0]) hull() {
        translate([0,motor_hole_i,mount_d+platform_i+motor_hole_i])
          rotate([0,90,0])
            cylinder(r=motor_hole_i,2*mount_t,$fn=2*mount_sm);
        translate([0,0,0])
          cube([2*mount_t,2*motor_hole_i,platform_i+2*motor_hole_i]);
      }
      hull() {
        translate([-2*mount_t,0,0])
          cube([3*mount_t,motor_h,platform_i+mount_d]);
        translate([-4*mount_t,0,0])
          cube([5*mount_t,motor_h,mount_d]);
      }
    }
    // mounting hole countersink
    translate([mount_t,motor_hole_i,mount_d+platform_i+motor_hole_i]) {
      rotate([0,90,0])
        cylinder(r=mount_cs_r,2*mount_t,$fn=mount_sm);
      translate([0,motor_hole_s,0]) rotate([0,90,0])
        cylinder(r=mount_cs_r,2*mount_t,$fn=mount_sm);
    }
    // mounting holes
    translate([-2*mount_t,motor_hole_i,motor_hole_i+mount_d+platform_i]) {
      rotate([0,90,0])
        cylinder(r=mount_hole_r,h=5*mount_t,$fn=mount_sm);
      translate([0,motor_hole_s,0]) rotate([0,90,0])
        cylinder(r=mount_hole_r,h=5*mount_t,$fn=mount_sm);
    }
  }
}
module mount() {

  difference() {
    union() {
      hull() {
        // part that extends out past platform
        translate([mount_t+mount_fan_cb_s-mount_fan_hole_cb_s-mount_fan_hole_r,mount_r,0])
          cylinder(r=mount_r,h=mount_d,$fn=mount_sm);
        translate([mount_w-mount_r-eps,eps,0])
          cylinder(r=eps,h=mount_d,$fn=mount_sm);
        translate([mount_t+mount_fan_cb_s-mount_fan_hole_cb_s-mount_fan_hole_r,mount_h-mount_r,0])
          cylinder(r=mount_r,h=mount_d,$fn=mount_sm);
        translate([mount_w-2*mount_r,mount_h-mount_r,0])
          cylinder(r=mount_r,h=mount_d,$fn=mount_sm);
      }
      // motor mount connector
      translate([mount_wi,0,0]) connector();
      // fan mount connector
      translate([0,motor_h,0]) rotate([0,0,180]) connector();
    }
    // fan duct mounting holes
    translate([mount_t+mount_fan_cb_s-mount_fan_hole_cb_s,mount_fan_lower_hole_h,-1]) {
      cylinder(r=mount_fan_hole_r,h=mount_d+2,$fn=mount_sm);
      translate([duct_hole_sw,duct_hole_sh,0])
        cylinder(r=mount_fan_hole_r,h=mount_d+2,$fn=mount_sm);
      // central opening (for wiring)
      translate([duct_hole_sw/2,duct_hole_sh/2,0])
        cylinder(r=wire_hole_r1,h=mount_d+platform_i+2,$fn=4*mount_sm);
      translate([duct_hole_sw/2,duct_hole_sh/2,0])
        cylinder(r=wire_hole_r2,h=mount_d/2+1,$fn=4*mount_sm);
      translate([duct_hole_sw/2,duct_hole_sh/2,mount_d/2+1-tol])
        cylinder(r2=wire_hole_r1,r1=wire_hole_r2,h=mount_d/2-1+tol,$fn=4*mount_sm);
    }
  }
}

mount();