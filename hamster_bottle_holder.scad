// Hamster Bottle Magnetic Holder (parametric)
// Units: millimeters
// Author: ChatGPT

// ---------------- Parameters ----------------
holder_h      = 58;     // total height (matches image: 58 mm)
back_w        = 56;     // backplate width
shelf_d       = 56;     // overall depth from wall to front edge
wall_t        = 3;      // main wall thickness
cradle_ID     = 50;     // inner diameter of cradle (image shows 5 cm)
front_lip_h   = 4;      // small lip at bottom front to stop sliding out
front_lip_t   = 2.4;    // lip thickness
notch_w       = 16;     // V-notch approximate width for spout
notch_depth   = 10;     // V-notch depth into cradle

// Magnet pockets (2 x 2 grid)
mag_d         = 12;     // magnet diameter (change to your magnets: 10–15)
mag_t         = 2.5;    // magnet thickness (pocket depth)
mag_rows      = 2;
mag_cols      = 2;
mag_margin    = 9;      // margin from edges
mag_spacing_x = 20;     // center-to-center X spacing
mag_spacing_y = 20;     // center-to-center Y spacing

// Fillets / rounding (visual only; printed via chamfers)
edge_rad      = 3;

$fn = 96; // smoothness

module backplate() {
    difference() {
        // backplate body
        cube([back_w, wall_t, holder_h], center=false);
        // magnet pockets
        for (i=[0:mag_cols-1], j=[0:mag_rows-1]) {
            x = mag_margin + i*mag_spacing_x;
            y = wall_t/2;
            z = mag_margin + j*mag_spacing_y;
            translate([x, -0.01, z])
                rotate([90,0,0])
                    cylinder(d=mag_d, h=mag_t+0.02);
        }
    }
}

module cradle() {
    outer_R = cradle_ID/2 + wall_t;
    inner_R = cradle_ID/2;
    ch = holder_h;
    d = shelf_d - wall_t;

    difference() {
        // outer rectangular prism
        translate([back_w/2, wall_t, 0])
            linear_extrude(ch)
                offset(r=edge_rad)
                    square([outer_R*2, d], center=true);

        // inner cavity
        translate([back_w/2, wall_t + wall_t, 0])
            linear_extrude(ch + 0.1)
                translate([0, inner_R + wall_t])
                    circle(r=inner_R);

        // V-notch at front
        translate([back_w/2, shelf_d + wall_t - 0.01, holder_h/2])
            rotate([90,0,0])
                linear_extrude(height=wall_t+0.02)
                    polygon(points=[
                        [-notch_w/2,0],
                        [0, -notch_depth],
                        [notch_w/2,0]
                    ]);

        // Cut away top/bottom to leave a band
        band_clear = 10;
        translate([-1, wall_t-0.01, -1])
            cube([back_w+2, shelf_d+2, band_clear]);
        translate([-1, wall_t-0.01, holder_h - band_clear +1])
            cube([back_w+2, shelf_d+2, band_clear]);
    }
}

module front_lip() {
    translate([back_w/2 - (cradle_ID/2 + wall_t), shelf_d - front_lip_t + wall_t, 0])
        cube([cradle_ID + 2*wall_t, front_lip_t, front_lip_h]);
}

module holder() {
    union() {
        backplate();
        cradle();
        front_lip();
    }
}

holder();

// ---------------- Print notes ----------------
// Orientation: lay the backplate flat on build plate (magnets facing up).
// Suggested settings (Bambu A1):
//  - Nozzle: 0.4 mm, Layer height: 0.20 mm
//  - Perimeters: 4, Top/Bottom: 5 layers
//  - Infill: 20–30% Grid or Gyroid
//  - Material: PETG recommended
//  - Brim: 3–5 mm for adhesion
//  - Pause mid-print to insert magnets, or glue after
