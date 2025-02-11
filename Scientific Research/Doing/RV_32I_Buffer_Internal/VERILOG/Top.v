module RISC_Top(
    input clk,
    input reset,
    input start_in,
    
	input [31:0] DMAD_addr_in,
	input [31:0] DMAD_data_in,
	input [7:0] DMAD_wea_in,

    input [31:0] DMAI_addr_in,
	input [31:0] DMAI_data_in,
	input [7:0] DMAI_wea_in,
	output state_done

    // output [31:0] inst_out
);

wire state_start;
wire [31:0] pc_nextt, pc, pc_next, pc_next1, pc_next2, pc_next3;
wire [31:0]  pc1, pc2, pc3, rd12, rd22, result_u, u_type, u_type3, u_type4;
wire [31:0] inst, inst1, inst2, inst3, inst4;
wire [4:0] alu_ctrl1, alu_ctrl2;
wire [2:0] alu_op, alu_op1;
wire lui, auipc, jal, jalr, mem_write, mem_read, alu_src, branch, mem_to_reg, reg_write; 
wire lui1, auipc1, jal1, jalr1, mem_write1, mem_read1, alu_src1, branch1, mem_to_reg1, reg_write1; 
wire lui2, auipc2, jal2, jalr2, mem_write2, mem_read2, alu_src2, branch2, mem_to_reg2, reg_write2; 
wire lui3, auipc3, jal3, jalr3, mem_write3, mem_read3, branch3, mem_to_reg3, reg_write3;
wire lui4, auipc4, mem_to_reg4;
wire reg_write4;

wire [31:0] rd1, rd2, rd11, rd23, rd_data, rd33;
wire [31:0] imm1, imm2;
wire [31:0] pc_imm, pc_imm3, pc_branch;
wire [31:0] result,result_load, result_load4, result_load5, result_load7;
wire signed [31:0] result1, result_load3, result2,result3;
wire [31:0] j_type, j_type4;
wire ecall, ecall1, ecall2, ecall3;
// ena_ins, wea;

wire [31:0] alo,data_ins, addr_ins, data_ins_d, addr_ins_d;
wire [7:0] we_ins, we_ins_d;
wire en_o_risc, en_o_risc_d;


// signal of custom Buffer 
wire [31:0] w1, w2, w3, w4, w5, w6, w7, w8, w22, w23;
wire load_temp, plus1, plus12, plus13;
wire load_temp1, plus11;
wire [31:0] out0, out1, out2, out3, out4, out5, out6, out7, out8, out9,
            out10, out11, out12, out13, out14, out15, out16, out17, out18, out19,
            out20, out21, out22, out23, out24, out25, out26, out27, out28, out29,
            out30, out31, out32, out33, out34, out35, out36, out37, out38, out39,
            out40, out41, out42, out43, out44, out45, out46, out47, out48, out49,
            out50, out51, out52, out53, out54, out55, out56, out57, out58, out59,
            out60, out61, out62, out63, out64, out65, out66, out67, out68, out69,
            out70, out71, out72, out73, out74, out75, out76, out77, out78, out79,
            out80, out81, out82, out83, out84, out85, out86, out87, out88, out89,
            out90, out91, out92, out93, out94, out95, out96, out97, out98, out99,
            out100, out101, out102, out103, out104, out105, out106, out107, out108, out109,
            out110, out111, out112, out113, out114, out115, out116, out117, out118, out119,
            out120, out121, out122, out123, out124, out125, out126, out127;

wire AES_W,enable_AES;
wire [1:0] key_size, key_size2, key_size3;
wire AES_W2,enable_AES2;
wire AES_W3,enable_AES3;

