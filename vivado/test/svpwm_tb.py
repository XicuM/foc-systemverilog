from vivado.test.utils import *


@cocotb.test
async def svpwm_tb(dut):
    pass


@cocotb.test
async def sector_selector_tb(dut):

    # Get parameters
    FRACTIONAL_BITS = dut.FRACTIONAL_BITS.value

    # Define signals
    t = np.arange(0, 4*np.pi, 0.1)
    alpha, beta = np.sin(t), np.sin(t-2*np.pi/3)
    sector = np.zeros(len(t))

    # Dump signals
    for i in range(len(t)):
        dut.alpha.value = to_signed(alpha[i], FRACTIONAL_BITS)
        dut.beta.value = to_signed(beta[i], FRACTIONAL_BITS)
        await Timer(1, units='ns')
        sector[i] = int(dut.sector)/10
    
    # TODO: Assert signals

    if plot_signals():
        plt.step(t, alpha, where='post')
        plt.step(t, beta, where='post')
        plt.step(t, sector, where='post')
        plt.title('Sector Selector Test')
        plt.show()