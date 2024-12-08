`timescale 1ns / 1ps

module speed_controller #(
    parameter N = 10,
    parameter F = 9
)(
    input logic signed [N-1:0] speed_ref,
    input logic signed [N-1:0] speed,
    output logic signed [N-1:0] torque_ref
);

    pi_controller #(N, F) speed_controller_inst(
        .reference(speed_ref),
        .feedback(speed),
        .kp(kp_ctrl_speed),
        .ki(ki_ctrl_speed),
        .kaw(kaw_ctrl_speed),
        .output(torque_ref)
    );

endmodule