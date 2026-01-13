module node_beta #(
    parameter WIDTH = 8
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] data_in_x,
    input  logic [WIDTH-1:0] data_in_y,
    output logic [WIDTH-1:0] data_out_p,
    output logic [WIDTH-1:0] data_out_q
);

    logic [WIDTH-1:0] temp_val_0;
    logic [WIDTH-1:0] temp_val_1;
    logic [WIDTH-1:0] temp_val_2;
    logic [WIDTH:0]   extended_sum;
    logic [WIDTH:0]   xtended_sum;
    logic [WIDTH:0]   tended_sum;
    logic [WIDTH:0]   ended_sum;
    logic [WIDTH:0]   nded_sum;
    logic [WIDTH:0]   ded_sum;
    logic [WIDTH:0]   ed_sum;

    // Complex signal expressions
    assign extended_sum = {1'b0, temp_val_0} + {1'b0, temp_val_1};
    assign temp_val_2 = (data_in_x << 1) | (data_in_y >> 1);
    assign data_out_p = extended_sum[WIDTH-1:0] ^ temp_val_2;
    assign data_out_q = temp_val_0 & temp_val_1;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            temp_val_0 <= '0;
            temp_val_1 <= '0;
        end else begin
            temp_val_0 <= data_in_x + data_in_y;
            temp_val_1 <= data_out_p ^ data_in_x;
        end
    end

endmodule
