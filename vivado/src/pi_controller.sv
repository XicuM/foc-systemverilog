`timescale 1ns / 1ps

module pi_controller #(
    parameter int I_WIDTH = 10,
    parameter int I_FRACTIONAL_BITS = 9,
    parameter int O_WIDTH = 10,
    parameter int O_FRACTIONAL_BITS = 9,
    parameter bool ANTI_WINDUP = 1
)(
    input logic clk, en, nrst,                      // Clock, enable, reset
    input logic signed [I_WIDTH-1:0] r, y,          // Reference, feedback
    input logic signed [I_WIDTH-1:0] kp, ki, kaw,   // Gains
    input logic signed [O_WIDTH-1:0] u_sat,         // Saturated output
    output logic signed [O_WIDTH-1:0] u             // Output
);
    logic signed [I_WIDTH-1:0] e;                           // Error 
    logic signed [I_WIDTH+I_FRACTIONAL_BITS-1:0] integral;  // Integral term
    logic signed [O_WIDTH+O_FRACTIONAL_BITS-1:0] result;    // Result

    // Error calculation
    assign e = r - y;

    // Integral register
    always_ff @(posedge clk)
        if (!nrst) integral <= 0;
        else if (en)
            integral <= (ANTI_WINDUP) ?
                integral + e + kaw*(u_sat - u) :
                integral + e;

    // Output assignment
    assign result = kp*e + ki*integral;
    assign u = result >>> OUTPUT_FRACTIONAL_BITS;

endmodule