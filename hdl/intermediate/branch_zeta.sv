module branch_zeta #(
    parameter WIDTH = 16
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] stream_in,
    output logic [WIDTH-1:0] stream_out_p,
    output logic [WIDTH-1:0] stream_out_q
);

    logic [WIDTH-1:0] pipeline_0;
    logic [WIDTH-1:0] pipeline_1;
    logic [WIDTH-1:0] pipeline_2;
    logic [WIDTH-1:0] feedback;

    assign feedback = pipeline_2 >> 3;
    assign stream_out_p = pipeline_1 | feedback;
    assign stream_out_q = pipeline_0 ^ pipeline_2;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pipeline_0 <= '0;
            pipeline_1 <= '0;
            pipeline_2 <= '0;
        end else begin
            pipeline_0 <= stream_in;
            pipeline_1 <= pipeline_0 + feedback;
            pipeline_2 <= pipeline_1 ^ stream_in;
        end
    end

endmodule
