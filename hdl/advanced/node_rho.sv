module node_rho #(
    parameter WIDTH = 32
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] bundle_in_0,
    input  logic [WIDTH-1:0] bundle_in_1,
    output logic [WIDTH-1:0] bundle_out
);

    logic [WIDTH-1:0] nu_out_0[3];
    logic [WIDTH-1:0] nu_out_1[3];
    logic [WIDTH-1:0] pi_out_a[3];
    logic [WIDTH-1:0] pi_out_b[3];
    logic [WIDTH-1:0] aggregate;
    logic [WIDTH-1:0] sub_mix_0;
    logic [WIDTH-1:0] sub_mix_1;

    assign sub_mix_0 = (nu_out_0[0] + nu_out_1[0]) ^ (pi_out_a[0] | pi_out_b[0]);
    assign sub_mix_1 = (nu_out_0[1] & nu_out_1[1]) | (pi_out_a[1] + pi_out_b[1]);
    assign aggregate = sub_mix_0 ^ sub_mix_1 ^ (nu_out_0[2] | pi_out_a[2]);
    assign bundle_out = aggregate & bundle_in_0;

    branch_nu #(
        .WIDTH(WIDTH)
    ) u_nu_0 (
        .clk       (clk),
        .rst_n     (rst_n),
        .vec_in_0  (bundle_in_0),
        .vec_in_1  (bundle_in_1),
        .vec_out_0 (nu_out_0[0]),
        .vec_out_1 (nu_out_1[0])
    );

    branch_nu #(
        .WIDTH(WIDTH)
    ) u_nu_1 (
        .clk       (clk),
        .rst_n     (rst_n),
        .vec_in_0  (bundle_in_1),
        .vec_in_1  (nu_out_0[0]),
        .vec_out_0 (nu_out_0[1]),
        .vec_out_1 (nu_out_1[1])
    );

    branch_nu #(
        .WIDTH(WIDTH)
    ) u_nu_2 (
        .clk       (clk),
        .rst_n     (rst_n),
        .vec_in_0  (sub_mix_0),
        .vec_in_1  (bundle_in_0),
        .vec_out_0 (nu_out_0[2]),
        .vec_out_1 (nu_out_1[2])
    );

    branch_pi #(
        .WIDTH(WIDTH)
    ) u_pi_0 (
        .clk        (clk),
        .rst_n      (rst_n),
        .flow_in    (nu_out_0[0]),
        .flow_out_a (pi_out_a[0]),
        .flow_out_b (pi_out_b[0])
    );

    branch_pi #(
        .WIDTH(WIDTH)
    ) u_pi_1 (
        .clk        (clk),
        .rst_n      (rst_n),
        .flow_in    (nu_out_1[1]),
        .flow_out_a (pi_out_a[1]),
        .flow_out_b (pi_out_b[1])
    );

    branch_pi #(
        .WIDTH(WIDTH)
    ) u_pi_2 (
        .clk        (clk),
        .rst_n      (rst_n),
        .flow_in    (sub_mix_1),
        .flow_out_a (pi_out_a[2]),
        .flow_out_b (pi_out_b[2])
    );

endmodule
