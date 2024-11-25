`timescale 1ns / 1ps

// ---------------------------------------------------------------------
// Clarke Transform

module clarke_transform #(
    parameter int N = 10,
    parameter int F = 9
)(
    input logic signed [N-1:0] a,
    input logic signed [N-1:0] b,
    output logic signed [N-1:0] alpha,
    output logic signed [N-1:0] beta
);

    localparam logic signed [N+F-1:0] ONE_OVER_SQRT_3 = 0.5773 * (1 << F);
    logic signed [N+F-1:0] temp;
    
    assign alpha = a;
    assign temp = a + (b <<< 1);
    assign beta = (ONE_OVER_SQRT_3 * temp) >>> F;

endmodule

// ---------------------------------------------------------------------
// Park Transform

module park_transform #(
    parameter int N = 10,
    parameter int F = 9
)(
    input logic signed [N-1:0] alpha,
    input logic signed [N-1:0] beta,
    input logic signed [N-1:0] sin,
    input logic signed [N-1:0] cos,
    output logic signed [N-1:0] q,
    output logic signed [N-1:0] d
);

    assign q = (alpha*cos + beta*sin) >>> F;
    assign d = (beta*cos - alpha*sin) >>> F;

endmodule

// ---------------------------------------------------------------------
// Inverse Park Transform

module inv_park_transform #(
    parameter int N = 10,
    parameter int F = 9
)(
    input logic signed [N-1:0] v,
    input logic signed [N-1:0] d,
    input logic signed [N-1:0] sin,
    input logic signed [N-1:0] cos,
    output logic signed [N-1:0] alpha,
    output logic signed [N-1:0] beta
);

    assign alpha = (q*cos - d*sin) >>> F;
    assign beta = (q*sin + d*cos) >>> F;

endmodule