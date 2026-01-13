module top (
    input logic clk,
    input logic rst_n,
    input logic [7:0] data_in,
    output logic [7:0] data_out
);
    logic [7:0] a_out, b_out, c_out;

    // Instantiate submodules
    a a_inst (
        .clk(clk),
        .data_in(data_in),
        .data_out(a_out)
    );

    b b_inst (
        .clk(clk),
        .data_in(a_out),
        .data_out(b_out)
    );

    c c_inst (
        .clk(clk),
        .data_in(b_out),
        .data_out(c_out)
    );

    assign data_out = c_out;

endmodule
