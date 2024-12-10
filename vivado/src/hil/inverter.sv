`timescale 1ns / 1ps

// Ideal inverter module with no switching losses
module inverter #(
    parameter WIDTH = 16,
    parameter FRACTIONAL_BITS = 8
)(
    input logic [5:0] gates,
    input logic signed [WIDTH-1:0] v_dc, 
    output logic signed [WIDTH-1:0] v_a, v_b, v_c
);

    always_comb
        case (gates)
            6'b000001: begin v_a <= v_dc; v_b <= 0;    v_c <= 0;    end
            6'b000010: begin v_a <= 0;    v_b <= v_dc; v_c <= 0;    end
            6'b000100: begin v_a <= 0;    v_b <= 0;    v_c <= v_dc; end
            6'b001000: begin v_a <= 0;    v_b <= v_dc; v_c <= v_dc; end
            6'b010000: begin v_a <= v_dc; v_b <= 0;    v_c <= v_dc; end
            6'b100000: begin v_a <= v_dc; v_b <= v_dc; v_c <= 0;    end
            default:   begin v_a <= 0;    v_b <= 0;    v_c = 0;    end
        endcase

endmodule