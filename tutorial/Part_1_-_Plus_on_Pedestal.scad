translate([0, 0, 3])
{
cylinder(h=20, r=5);
translate([-10, 0, 10])
{
rotate([0,90,0])
{
cylinder(h=20, r=5);
}
}
translate([0, 10, 10])
{
rotate([90,0,0])
{
cylinder(h=20, r=5);
}
}
translate([0, 0, 10])
{
sphere(r = 8);
}
}
translate([-7.5, -7.5, 0])
{
cube([15, 15, 4]);
}