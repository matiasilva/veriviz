module leaf_mu #(
    parameter WIDTH = 32
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] signal_in,
    output logic [WIDTH-1:0] signal_out
);

    logic [WIDTH-1:0] kappa_out;
    logic [WIDTH-1:0] processed;
    logic [WIDTH-1:0] feedback;

    assign processed = signal_in << 1;
    assign signal_out = kappa_out & processed;
    assign feedback = kappa_out | signal_in;

    micro_kappa #(
        .WIDTH(WIDTH)
    ) u_kappa (
        .clk    (clk),
        .rst_n  (rst_n),
        .z_in   (feedback),
        .z_out  (kappa_out)
    );

endmodule
