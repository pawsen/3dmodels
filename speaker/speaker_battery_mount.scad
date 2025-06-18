

// rigtig bredde er nok nærmere 65mm, men Leapfrog printer ca. en mm for kort i bredden. Højde passer.
   width = 66;
   height = 25.5;


// Usually you do not have to change these variables
   depth = 20;
   // length of mounting
   lm = 20;
   ls = 15;
   // thickness
   t = 4;
   t_mount = 4;
   t_stoppers = 4;

/*
   width = 74.5;
   height = 28.5;
   depth = 20;
   // length of mounting
   lm = 20;
   ls = 15;
   // thickness
   t = 4;
   t_mount = 4;
   t_stoppers = 4;
*/
// For making rounded corners
module fillet(r, h) {
    translate([r / 2, r / 2, 0])

    
        difference() {
            cube([r + 0.01, r + 0.01, h], center = true);

            translate([r/2, r/2, 0])
                cylinder(r = r, h = h + 1,$fn = 50, center = true);

        }
}


module frame_L(_width, _height, _depth){
    h = _height;
    w = _width/2;
    d = _depth;

    // top
    translate([0,0,h]) cube([w,d,t]);
    // side
    difference(){
        translate([w,0,0]) cube([t,d,h+t]);
        // add rounded corner
        translate([w+t,d/2,h+t])
        rotate([90,180,0])
        fillet(t,d+0.1);
        }
        
    // mounting piece
    union(){
        translate([w,0,0]) cube([lm,d,t_mount]);
        // add rounded corner
        translate([w+t,d/2,t])
        rotate([90,0,0])
        fillet(2*t,d+0.1);
    }
}

module frame(_width, _height, _depth){
    frame_L(_width, _height, _depth);
    mirror([1,0,0])
    frame_L(_width, _height, _depth);
}

module stoppers(_width,_w_frame, _h_frame){

    w = _w_frame/2;
    translate([w-_width,0,0])cube([_width,t_stoppers,_h_frame]);
    mirror([1,0,0])
    translate([w-_width,0,0])cube([_width,t_stoppers,_h_frame]);
    
}

// bottom mount
rotate([90,0,0]) frame(width,height,depth);
rotate([90,0,0]) stoppers(ls,width,height);

translate([0,height*1.5,0])
rotate([90,0,0]) frame(width,height,depth);
