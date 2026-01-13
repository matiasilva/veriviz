module branch_nu #(
    parameter WIDTH = 32
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] vec_in_0,
    input  logic [WIDTH-1:0] vec_in_1,
    output logic [WIDTH-1:0] vec_out_0,
    output logic [WIDTH-1:0] vec_out_1
);

    logic [WIDTH-1:0] lambda_out[3];
    logic [WIDTH-1:0] mu_out[2];
    logic [WIDTH-1:0] merge_0;
    logic [WIDTH-1:0] merge_1;
    logic [WIDTH-1:0] merge_2;

    assign merge_0 = vec_in_0 ^ vec_in_1;
    assign merge_1 = lambda_out[0] + mu_out[0];
    assign merge_2 = lambda_out[1] & lambda_out[2];
    assign vec_out_0 = (lambda_out[0] & merge_0) | merge_2;
    assign vec_out_1 = (mu_out[0] | merge_1) ^ mu_out[1];

    leaf_lambda #(
        .WIDTH(WIDTH)
    ) u_lambda_0 (
        .clk      (clk),
        .rst_n    (rst_n),
        .data_in  (merge_0),
        .data_out (lambda_out[0])
    );

    leaf_lambda #(
        .WIDTH(WIDTH)
    ) u_lambda_1 (
        .clk      (clk),
        .rst_n    (rst_n),
        .data_in  (vec_in_0),
        .data_out (lambda_out[1])
    );

    leaf_lambda #(
        .WIDTH(WIDTH)
    ) u_lambda_2 (
        .clk      (clk),
        .rst_n    (rst_n),
        .data_in  (mu_out[0]),
        .data_out (lambda_out[2])
    );

    leaf_mu #(
        .WIDTH(WIDTH)
    ) u_mu_0 (
        .clk        (clk),
        .rst_n      (rst_n),
        .signal_in  (vec_in_1),
        .signal_out (mu_out[0])
    );

    leaf_mu #(
        .WIDTH(WIDTH)
    ) u_mu_1 (
        .clk        (clk),
        .rst_n      (rst_n),
        .signal_in  (lambda_out[0]),
        .signal_out (mu_out[1])
    );

endmodule
