module branch_epsilon #(
    parameter WIDTH = 16
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] data_in_0,
    input  logic [WIDTH-1:0] data_in_1,
    output logic [WIDTH-1:0] data_out_0,
    output logic [WIDTH-1:0] data_out_1
);

    logic [WIDTH-1:0] gamma_output;
    logic [WIDTH-1:0] delta_output;
    logic [WIDTH-1:0] intermediate_mix;

    assign intermediate_mix = gamma_output + delta_output;
    assign data_out_0 = gamma_output ^ intermediate_mix;
    assign data_out_1 = delta_output & data_in_1;

    leaf_gamma #(
        .WIDTH(WIDTH)
    ) u_gamma (
        .clk     (clk),
        .rst_n   (rst_n),
        .vec_in  (data_in_0),
        .vec_out (gamma_output)
    );

    leaf_delta #(
        .WIDTH(WIDTH)
    ) u_delta (
        .clk    (clk),
        .rst_n  (rst_n),
        .vec_a  (data_in_0),
        .vec_b  (data_in_1),
        .result (delta_output)
    );

endmodule
