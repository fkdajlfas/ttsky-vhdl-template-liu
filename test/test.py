# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test seed")

    # set seed, Moore so wait one cyckle for value to be saved
    dut.ui_in.value = 210
    await ClockCycles(dut.clk, 1)

    # verify that seed is correct with output
    for i, expected in enumerate([64,66,80,214,100,71,125,144,18,132,163,188,93,179,41,97,110,26,200,136]):
        await ClockCycles(dut.clk, 1)
        assert dut.uo_out.value == expected

    dut._log.info("Test switching seed")

    # switching the seed, for one Moore so the get one more of the last sequence
    dut.ui_in.value = 2
    await ClockCycles(dut.clk, 1)
    assert int(dut.uo_out.value) == 203;

    # check if output is correct with the new seed
    expected_random = [18,134,179,42,120,188,95,163,188,92,187,98,114,230,211,74,30,237,133,172,207]
    for i, expected in enumerate(expected_random):
        await ClockCycles(dut.clk, 1)
        assert dut.uo_out.value == expected

    dut._log.info("Test reset")

    # we reset for one cycle, Moore so wait one until
    # the expected value is returned
    dut.rst_n.value = 0;
    await ClockCycles(dut.clk, 1)
    dut.rst_n.value = 1;
    await ClockCycles(dut.clk, 1)

    for i, expected in enumerate(expected_random):
        await ClockCycles(dut.clk, 1)
        assert dut.uo_out.value == expected




