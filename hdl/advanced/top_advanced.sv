module top_advanced #(
    parameter WIDTH = 32
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] primary_input_a,
    input  logic [WIDTH-1:0] primary_input_b,
    input  logic [WIDTH-1:0] primary_input_c,
    input  logic [WIDTH-1:0] primary_input_d,
    output logic [WIDTH-1:0] primary_output_x,
    output logic [WIDTH-1:0] primary_output_y,
    output logic [WIDTH-1:0] primary_output_z
);

    // Interconnect signals
    logic [WIDTH-1:0] tau_out_0[3];
    logic [WIDTH-1:0] tau_out_1[3];
    logic [WIDTH-1:0] rho_direct_out[4];
    logic [WIDTH-1:0] sigma_out_p[3];
    logic [WIDTH-1:0] sigma_out_q[3];
    logic [WIDTH-1:0] top_level_mix_0;
    logic [WIDTH-1:0] top_level_mix_1;
    logic [WIDTH-1:0] top_level_mix_2;
    logic [WIDTH-1:0] top_level_mix_3;

    // Top-level signal processing
    assign top_level_mix_0 = primary_input_a ^ primary_input_d;
    assign top_level_mix_1 = tau_out_0[0] + rho_direct_out[0];
    assign top_level_mix_2 = sigma_out_p[0] & sigma_out_q[0];
    assign top_level_mix_3 = tau_out_1[1] ^ rho_direct_out[2];
    assign primary_output_x = (top_level_mix_0 | tau_out_1[0]) ^ top_level_mix_1;
    assign primary_output_y = (top_level_mix_1 & rho_direct_out[1]) + sigma_out_p[1];
    assign primary_output_z = tau_out_0[2] ^ (top_level_mix_2 | primary_input_b);

    // Instantiate cluster_tau instances (contains node_rho->branch_nu->leaf_lambda/mu->micro_* and node_sigma)
    cluster_tau #(
        .WIDTH(WIDTH)
    ) u_tau_0 (
        .clk      (clk),
        .rst_n    (rst_n),
        .input_0  (primary_input_a),
        .input_1  (primary_input_b),
        .input_2  (primary_input_c),
        .output_0 (tau_out_0[0]),
        .output_1 (tau_out_1[0])
    );

    cluster_tau #(
        .WIDTH(WIDTH)
    ) u_tau_1 (
        .clk      (clk),
        .rst_n    (rst_n),
        .input_0  (primary_input_b),
        .input_1  (primary_input_c),
        .input_2  (primary_input_d),
        .output_0 (tau_out_0[1]),
        .output_1 (tau_out_1[1])
    );

    cluster_tau #(
        .WIDTH(WIDTH)
    ) u_tau_2 (
        .clk      (clk),
        .rst_n    (rst_n),
        .input_0  (primary_input_c),
        .input_1  (primary_input_d),
        .input_2  (primary_input_a),
        .output_0 (tau_out_0[2]),
        .output_1 (tau_out_1[2])
    );

    // Instantiate standalone node_rho instances for additional hierarchy
    node_rho #(
        .WIDTH(WIDTH)
    ) u_rho_direct_0 (
        .clk         (clk),
        .rst_n       (rst_n),
        .bundle_in_0 (primary_input_c),
        .bundle_in_1 (primary_input_d),
        .bundle_out  (rho_direct_out[0])
    );

    node_rho #(
        .WIDTH(WIDTH)
    ) u_rho_direct_1 (
        .clk         (clk),
        .rst_n       (rst_n),
        .bundle_in_0 (tau_out_0[0]),
        .bundle_in_1 (primary_input_a),
        .bundle_out  (rho_direct_out[1])
    );

    node_rho #(
        .WIDTH(WIDTH)
    ) u_rho_direct_2 (
        .clk         (clk),
        .rst_n       (rst_n),
        .bundle_in_0 (tau_out_1[1]),
        .bundle_in_1 (primary_input_b),
        .bundle_out  (rho_direct_out[2])
    );

    node_rho #(
        .WIDTH(WIDTH)
    ) u_rho_direct_3 (
        .clk         (clk),
        .rst_n       (rst_n),
        .bundle_in_0 (sigma_out_p[0]),
        .bundle_in_1 (primary_input_d),
        .bundle_out  (rho_direct_out[3])
    );

    // Instantiate standalone node_sigma instances
    node_sigma #(
        .WIDTH(WIDTH)
    ) u_sigma_direct_0 (
        .clk           (clk),
        .rst_n         (rst_n),
        .channel_in    (top_level_mix_0),
        .channel_out_p (sigma_out_p[0]),
        .channel_out_q (sigma_out_q[0])
    );

    node_sigma #(
        .WIDTH(WIDTH)
    ) u_sigma_direct_1 (
        .clk           (clk),
        .rst_n         (rst_n),
        .channel_in    (rho_direct_out[0]),
        .channel_out_p (sigma_out_p[1]),
        .channel_out_q (sigma_out_q[1])
    );

    node_sigma #(
        .WIDTH(WIDTH)
    ) u_sigma_direct_2 (
        .clk           (clk),
        .rst_n         (rst_n),
        .channel_in    (tau_out_1[2]),
        .channel_out_p (sigma_out_p[2]),
        .channel_out_q (sigma_out_q[2])
    );

endmodule
