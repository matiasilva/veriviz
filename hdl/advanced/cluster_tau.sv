module cluster_tau #(
    parameter WIDTH = 32
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] input_0,
    input  logic [WIDTH-1:0] input_1,
    input  logic [WIDTH-1:0] input_2,
    output logic [WIDTH-1:0] output_0,
    output logic [WIDTH-1:0] output_1
);

    logic [WIDTH-1:0] rho_out;
    logic [WIDTH-1:0] sigma_out_p;
    logic [WIDTH-1:0] sigma_out_q;
    logic [WIDTH-1:0] interconnect_0;
    logic [WIDTH-1:0] interconnect_1;

    assign interconnect_0 = input_0 ^ input_2;
    assign interconnect_1 = rho_out + sigma_out_p;
    assign output_0 = interconnect_1 & sigma_out_q;
    assign output_1 = rho_out | sigma_out_p;

    node_rho #(
        .WIDTH(WIDTH)
    ) u_rho (
        .clk         (clk),
        .rst_n       (rst_n),
        .bundle_in_0 (input_0),
        .bundle_in_1 (input_1),
        .bundle_out  (rho_out)
    );

    node_sigma #(
        .WIDTH(WIDTH)
    ) u_sigma (
        .clk           (clk),
        .rst_n         (rst_n),
        .channel_in    (input_2),
        .channel_out_p (sigma_out_p),
        .channel_out_q (sigma_out_q)
    );

endmodule
