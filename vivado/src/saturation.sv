`timescale 1ns / 1ps

module saturation #(
    parameter WIDTH = 10,
    parameter FRACTIONAL_BITS = 9
)(
    input logic signed [WIDTH-1:0] x,
    input logic signed [WIDTH-1:0] max,
    input logic signed [WIDTH-1:0] min,
    output logic signed [WIDTH-1:0] y
);

    always_comb
        if (x > max) y <= max;
        else if (x < min) y <= min;
        else  y <= x;

endmodule