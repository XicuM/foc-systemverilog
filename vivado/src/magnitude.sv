`timescale 1ns / 1ps

module magnitude #(
    parameter int WIDTH = 17,
    parameter int FRACTIONAL_BITS = 12,
    parameter int ITERATIONS = 16
)(
    input wire [WIDTH-1:0] x_in, y_in,
    output logic [WIDTH-1:0] out
);

    // Local variables
    logic signed [WIDTH-1:0] x[0:ITERATIONS];           // Array of intermediate x values
    logic signed [WIDTH-1:0] y[0:ITERATIONS];           // Array of intermediate y values
    logic signed [WIDTH+FRACTIONAL_BITS-1:0] out_temp;  // Temporary output

    // Precompute the scaling factor
    function automatic real compute_gain;
        real gain = 1.0;
        for (int i = 0; i < ITERATIONS; i++)
            gain *= 1.0 / $sqrt(1.0 + 2.0**(-2*i));
        return gain;
    endfunction
    localparam logic signed [WIDTH-1:0] SCALING_FACTOR = $rtoi(compute_gain()*(1 << FRACTIONAL_BITS));
    
    // Input values
    always_comb begin x[0]=x_in; y[0]=y_in; end

    // Unrolled CORDIC combinatorial pipeline
    generate
        for (genvar i=0; i<ITERATIONS; i++) begin
            always_comb begin
                if (((x[i]>0)&&(y[i]>0)) || ((x[i]<0)&&(y[i]<0))) begin
                    x[i+1] = x[i] + (y[i] >>> i);
                    y[i+1] = y[i] - (x[i] >>> i);
                end else begin
                    x[i+1] = x[i] - (y[i] >>> i);
                    y[i+1] = y[i] + (x[i] >>> i);
                end
            end
        end
    endgenerate

    // Absolute value of the output
    always_comb begin
        out_temp = x[ITERATIONS]*SCALING_FACTOR;
        out = out_temp > 0 ? 
            out_temp >>> FRACTIONAL_BITS : -out_temp >>> FRACTIONAL_BITS;
    end
    
endmodule