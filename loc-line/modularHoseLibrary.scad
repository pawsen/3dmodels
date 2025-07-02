// ==========================================
// Title:            Modular Hose Library
// Version:          0.3
// Last Updated:     08/16/2020
// Author:           Damian Axford, Cal Fisher
// License:          Attribution - Share Alike - Creative Commons
// License URL:      http://creativecommons.org/licenses/by-sa/3.0/
// Thingiverse URL:  http://www.thingiverse.com/thing:9457
// ==========================================

// ------------
// Dependencies
// ------------

// TODO - Use library instead
// boxes.scad required for roundedBox module
//include <boxes.scad>
module roundedBox(size, radius, sidesonly) {
  rot = [ [0, 0, 0], [90, 0, 90], [90, 90, 0] ];
  if (sidesonly) {
    cube(size - [2 * radius, 0, 0], true);
    cube(size - [0, 2 * radius, 0], true);

    for (x = [radius - size[0] / 2, -radius + size[0] / 2],
         y = [radius - size[1] / 2, -radius + size[1] / 2]) {
      translate([x, y, 0])
        cylinder(r= radius, h= size[2], center= true);
    }
  } else {
    cube([size[0], size[1] - radius * 2, size[2] - radius * 2], center= true);
    cube([size[0] - radius * 2, size[1], size[2] - radius * 2], center= true);
    cube([size[0] - radius * 2, size[1] - radius * 2, size[2]], center= true);

    for (axis = [0:2]) {
      for (x = [radius - size[axis] / 2, -radius + size[axis] / 2],
           y = [radius - size[(axis + 1) % 3] / 2, -radius + size[(axis + 1) % 3] / 2]) {
        rotate(rot[axis])
          translate([x, y, 0])
          cylinder(h = size[(axis + 2) % 3] - 2*radius, r = radius, center = true);
      }
    }

    for (x = [radius - size[0] / 2, -radius + size[0] / 2],
         y = [radius - size[1] / 2, -radius + size[1] / 2],
         z = [radius - size[2] / 2, -radius + size[2] / 2]) {
      translate([x, y, z]) sphere(radius);
    }
  }
}

// ----------------
// Global Variables
// ----------------

// Definition - Number of fragments to use when generating curved surfaces
DEFINITION = 128; // used for $fn (definition) parameter when generating curved surfaces
DEFINITION = 32;

// Tolerance - Distance between ball and socket surfaces (male/female connection)
//TOLERANCE = 0.2; // Fits Somewhat Loose
TOLERANCE = 0.16; // Fits Snug

// Modular Hose Shapes
WAIST_OUTER_DIAMETER_MULTIPLIER = 1.58;
mhSocketHeightScaleFactor = 1.26 + 0.39;

// Smallest inner diameter - the defining size of a loc-line segment
// Fractions of an inch
i1 = 25.4; // 25.4mm == 1in
i34 = i1 * 3/4;
i2 = i1 / 2;
i4 = i1 / 4;
i8 = i1 / 8;
i16 = i1 / 16;
i32 = i1 / 32;

// -----------------------
// Modular Hose Components
// -----------------------

// Modular Hose - Socket (Female Connector)
module modularHoseSocket(mhBore) {
  mhOffsetToSocketCenter = 0.31 * mhBore;
  mhOffsetToBaseOfSkirt = 0.39 * mhBore;
  mhSocketID = TOLERANCE + mhBore * 2;
  mhSkirtOD = 2.40 * mhBore; // started at 2.52
  mhSkirtHeight = 1.26 * mhBore;
  mhWaistOD = WAIST_OUTER_DIAMETER_MULTIPLIER * mhBore;
  mhRimRadius = 0.18 * mhBore;
  mhSocketChamferOffset = 0.79 * mhBore;
  mhSocketChamferHeight = 0.86 * mhBore;
  mhSocketChamferID = mhBore * 1.77;

  union() {
    if ($children > 0) {
      translate([0, 0, mhSkirtHeight + mhOffsetToBaseOfSkirt]) children(0);
    }

