module d (
    input logic clk,
    input logic [7:0] data_in,
    output logic [7:0] data_out
);
    logic [7:0] internal;
    logic [7:0] i_out, j_out;

    // Instantiate submodules
    i i_inst (
        .clk(clk),
        .data_in(data_in),
        .data_out(i_out)
    );

    j j_inst (
        .clk(clk),
        .data_in(i_out),
        .data_out(j_out)
    );

    assign internal = j_out - 8'h10;
    assign data_out = internal;

endmodule
