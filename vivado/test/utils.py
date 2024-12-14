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


def run_test(
    top_module: str,
    files: str = 'src',
    test_cases: list[str] = [],
    open_waveform: bool = False
):
    root = Path(__file__).parent.parent
    build_dir = root/'test'/'.sim'/top_module
    
    # sources is a single file
    if '.' in files: 
        src_files = [root/'src'/Path(files)]
        test_dir = root/'test'/Path(files).parent
    # sources is a directory
    else:
        src_files = []
        for src_dir, _, files in os.walk(root/Path(files)):
            for file in files:
                if file.endswith('.sv'):
                    src_files.append(Path(src_dir)/file)
        test_dir = root/'src'/Path(files)

    print(f'Running test for {top_module} module...')
    print(f'Build dir: {build_dir}')
    print(f'Test dir: {test_dir}')
    print(f'Source files:')
    for file in src_files:
        print(f'  - {file}')

    runner = get_runner(os.getenv('SIM', 'icarus'))
    runner.build(
        sources=src_files,
        hdl_toplevel=top_module,
        build_dir=build_dir,
        waves=open_waveform
    )
    runner.test(
        hdl_toplevel=top_module,
        test_module=top_module+'_tb',
        build_dir=build_dir,
        test_dir=test_dir,
        testcase=test_cases,
        waves=open_waveform
    )

    if plot_signals() and open_waveform:
        waveform_path = Path(__file__).parent/'.sim'
        subprocess.Popen(['gtkwave', waveform_path/(top_module+'.fst')]) # TODO: arreglar expresión
