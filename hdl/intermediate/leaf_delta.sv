module leaf_delta #(
    parameter WIDTH = 16
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] vec_a,
    input  logic [WIDTH-1:0] vec_b,
    output logic [WIDTH-1:0] result
);

    logic [WIDTH-1:0] merged;
    logic [WIDTH-1:0] shifted_a;
    logic [WIDTH-1:0] shifted_b;
    logic [WIDTH-1:0] acc;

    assign shifted_a = vec_a << 2;
    assign shifted_b = vec_b >> 2;
    assign merged = shifted_a ^ shifted_b;
    assign result = acc & merged;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc <= '0;
        end else begin
            acc <= acc + merged;
        end
    end

endmodule
