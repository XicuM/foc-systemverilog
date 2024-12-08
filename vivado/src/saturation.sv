`timescale 1ns / 1ps

module saturation #(
    parameter N = 10,
    parameter F = 9
)(
    input logic signed [N-1:0] x,
    input logic signed [N-1:0] max,
    input logic signed [N-1:0] min,
    output logic signed [N-1:0] y
);

    always_comb begin
        if (x > max) begin
            y = max;
        end else if (x < min) begin
            y = min;
        end else begin
            y = x;
        end
    end

endmodule