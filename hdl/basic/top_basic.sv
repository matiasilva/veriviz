module top_basic #(
    parameter WIDTH = 8
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] input_a,
    input  logic [WIDTH-1:0] input_b,
    input  logic [WIDTH-1:0] input_c,
    output logic [WIDTH-1:0] output_x,
    output logic [WIDTH-1:0] output_y,
    output logic             output_valid
);

    // Internal interconnect signals
    logic [WIDTH-1:0] alpha_to_beta;
    logic [WIDTH-1:0] beta_p_to_output;
    logic [WIDTH-1:0] beta_q_internal;
    logic             alpha_valid;
    logic [WIDTH-1:0] processed_input;

    // Signal processing
    assign processed_input = input_a ^ input_c;
    assign output_x = beta_p_to_output & alpha_to_beta;
    assign output_y = beta_q_internal | processed_input;
    assign output_valid = alpha_valid;

    // Instantiate node_alpha
    node_alpha #(
        .WIDTH(WIDTH)
    ) u_alpha (
        .clk       (clk),
        .rst_n     (rst_n),
        .data_in_a (input_a),
        .data_in_b (input_b),
        .data_out  (alpha_to_beta),
        .valid_out (alpha_valid)
    );

    // Instantiate node_beta
    node_beta #(
        .WIDTH(WIDTH)
    ) u_beta (
        .clk        (clk),
        .rst_n      (rst_n),
        .data_in_x  (alpha_to_beta),
        .data_in_y  (input_c),
        .data_out_p (beta_p_to_output),
        .data_out_q (beta_q_internal)
    );

endmodule
