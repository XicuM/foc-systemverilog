`timescale 1ns / 1ps

module sector_selector #(
    parameter WIDTH = 10,
    parameter FRACTIONAL_BITS = 8
)(
    input logic signed [WIDTH-1:0] alpha, beta,
    output logic [2:0] sector
);
    // Constants
    localparam logic signed [WIDTH+FRACTIONAL_BITS-1:0] 
        SQRT_3 = $rtoi((1<<FRACTIONAL_BITS)*$sqrt(3));

    // Local variables
    logic signed [WIDTH-1:0] temp;

    // Sector selector equations
    always_comb begin
        temp = (SQRT_3*alpha) >>> FRACTIONAL_BITS;
        sector[2] = (temp-beta) > 0;
        sector[1] = (temp+beta) > 0;
        sector[0] = beta < 0;
    end
    
endmodule