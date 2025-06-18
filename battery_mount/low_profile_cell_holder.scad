// -*- mode: c -*-

// === Parameters ===
cell_diameter = 21.2;     // 21700 = ~21.2mm diameter
cell_radius = cell_diameter / 2;
cell_length = 70;         // Full length
holder_depth = 35;        // Half-length holder
wall_thickness = 1.2;
cell_count = 8;           // Number of cells in row
cell_spacing = 1.0;       // Gap between cells
base_thickness = 1.6;
mirror_holder = false;    // Set to true to mirror for the opposite side

// === Main ===
translate([0, 0, base_thickness])
    for (i = [0 : cell_count - 1]) {
        x = i * (cell_diameter + cell_spacing);
        translate([x, 0, 0])
            cell_slot();
    }

if (mirror_holder)
    mirror([0, 1, 0])
        translate([0, -(cell_radius + wall_thickness + 1), 0])
            linear_extrude(height = base_thickness)
                square([cell_count * (cell_diameter + cell_spacing), cell_radius + wall_thickness + 1]);

// === Cell Slot Module ===
module cell_slot() {
    difference() {
        // Outer wall
        linear_extrude(height = holder_depth)
            offset(r = wall_thickness)
                circle(cell_radius);

        // Inner cutout
        translate([0, 0, -1]) // slight Z offset to fully cut
            linear_extrude(height = holder_depth + 2)
                circle(cell_radius);
    }
}
