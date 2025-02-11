module wr_b2data(
    input clk,
    input reset,
    input wire [127:0] result_AES_in,
    input wire enable_wb,
    output reg en_w_datamem,
    output reg [31:0] data_aes,
    output reg [31:0] addr_aes
);
reg done_flag;
reg [31:0] temp_data_out [0:3];
reg [31:0] addr_aes_temp;
integer i;
reg [1:0] state; 
reg [2:0] round;
localparam IDLE = 2'd0, N1 = 2'd1, DONE = 2'd2;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_aes <= 32'b0;
        addr_aes <= 32'b0;
        en_w_datamem <= 1'b0;
        state <= IDLE;
    end
    else if (enable_wb) begin
        case (state)
            IDLE: begin 
                for (i = 0; i<4; i = i +1) begin
                    temp_data_out[i] = result_AES_in[127 - (i * 32) -: 32];
                end
                state <= N1;
                round <= 0;
            end  

            N1: begin
                if (round < 4) begin 
                    data_aes <= temp_data_out[round];
                    addr_aes <= 32'd500 + round*4;
                    en_w_datamem <= 1'b1;
                    round <= round + 1;
                end else begin 
                    state <= DONE;
                    en_w_datamem <= 1'b0;
                end 
                end

            DONE: begin
                done_flag <= 1;
            end 
            default: begin
                data_aes <= data_aes;
        addr_aes <= addr_aes;
        en_w_datamem <= en_w_datamem;
        state <= state;
            end

        endcase
    end else begin
        data_aes <= data_aes;
        addr_aes <= addr_aes;
        en_w_datamem <= en_w_datamem;
        state <= state;
    end
end
endmodule