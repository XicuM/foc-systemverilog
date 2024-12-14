`timescale 1ns / 1ps

module svpwm #(
    parameter WIDTH = 8
)(
    input logic signed [WIDTH-1:0] alpha, beta,
    input logic [WIDTH-1:0] da_on, db_on, dc_on
);
    
    // Local parameters
    localparam logic signed [WIDTH+FRACTIONAL_BITS-1:0] 
        SQRT_3 = $rtoi((1<<FRACTIONAL_BITS)*$sqrt(3));
    
    // Local variables
    logic signed [WIDTH+FRACTIONAL_BITS-1:0] alpha_temp, beta_temp;
    logic [2:0] sector;
    logic signed [WIDTH-1:0] x, y, z, t1, t2, tx, ty, tz;

    // Sector selector
    sector_selector #(
        .WIDTH(WIDTH)
    ) sector_selector_inst (
        .alpha(alpha),
        .beta(beta),
        .sector(sector)
    );

    always_comb begin

        // Normalization
        x = alpha*SQRT_3/V_DC >> FRACTIONAL_BITS;
        y = z >> 1;
        z = beta*SQRT_3/V_DC >> FRACTIONAL_BITS;

        // Calculation of high time
        case (sector)
            3'b001: begin t1 =  z; t2 =  x; end
            3'b010: begin t1 =  y; t2 = -z; end
            3'b011: begin t1 =  x; t2 = -y; end
            3'b100: begin t1 = -z; t2 = -x; end
            3'b101: begin t1 = -y; t2 = -x; end
            3'b110: begin t1 =  z; t2 =  y; end
        endcase

        // Calculation of duty cycles
        tx = (1 - t1 - t2) >> 2;
        ty = (1 - t1 + t2) >> 2;
        tz = (1 + t1 + t2) >> 2;

        // Assign duty cycles to phase outputs
        case (sector)
            3'b001: begin da_on = tx; db_on = ty; dc_on = tz; end
            3'b010: begin da_on = ty; db_on = tx; dc_on = tz; end
            3'b011: begin da_on = tz; db_on = tx; dc_on = ty; end
            3'b100: begin da_on = tz; db_on = ty; dc_on = tx; end
            3'b101: begin da_on = ty; db_on = tx; dc_on = tx; end
            3'b110: begin da_on = tx; db_on = tx; dc_on = ty; end
        endcase
        
    end

endmodule