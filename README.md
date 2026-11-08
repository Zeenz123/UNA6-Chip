![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg)

# UNA-6 Custom Microprocessor & Graphics Processing Unit

The **UNA-6** is an 8-bit monolithic computing architecture featuring an integrated CPU instruction execution core alongside hardware coprocessors. Designed for real-time calculation and 2D/3D projection, the design integrates dedicated sub-circuits for geometric operations, hardware circle and triangle rasterization, signed 16-bit division, trigonometric calculation, and Bresenham line stepping.

This repository packages the design for silicon fabrication on the **SkyWater 130nm (sky130A)** process using the **Tiny Tapeout** flow.

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
│   └── project.v       # Combined and hardened UNA-6 Verilog implementation
├── test/
│   ├── tb.v            # Verilog testbench wrapper
│   └── test.py         # Cocotb verification testbench
└── info.yaml           # Tiny Tapeout metadata & pin configuration
```

---

## Credits & Attributions

- **Architecture & Circuit Design:** Fulxor & Community ([UNA Architecture](https://github.com/logisim-evolution/))
- **ASIC Top-Level Integration & Tiny Tapeout Packaging:** Zeenz123
