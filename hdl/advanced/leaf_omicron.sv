module leaf_omicron #(
    parameter WIDTH = 32
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] token_in,
    output logic [WIDTH-1:0] token_out
);

    logic [WIDTH-1:0] memory [3:0];
    logic [1:0]       ptr;
    logic [WIDTH-1:0] selected;

    assign selected = memory[ptr];
    assign token_out = selected ^ token_in;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            memory[0] <= '0;
            memory[1] <= '0;
            memory[2] <= '0;
            memory[3] <= '0;
            ptr <= 2'b00;
        end else begin
            memory[ptr] <= token_in;
            ptr <= ptr + 1'b1;
        end
    end

endmodule
