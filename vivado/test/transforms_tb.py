from vivado.test.utils import *

@cocotb.test
async def clarke_transform_tb(dut):
    
    # Get parameters
    FRACTIONAL_BITS = dut.FRACTIONAL_BITS.value

    # Define signals
    t = np.arange(0, 4*np.pi, 0.1)
    a, b = np.sin(t), np.sin(t-2*np.pi/3)
    alpha, beta = np.zeros(len(t)), np.zeros(len(t))

    # Dump signals
    for i in range(len(t)):
        dut.a.value = to_signed(a[i], FRACTIONAL_BITS)
        dut.b.value = to_signed(b[i], FRACTIONAL_BITS)
        await Timer(1, units='ns')
        alpha[i] = from_signed(dut.alpha, FRACTIONAL_BITS)
        beta[i] = from_signed(dut.beta, FRACTIONAL_BITS)
    
    if plot_signals():

        # Plot inputs
        plt.subplot(2, 1, 1)
        plt.step(t, a, where='post')
        plt.step(t, b, where='post')
        plt.title('Inputs')
        plt.legend(['a', 'b'])
        
        # Plot outputs
        plt.subplot(2, 1, 2)
        plt.step(t, alpha, where='post')
        plt.step(t, beta, where='post')
        plt.title('Outputs')
        plt.legend(['alpha', 'beta'])

        plt.suptitle('Clarke Transform Test')
        plt.show()


@cocotb.test
async def inv_clarke_transform_tb(dut):

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


@cocotb.test
async def park_transform_tb(dut):

    # Define parameters
    FRACTIONAL_BITS = dut.FRACTIONAL_BITS.value

    # Define signals
    t = np.arange(0, 4*np.pi, 0.1) 
    alpha, beta = np.cos(t), np.sin(t)
    d, q = np.zeros(len(t)), np.zeros(len(t))

    # Dump signals
    for i in range(len(t)):
        dut.angle.value = to_signed(t[i] % (2*np.pi), FRACTIONAL_BITS)
        dut.alpha.value = to_signed(alpha[i], FRACTIONAL_BITS)
        dut.beta.value = to_signed(beta[i], FRACTIONAL_BITS)
        await Timer(1, units='ns')
        d[i] = from_signed(dut.d, FRACTIONAL_BITS)
        q[i] = from_signed(dut.q, FRACTIONAL_BITS)
    
    # Assert signals

    if plot_signals():

        # Plot inputs
        plt.subplot(2, 1, 1)
        plt.step(t, alpha, where='post')
        plt.step(t, beta, where='post')
        plt.title('Inputs')
        plt.legend(['alpha', 'beta'])
        
        # Plot outputs
        plt.subplot(2, 1, 2)
        plt.step(t, d, where='post')
        plt.step(t, q, where='post')
        plt.title('Outputs')
        plt.legend(['d', 'q'])

        plt.suptitle('Park Transform Test')
        plt.show()