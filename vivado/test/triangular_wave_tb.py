from vivado.test.utils import *

@cocotb.test
@init_ff
async def triangular_wave_tb(dut):

    # Define signals
    F = 5
    t = range(200)

    # Dump signals
    output = []
    for _ in t:
        await Timer(2, units='ns')
        output.append(from_unsigned(dut.out, F))
    
    # Plot signals
    if plot_signals():
        plt.step(t, output, where='post')
        plt.title('Triangular wave')
        plt.show()