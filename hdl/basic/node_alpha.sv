module node_alpha #(
    parameter WIDTH = 8
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] data_in_a,
    input  logic [WIDTH-1:0] data_in_b,
    output logic [WIDTH-1:0] data_out,
    output logic             valid_out
);

    logic [WIDTH-1:0] internal_reg_0;
    logic [WIDTH-1:0] internal_reg_1;
    logic [WIDTH-1:0] combined_signal;
    logic             state_bit;

    // Internal signal combinations
    assign combined_signal = (internal_reg_0 & data_in_a) | (internal_reg_1 ^ data_in_b);
    assign data_out = combined_signal + internal_reg_0;
    assign valid_out = state_bit & (|combined_signal);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            internal_reg_0 <= '0;
            internal_reg_1 <= '0;
            state_bit <= 1'b0;
        end else begin
            internal_reg_0 <= data_in_a ^ data_in_b;
            internal_reg_1 <= combined_signal;
            state_bit <= ~state_bit;
        end
    end

endmodule