    difference() {
      union() {
        // Skirt
        translate([0, 0, mhOffsetToBaseOfSkirt])
          cylinder(h = mhSkirtHeight, r1 = mhSkirtOD / 2, r2 = mhWaistOD / 2, $fn = DEFINITION);

        // Rim
        // Rim - Collar
        translate([0, 0, mhRimRadius])
          cylinder(h = mhOffsetToBaseOfSkirt - mhRimRadius, r = mhSkirtOD / 2, $fn = DEFINITION);

        // Rim - Radius
        rotate_extrude(convexity = 10, $fn = DEFINITION)
          translate([(mhSkirtOD / 2) - mhRimRadius, mhRimRadius, 0])
          circle(r = mhRimRadius, $fn = DEFINITION / 2);

        // Rim - Cap
        cylinder(h = mhRimRadius, r = (mhSkirtOD / 2) - mhRimRadius, $fn = DEFINITION);
      }

      // Remove Bore
      translate([0, 0, -1])
        cylinder(h = mhSkirtHeight + mhOffsetToBaseOfSkirt + 2, r = mhBore / 2, $fn = DEFINITION);

      // Straighten Socket Sides
      translate([0, 0, mhSocketChamferOffset])
        cylinder(
          h = mhSocketChamferHeight, 
          r1 = mhSocketChamferID / 2,
          r2 = mhBore / 2, 
          $fn = DEFINITION);

      // Remove Socket
      translate([0, 0, mhOffsetToSocketCenter])
        sphere(r = mhSocketID / 2, $fn = DEFINITION);
    }
  }
}

// Modular Hose - Waist (Middle, Connecting Part)
module modularHoseWaist(mhBore, mhWaistHeight) {
  mhWaistOD = WAIST_OUTER_DIAMETER_MULTIPLIER * mhBore;

  union() {
    if ($children > 0) {
      translate([0, 0, mhWaistHeight]) children(0);
    }

    difference() {
      translate([0, 0, -0.01])
        cylinder(h = mhWaistHeight + 0.02, r = mhWaistOD / 2, $fn = DEFINITION);

      // Remove Bore
      translate([0, 0, -1])
        cylinder(h = mhWaistHeight + 2, r = mhBore / 2, $fn = DEFINITION);
    }
  }
}

// Modular Hose - Ball (Male Connector)
module modularHoseBall(mhBore) {
  mhBallOD = mhBore * 2;
  mhOffsetToBallCenter = 0.61 * mhBore;
  mhOffsetToTopOfBall = 1.07 * mhBore;
  mhWideBore = mhBore * 1.6; // started at 1.32
  mhBallID = mhBore * 1.6;
  mhOffsetToInnerBallCenter = 0.75 * mhBore;

  difference() {
    translate([0, 0, mhOffsetToBallCenter])
      sphere(r = mhBallOD / 2, $fn = DEFINITION);

    // Remove top of ball
    translate([0, 0, mhOffsetToTopOfBall + mhBallOD / 2])
      cube(size = [mhBallOD, mhBallOD, mhBallOD], center = true);
  
    // Remove bottom of ball
    translate([0, 0, -mhBallOD / 2])
      cube(size = [mhBallOD, mhBallOD, mhBallOD], center = true);

    // Hollow out the ball
    translate([0, 0, -0.01])
      cylinder(h = mhOffsetToTopOfBall + 0.02, r1 = mhBore / 2, r2 = mhWideBore / 2, $fn = DEFINITION);

    // Hollow out some more with a stretched sphere
    translate([0, 0, mhOffsetToInnerBallCenter])
      scale([1, 1, 1.2])
      sphere(r = mhBallID / 2, $fn = DEFINITION);
  }
}

// Modular Hose - Nozzle Tip
module modularHoseRoundNozzleTip(mhBore, mhNozzleID) {
  mhWaistOD = WAIST_OUTER_DIAMETER_MULTIPLIER * mhBore;
  mhNozzleHeight = 2 * mhBore;
  mhNozzleOD = mhNozzleID + 1.2;

