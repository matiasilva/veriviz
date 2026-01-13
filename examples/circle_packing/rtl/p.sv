module p (
    input logic clk,
    input logic [7:0] data_in,
    output logic [7:0] data_out
);
    logic [7:0] internal;

    assign internal = data_in << 1;
    assign data_out = internal;

endmodule
