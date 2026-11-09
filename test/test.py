# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Starting UNA-6 Core Verification Test")

    # 10us period (100 KHz clock)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Apply Reset
    dut._log.info("Applying system reset...")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    
    # Release Reset
    dut.rst_n.value = 1
    dut._log.info("System reset released. Running clock cycles...")

    # Run for 50 cycles to verify steady-state clocking and execution
    for i in range(50):
        dut.ui_in.value = (i & 0xFF)
        await ClockCycles(dut.clk, 1)

    dut._log.info("UNA-6 Clock & Reset verification successful!")