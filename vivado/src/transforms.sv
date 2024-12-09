`timescale 1ns / 1ps


parameter real PI = 3.141592653589793;
parameter real PI_OVER_2 = PI / 2.0;


// ---------------------------------------------------------------------
// Clarke Transform

module clarke_transform #(
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


// ---------------------------------------------------------------------
// Inverse Clarke Transform

module inv_clarke_transform #(
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

// ---------------------------------------------------------------------
// Park Transform

module park_transform #(
    parameter WIDTH = 12,
    parameter FRACTIONAL_BITS = 8
)(
    input logic signed [WIDTH-1:0] alpha, beta,
    input logic signed [WIDTH-1:0] angle,
    output logic signed [WIDTH-1:0] q, d
);

    cordic_rotation #(
        .WIDTH(WIDTH), 
        .FRACTIONAL_BITS(FRACTIONAL_BITS)
    ) cordic_park_inst (
        .x_in(alpha),
        .y_in(beta),
        .z_in(angle),
        .x_out(q),
        .y_out(d)
    );

endmodule


// ---------------------------------------------------------------------
// Inverse Park Transform

module inv_park_transform #(
    parameter WIDTH = 12,
    parameter FRACTIONAL_BITS = 8
)(
    input logic signed [WIDTH-1:0] d, q,
    input logic signed [WIDTH-1:0] angle,
    output logic signed [WIDTH-1:0] alpha, beta
);
    
    cordic_rotation #(
        .WIDTH(WIDTH), 
        .FRACTIONAL_BITS(FRACTIONAL_BITS)
    ) cordic_inv_park_inst (
        .x_in(v),
        .y_in(d),
        .z_in(-angle),
        .x_out(alpha),
        .y_out(beta)
    );

endmodule

// ---------------------------------------------------------------------
// Rotational CORDIC

module cordic_rotation #(
    parameter WIDTH = 10,
    parameter FRACTIONAL_BITS = 8,
    parameter ITERATIONS = 16
)(
    input logic [WIDTH-1:0] x_in, y_in, z_in,
    output logic [WIDTH-1:0] x_out, y_out
);

    // Local variables
    logic signed [WIDTH-1:0] x [0:ITERATIONS];          // Array of intermediate x values
    logic signed [WIDTH-1:0] y [0:ITERATIONS];          // Array of intermediate y values
    logic signed [WIDTH-1:0] z [0:ITERATIONS];          // Array of intermediate z values
    logic signed [WIDTH+FRACTIONAL_BITS-1:0] x_out_temp, y_out_temp;  // Temporary output

    // Precompute the scaling factor
    function automatic real compute_gain;
        real gain = 1.0;
        for (int i = 0; i < ITERATIONS; i++)
            gain *= 1.0 / $sqrt(1.0 + 2.0**(-2*i));
        return gain;
    endfunction
    localparam logic signed [WIDTH-1:0] SCALING_FACTOR = $rtoi(compute_gain()*(1 << FRACTIONAL_BITS));
    
    // Precomputed atan(2^-i) lookup table
    logic signed [WIDTH-1:0] ATAN_TABLE [0:ITERATIONS-1];
    generate
        for (genvar i = 0; i < ITERATIONS; i++)
            initial ATAN_TABLE[i] = $atan(2**(-i))*(1<<FRACTIONAL_BITS);
    endgenerate

    // Prerotate based on the quadrant of (x, y)
    always_comb begin
        if (x_in < 0) begin
            if (y_in < 0) begin     // Quadrant III
                x[0] = y_in;    y[0] = -x_in;   z[0] = z_in - PI;
            end else begin          // Quadrant II
                x[0] = -y_in;   y[0] = -x_in;   z[0] = z_in + PI;
            end
        end else begin
            if (y_in < 0) begin     // Quadrant IV
                x[0] = y_in;    y[0] = x_in;    z[0] = z_in + PI_OVER_2;
            end else begin          // Quadrant I
                x[0] = x_in;    y[0] = y_in;    z[0] = z_in;
            end
        end
    end

    // Unrolled CORDIC combinatorial pipeline
    always_comb begin
        for (int i = 0; i < ITERATIONS; i++) begin
            if (z[i] > 0) begin
                x[i+1] = x[i] - (y[i] >>> i);
                y[i+1] = y[i] + (x[i] >>> i);
                z[i+1] = z[i] - ATAN_TABLE[i];
            end else begin
                x[i+1] = x[i] + (y[i] >>> i);
                y[i+1] = y[i] - (x[i] >>> i);
                z[i+1] = z[i] + ATAN_TABLE[i];
            end
        end
    end

    // Output values
    always_comb begin
        x_out_temp = x[ITERATIONS]*SCALING_FACTOR;
        y_out_temp = y[ITERATIONS]*SCALING_FACTOR;
        x_out = x_out_temp >>> FRACTIONAL_BITS;
        y_out = y_out_temp >>> FRACTIONAL_BITS;
    end
    
endmodule