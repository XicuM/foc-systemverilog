`timescale 1ns / 1ps

module freq_divider #(
    parameter N = 6250   // Divide from 100 MHz to 16 kHz
)(
    input logic clk, en, nrst,
    output logic ctrl_clk
);

    logic [$clog2(N):0] counter;

    assign ctrl_clk = ~|counter;

    always_ff @(posedge clk)
        if (!nrst) counter <= 0;
        else if (en)
            if (ctrl_clk) counter <= N - 1;
            else counter <= counter - 1'b1;

endmodule