from vivado.test.utils import *


@cocotb.test
async def magnitude_tb(dut):
    
    # Define parameters
    FRACTIONAL_BITS = dut.FRACTIONAL_BITS.value
    ACCURACY = 2

    def logs(dut, case):
        dut._log.info(f'\nTEST CASE {case}:')
        scaling_factor = int(dut.SCALING_FACTOR)/(1<<FRACTIONAL_BITS)
        x_values = [int(x)/(1<<FRACTIONAL_BITS) for x in dut.x.value]
        y_values = [int(y)/(1<<FRACTIONAL_BITS) for y in dut.y.value]
        out_value = from_signed(dut.out, FRACTIONAL_BITS)
        dut._log.info(f'Scaling factor: {scaling_factor}')
        dut._log.info(f'x in each iteration: {x_values}')
        dut._log.info(f'y in each iteration: {y_values}')
        dut._log.info(f'Result: {out_value}')

    # Test case 1
    dut.x_in.value = to_signed(1, FRACTIONAL_BITS)
    dut.y_in.value = to_signed(0, FRACTIONAL_BITS)
    await Timer(1, units='ns')
    logs(dut, 1)
    out = round(from_signed(dut.out, FRACTIONAL_BITS), ACCURACY)
    assert out == 1

    # Test case 2
    dut.x_in.value = to_signed(0, FRACTIONAL_BITS)
    dut.y_in.value = to_signed(1, FRACTIONAL_BITS)
    await Timer(5, units='ns')
    logs(dut, 2)
    out = round(from_signed(dut.out, FRACTIONAL_BITS), ACCURACY)
    assert out == 1

    # Test case 3
    dut.x_in.value = to_signed(1, FRACTIONAL_BITS)
    dut.y_in.value = to_signed(1, FRACTIONAL_BITS)
    await Timer(5, units='ns')
    logs(dut, 3)
    out = round(from_signed(dut.out, FRACTIONAL_BITS), ACCURACY)
    assert out == round(np.sqrt(2), ACCURACY)

    # Test case 4
    dut.x_in.value = to_signed(-1, FRACTIONAL_BITS)
    dut.y_in.value = to_signed(1, FRACTIONAL_BITS)
    await Timer(5, units='ns')
    logs(dut, 4)
    out = round(from_signed(dut.out, FRACTIONAL_BITS), ACCURACY)
    assert out == round(np.sqrt(2), ACCURACY)

    # Test case 5
    dut.x_in.value = to_signed(-4, FRACTIONAL_BITS)
    dut.y_in.value = to_signed(-3, FRACTIONAL_BITS)
    await Timer(5, units='ns')
    logs(dut, 5)
    out = round(from_signed(dut.out, FRACTIONAL_BITS), ACCURACY)
    assert out == 5