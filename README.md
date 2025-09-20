# Parametric Bottle Holder 🐹💧
**3D-printable, parametric mount for hamster water bottles.**  
Designed in OpenSCAD. Units: millimetres.

---

## 📐 Overview
A hamster water bottle holder — acrylic-style replica.  

- **Dimensions (real-world):** 56 W × 56 H × 58 D; 50 mm inner span  
- **Parts:**  
  - Backplate (with 4 magnet pockets & rails)  
  - Cradle (with grooves)  
- Bottom floor included; narrow U-slot opens fully through the front rim.  

---

## ⚙️ Parameters

### Dimensions
- `back_w = 56` — backplate width  
- `holder_h = 56` — overall height  
- `depth_tot = 58` — wall to front-most edge  
- `inner_w = 50` — inside span (5 cm)  

### Thicknesses
- `wall_t = 3` — wall thickness  
- `bottom_t = 3` — bottom floor thickness  

### Magnet pockets (backplate)
- `mag_d = 12` — magnet diameter  
- `mag_t = 2.5` — pocket depth  
- `mag_mx = 10` — side margin  
- `mag_mz = 10` — top/bottom margin  

### Slide join (rails/grooves)
- `rail_w = 6` — rail width  
- `rail_t = 2.8` — rail protrusion  
- `rail_inset = 7` — inset from each side edge to centreline  
- `fit_clear = 0.30` — clearance per side inside grooves  

### Bottom U-slot (for spout)
- `slot_w = 14` — opening width (tweak if nozzle is wider)  
- `slot_depth = 24` — depth of slot from front  

---

## 🛠 Usage

Open the `.scad` file in OpenSCAD and tweak the parameters at the top to fit your specific water bottle.  

### Render / Export
```bash
# Preview in OpenSCAD GUI
openscad holder.scad

# Export STL (both parts together)
openscad -o exports/holder.stl holder.scad
