module b (
    input logic clk,
    input logic [7:0] data_in,
    output logic [7:0] data_out
);
    logic [7:0] internal;
    logic [7:0] g_out, h_out;

    // Instantiate submodules
    g g_inst (
        .clk(clk),
        .data_in(data_in),
        .data_out(g_out)
    );

    h h_inst (
        .clk(clk),
        .data_in(g_out),
        .data_out(h_out)
    );

    assign internal = h_out >> 2;
    assign data_out = internal;

endmodule
