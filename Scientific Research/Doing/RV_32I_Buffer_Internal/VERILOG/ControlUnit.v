module ControlUnit(
    input [6:0] opcode,
    input [2:0] funct3,
    output reg branch,
    output reg mem_read,
    output reg mem_to_reg,
    output reg [2:0] alu_op,
    output reg mem_write,
    output reg alu_src,
    output reg reg_write,
    output reg jalr,          // Jump and Link Register
    output reg jal,           // Jump and Link
    output reg lui,       // Lui and auipc
    output reg auipc,
    output reg ecall,
    output reg plus1,
    output reg load_temp,

    output reg AES_W,
    output reg [1:0] key_size,
    output reg enable_AES
);
    always @(*) begin
        case (opcode)
            7'b0110011: begin // R-type (add, sub, and, or, slt...)
                alu_op = 3'b000;
                branch = 0;
                mem_read = 0;
                mem_to_reg = 0;
                mem_write = 0;
                alu_src = 1;
                reg_write = 1;
                jalr = 0;
                jal = 0;
                ecall = 0;
				load_temp = 0;
            plus1 = 0;
            AES_W = 0;
            key_size = 2'd0;
            enable_AES = 0;
            
            end
            7'b0010011: begin // I-type (addi, ori, andi...)
                alu_op = 3'b001;
                branch = 0;
                mem_read = 0;
                mem_to_reg = 0;
                mem_write = 0;
                alu_src = 0;
                reg_write = 1;
                jalr = 0;
                jal = 0;
                lui = 0; 
                auipc = 0;
                ecall = 0;
				load_temp = 0;
            plus1 = 0;
            AES_W = 0;
            key_size = 2'd0;
            enable_AES = 0;
            
            end
            7'b0000011: begin // Load (lb, lh, lw, lbu, lhu...)
                alu_op = 3'b010;
                branch = 0;
                mem_read = 1;
                mem_to_reg = 1;
                mem_write = 0;
                alu_src = 0;
                reg_write = 1;
                jalr = 0;
                jal = 0;
                lui = 0; 
                auipc = 0;
                ecall = 0;
				load_temp = 0;
                plus1 = 0;
                AES_W = 0;
                key_size = 2'd0;
                enable_AES = 0;
            
            end
            7'b0100011: begin // Store (sb, sh, sw...)
                alu_op = 3'b010; // Ph�p c?ng nh? bth
                branch = 0;
                mem_read = 0;
                mem_to_reg = 0;
                mem_write = 1;
                alu_src = 1'b0;
                reg_write = 0;
                jalr = 0;
                jal = 0;
                lui = 0; 
                auipc = 0;
                ecall = 0;
				load_temp = 0;
                plus1 = 0;
                AES_W = 0;
                key_size = 2'd0;
                enable_AES = 0;
            
            end
            
            7'b1100011: begin // Branch (beq, bne, blt, bge...)
                alu_op = 3'b100;
                branch = 1;
                mem_read = 0;
                mem_to_reg = 0;
                mem_write = 0;
                alu_src = 1;
                reg_write = 0;
                jalr = 0;
                jal = 0;
                lui = 0; 
                auipc = 0;
                ecall = 0;
				load_temp = 0;
                plus1 = 0;
                AES_W = 0;
                key_size = 2'd0;
                enable_AES = 0;
            
            end

            7'b1101111: begin // JAL (Jump and Link)
                alu_op = 3'b000;
                branch = 0;
                mem_read = 0;
                mem_to_reg = 0;
                mem_write = 0;
                alu_src = 0;
                reg_write = 1;
                jalr = 0;
                jal = 1;
                lui = 0; 
                auipc = 0;                
                ecall = 0;
				load_temp = 0;
                plus1 = 0;
                AES_W = 0;
                key_size = 2'd0;
                enable_AES = 0;
           
            end

            7'b1100111: begin // JALR (Jump and Link Register)
                alu_op = 3'b000;   // Th?c hi?n ph�p c?ng v� PC = rs1 + imm
                branch = 0;
                mem_read = 0;
                mem_to_reg = 0;
                mem_write = 0;
                alu_src = 0;
                reg_write = 1;
                jalr = 1;
                jal = 0;
                lui = 0; 
                auipc = 0;
                ecall = 0;
				load_temp = 0;
                plus1 = 0;
                AES_W = 0;
                key_size = 2'd0;
                enable_AES = 0;
                
            end

             7'b0110111 : begin // U Type - lui
                 alu_op = 3'b000;
                 branch = 0;
                 mem_read = 0;
                 mem_to_reg = 0;
                 mem_write = 0;
                 alu_src = 0;
                 reg_write = 1;
                 jalr = 0;
                 jal = 0;
                 lui = 1; 
                 auipc = 0;
                 ecall = 0;
				 load_temp = 0;
                plus1 = 0;
                AES_W = 0;
                key_size = 2'd0;
                enable_AES = 0;
            
             end
             7'b0010111 : begin // U Type - auipc
                 alu_op = 3'b000;
                 branch = 0;
                 mem_read = 0;
                 mem_to_reg = 0;
                 mem_write = 0;
                 alu_src = 0;
                 reg_write = 1;
                 jalr = 0;
                 jal = 0;
                 lui = 0;
                 auipc = 1;
                 ecall = 0;
				 load_temp = 0;
                plus1 = 0;
                AES_W = 0;
                key_size = 2'd0;
                enable_AES = 0;
            
             end
            7'b1110011 : begin
                 alu_op = 3'b000;
                 branch = 0;
                 mem_read = 0;
                 mem_to_reg = 0;
                 mem_write = 0;
                 alu_src = 0;
                 reg_write = 0;
                 jalr = 0;
                 jal = 0;
                 lui = 0;
                 auipc = 0;
                 ecall = 1;
				 load_temp = 0;
                plus1 = 0;
                AES_W = 0;
                key_size = 2'd0;
                enable_AES = 0;
            
            end
            
    7'b0101011: begin // ??�y l� custom buffer
    case (funct3)
        3'b000: begin
            alu_op = 3'b000;
            branch = 0;
            mem_read = 0;
            mem_to_reg = 0;
            mem_write = 0;
            alu_src = 0;
            reg_write = 0;
            jalr = 0;
            jal = 0;
            lui = 0;
            auipc = 0;
            ecall = 0;
            load_temp = 1;
            plus1 = 0;
            AES_W = 0;
            key_size = 2'd0;
            enable_AES = 0;
            
        end

        3'b001: begin
            alu_op = 3'b000;
            branch = 0;
            mem_read = 0;
            mem_to_reg = 0;
            mem_write = 0;
            alu_src = 0;
            reg_write = 0;
            jalr = 0;
            jal = 0;
            lui = 0;
            auipc = 0;
            ecall = 0;
            load_temp = 0;
            plus1 = 1;
            AES_W = 0;
            key_size = 2'd0;
            enable_AES = 0;
            
        end

        3'b010: begin // funct3 = 2 // d�ng ?? t�nh aes 128
            alu_op = 3'b000;
            branch = 0;
            mem_read = 0;
            mem_to_reg = 0;
            mem_write = 0;
            alu_src = 0;
            reg_write = 0;
            jalr = 0;
            jal = 0;
            lui = 0;
            auipc = 0;
            ecall = 0;
            load_temp = 0;
            plus1 = 0;
            AES_W = 1;
            key_size = 2'd0;
            enable_AES = 0;

        end

        3'b011: begin // funct3 = 3 // d�ng ?? t�nh aes 192
            alu_op = 3'b000;
            branch = 0;
            mem_read = 0;
            mem_to_reg = 0;
            mem_write = 0;
            alu_src = 0;
            reg_write = 0;
            jalr = 0;
            jal = 0;
            lui = 0;
            auipc = 0;
            ecall = 0;
            load_temp = 0;
            plus1 = 0;
            AES_W = 1;
            key_size = 2'd1;
            enable_AES = 0;

        end

        3'b100: begin // funct3 = 4 // d�ng ?? t�nh aes 256
            alu_op = 3'b000;
            branch = 0;
            mem_read = 0;
            mem_to_reg = 0;
            mem_write = 0;
            alu_src = 0;
            reg_write = 0;
            jalr = 0;
            jal = 0;
            lui = 0;
            auipc = 0;
            ecall = 0;
            load_temp = 0;
            plus1 = 0;
            AES_W = 1;
            key_size = 2'd2;
            enable_AES = 0;            
        end

        3'b101: begin // funct3 = 5 // d�ng ?? t�nh enable t�nh AES
            alu_op = 3'b000;
            branch = 0;
            mem_read = 0;
            mem_to_reg = 0;
            mem_write = 0;
            alu_src = 0;
            reg_write = 0;
            jalr = 0;
            jal = 0;
            lui = 0;
            auipc = 0;
            ecall = 0;
            load_temp = 0;
            plus1 = 0;
            AES_W = 0;
            key_size = key_size;
            enable_AES = 1;
        end


        default: begin
            alu_op = 3'b000;
            branch = 0;
            mem_read = 0;
            mem_to_reg = 0;
            mem_write = 0;
            alu_src = 0;
            reg_write = 0;
            jalr = 0;
            jal = 0;
            lui = 0;
            auipc = 0;
            ecall = 0;
            load_temp = 0;
            plus1 = 0;
            AES_W = 0;
            key_size = 2'd0;
            enable_AES = 0;
        end
    endcase
end
        
            default: begin
                 alu_op = 3'b000;
                 branch = 0;
                 mem_read = 0;
                 mem_to_reg = 0;
                 mem_write = 0;
                 alu_src = 0;
                 reg_write = 0;
                 jalr = 0;
                 jal = 0;
                 lui = 0;
                 auipc = 0;
                 ecall = 0;
				 load_temp = 0;
            plus1 = 0;
            AES_W = 0;
            key_size = 2'd0;
            enable_AES = 0;
            end
        endcase
    end
endmodule
