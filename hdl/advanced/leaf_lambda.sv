module leaf_lambda #(
    parameter WIDTH = 32
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] data_in,
    output logic [WIDTH-1:0] data_out
);

    logic [WIDTH-1:0] theta_out;
    logic [WIDTH-1:0] iota_out;
    logic [WIDTH-1:0] combined;

    assign combined = theta_out + iota_out;
    assign data_out = combined ^ data_in;

    micro_theta #(
        .WIDTH(WIDTH)
    ) u_theta (
        .clk    (clk),
        .rst_n  (rst_n),
        .x_in   (data_in),
        .x_out  (theta_out)
    );

    micro_iota #(
        .WIDTH(WIDTH)
    ) u_iota (
        .clk    (clk),
        .rst_n  (rst_n),
        .y_in   (data_in),
        .y_out  (iota_out)
    );

endmodule
