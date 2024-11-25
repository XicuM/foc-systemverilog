from vivado.test.utils import *


@cocotb.test
async def clarke_tb(dut):
    # Define the number of fractional bits
    F = 8

    # Define signals
    t = np.arange(0, 4*np.pi, 0.1)
    a = np.sin(t)
    b = np.sin(t-2*np.pi/3)
    alpha = np.zeros(len(a))
    beta = np.zeros(len(a))

    # Dump signals
    for i in range(len(a)):
        dut.a.value = to_signed(a[i], F)
        dut.b.value = to_signed(b[i], F)
        await Timer(1, units='ns')
        alpha[i] = from_signed(dut.alpha, F)
        beta[i] = from_signed(dut.beta, F)
    
    # TODO: Assert signals

    # Plot signals
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
async def park_tb(dut):

    # Define the number of fractional bits
    F = 8

    # Define signals
    t = np.arange(0, 4*np.pi, 0.1)
    a = np.sin(t)
    b = np.sin(t-2*np.pi/3)
    alpha = np.zeros(len(a))
    beta = np.zeros(len(a))

    # Dump signals
    for i in range(len(a)):
        dut.a.value = int(a[i] * 1<<F) 
        dut.b.value = int(b[i] * 1<<F)
        await Timer(1, units='ns')
        alpha[i] = dut.alpha.value.signed_integer / 1<<F
        beta[i] = dut.beta.value.signed_integer / 1<<F
    
    # Assert signals
    #assert np.allclose(alpha, np.sqrt(2/3)*a - np.sqrt(1/3)*b)
    #assert np.allclose(beta, 1/np.sqrt(3)*b)

    # Plot signals
    #if os.environ['COCOTB_PLOT'] == 'True':
        # Plot inputs
        import matplotlib.pyplot as plt
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


@cocotb.test()
async def clarke_and_park_tb(dut):

    cocotb.start_soon(Clock(dut.clk, 1, units='ns').start())
    dut.rst.value = 1

    await FallingEdge(dut.clk)
    dut.en.value = 1
    dut.rst.value = 0

    values = []
    for _ in range(100): 
        await Timer(1, units='ns')
        values.append(dut.count.value.integer)
        
    import matplotlib.pyplot as plt
    plt.plot(values)
    plt.show()