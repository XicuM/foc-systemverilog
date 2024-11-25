`timescale 1ns / 1ps

module current_control #(
    parameter int N = 10,
    parameter int F = 9
)(
    input logic clk, en, nrst,
    input logic signed [N-1:0] i_d_ref,
    input logic signed [N-1:0] i_d,
    input logic signed [N-1:0] i_q_ref,
    input logic signed [N-1:0] i_q,
    output logic signed[N-1:0] v_d,
    output logic signed[N-1:0] v_q
);

    pi_controller #(N, F) id_controller_inst(
        .clk(clk),
        .nrst(nrst),
        .en(en),
        .reference(i_d_ref),
        .feedback(i_d),
        .kp(kp_ctrl_id),
        .ki(ki_ctrl_id),
        .kaw(kaw_ctrl_id),
        .output(v_d)
    );

    pi_controller #(N, F) iq_controller_inst(
        .clk(clk),
        .nrst(nrst),
        .en(en),
        .reference(i_q_ref),
        .feedback(i_q),
        .kp(kp_ctrl_iq),
        .ki(ki_ctrl_iq),
        .kaw(kaw_ctrl_iq),
        .output(v_q)
    );

    // Decoupling

endmodule