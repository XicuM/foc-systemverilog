`timescale 1ns / 1ps

module triangular_wave #(
    parameter int N = 6,
    parameter int F = 5
)(
    input clk,
    input en,
    input nrst,
    output logic [N-1:0] out
);

    logic up_ndown = 1'b1;
    logic [N-1:0] count = 0;

    always_ff @(posedge clk) begin
        if (!nrst) begin
            up_ndown <= 1'b1;
            count <= 0;
        end else if (en) begin
            if (count == 2**N-1) up_ndown <= 1'b0;
            else if (up_ndown) count += 1;
            if (count == 0) up_ndown <= 1'b1;
            else if (!up_ndown) count -= 1;
        end
    end

    assign out = count;

endmodule