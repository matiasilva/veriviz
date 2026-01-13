module j (
    input logic clk,
    input logic [7:0] data_in,
    output logic [7:0] data_out
);
    logic [7:0] internal;
    logic [7:0] o_out, p_out;

    // Instantiate submodules
    o o_inst (
        .clk(clk),
        .data_in(data_in),
        .data_out(o_out)
    );

    p p_inst (
        .clk(clk),
        .data_in(o_out),
        .data_out(p_out)
    );

    assign internal = p_out | 8'h33;
    assign data_out = internal;

endmodule
