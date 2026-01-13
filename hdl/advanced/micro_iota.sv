module micro_iota #(
    parameter WIDTH = 32
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] y_in,
    output logic [WIDTH-1:0] y_out
);

    logic [WIDTH-1:0] accumulator;
    logic [WIDTH-1:0] shifted;

    assign shifted = {y_in[WIDTH-2:0], y_in[WIDTH-1]};
    assign y_out = accumulator | shifted;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= '0;
        end else begin
            accumulator <= accumulator + y_in;
        end
    end

endmodule