// AES signal involve
wire [31:0] data_aes,addr_aes;
wire en_w_datamem; // tín hiệu này xor với en_w của datameme
wire done_aes_w;
wire done_AES;
wire [127:0] result_AES;

    PC PC(
        .clk(clk),
        .reset(reset),
        .pc_in(pc_nextt),
        .start(state_start),
        .ecall_detected(ecall3),
        .pc_ecall(pc3),

        .pc_out(pc)
        // .ena_ins(ena_ins),
        // .wea(wea)
    );

    PC_plus4 PC_plus4(
        .pc_in(pc),
        .pc_out(pc_next)
    );

    Reg1 Re1(
    .clk(clk),
    .reset(reset),
    .pc_plus4_in(pc_next),
    .pc_in(pc),
    .start(state_start),
    // .inst_in(inst),
    // .reg_write_in(reg_write),
    // .alu_op_in(alu_op),
    // .alu_src_in(alu_src),
    // .branch_in(branch),
    // .mem_to_reg_in(mem_to_reg),
    // .mem_write_in(mem_write),
    // .mem_read_in(mem_read),
    // .lui_in(lui),
    // .auipc_in(auipc),
    // .jal_in(jal),
    // .jalr_in(jalr),
    // .ecall_in(ecall),
     .load_temp_in(load_temp),
    .plus1_in(plus1),


    // Outputs
    // .lui_out(lui1),
    // .auipc_out(auipc1),
    // .jal_out(jal1),
    // .jalr_out(jalr1),
    // .mem_write_out(mem_write1),
    // .mem_read_out(mem_read1),
    // .alu_op_out(alu_op1),
    // .alu_src_out(alu_src1),
    // .branch_out(branch1),
    // .mem_to_reg_out(mem_to_reg1),
    // .reg_write_out(reg_write1),
    // .inst_out(inst1),
    // .ecall_out(ecall1)
    .pc_plus4_out(pc_next1),
    .pc_out(pc1),
    .load_temp_out(load_temp1),
    .plus1_out(plus11)

    );

Reg2 Re2 (
    .clk(clk),
    .reset(reset),
    .start(state_start),
    .lui_in(lui),
    .auipc_in(auipc),
    .jal_in(jal),
    .jalr_in(jalr),
    .mem_write_in(mem_write),
    .mem_read_in(mem_read),
    .alu_ctrl_in(alu_ctrl1),
    .alu_src_in(alu_src),
    .branch_in(branch),
    .mem_to_reg_in(mem_to_reg),
    .reg_write_in(reg_write),
    .inst_in(inst),
    .pc_plus4_in(pc_next1),
    .pc_in(pc1),
    .rd1_in(rd1),
    .rd2_in(rd2),
    .imm1_in(imm1),
    .ecall_in(ecall),
    .AES_W_in(AES_W),
    .key_size_in(key_size),
    .enable_AES_in(enable_AES),
    .re_adder_32_in(w3),
    .w2_in(w2),
    .plus1_in(plus1),
    

    // Outputs
    .lui_out(lui2),
    .auipc_out(auipc2),
    .jal_out(jal2),
    .jalr_out(jalr2),
    .mem_write_out(mem_write2),
    .mem_read_out(mem_read2),
    .alu_ctrl_out(alu_ctrl2),
    .alu_src_out(alu_src2),
    .branch_out(branch2),
    .mem_to_reg_out(mem_to_reg2),
    .reg_write_out(reg_write2),
    .inst_out(inst2),
    .pc_plus4_out(pc_next2),
    .pc_out(pc2),
    .rd1_out(rd12),
    .rd2_out(rd22),
    .imm1_out(imm2),
    .ecall_out(ecall2),
    .AES_W_out(AES_W2),
    .key_size_out(key_size2),
    .re_adder_32_out(w4),
    .w2_out(w22),
    .plus1_out(plus12),
    .enable_AES_out(enable_AES2)
);

    Reg3 Re3(
    .clk(clk),
    .reset(reset),
    .start(state_start),
    .lui_in(lui2),
    .auipc_in(auipc2),
    .jal_in(jal2),
    .jalr_in(jalr2),
    .mem_write_in(mem_write2),
    .mem_read_in(mem_read2), 
    .branch_in(branch2),
    .mem_to_reg_in(mem_to_reg2),
    .reg_write_in(reg_write2),
    .inst_in(inst2),
    .pc_plus4_in(pc_next2),
    .pc_imm_in(pc_imm),
    .result_in(w5),
    .rd23_in(rd22),
    .u_type_in(u_type),
    .ecall_in(ecall2),
    .pc_in(pc2),//
    .AES_W_in(AES_W2),
    .key_size_in(key_size2),
    .enable_AES_in(enable_AES2),
    .w3_in(w22),
    .plus1_in(plus12),

    // Outputs
    .lui_out(lui3),
    .auipc_out(auipc3),
    .jal_out(jal3),
    .jalr_out(jalr3),
    .mem_write_out(mem_write3),
    .mem_read_out(mem_read3),

    .branch_out(branch3),
    .mem_to_reg_out(mem_to_reg3),
    .reg_write_out(reg_write3),
    .inst_out(inst3),
    .pc_plus4_out(pc_next3),
    .pc_imm_out(pc_imm3), 
    .result_out(w6),
    .rd23_out(rd23),
    .u_type_out(u_type3),
    .ecall_out(ecall3),
    .pc_out(pc3),
    .AES_W_out(AES_W3),
    .key_size_out(key_size3),
    .enable_AES_out(enable_AES3),
    .w3_out(w23),
    .plus1_out(plus13)   
    );

    Reg4 Re4(
    .clk(clk),
    .reset(reset),
    .start(state_start),
    .lui_in(lui3),
    .auipc_in(auipc3),
    .mem_to_reg_in(mem_to_reg3),
    .reg_write_in(reg_write3),
    .inst_in(inst3),
    
    // .result_load_in(alo),

    .j_type_in(j_type),
    .u_type_in(u_type3),

    // Outputs
    .lui_out(lui4),
    .auipc_out(auipc4),
    .mem_to_reg_out(mem_to_reg4),
    .reg_write_out(reg_write4),
    .inst_out(inst4),

    // .result_load_out(result_load_out),

    .j_type_out(j_type4),
    .u_type_out(u_type4)
    );

