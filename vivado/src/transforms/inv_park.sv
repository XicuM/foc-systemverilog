`timescale 1ns / 1ps

module inv_park #(
    parameter WIDTH = 12,
    parameter FRACTIONAL_BITS = 8
)(
    input logic signed [WIDTH-1:0] d, q,
    input logic signed [WIDTH-1:0] angle,
    output logic signed [WIDTH-1:0] alpha, beta
);
    
    cordic_rotation #(
        .WIDTH(WIDTH), 
        .FRACTIONAL_BITS(FRACTIONAL_BITS)
    ) cordic_inv_park_inst (
        .x_in(v),
        .y_in(d),
        .z_in(-angle),
        .x_out(alpha),
        .y_out(beta)
    );

endmodule