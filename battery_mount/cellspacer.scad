$fn=120;

//cell_type = 1: "18650", 2: "21700"
cell_type = 1;
cell_dia = (cell_type == 1) ? 18.1 : //"18650"
           (cell_type == 2) ? 21.3 : 0; //"21700"

cell_h = (cell_type == 1) ? 65/2 :
         (cell_type == 2) ? 35 : 0; // 70/2

echo(cell_type  = cell_type);

// the width is less than the cell diameter to avoid the long thin walls
width = cell_dia - 5;

// the seperation (minimum walll thickness) should at least be equal to the nozzle diameter
// v_sep is actually the wall thickness between two alternating cells (ie. the diagonal, jf c^2 = a^2+b^2) 
h_sep=0.4;
v_sep = 0.4;
cell_no=10;

module cells()
{
for (i=[0:cell_no-1]){
    x = 0.5*(cell_dia+h_sep);
    c = cell_dia + v_sep;
    y = sqrt( c*c - x*x);
    translate ([i*x, 0.5*pow(-1,i)*y, 0]) cylinder (d=cell_dia, h=cell_h+1, center=true);
    }
}

module block()
{
    x = (cell_no-1)*(cell_dia+h_sep);
    translate ([0.25*x,0,0]) cube ([0.5*x, width ,cell_h], center=true);
}

//cells();
difference ()
{
    block();
    cells();
}    
