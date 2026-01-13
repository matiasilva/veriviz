module m (
    input logic clk,
    input logic [7:0] data_in,
    output logic [7:0] data_out
);
    logic [7:0] internal;
    logic [7:0] q_out, r_out;

    // Instantiate submodules
    q q_inst (
        .clk(clk),
        .data_in(data_in),
        .data_out(q_out)
    );

    r r_inst (
        .clk(clk),
        .data_in(q_out),
        .data_out(r_out)
    );

    assign internal = r_out - 8'h01;
    assign data_out = internal;

endmodule
