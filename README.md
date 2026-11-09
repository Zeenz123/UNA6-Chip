![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg)

# UNA-6 Custom Microprocessor & Graphics Processing Unit

The **UNA-6** is an 8-bit monolithic computing architecture featuring an integrated CPU instruction execution core alongside hardware coprocessors. Designed for real-time calculation and 2D/3D projection, the design integrates dedicated sub-circuits for geometric operations, hardware circle and triangle rasterization, signed 16-bit division, trigonometric calculation, and Bresenham line stepping.

This repository packages the design for silicon fabrication on the **SkyWater 130nm (sky130A)** process in a **2×2 tile ($334.88\,\mu\text{m} \times 225.76\,\mu\text{m}$)** using the **Tiny Tapeout** flow.

---

## 3D Interactive Silicon Layout & Viewer

Explore the complete multi-layer metal stack, cell placement, and power routing in 3D:

👉 **[Launch Interactive 3D GDS Viewer](https://zeenz123.github.io/UNA6-Chip/)**  
*(Direct link: [gds-viewer.tinytapeout.com](https://gds-viewer.tinytapeout.com/?process=SKY130&model=https%3A%2F%2Fzeenz123.github.io%2FUNA6-Chip%2Ftinytapeout.gds))*

---

## Silicon Manufacturing & Tape-out Files

All foundry production files are verified against DRC/LVS and packaged automatically on every clean build:

| Deliverable | Format | Purpose |
| :--- | :--- | :--- |
| **GDSII Stream** | `tt_um_una6_chip.gds` | Primary photolithography mask data for SkyWater 130nm foundry |
| **OASIS Layout** | `tt_um_una6_chip.oas` | High-efficiency compressed binary layout file |
| **LEF Library** | `tt_um_una6_chip.lef` | Cell boundaries, routing obstructions, and pin placements |
| **Gate-Level Netlist** | `tt_um_una6_chip.v` | Synthesized gate netlist mapped to `sky130_fd_sc_hd` cells |
| **Parasitics (SPEF)** | `tt_um_una6_chip.spef` | Extracted wire capacitance and resistance for timing signoff |
| **Rendered Die Preview** | `gds_render.png` | 2D color-coded silicon floorplan and metal route rendering |

### How to Download Manufacturing Files
1. Navigate to the **[GitHub Actions Tab](https://github.com/Zeenz123/UNA6-Chip/actions/workflows/gds.yaml)**.
2. Select the latest green build (e.g., **[Workflow Run #32](https://github.com/Zeenz123/UNA6-Chip/actions/runs/42629814885)**).
3. Scroll down to the **Artifacts** section at the bottom of the page.
4. Click **`tt_submission`** to download the complete ZIP package containing the production `.gds`, `.oas`, `.lef`, and `.v` files.
5. Click **`gds_render`** to download the high-resolution 2D chip layout preview image.

---

## Architectural Highlights

- **8-Bit Processor Core:** Custom accumulator-based execution unit with stack and register file support.
- **Hardware Graphics Accelerator (`GRAPHICSCARD`):**
  - Dedicated hardware rasterizers for Bresenham lines, circles, and triangles.
  - Coordinate generators with direct hardware pulse streams for X and Y plotting.
  - 3D to 2D rotation and projection co-processing logic.
- **Hardware Arithmetic Engine (`MATH`):**
  - High-speed hardware multiplier and divider.
  - 16-bit signed division co-processor (`SIGNED_DIVIDER_16`).
  - Trigonometric calculation lookup core (`TRIGCALC`).

---

## Pinout Mapping

| Pad Group | Pin Range | Internal Signal | Function |
| :--- | :--- | :--- | :--- |
| **Dedicated Inputs** | `ui_in[7:0]` | `INPUT[7:0]` | External 8-bit data / instruction bus |
| **Dedicated Outputs** | `uo_out[7:0]` | `DATAOUT[7:0]` | Accumulator / ALU / Graphics result bus |
| **Bidirectional I/O** | `uio_out[5:0]` | `OUTSIDECONTROL[5:0]` | Peripheral strobes, bus flags, status |
| **Bidirectional I/O** | `uio_out[6]` | `X` | Rasterizer X coordinate stream |
| **Bidirectional I/O** | `uio_out[7]` | `Y` | Rasterizer Y coordinate stream |
| **Global Control** | `clk` | `CLK` | System clock |
| **Global Control** | `rst_n` | `~rst_n` | Active-low master reset |
| **Global Control** | `ena` | `ena` | Chip enable / clock gating |

---

## Project Structure

```text
├── docs/
│   └── info.md         # Full project datasheet documentation
├── src/
│   ├── config.json     # OpenLane 2 physical synthesis configuration
│   └── project.v       # Combined and hardened UNA-6 Verilog implementation
├── test/
│   ├── Makefile        # Cocotb simulation Makefile
│   ├── tb.v            # Verilog testbench wrapper
│   └── test.py         # Cocotb verification testbench
└── info.yaml           # Tiny Tapeout metadata & pin configuration
```

---

## Credits & Attributions

- **Architecture & Circuit Design:** Fulxor & Community ([UNA Architecture](https://github.com/logisim-evolution/))
- **ASIC Top-Level Integration & Tiny Tapeout Packaging:** Zeenz123
