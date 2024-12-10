`timescale 1ns / 1ps

module park #(
    parameter WIDTH = 12,
    parameter FRACTIONAL_BITS = 8
)(
    input logic signed [WIDTH-1:0] alpha, beta,
    input logic signed [WIDTH-1:0] angle,
    output logic signed [WIDTH-1:0] q, d
);

    cordic_rotation #(
        .WIDTH(WIDTH), 
        .FRACTIONAL_BITS(FRACTIONAL_BITS)
    ) cordic_park_inst (
        .x_in(alpha),
        .y_in(beta),
        .z_in(angle),
        .x_out(q),
        .y_out(d)
    );

endmodule