`timescale 1ns / 1ps

module triangular_wave_copy #(
    parameter N = 6,
    parameter F = 5 // Not used
)(
    input logic clk, en, nrst,
    output logic [N-1:0] out
);

    logic up_ndown;
    logic [N-1:0] count;

    always_ff @(posedge clk)
        if (!nrst) up_ndown <= 1'b1;
        else if (en)
            if (&count) up_ndown <= 1'b0;
            else if (~|count) up_ndown <= 1'b1;

    always_ff @(posedge clk)
        if (!nrst) count <= N'b0;
        else if (en)
            if (up_ndown) count <= count + 1'b1;
            else count <= count - 1'b1;

    assign out = count;

endmodule