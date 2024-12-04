`timescale 1ns / 1ps

module dead_time (
    input logic clk,
    input logic rst_n,
    input logic en,
    input logic [15:0] dead_time,
    output logic done
);

    logic [15:0] counter;

    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            counter <= 16'h0;
        end else if (en) begin
            if (counter == dead_time) begin
                done <= 1;
                counter <= 16'h0;
            end else begin
                counter <= counter + 1;
            end
        end
    end