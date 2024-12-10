import os
import subprocess
import yaml
from pathlib import Path
from cocotb.runner import get_runner

import cocotb
from cocotb.triggers import Timer, FallingEdge, RisingEdge
from cocotb.clock import Clock
from cocotb.regression import TestFactory

import numpy as np
import matplotlib.pyplot as plt


to_unsigned = lambda x, F: int(x*(1<<F))
to_signed = lambda x, F: int(x*(1<<F))
from_unsigned = lambda x, F: x.value.integer/(1<<F)
from_signed = lambda x, F: x.value.signed_integer/(1<<F)


class Conversion:
    def __init__(self, dut):
        self.fractional_bits = dut.FRACTIONAL_BITS.value
    
    def to_unsigned(self, x):
        return int(x*(1<<self.fractional_bits))

    def to_signed(self, x):
        return int(x*(1<<self.fractional_bits))
    
    def from_unsigned(self, x):
        return x.value.integer/(1<<self.fractional_bits)
    
    def from_signed(self, x):
        return x.value.signed_integer/(1<<self.fractional_bits)


def plot_signals():
    settings_path = Path(__file__).parent/'.sim'/'settings.yaml'
    if os.path.exists(settings_path):
        with open(settings_path, 'r') as f:
            return yaml.safe_load(f)['plot']
    else: return False


def init_ff(test_function):

    async def wrapper(dut):
        await cocotb.start(Clock(dut.clk, 2, units='ns').start())
        dut.nrst.value = 0
        dut.en.value = 1
        await Timer(2, units='ns')
        dut.nrst.value = 1
        await test_function(dut)

    return wrapper


def get_sources(dir):
    sources = []
    for root, _, files in os.walk(dir):
        for file in files:
            if file.endswith('.sv'):
                sources.append(Path(root)/file)
    return sources


def run_test(
    source: str, 
    top_module: str,
    test_cases: list[str] = [],
    open_waveform: bool = False
):
    
    source = source.split('/')
    src_file = '/'.join(source)
    test_dir = '/'.join(source[:-1])
    vivado_path = Path(__file__).parent.parent

    runner = get_runner(os.getenv('SIM', 'icarus'))
    runner.build(
        sources=get_sources(),
        hdl_toplevel=top_module,
        build_dir=vivado_path/'test'/'.sim'/top_module,
        waves=open_waveform
    )
    runner.test(
        hdl_toplevel=top_module,
        test_module=source[-1].replace('.sv', '_tb'),
        build_dir=vivado_path/'test'/'.sim'/top_module,
        test_dir=vivado_path/'test'/Path(test_dir),
        testcase=test_cases,
        waves=open_waveform
    )
    if plot_signals() and open_waveform:
        waveform_path = Path(__file__).parent/'.sim'
        subprocess.Popen(['gtkwave', waveform_path/(top_module+'.fst')])