//InstructionMemory Ins_Mem(
//    .addr(pc),

//    .inst_out(alo)
//);

ControlUnit CU(

    .opcode(inst[6:0]),
    .funct3(inst[14:12]),
    
    // Output
    .branch(branch),
    .mem_read(mem_read),
    .mem_to_reg(mem_to_reg),
    .alu_op(alu_op),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .reg_write(reg_write),
    .jalr(jalr),
    .jal(jal),
    .lui(lui),
    .auipc(auipc),
    .ecall(ecall),
    .plus1(plus1),
    .load_temp(load_temp),

    .AES_W(AES_W),
    .key_size(key_size),
    .enable_AES(enable_AES)
    
);

ALUControl ALU_CU(

    .funct3(inst[14:12]),
    .funct7(inst[31:25]),
    .alu_op(alu_op),

    .alu_ctrl(alu_ctrl1)
);

Registers_file RF(
    .clk(clk),
    .reset(reset),
    .start(state_start),
    .reg_write(reg_write4),            ///
    .rs1_addr(inst[19:15]),
    .rs2_addr(inst[24:20]),
    .rd_addr(inst4[11:7]), 

    .rd_data(rd_data),
    .rs1_data(rd1),
    .rs2_data(rd2),
    .rss(w1)
    );

ImmediateGenerator Imm_Gen(
    .inst_in(inst),
    .imm_out(imm1)
);
    
MUX2to1_ALU MUX_ALU(

    .a(rd22),
    .b(imm2),
    .sel(alu_src2),

    .c(rd11)
);

Adder Adder(
    .a(pc2),
    .b(imm2),

    .c(pc_imm)
);

ALU ALU(
    .a(rd12),
    .b(rd11),
    .alu_ctrl(alu_ctrl2),
    .result(result)
);

Mux_U1 Mux_U1(
    
   .a(result),
   .b(pc2),
   .sel(lui2),

   .c(result_u)
);

Adder_U Adder_U(
   .a(imm2),
   .b(result_u),
    
   .c(u_type)
);

Mux_J1 Mux_J1(
    .a(w6),
    .b(pc_imm3),
    .sel(jalr3),
    
    .c(pc_branch)
);

MUX2to1_PC MUX_PC(
    .a(pc_next3),
    .b(pc_branch),
    .sel1(w6),
    .sel2(branch3),
    .jal(jal3),
    .jalr(jalr3),

    .c(pc_nextt)
);

// DataMemory Data_Mem(
//    .clk(clk),
//    .reset(reset),
//    .mem_write(mem_write3),
//    .mem_read(mem_read3),
//    .addr(result1>>>2),
//    .sel(result1[31:28]),
//    .write_data(rd23),
//    .funct3(inst3[14:12]),
//    .res(res),

//    .done_AES(done_AES),
//    .AES_result(result_AES),
//    .enable_AES(enable_AES),

//    .AES_input0(AES_input0),
//    .AES_input1(AES_input1),
//    .AES_input2(AES_input2),
//    .AES_input3(AES_input3),
//    .AES_input4(AES_input4),
//    .AES_input5(AES_input5),
//    .AES_input6(AES_input6),
//    .AES_input7(AES_input7),

    
//    .read_data(alo)
// );

// data_mem data_mem(
//     .clka(clk),
//     .addra(DMAD_addr_in>>2),
//     .dina(DMAD_data_in),
//     .douta(result_load5),  // khai báo
//     .ena(1'b1),
//     .wea(DMAD_wea_in),

