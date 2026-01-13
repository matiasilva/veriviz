module i (
    input logic clk,
    input logic [7:0] data_in,
    output logic [7:0] data_out
);
    logic [7:0] internal;
    logic [7:0] m_out, n_out;

    // Instantiate submodules
    m m_inst (
        .clk(clk),
        .data_in(data_in),
        .data_out(m_out)
    );

    n n_inst (
        .clk(clk),
        .data_in(m_out),
        .data_out(n_out)
    );

    assign internal = {n_out[3:0], n_out[7:4]};
    assign data_out = internal;

endmodule
