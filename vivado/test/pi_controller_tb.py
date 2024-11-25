from vivado.test.utils import *

@cocotb.test
@init_ff
async def pi_controller_tb(dut):

    # Define signals
    F = 5

    # Define the input signal
    t = range(200)
    u = np.sin(2*np.pi/200*np.array(t))

    if plot_signals():
        pass