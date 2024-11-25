from vivado.test.utils import *

@cocotb.test
async def freq_divider_tb(dut):
    N = 7000

    # Initialize sequential logic
    await init_ff(dut)

    # Dump signals
    clk = []
    ctrl_clk = []
    for _ in range(N):
        await Timer(1, units='ns')
        await RisingEdge(dut.clk)
        clk.append(int(dut.clk.value))
        ctrl_clk.append(int(dut.ctrl_clk.value))
        await FallingEdge(dut.clk)
        clk.append(int(dut.clk.value))
        ctrl_clk.append(int(dut.ctrl_clk.value))

    if plot_signals():
        plt.step(range(2*N), clk, where='post')
        plt.step(range(2*N), ctrl_clk, where='post')
        plt.title('Frequency divider')
        plt.show()