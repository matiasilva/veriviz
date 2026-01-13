module n (
    input logic clk,
    input logic [7:0] data_in,
    output logic [7:0] data_out
);
    logic [7:0] internal;
    logic [7:0] s_out, t_out;

    // Instantiate submodules
    s s_inst (
        .clk(clk),
        .data_in(data_in),
        .data_out(s_out)
    );

    t t_inst (
        .clk(clk),
        .data_in(s_out),
        .data_out(t_out)
    );

    assign internal = t_out + 8'h01;
    assign data_out = internal;

endmodule
