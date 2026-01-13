module branch_pi #(
    parameter WIDTH = 32
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] flow_in,
    output logic [WIDTH-1:0] flow_out_a,
    output logic [WIDTH-1:0] flow_out_b
);

    logic [WIDTH-1:0] xi_out[3];
    logic [WIDTH-1:0] omicron_out[2];
    logic [WIDTH-1:0] cross_connect;
    logic [WIDTH-1:0] cross_connect_2;

    assign cross_connect = xi_out[0] & omicron_out[0];
    assign cross_connect_2 = xi_out[1] | xi_out[2];
    assign flow_out_a = (xi_out[0] + cross_connect) ^ omicron_out[1];
    assign flow_out_b = (omicron_out[0] ^ flow_in) | cross_connect_2;

    leaf_xi #(
        .WIDTH(WIDTH)
    ) u_xi_0 (
        .clk        (clk),
        .rst_n      (rst_n),
        .packet_in  (flow_in),
        .packet_out (xi_out[0])
    );

    leaf_xi #(
        .WIDTH(WIDTH)
    ) u_xi_1 (
        .clk        (clk),
        .rst_n      (rst_n),
        .packet_in  (cross_connect),
        .packet_out (xi_out[1])
    );

    leaf_xi #(
        .WIDTH(WIDTH)
    ) u_xi_2 (
        .clk        (clk),
        .rst_n      (rst_n),
        .packet_in  (omicron_out[0]),
        .packet_out (xi_out[2])
    );

    leaf_omicron #(
        .WIDTH(WIDTH)
    ) u_omicron_0 (
        .clk       (clk),
        .rst_n     (rst_n),
        .token_in  (cross_connect),
        .token_out (omicron_out[0])
    );

    leaf_omicron #(
        .WIDTH(WIDTH)
    ) u_omicron_1 (
        .clk       (clk),
        .rst_n     (rst_n),
        .token_in  (xi_out[1]),
        .token_out (omicron_out[1])
    );

endmodule
