module micro_kappa #(
    parameter WIDTH = 32
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] z_in,
    output logic [WIDTH-1:0] z_out
);

    logic [WIDTH-1:0] buffer_0;
    logic [WIDTH-1:0] buffer_1;
    logic [WIDTH-1:0] mixed;

    assign mixed = buffer_0 & buffer_1;
    assign z_out = mixed ^ z_in;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer_0 <= '0;
            buffer_1 <= '0;
        end else begin
            buffer_0 <= z_in + mixed;
            buffer_1 <= buffer_0 | z_in;
        end
    end

endmodule
