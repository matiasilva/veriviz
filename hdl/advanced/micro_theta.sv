module micro_theta #(
    parameter WIDTH = 32
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] x_in,
    output logic [WIDTH-1:0] x_out
);

    logic [WIDTH-1:0] reg_a;
    logic [WIDTH-1:0] reg_b;

    assign x_out = reg_a ^ reg_b;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_a <= '0;
            reg_b <= '0;
        end else begin
            reg_a <= x_in;
            reg_b <= x_in >> 4;
        end
    end

endmodule
