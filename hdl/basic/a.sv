module a (
    input logic clk,
    input logic [7:0] data_in,
    output logic [7:0] data_out
);
    logic [7:0] internal;
    logic [7:0] d_out, e_out, f_out;

    // Instantiate submodules
    d d_inst (
        .clk(clk),
        .data_in(data_in),
        .data_out(d_out)
    );

    e e_inst (
        .clk(clk),
        .data_in(d_out),
        .data_out(e_out)
    );

    f f_inst (
        .clk(clk),
        .data_in(e_out),
        .data_out(f_out)
    );

    assign internal = f_out & 8'h55;
    assign data_out = internal;

endmodule
