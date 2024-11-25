`timescale 1ns / 1ps

module freq_divider #(
    parameter int N = 6250   // Divide from 100 MHz to 16 kHz
)(
    input logic clk, en, nrst,
    output logic ctrl_clk
);

    reg [$clog2(N):0] counter;

    always_ff @(posedge clk) begin
        if (!nrst) counter <= 0;
        else if (en)
            if (counter == 0) begin
                ctrl_clk <= 1;
                counter <= N - 1;
            end else begin
                ctrl_clk <= 0;
                counter <= counter - 1;
            end
    end

endmodule