`timescale 1ns / 1ps

module inv_clarke #(
    parameter WIDTH = 10,
    parameter FRACTIONAL_BITS = 8
)(
    input logic signed [WIDTH-1:0] alpha, beta,
    output logic signed [WIDTH-1:0] a, b, c
);
    
    // Constants
    localparam logic signed [WIDTH+FRACTIONAL_BITS-1:0] 
        SQRT_3 = $rtoi($itor(1<<(FRACTIONAL_BITS-1))*$sqrt(3));
    
    // Local variables
    logic signed [WIDTH+FRACTIONAL_BITS-1:0] temp;
    
    // Inverse Clarke transform equations
    assign a = alpha;
    assign temp = beta * SQRT_3;
    assign b = (temp >>> FRACTIONAL_BITS) - (alpha >>> 1);
    assign c = -(temp >>> FRACTIONAL_BITS) - (alpha >>> 1);

endmodule