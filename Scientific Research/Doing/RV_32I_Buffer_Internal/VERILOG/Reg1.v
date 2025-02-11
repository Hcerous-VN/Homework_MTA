module Reg1(
    input clk,
    input reset,
    input start,

    // input lui_in,
    // input auipc_in,
    // input jal_in,
    // input jalr_in,
    // input mem_write_in,
    // input mem_read_in,
    // input [2:0] alu_op_in,
    // input alu_src_in,
    // input branch_in,
    // input mem_to_reg_in,
    // input reg_write_in,

    input [31:0] pc_plus4_in,
    input [31:0] pc_in,
        input load_temp_in,
    input plus1_in,
    // input [31:0] inst_in,
    // input ecall_in,

    // output reg lui_out,
    // output reg auipc_out,
    // output reg  jal_out,
    // output reg  jalr_out, 
    // output reg  mem_write_out,
    // output reg mem_read_out,
    // output reg [2:0] alu_op_out,
    // output reg alu_src_out,
    // output reg branch_out,
    // output reg mem_to_reg_out,
    // output reg reg_write_out,

    output reg [31:0] pc_plus4_out,
    output reg [31:0] pc_out,
        output reg load_temp_out,
    output reg plus1_out
    // output reg [31:0] inst_out,
    // output reg ecall_out
    
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pc_out <= 32'b0;
        pc_plus4_out <= 32'b0; // Đặt giá trị mặc định cho pc_plus4_out khi reset
        // inst_out <= 32'b0;
        // reg_write_out <= 1'b0;
        // alu_op_out <= 3'b0;
        // alu_src_out <= 1'b0;
        // branch_out <= 1'b0;
        // mem_to_reg_out <= 1'b0;
        // mem_write_out <= 1'b0;
        // mem_read_out <= 1'b0;
        // lui_out <= 1'b0;
        // auipc_out <= 1'b0;
        // jal_out <= 1'b0;
        // jalr_out <= 1'b0;
        // ecall_out <= 1'b0;
        load_temp_out <= 1'b0;
        plus1_out <= 1'b0;
    end else if (start) begin
        pc_out <= pc_in;
        pc_plus4_out <= pc_plus4_in;
        load_temp_out <= load_temp_in;
        plus1_out <= plus1_in;
    end else begin
        pc_out <= 32'b0;
        pc_plus4_out <= 32'b0; // Gán giá trị cho pc_plus4_out
        // inst_out <= inst_in;
        // reg_write_out <= reg_write_in;
        // alu_op_out <= alu_op_in;
        // alu_src_out <= alu_src_in;
        // branch_out <= branch_in;
        // mem_to_reg_out <= mem_to_reg_in;
        // mem_write_out <= mem_write_in;
        // mem_read_out <= mem_read_in;
        // lui_out <= lui_in;
        // auipc_out <= auipc_in;
        // jal_out <= jal_in;
        // jalr_out <= jalr_in;
        // ecall_out <= ecall_in;
        load_temp_out <= 1'b0;
        plus1_out <= 1'b0;
    end
end

endmodule
