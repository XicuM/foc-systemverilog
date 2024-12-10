`timescale 1ns / 1ps

module clarke #(
    parameter WIDTH = 10,
    parameter FRACTIONAL_BITS = 8
)(
    input logic signed [WIDTH-1:0] a, b,
    output logic signed [WIDTH-1:0] alpha, beta
);
    
    // Constanta
    localparam logic signed [WIDTH+FRACTIONAL_BITS-1:0] 
        ONE_OVER_SQRT_3 = $rtoi((1<<FRACTIONAL_BITS)/$sqrt(3));
    
    // Local variables
    logic signed [WIDTH+FRACTIONAL_BITS-1:0] temp;
    
    // Clarke transform equations
    assign alpha = a;
    assign temp = a + (b <<< 1);
    assign beta = (ONE_OVER_SQRT_3 * temp) >>> FRACTIONAL_BITS;

endmodule