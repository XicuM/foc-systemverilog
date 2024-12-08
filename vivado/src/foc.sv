`timescale 1ns / 1ps

module foc #(
    parameter N = 10,
    parameter F = 9
)(
    input logic signed [N-1:0] torque_ref,      // Reference torque
    input logic signed [N-1:0] speed_ref,       // Reference speed
    input logic signed [N-1:0] i_alpha,         // Alpha current
    input logic signed [N-1:0] i_beta,          // Beta current
    output logic signed [5:0] gates = 6'b000000 // Gate signals
    control_params #(N, F) ctrl_params
);

    freq_divider #(N) freq_divider_inst (
        .clk(clk),
        .ctrl_clk(ctrl_clk)
    );

    clarke_transform #(N, F) clarke_inst (
        .a(i_alpha),
        .b(i_beta),
        .alpha(i_alpha),
        .beta(i_beta)
    );

    park_transform #(N, F) park_inst (
        .alpha(i_alpha),
        .beta(i_beta),
        .sin(theta),
        .cos(theta),
        .q(i_d),
        .d(i_q)
    );

endmodule


interface control_params #(
    parameter N = 10,
    parameter F = 9
);

    logic signed [N-1:0] ki_ctrl_speed;
    logic signed [N-1:0] kp_ctrl_speed;
    logic signed [N-1:0] kaw_ctrl_speed;
    
    logic signed [N-1:0] ki_ctrl_torque;
    logic signed [N-1:0] kp_ctrl_torque;
    logic signed [N-1:0] kaw_ctrl_speed;

    logic signed [N-1:0] ki_ctrl_id;
    logic signed [N-1:0] kp_ctrl_id;
    logic signed [N-1:0] kaw_ctrl_id;
    
    logic signed [N-1:0] ki_ctrl_iq;
    logic signed [N-1:0] kp_ctrl_iq;
    logic signed [N-1:0] kaw_ctrl_iq;

endinterface


interface signals #(
    parameter N = 10,
    parameter F = 9
);
  
    logic signed [N-1:0] i_d_ref;
    logic signed [N-1:0] i_d;
    logic signed [N-1:0] i_q_ref;
    logic signed [N-1:0] i_q;
    logic signed [N-1:0] i_alpha;
    logic signed [N-1:0] i_beta;
    logic signed [N-1:0] theta;

endinterface