  difference() {
    // Outer Nozzle
    cylinder(h = mhNozzleHeight, r1 = mhWaistOD / 2, r2 = mhNozzleOD / 2, $fn = DEFINITION);

    // Remove Inner Bore
    translate([0, 0, -0.01])
      cylinder(
        h = mhNozzleHeight + 0.02, 
        r1 = mhBore / 2, 
        r2 = mhNozzleID / 2, 
        $fn = DEFINITION);
  }
}

// Modular Hose - Flare Nozzle
module modularHoseFlareNozzleTip(mhBore, mhNozzleWidth, mhNozzleThickness) {
  mhWaistOD = WAIST_OUTER_DIAMETER_MULTIPLIER * mhBore;
  mhNozzleHeight = 2 * mhBore;

  difference() {
    // Outer Nozzle
    cylinder(h = mhNozzleHeight, r1 = mhWaistOD / 2, r2 = mhNozzleWidth / 2, $fn = DEFINITION);

    // Remove Inner Bore
    translate([0, 0, -0.01])
      cylinder(
        h = mhNozzleHeight + 0.02, 
        r1 = mhBore / 2, 
        r2 = mhNozzleThickness / 2, 
        $fn = DEFINITION);
  }
}

// Modular Hose - Flat Nozzle
// Parameters:
// - mhBore - Inner diameter hole. Measurements are based off of this
// - nozzleLength - Length of the nozzle
// - nozzleWidth - Width of the nozzle
// - nozzleHeight - Height of the nozzle
// - nozzleWallThickness - Thickness of the nozzle walls
module modularHoseFlatNozzleTip(mhBore, nozzleLength, nozzleWidth, nozzleHeight, nozzleWallThickness) {
  mhWaistOD = WAIST_OUTER_DIAMETER_MULTIPLIER * mhBore;

  difference() {
    union() {
      difference() {
        // Outer Flat Nozzle
        hull() {
          cylinder(h = nozzleLength, r1 = mhWaistOD / 2, r2 = 0, $fn = DEFINITION);

          translate([0, 0, nozzleLength - 0.01])
            cube([nozzleWidth, nozzleHeight, 0.01], true);
        }

        // Inner Flat Nozzle
        hull() {
          translate([0, 0, -0.01])
            cylinder(
              h = nozzleLength + 0.01, 
              r1 = mhBore / 2,
              r2 = 0,
              $fn = DEFINITION);

          translate([0, 0, nozzleLength])
            cube([nozzleWidth - nozzleWallThickness * 2, nozzleHeight - nozzleWallThickness * 2, 0.01], true);
        }
      }
    }
  }
}

// -----------------------------------------------
// Modular Hose Composite Elements (Non-Chainable)
// -----------------------------------------------

// Modular Hose - Normal segment with female (socket) and male (ball) ends
module modularHoseSegment(mhBore) {
  modularHoseSocket(mhBore)
    modularHoseWaist(mhBore, 0.24 * mhBore)
    modularHoseBall(mhBore);
}

// Modular Hose - Extended Segment
module modularHoseExtendedSegment(mhBore, mhWaistHeight) {
  modularHoseSocket(mhBore)
    modularHoseWaist(mhBore, mhWaistHeight)
    modularHoseBall(mhBore);
}

// Modular Hose - Round Nozzle
module modularHoseRoundNozzle(mhBore, mhNozzleID) {
  modularHoseSocket(mhBore)
    modularHoseRoundNozzleTip(mhBore, mhNozzleID);
}

// Modular Hose - Flare Nozzle
module modularHoseFlareNozzle(mhBore, mhNozzleWidth, mhNozzleThickness) {
  modularHoseSocket(mhBore)
    modularHoseFlareNozzleTip(mhBore, mhNozzleWidth, mhNozzleThickness);
}

