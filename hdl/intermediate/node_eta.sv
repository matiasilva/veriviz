module node_eta #(
    parameter WIDTH = 16
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] input_vec,
    output logic [WIDTH-1:0] output_vec
);

    logic [WIDTH-1:0] local_state_0;
    logic [WIDTH-1:0] local_state_1;
    logic [WIDTH-1:0] computed;

    assign computed = local_state_0 & ~local_state_1;
    assign output_vec = computed + input_vec;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            local_state_0 <= '0;
            local_state_1 <= '0;
        end else begin
            local_state_0 <= input_vec | computed;
            local_state_1 <= local_state_0 ^ input_vec;
        end
    end

endmodule
