module top_intermediate #(
    parameter WIDTH = 16
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] input_stream_a,
    input  logic [WIDTH-1:0] input_stream_b,
    input  logic [WIDTH-1:0] input_stream_c,
    output logic [WIDTH-1:0] output_stream_x,
    output logic [WIDTH-1:0] output_stream_y,
    output logic [WIDTH-1:0] output_stream_z
);

    // Interconnect signals between modules
    logic [WIDTH-1:0] epsilon_out_0;
    logic [WIDTH-1:0] epsilon_out_1;
    logic [WIDTH-1:0] zeta_out_p;
    logic [WIDTH-1:0] zeta_out_q;
    logic [WIDTH-1:0] eta_out;
    logic [WIDTH-1:0] combined_signal_0;
    logic [WIDTH-1:0] combined_signal_1;

    // Top-level signal combinations
    assign combined_signal_0 = epsilon_out_0 + zeta_out_p;
    assign combined_signal_1 = epsilon_out_1 ^ zeta_out_q;
    assign output_stream_x = combined_signal_0 & eta_out;
    assign output_stream_y = combined_signal_1 | input_stream_c;
    assign output_stream_z = eta_out ^ (epsilon_out_0 + epsilon_out_1);

    // Instantiate branch_epsilon (contains leaf_gamma and leaf_delta)
    branch_epsilon #(
        .WIDTH(WIDTH)
    ) u_epsilon (
        .clk        (clk),
        .rst_n      (rst_n),
        .data_in_0  (input_stream_a),
        .data_in_1  (input_stream_b),
        .data_out_0 (epsilon_out_0),
        .data_out_1 (epsilon_out_1)
    );

    // Instantiate branch_zeta
    branch_zeta #(
        .WIDTH(WIDTH)
    ) u_zeta (
        .clk          (clk),
        .rst_n        (rst_n),
        .stream_in    (input_stream_c),
        .stream_out_p (zeta_out_p),
        .stream_out_q (zeta_out_q)
    );

    // Instantiate node_eta
    node_eta #(
        .WIDTH(WIDTH)
    ) u_eta (
        .clk        (clk),
        .rst_n      (rst_n),
        .input_vec  (combined_signal_0),
        .output_vec (eta_out)
    );

endmodule
