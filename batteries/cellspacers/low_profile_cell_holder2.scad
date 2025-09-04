// === Parameters ===
cell_diameter = 21.2;
cell_radius = cell_diameter / 2;
cell_count = 8;                   // Number of cells
gap = 0.6;                        // Gap between slots
slot_depth = 4.5;                 // Depth of the semi-circle scoop
base_thickness = 2;              // Flat base thickness
holder_length = cell_count * (cell_diameter + gap);
holder_width = 10;               // Width in Y direction (adjust for grip)
extra_lip = 1.5;                 // Lip beyond slot depth for retention
mirror_holder = false;           // Set to true to generate the mirrored side

// === Main Holder ===
difference() {
    // Block base
    cube([holder_length, holder_width, base_thickness + slot_depth + extra_lip]);

    // Scalloped cutouts for cells
    for (i = [0 : cell_count - 1]) {
        x = i * (cell_diameter + gap) + cell_radius;
        translate([x, 0, base_thickness + slot_depth])
            rotate([90, 0, 0])
                cylinder(h = holder_width + 1, r = cell_radius, $fn = 64); // scallop cut
    }
}

// === Optional Mirrored Holder for Top Retention ===
if (mirror_holder) {
    translate([0, holder_width + 5, 0])
        mirror([0, 1, 0])
            difference() {
                cube([holder_length, holder_width, base_thickness + slot_depth + extra_lip]);

                for (i = [0 : cell_count - 1]) {
                    x = i * (cell_diameter + gap) + cell_radius;
                    translate([x, 0, base_thickness + slot_depth])
                        rotate([90, 0, 0])
                            cylinder(h = holder_width + 1, r = cell_radius, $fn = 64);
                }
            }
}
