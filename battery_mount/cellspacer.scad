$fn=120;
cell_dia=21.8;
cell_dia=18.1;
cell_h=70;
d_cell=0.1;
v_sep = 0.44;
cell_no=4;
///////////////////////////////////////////////////////////////////////////////////
module cells()
{
 for (i=[0:cell_no])
   translate ([i*0.5*(cell_dia+d_cell), pow(-1,i)*v_sep*cell_dia, 0]) cylinder (d=cell_dia, h=cell_h, center=true);  
}
///////////////////////////////////////////////////////////////////////////////////
module block()
{
   translate ([(0.25*cell_no*(cell_dia+d_cell)),0,0]) cube ([(0.5*cell_no*(cell_dia+d_cell)), cell_dia ,cell_h], center=true);
}
///////////////////////////////////////////////////////////////////////////////////
difference ()
{
    block();
    cells();
}    
