difference()
{
translate([0, 0, 25])
{
intersection()
{
translate([-25, -25, -25])
{
cube(50);
}
sphere(6.7*5);
}
}
translate([0, 0, 2])
{
cylinder(h=50, r=19);
}
}