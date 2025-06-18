/* Krydderihylde
 * Passer til 
 */


// material thickness
thk = 6;
length = 600;
// højde af bagplade
bh = 40;
// højde af frontplade
fh = 16;
// dybde af selve hylden
depth = 73;

tab_length = 15;
interval = tab_length*2;
n_tabs = length/interval;

// eps >0 sikre at openscad ikke sætter hele parten sammen til een.
// Kan sættes til 0, hvis kun en del skæres
eps = 0.005;

//bagplade
module bagplade(){
difference(){
	square([length,bh+thk],center=false);
	for(i=[0:1:n_tabs]){
		translate([tab_length*2*i,0,0])
			square([tab_length+eps,2*thk],center=true);
	}
}
}

module bundplade(){
difference(){
	square([length,depth+2*thk],center=false);
	for(i=[0:1:n_tabs]){
		translate([tab_length*2*i+tab_length,0,0])
			square([tab_length+eps,thk*2],center=true);
		translate([tab_length*2*i+tab_length,depth+2*thk,0])
			square([tab_length+eps,thk*2],center=true);
	}
}
}

module frontplade(){
difference(){
	square([length,fh+thk],center=false);
	for(i=[0:1:n_tabs]){
		translate([tab_length*2*i,fh+thk,0])
			square([tab_length+eps,2*thk],center=true);
	}
}
}

module endplade()
	polygon([[0,0],[0,fh+thk],[depth+2*thk,bh+thk],[depth+2*thk,0]]);


// sammensæt forskellige dele
module hylde(){
	frontplade();
	translate([0,fh+eps]){
		bundplade();
	}
	translate([0,fh+1*thk+2*eps+depth]){
		bagplade();
	}
}

module endplates(){
	endplade();
	translate([depth+2*thk,bh+fh+thk*2+eps,0])
		rotate([0,0,180])
		endplade();

}

// projection cut er til at lave et 2d snit i 3d flade
//projection(cut = false)
hylde();
translate([0,fh+bh+2*thk+depth+3*eps,0])
endplates();
