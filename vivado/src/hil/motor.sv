`timescale 1ns / 1ps

module motor #(
    parameter timestep = 1.0,
)(
    input  logic clk, nrst, en,
    input  logic [N_BITS_VOLTAGE-1:0] v_a, v_b, v_c,
    output logic [N_BITS_CURRENT-1:0] i_a, i_b, i_c
    output logic [N_BITS_ANGLE-1:0] angle,
    output logic [N_BITS_SPEED-1:0] speed,
    output logic [N_BITS_TORQUE-1:0] torque
);

    logic signed [N_BITS_VOLTAGE-1:0] i_alpha, i_beta;
    logic signed [N_BITS_VOLTAGE-1:0] i_d, i_q;

    // Clarke
    clarke_transform #(
        .WIDTH(N_BITS_VOLTAGE),
        .FRACTIONAL_BITS(F_BITS_VOLTAGE)
    ) clarke_inst (
        .a(v_a),
        .b(v_b),
        .alpha(v_alpha),
        .beta(v_beta)
    );

    // Park
    park_transform #(
        .WIDTH(N_BITS_VOLTAGE),
        .FRACTIONAL_BITS(F_BITS_VOLTAGE)
    ) park_inst (
        .alpha(v_alpha),
        .beta(v_beta),
        .theta(theta),
        .d(v_d),
        .q(v_q)
    );

    // Calculate current
    assign i_d = i_d + timestep * 1/Ls * (v_d - R * i_d - Ls * speed * i_q);

    // Calculate angle
    logic signed [N_BITS_ANGLE+F_BITS_ANGLE-1:0] angle_temp;
    always_ff @(posedge clk) begin
        if (!nrst) begin
            angle <= 0;
        end else if (en) begin
            angle_temp <= timestep * speed;
            angle <= angle + (angle_temp >> F_BITS_ANGLE);
        end
    end

    // Calculate speed
    always_ff @(posedge clk) begin
        if (!nrst) begin
            speed <= 0;
        end else if (en) begin
            speed <= speed + timestep * 1/J * (torque - B * speed);
        end
    end
    
    // Calculate torque
    assign torque = 3/2 * P * (i_q * i_a - i_d * i_b);

    // Inverse Park
    inv_park_transform #(
        .WIDTH(N_BITS_CURRENT),
        .FRACTIONAL_BITS(F_BITS_CURRENT)
    ) inv_park_inst (
        .d(i_d),
        .q(i_q),
        .theta(theta),
        .alpha(i_alpha),
        .beta(i_beta)
    );
    
    // Inverse Clarke
    inv_clarke_transform #(
        .WIDTH(N_BITS_CURRENT),
        .FRACTIONAL_BITS(F_BITS_CURRENT)
    ) clarke_inst (
        .alpha(i_alpha),
        .beta(i_beta),
        .a(i_a),
        .b(i_b),
        .c(i_c)
    );

endmodule