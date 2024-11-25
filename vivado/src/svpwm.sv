`timescale 1ns / 1ps

module svpwm #(
    parameter int N = 8
)(
    input logic [N-1:0] v_alpha,
    input logic [N-1:0] v_beta,
    output logic da_on,
    output logic db_on,
    output logic dc_on
);
    logic [N-1:0] a, b, sum;
    
    always_comb begin
        sum = a + b;
    end

    // Sector selector
    always_comb begin
        sum = a + b;
    end
    
    // Normalization

endmodule