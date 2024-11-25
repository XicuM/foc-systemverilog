`timescale 1ns / 1ps

module speed_detection #(
    parameter int N = 10,
    parameter int F = 9
)(
    input logic clk, en, nrst,
    input logic signed [N-1:0] pos_in,
    output logic signed [N-1:0] pos_out,
    output logic signed [N-1:0] speed_out
);

    

endmodule