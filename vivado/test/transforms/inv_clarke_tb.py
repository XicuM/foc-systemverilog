from vivado.test.utils import *

@cocotb.test
async def inv_clarke_tb(dut):

# Get parameters
    FRACTIONAL_BITS = dut.FRACTIONAL_BITS.value

    # Define signals
    t = np.arange(0, 4*np.pi, 0.1)
    alpha, beta = np.cos(t), np.sin(t)
    a, b, c = np.zeros(len(t)), np.zeros(len(t)), np.zeros(len(t))

    # Dump signals
    for i in range(len(t)):
        dut.alpha.value = to_signed(alpha[i], FRACTIONAL_BITS)
        dut.beta.value = to_signed(beta[i], FRACTIONAL_BITS)
        await Timer(1, units='ns')
        a[i] = from_signed(dut.a, FRACTIONAL_BITS)
        b[i] = from_signed(dut.b, FRACTIONAL_BITS)
        c[i] = from_signed(dut.c, FRACTIONAL_BITS)
    
    if plot_signals():

        # Plot inputs
        plt.subplot(2, 1, 1)
        plt.step(t, alpha, where='post')
        plt.step(t, beta, where='post')
        plt.title('Outputs')
        plt.legend(['alpha', 'beta'])
        
        # Plot outputs
        plt.subplot(2, 1, 2) 
        plt.step(t, a, where='post')
        plt.step(t, b, where='post')
        plt.title('Outputs')
        plt.legend(['a', 'b'])

        plt.suptitle('Inverse Clarke Transform Test')
        plt.show()