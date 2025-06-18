// -*- coding: utf-8 -*-

L = 28;
b = 7;
t = 2;
d_bottom = 12;

// inner backplate
L_offset = 6;
L_b = 13;
L_t = 2;
L_d = 5;

// front plate
L_offset1 = 20;
L_d1 = 10;

L_offset2 = 9;
L_end = 17;


cube([L,b,t]);
// end stop
translate([L,0,0]) cube([t,b,d_bottom]);

// back plate
translate([0,b,0]) cube([L+t,t,d_bottom]);
// inner back plate
translate([L_offset,b-L_t,0]) cube([L_b,L_t,L_d]);

// front plate
translate([L_offset1,-t,0]) cube([(L+t)-L_offset1,t,L_d1]);
translate([L_offset2,-t,0]) cube([L_end - L_offset2,t,L_d1]);