// Modular Hose - Flat Nozzle
module modularHoseFlatNozzle(mhBore, nozzleLength, nozzleWidth, nozzleHeight, nozzleWallThickness) {
  modularHoseSocket(mhBore)
    modularHoseFlatNozzleTip(mhBore, nozzleLength, nozzleWidth, nozzleHeight, nozzleWallThickness);
}

// Modular Hose - Base Plate
module modularHoseBasePlate(mhBore, mhThreadDia = 3) {
  mhWaistOD = WAIST_OUTER_DIAMETER_MULTIPLIER * mhBore;
  mhPlateHeight = 0.5 * mhBore;
  mhPlateWidth = mhWaistOD + 4 * mhThreadDia;
  mhScrewOffset = mhWaistOD / 2 + mhThreadDia / 2;

  union() {
    translate([0, 0, 1 + mhPlateHeight * 2]) modularHoseBall(mhBore);
    translate([0, 0, 1]) modularHoseWaist(mhBore, mhPlateHeight * 2);

    difference() {
      translate([0, 0, mhPlateHeight/2])
        roundedBox([mhPlateWidth, mhPlateWidth, mhPlateHeight], radius = 2 * mhThreadDia, sidesonly=true, $fn = DEFINITION);

      // Remove Inner Bore bore (perhaps to feed cables through?)
      translate([0, 0, -0.01])
        cylinder(h = mhPlateHeight + 0.02, r = mhBore / 2, $fn = DEFINITION);

      // Remove Screw Holes
      for (x = [-1, 1]) {
        for (y = [-1, 1]) {
          translate([x * mhScrewOffset, y * mhScrewOffset, -1]) 
            cylinder(h = mhPlateHeight + 2, r = mhThreadDia / 2, $fn = DEFINITION);
        }
      }
    }
  }
}

// Modular Hose - Double Socket (Female/Female)
module modularHoseDoubleSocket(mhBore) {
  union() {
    modularHoseSocket(mhBore);
    translate([0, 0, mhSocketHeightScaleFactor * mhBore])
      translate([0, 0, mhSocketHeightScaleFactor * mhBore])
      mirror([0, 0, 1])
      modularHoseSocket(mhBore);
  }
}

// ----------
// Debug Code
// - Shows a cross section through two "joined" hose segments with a 1mm "ruler" overlay
// ----------

debug = false;
// Enable debug by uncommenting this line:
//debug = true;

if (debug) {
  // Top Segment
  difference() {
    translate([0, 0, 13.9]) modularHoseSegment(i4);
    translate([-10, 0, -1]) cube(size = [20, 20, 100]);
  }

  // Bottom Segment
  difference() {
    modularHoseSegment(i4);
    translate([-10, 0, -1])
      cube(size = [20, 20, 20]);
  }

  // Show Ruler
  for (i = [-10 : 10]) {
    translate([i - 0.05, 0, 0])
      rotate([90, 0, 0])
      color([0.9, 0.9, 0.9, 1])
      square(size = [0.1, 20]);
  }
}

// -----------------------------------
// Example Usage of Composite Elements
// -----------------------------------

module evenlySpace(spacing) {
  if ($children > 0) {
    gridxy = ceil(sqrt($children));

    for (i = [0 : $children - 1]) {
      translate([(i % gridxy) * spacing, floor(i / gridxy) * spacing, 0]) children(i);
    }
  }
}

examples = false;
// Disnable examples by commenting out this line:
// examples = true;

if (examples) {
  evenlySpace(25) {
    // Nozzles
    modularHoseRoundNozzle(i4, i2);
    modularHoseRoundNozzle(i4, i8);
    modularHoseRoundNozzle(i4, i16);

    modularHoseFlatNozzle(i4, i1, i1, i4, i32);

    // Segments
    modularHoseSegment(i4);
    modularHoseExtendedSegment(i4, 20);

    // Special Sockets
    modularHoseBasePlate(i4);
    modularHoseDoubleSocket(i4);
  }
} else {
  modularHoseSegment(i34);
}