//     .clkb(clk),
//     .addrb(w7[12:0]>>2),
//     .dinb(rd33),
//     .doutb(result_load4),
//     // .ena(mem_write3|mem_read3),
//     .enb((mem_read3|plus13)|mem_write3|en_w_datamem),
//     .web(mem_write3|en_w_datamem)

//     );

data_mem data_mem(
    .clka(clk),
    .addra(addr_ins_d[12:0]>>2),
    .dina(data_ins_d),
    .douta(result_load4),
    .ena(en_o_risc_d),
    .wea(we_ins_d[0:0])
    
);

mux_data_mem mux_data_mem(
    .ins_addr_nap(DMAD_addr_in),
    .ins_addr_risc(w7),
    .ins_data_nap(DMAD_data_in),
    .ins_data_risc(rd33),
    .we_cpu(DMAD_wea_in[0:0]),
    .we_risc(mem_write3|en_w_datamem),
    .en_risc((mem_read3|plus13)|mem_write3|en_w_datamem),

    .sel(state_start),
    
    .addr_ins(addr_ins_d),
    .data_ins(data_ins_d),
    .we_ins(we_ins_d[0:0]),
    .en_o_risc(en_o_risc_d)
);








// ins_mem ins_mem(
//     .clka(clk),
//     .addra(DMAI_addr_in>>2),
//     .dina(DMAI_data_in),
//     .douta(result_load7),  // khai báo
//     .ena(1'b1),
//     .wea(DMAI_wea_in),

// //////////////
//     .clkb(clk),
//     .addrb(pc[12:0]>>2),
//     .dinb(32'b0),
    
//     // .ena(mem_write3|mem_read3),
//     .enb(1'b1),
//     .web(1'd0),

//     .doutb(inst)
//     );

