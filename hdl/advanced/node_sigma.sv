module node_sigma #(
    parameter WIDTH = 32
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] channel_in,
    output logic [WIDTH-1:0] channel_out_p,
    output logic [WIDTH-1:0] channel_out_q
);

    logic [WIDTH-1:0] pipe_stage_0;
    logic [WIDTH-1:0] pipe_stage_1;
    logic [WIDTH-1:0] pipe_stage_2;
    logic [WIDTH-1:0] feedback_path;

    assign feedback_path = pipe_stage_2 >> 5;
    assign channel_out_p = pipe_stage_1 + feedback_path;
    assign channel_out_q = pipe_stage_0 ^ pipe_stage_2;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pipe_stage_0 <= '0;
            pipe_stage_1 <= '0;
            pipe_stage_2 <= '0;
        end else begin
            pipe_stage_0 <= channel_in;
            pipe_stage_1 <= pipe_stage_0 | feedback_path;
            pipe_stage_2 <= pipe_stage_1 & channel_in;
        end
    end

endmodule
