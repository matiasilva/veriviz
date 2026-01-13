module leaf_xi #(
    parameter WIDTH = 32
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] packet_in,
    output logic [WIDTH-1:0] packet_out
);

    logic [WIDTH-1:0] stage_0;
    logic [WIDTH-1:0] stage_1;
    logic [WIDTH-1:0] stage_2;

    assign packet_out = stage_2 ^ packet_in;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage_0 <= '0;
            stage_1 <= '0;
            stage_2 <= '0;
        end else begin
            stage_0 <= packet_in;
            stage_1 <= stage_0 >> 2;
            stage_2 <= stage_1 + stage_0;
        end
    end

endmodule
