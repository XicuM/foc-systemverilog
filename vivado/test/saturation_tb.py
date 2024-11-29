from vivado.test.utils import *

@cocotb.test
async def saturation_tb(dut):

    # Define signals
    F = 9
    x = np.linspace(-1,1, 100)
    dut.max.value = to_signed(0.5, F)
    dut.min.value = to_signed(-0.5, F)

    # Dump signals
    y = []
    for x_i in x:
        dut.x.value = to_signed(x_i, F)
        await Timer(2, units='ns')
        y.append(from_signed(dut.y, F))
    
    # Plot signals
    if plot_signals():
        plt.step(x, y, where='post')
        plt.title('Saturated signal')
        plt.show()