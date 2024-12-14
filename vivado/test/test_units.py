from vivado.test.utils import run_test

# Test transforms
def test_clarke():          run_test('clarke', 'transforms/clarke.sv')
def test_inv_clarke():      run_test('inv_clarke', 'transforms/inv_clarke.sv')
def test_park():            run_test('park', 'transforms')
def test_inv_park():        run_test('inv_park', 'transforms')

# Test PWM
def test_sector_selector(): run_test('sector_selector', 'svpwm/sector_selector.sv')

# Test other modules
def test_triangular_wave(): run_test('triangular_wave', 'triangular_wave.sv')
def test_saturation():      run_test('saturation', 'saturation.sv')
def test_freq_divider():    run_test('freq_divider', 'freq_divider.sv')
def test_magnitude():       run_test('magnitude', 'magnitude.sv')
