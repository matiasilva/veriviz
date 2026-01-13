module leaf_gamma #(
    parameter WIDTH = 16
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] vec_in,
    output logic [WIDTH-1:0] vec_out
);

    logic [WIDTH-1:0] stage_0;
    logic [WIDTH-1:0] stage_1;
    logic [WIDTH-1:0] rotated;

    assign rotated = {vec_in[WIDTH-2:0], vec_in[WIDTH-1]};
    assign vec_out = stage_1 ^ rotated;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage_0 <= '0;
            stage_1 <= '0;
        end else begin
            stage_0 <= vec_in + rotated;
            stage_1 <= stage_0 | vec_in;
        end
    end

endmodule
