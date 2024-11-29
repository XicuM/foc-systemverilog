from vivado.test.utils import *
import control as ct

@cocotb.test
@init_ff
async def pi_controller_tb(dut):

    # Define parameters
    FRACTIONAL_BITS = dut.FRACTIONAL_BITS.value

    # Define plant
    plant = ct.TransferFunction([1], [1, 1])

    # Define controller
    dut.kp.value = to_signed(1, FRACTIONAL_BITS)
    dut.ki.value = to_signed(0.1, FRACTIONAL_BITS)
    dut.kaw.value = 0

    # Define the input signal
    t = range(200)
    u = np.sin(2*np.pi/200*np.array(t))

    # Open loop response
    t0 = 10
    ol = np.append(
        np.zeros(t0), 
        ct.step_response(plant, T=t[t0:])[1]
    )
    
    # Closed loop response
    cl = np.zeros(len(t))
    for t_i in t:
        if t_i < t0: continue
        await FallingEdge(dut.clk)
        dut.reference.value = to_signed(u[t_i], FRACTIONAL_BITS)
        dut.feedback.value = to_signed(0, FRACTIONAL_BITS)
        await RisingEdge(dut.clk)
        u = from_signed(dut.output.value, FRACTIONAL_BITS)
        cl[t_i] = ct.forced_response()

    if plot_signals():
        plt.subplot(2, 1, 1)
        plt.step(t, ol, where='post')
        plt.title('Open loop response')
        
        plt.subplot(2, 1, 2)
        plt.step(t, cl, where='post')
        plt.title('Closed loop response')

        plt.show()