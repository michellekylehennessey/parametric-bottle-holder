# parametric-bottle-holder
FOR FUN - 3D-printable, parametric mount for hamster water bottles.
// Hamster Bottle Magnetic Holder (parametric)
// Units: millimeters
// Author: MishMish

// ---------------- Parameters ----------------
// Hamster Bottle Holder — acrylic-style replica
// Exact dims: 56 W × 56 H × 58 D; 50 mm inner span
// Two parts: BACKPLATE (with 4 magnet pockets & rails) + CRADLE (with grooves)
// Bottom floor included; narrow U-slot opens fully through the front rim.
// Units: millimetres

// ----- Dimensions -----
back_w    = 56;   // backplate width
holder_h  = 56;   // overall height
depth_tot = 58;   // wall to front-most edge
inner_w   = 50;   // inside span (5 cm)

// ----- Thicknesses -----
wall_t    = 3;    // “acrylic” wall thickness
bottom_t  = 3;    // bottom floor thickness

// ----- Magnet pockets (backplate) -----
mag_d   = 12;     // magnet diameter
mag_t   = 2.5;    // pocket depth
mag_mx  = 10;     // side margin
mag_mz  = 10;     // top/bottom margin

// ----- Slide join (rails on backplate, grooves in cradle) -----
rail_w     = 6;       // rail width
rail_t     = 2.8;     // rail protrusion
rail_inset = 7;       // from each side edge to rail centreline
fit_clear  = 0.30;    // clearance per side inside grooves

// ----- Bottom U-slot (for spout) -----
slot_w     = 14;      // opening width (tweak if your grommet/nozzle is wider)
slot_depth = 24;      // how far back the slot goes from the front
// (rounded inner end is produced automatically)

$fn = 96;

// ---------- helpers ----------
module magnet_pockets(){
  sx = (back_w - 2*mag_mx - mag_d);
  sz = (holder_h - 2*mag_mz - mag_d);
  for (ix=[0,1], iz=[0,1]) {
    cx = mag_mx + mag_d/2 + ix*sx;
    cz = mag_mz + mag_d/2 + iz*sz;
    translate([cx, -0.01, cz])
      rotate([90,0,0]) cylinder(d=mag_d, h=mag_t+0.02);
  }
}

// 2D rounded-U footprint (inner cavity outline), centred in X
module rounded_U_path(width_in, depth_in){
  r = width_in/2;
  // straight section
  translate([back_w/2 - width_in/2, 0])
    square([width_in, depth_in - r], center=false);
  // semicircle nose
  translate([back_w/2, depth_in - r])
    circle(r=r);
}

// ---------- PART: Backplate ----------
module part_backplate(){
  // plate with magnet pockets
  difference(){
    cube([back_w, wall_t, holder_h], center=false);
    magnet_pockets();
  }
  // rails
  translate([rail_inset - rail_w/2, wall_t, 0])
    cube([rail_w, rail_t, holder_h], center=false);
  translate([back_w - rail_inset - rail_w/2, wall_t, 0])
    cube([rail_w, rail_t, holder_h], center=false);
}

// ---------- PART: Cradle (walls + bottom + slot + grooves) ----------
module part_cradle(){
  D = depth_tot - wall_t;  // depth available in front of backplate

  // --- Side & front walls (U shell) ---
  difference(){
    // outer wall
    linear_extrude(height=holder_h)
      offset(r=wall_t)
        rounded_U_path(inner_w, D);
    // inner hollow (creates wall thickness)
    translate([0, wall_t, 0])
      linear_extrude(height=holder_h + 0.2)
        rounded_U_path(inner_w, D - wall_t);
  }

  // --- Bottom floor filling the inner footprint ---
  difference(){
    // bottom fills inner cavity
    linear_extrude(height=bottom_t)
      rounded_U_path(inner_w, D - wall_t);

    // SLOT: extend from inside cavity THROUGH the front rim so it’s visibly open
    slot_start_y = (D - wall_t) - slot_depth;  // start inside
    slot_len_y   = slot_depth + wall_t + 1;    // push past rim by +1 mm
    translate([back_w/2 - slot_w/2, slot_start_y, -0.01])
      linear_extrude(height=bottom_t + 0.02)
        union(){
          square([slot_w, slot_len_y], center=false);
          // rounded inner end
          translate([slot_w/2, slot_len_y]) circle(r=slot_w/2);
        }
  }

  // --- Tiny matching gap in the FRONT RIM at the bottom (confirm visible opening) ---
  translate([back_w/2 - slot_w/2, (D - wall_t) - 0.5, -0.01])
    linear_extrude(height=bottom_t + 0.6)
      square([slot_w, wall_t + 1.5], center=false);

  // --- Grooves for the slide-on rails ---
  groove_w = rail_w + 2*fit_clear;
  groove_t = rail_t + fit_clear;
  difference(){
    translate([rail_inset - groove_w/2, wall_t - 0.01, -0.01])
      cube([groove_w, groove_t + 0.02, holder_h + 0.02], center=false);
    translate([back_w - rail_inset - groove_w/2, wall_t - 0.01, -0.01])
      cube([groove_w, groove_t + 0.02, holder_h + 0.02], center=false);
  }
}

// ---------- layout (export both parts side-by-side) ----------
part_backplate();                // left, at origin
translate([70,0,0]) part_cradle();  // right

// ----- PRINT NOTES -----
// Backplate: flat on bed, pockets up. 0.2 mm layers, 4–5 walls, 20–30% infill.
// Cradle: lay on its back (grooves up). Same settings. PETG recommended.
// Fit: increase fit_clear to 0.40 if slide is tight; drop to 0.20 if loose.
// Magnets: glue 4× round magnets into backplate pockets; mind polarity.


// ---------------- Print notes ----------------
// Orientation: lay the backplate flat on build plate (magnets facing up).
// Suggested settings (Bambu A1):
//  - Nozzle: 0.4 mm, Layer height: 0.20 mm
//  - Perimeters: 4, Top/Bottom: 5 layers
//  - Infill: 20–30% Grid or Gyroid
//  - Material: PETG recommended
//  - Brim: 3–5 mm for adhesion
//  - Pause mid-print to insert magnets, or glue after