mux_ins_rom mux_ins_rom(
    .ins_addr_nap(DMAI_addr_in>>2),
    .ins_addr_risc(pc>>2),
    .ins_data_nap(DMAI_data_in),
    .ins_data_risc(32'b0),
    .we_cpu(DMAI_wea_in[0:0]),
    .we_risc(1'd0),
    .en_risc(mem_write3|mem_read3),

    .sel(state_start),

    .addr_ins(addr_ins),
    .data_ins(data_ins),
    .we_ins(we_ins[0:0]),
    .en_o_risc(en_o_risc)
);

ins_mem ins_mem(
    .clka(clk),
    .addra(addr_ins[12:0]),
    .dina(data_ins),
    .douta(inst),
    .ena(en_o_risc),
    .wea(we_ins[0:0])
    
);


Mux_J2 Mux_J2(
    .a(pc_next3),
    .b(w6),
    .sel1(jal3),
    .sel2(jalr3),

    .c(j_type)
);

MUX2to1_WB MUX_WB(
    .a(result_load4),
    .b(j_type4),
    .sel(mem_to_reg4),

    .c(result_load)
);

Mux_U2 Mux_U2(
    .a(u_type4),
    .b(result_load),
    .sel1(lui4),
    .sel2(auipc4),

    .c(rd_data)

);



// AES_Match AES(
//         .clk(clk),
//         .reset(reset),
//         .enable_AES(enable_AES),
//         .buffer_wire_0(AES_input0),
//         .buffer_wire_1(AES_input1),
//         .buffer_wire_2(AES_input2),
//         .buffer_wire_3(AES_input3),
//         .buffer_wire_4(AES_input4),
//         .buffer_wire_5(AES_input5),
//         .buffer_wire_6(AES_input6),
//         .buffer_wire_7(AES_input7),
//         .ciphertext(result_AES),
//         .done_AES(done_AES)

// );


counter_offset counter_offset(
    .clk(clk),
    .reset(reset),
    .plus_1(plus1),
    .load_temp(load_temp),
    .temp_reg(w1),
    .count(w2)
    );

adder_32bit adder_32bit(
    .A(w1),
    .B(w2),
    .S(w3)
    );      
  

Mux_Buffer Mux_Buffer(
    .a(result),
    .b(w4<<2),
    .sel(plus1),

    // output
    // .c(result2), // chua biet
    .c(w5)
);

buffer buffer(
   .address(w8[6:0]),
   .data(result_load4),
   .reset(reset),
   .en_write(plus13),
   .clk(clk),
   .en_read(1'b1),
    
   .out0(out0),
   .out1(out1),
   .out2(out2),
   .out3(out3),
   .out4(out4),
   .out5(out5),
   .out6(out6),
   .out7(out7),
   .out8(out8),
   .out9(out9),
   .out10(out10),
   .out11(out11),
   .out12(out12),
   .out13(out13),
   .out14(out14),
   .out15(out15),
   .out16(out16),
   .out17(out17),
   .out18(out18),
   .out19(out19),
   .out20(out20),
   .out21(out21),
   .out22(out22),
   .out23(out23),
   .out24(out24),
   .out25(out25),
   .out26(out26),
   .out27(out27),
   .out28(out28),
   .out29(out29),
   .out30(out30),
   .out31(out31),
   .out32(out32),
   .out33(out33),
   .out34(out34),
   .out35(out35),
   .out36(out36),
   .out37(out37),
   .out38(out38),
   .out39(out39),
   .out40(out40),
   .out41(out41),
   .out42(out42),
   .out43(out43),
   .out44(out44),
   .out45(out45),
   .out46(out46),
   .out47(out47),
   .out48(out48),
   .out49(out49),
   .out50(out50),
   .out51(out51),
   .out52(out52),
   .out53(out53),
   .out54(out54),
   .out55(out55),
   .out56(out56),
   .out57(out57),
   .out58(out58),
   .out59(out59),
   .out60(out60),
   .out61(out61),
   .out62(out62),
   .out63(out63),
   .out64(out64),
   .out65(out65),
   .out66(out66),
   .out67(out67),
   .out68(out68),
   .out69(out69),
   .out70(out70),
   .out71(out71),
   .out72(out72),
   .out73(out73),
   .out74(out74),
   .out75(out75),
   .out76(out76),
   .out77(out77),
   .out78(out78),
   .out79(out79),
   .out80(out80),
   .out81(out81),
   .out82(out82),
   .out83(out83),
   .out84(out84),
   .out85(out85),
   .out86(out86),
   .out87(out87),
   .out88(out88),
   .out89(out89),
   .out90(out90),
   .out91(out91),
   .out92(out92),
   .out93(out93),
   .out94(out94),
   .out95(out95),
   .out96(out96),
   .out97(out97),
   .out98(out98),
   .out99(out99),
   .out100(out100),
   .out101(out101),
   .out102(out102),
   .out103(out103),
   .out104(out104),
   .out105(out105),
   .out106(out106),
   .out107(out107),
   .out108(out108),
   .out109(out109),
   .out110(out110),
   .out111(out111),
   .out112(out112),
   .out113(out113),
   .out114(out114),
   .out115(out115),
   .out116(out116),
   .out117(out117),
   .out118(out118),
   .out119(out119),
   .out120(out120),
   .out121(out121),
   .out122(out122),
   .out123(out123),
   .out124(out124),
   .out125(out125),
   .out126(out126),
   .out127(out127)

);

Buffer32 Buffer32(
    .clk(clk),
    .reset(reset),
    .start(state_start),
    .in_data(w23),
    .out_data(w8)
);

keyExpansion keyExpansion(
    .clk(clk),
    .reset(reset),
    .enable_AES(enable_AES3),
    .AES_W(AES_W3),
    .key_size(key_size3),
    .plaint1(out0),
    .plaint2(out1),
    .plaint3(out2),
    .plaint4(out3),
    .key0(out4),
    .key1(out5),
    .key2(out6),
    .key3(out7),
    .key4(out8),
    .key5(out9),
    .key6(out10),
    .key7(out11),

    .result(result_AES),
    .done_aes_r(done_aes_w)
    // còn thiếu mấy tín hiệu đang ch�? bổ sung
    );

wr_b2data wr_b2data(
    .clk(clk),
    .reset(reset),
    .result_AES_in(result_AES),
    .enable_wb(done_aes_w),
    // Output
    .en_w_datamem(en_w_datamem),
    .data_aes(data_aes),
    .addr_aes(addr_aes)
    
);

// ADDR
MUX_AES1 MUX_AES1( 
    .a(w6),
    .b(addr_aes),
    .sel(en_w_datamem),
    .c(w7)
);

MUX_AES2 MUX_AES2(
    .a(rd23),
    .b(data_aes),
    .sel(en_w_datamem),
    .c(rd33)
);

state_control state_control(
    .clk(clk),
    .rst(reset),
    .start_in(start_in),
    .done_flag(inst4), // lấy từ ins của reg 4

    .state_start(state_start),// map vào các thanh ghi và 2 mux bram
    .state_done(state_done) // này map vào test bench 
);


endmodule
