`timescale 1ns / 1ps

module pi_controller #(
    parameter int N = 10,
    parameter int F = 9
)(
    input logic clk, en, nrst,                         
    input logic signed [N-1:0] reference,   // Reference signal
    input logic signed [N-1:0] feedback,    // Feedback signal
    input logic signed [N-1:0] kp,          // Proportional gain
    input logic signed [N-1:0] ki,          // Integral gain
    input logic signed [N-1:0] kaw,         // Anti-windup gain
    output logic signed [N-1:0] output      // Controller output
);

    logic signed [N+F-1:0] error;
    logic signed [N+F-1:0] integral;
    logic signed [N+F-1:0] result;
    
    assign error = reference - fb;
    assign integral += error;
    assign result = kp*error + ki*integral;

    always_ff @(posedge clk) begin
        if (!nrst) begin
            integral <= 0;
        end else if (en) begin
            if (result > 2**N-1) result <= 2**N-1;
            else if (result < -2**N) result <= -2**N;
        end
    end

endmodule