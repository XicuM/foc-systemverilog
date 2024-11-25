from vivado.test.utils import run_test

def test_clarke():
    run_test(
        source='transforms.sv',
        top_module='clarke_transform', 
        test_cases=['clarke_tb']
    )

def test_park():
    run_test(
        source='transforms.sv',
        top_module='park_transform',
        test_cases=['park_tb']
    )

def test_triangular_wave():
    run_test(
        source='triangular_wave.sv', 
        top_module='triangular_wave'
    )

def test_saturation():
    run_test(
        source='saturation.sv',
        top_module='saturation'
    )

def test_freq_divider():
    run_test(
        source='freq_divider.sv',
        top_module='freq_divider'
    )