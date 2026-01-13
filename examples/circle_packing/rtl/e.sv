module e (
    input logic clk,
    input logic [7:0] data_in,
    output logic [7:0] data_out
);
    logic [7:0] internal;
    logic [7:0] k_out, l_out;

    // Instantiate submodules
    k k_inst (
        .clk(clk),
        .data_in(data_in),
        .data_out(k_out)
    );

    l l_inst (
        .clk(clk),
        .data_in(k_out),
        .data_out(l_out)
    );

    assign internal = l_out + 8'h10;
    assign data_out = internal;

endmodule
