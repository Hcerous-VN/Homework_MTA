module AES_Match(
    // input [127:0] input_key,   // �?ầu vào 128-bit
    // input [127:0] input_plaintxt,
    input wire [31:0] buffer_wire_0,  // Plaintext phần 1
    input wire [31:0] buffer_wire_1,  // Plaintext phần 2
    input wire [31:0] buffer_wire_2,  // Plaintext phần 3
    input wire [31:0] buffer_wire_3,  // Plaintext phần 4

    input wire [31:0] buffer_wire_4,  // Key expansion w[0]
    input wire [31:0] buffer_wire_5,  // Key expansion w[1]
    input wire [31:0] buffer_wire_6,  // Key expansion w[2]
    input wire [31:0] buffer_wire_7,  // Key expansion w[3]

    input clk,
    input reset,
    input [31:0] enable_AES,

    output reg [127:0] ciphertext,
    output reg done_AES            // Tín hiệu báo hiệu hoàn tất
);
    // �?ịnh nghĩa mảng round_keys bên trong mô-đun, không phải là cổng
    // Variable of Key Expansion
    reg [127:0] round_keys [0:10];
    integer i;
    reg [7:0] sbox [0:255];
    reg done_ex;
    reg [2:0] fsm;
    reg [3:0] round_index; // Biến đếm để theo dõi vòng hiện tại

    // variable of AES 
    reg [127:0] state;
    reg [127:0] result;  // Biến tạm để lưu kết quả khi done
    reg [3:0] round;     // Vòng lặp hiện tại (0 đến 10)
    reg [127:0] round_key;
    reg [127:0] final_key;

    wire [127:0] initial_state; // Kết quả AddRoundKey ban đầu
    wire [127:0] input_key;
    wire [127:0] input_plaintxt;


    // Viết thêm tín hiệu done Key_expansion thì cho tính AES  

    initial begin
    sbox[8'h00] = 8'h63; sbox[8'h01] = 8'h7c; sbox[8'h02] = 8'h77; sbox[8'h03] = 8'h7b;
    sbox[8'h04] = 8'hf2; sbox[8'h05] = 8'h6b; sbox[8'h06] = 8'h6f; sbox[8'h07] = 8'hc5;
    sbox[8'h08] = 8'h30; sbox[8'h09] = 8'h01; sbox[8'h0a] = 8'h67; sbox[8'h0b] = 8'h2b;
    sbox[8'h0c] = 8'hfe; sbox[8'h0d] = 8'hd7; sbox[8'h0e] = 8'hab; sbox[8'h0f] = 8'h76;
    sbox[8'h10] = 8'hca; sbox[8'h11] = 8'h82; sbox[8'h12] = 8'hc9; sbox[8'h13] = 8'h7d;
    sbox[8'h14] = 8'hfa; sbox[8'h15] = 8'h59; sbox[8'h16] = 8'h47; sbox[8'h17] = 8'hf0;
    sbox[8'h18] = 8'had; sbox[8'h19] = 8'hd4; sbox[8'h1a] = 8'ha2; sbox[8'h1b] = 8'haf;
    sbox[8'h1c] = 8'h9c; sbox[8'h1d] = 8'ha4; sbox[8'h1e] = 8'h72; sbox[8'h1f] = 8'hc0;
    sbox[8'h20] = 8'hb7; sbox[8'h21] = 8'hfd; sbox[8'h22] = 8'h93; sbox[8'h23] = 8'h26;
    sbox[8'h24] = 8'h36; sbox[8'h25] = 8'h3f; sbox[8'h26] = 8'hf7; sbox[8'h27] = 8'hcc;
    sbox[8'h28] = 8'h34; sbox[8'h29] = 8'ha5; sbox[8'h2a] = 8'he5; sbox[8'h2b] = 8'hf1;
    sbox[8'h2c] = 8'h71; sbox[8'h2d] = 8'hd8; sbox[8'h2e] = 8'h31; sbox[8'h2f] = 8'h15;
    sbox[8'h30] = 8'h04; sbox[8'h31] = 8'hc7; sbox[8'h32] = 8'h23; sbox[8'h33] = 8'hc3;
    sbox[8'h34] = 8'h18; sbox[8'h35] = 8'h96; sbox[8'h36] = 8'h05; sbox[8'h37] = 8'h9a;
    sbox[8'h38] = 8'h07; sbox[8'h39] = 8'h12; sbox[8'h3a] = 8'h80; sbox[8'h3b] = 8'he2;
    sbox[8'h3c] = 8'heb; sbox[8'h3d] = 8'h27; sbox[8'h3e] = 8'hb2; sbox[8'h3f] = 8'h75;
    sbox[8'h40] = 8'h09; sbox[8'h41] = 8'h83; sbox[8'h42] = 8'h2c; sbox[8'h43] = 8'h1a;
    sbox[8'h44] = 8'h1b; sbox[8'h45] = 8'h6e; sbox[8'h46] = 8'h5a; sbox[8'h47] = 8'ha0;
    sbox[8'h48] = 8'h52; sbox[8'h49] = 8'h3b; sbox[8'h4a] = 8'hd6; sbox[8'h4b] = 8'hb3;
    sbox[8'h4c] = 8'h29; sbox[8'h4d] = 8'he3; sbox[8'h4e] = 8'h2f; sbox[8'h4f] = 8'h84;
    sbox[8'h50] = 8'h53; sbox[8'h51] = 8'hd1; sbox[8'h52] = 8'h00; sbox[8'h53] = 8'hed;
    sbox[8'h54] = 8'h20; sbox[8'h55] = 8'hfc; sbox[8'h56] = 8'hb1; sbox[8'h57] = 8'h5b;
    sbox[8'h58] = 8'h6a; sbox[8'h59] = 8'hcb; sbox[8'h5a] = 8'hbe; sbox[8'h5b] = 8'h39;
    sbox[8'h5c] = 8'h4a; sbox[8'h5d] = 8'h4c; sbox[8'h5e] = 8'h58; sbox[8'h5f] = 8'hcf;
    sbox[8'h60] = 8'hd0; sbox[8'h61] = 8'hef; sbox[8'h62] = 8'haa; sbox[8'h63] = 8'hfb;
    sbox[8'h64] = 8'h43; sbox[8'h65] = 8'h4d; sbox[8'h66] = 8'h33; sbox[8'h67] = 8'h85;
    sbox[8'h68] = 8'h45; sbox[8'h69] = 8'hf9; sbox[8'h6a] = 8'h02; sbox[8'h6b] = 8'h7f;
    sbox[8'h6c] = 8'h50; sbox[8'h6d] = 8'h3c; sbox[8'h6e] = 8'h9f; sbox[8'h6f] = 8'ha8;
    sbox[8'h70] = 8'h51; sbox[8'h71] = 8'ha3; sbox[8'h72] = 8'h40; sbox[8'h73] = 8'h8f;
    sbox[8'h74] = 8'h92; sbox[8'h75] = 8'h9d; sbox[8'h76] = 8'h38; sbox[8'h77] = 8'hf5;
    sbox[8'h78] = 8'hbc; sbox[8'h79] = 8'hb6; sbox[8'h7a] = 8'hda; sbox[8'h7b] = 8'h21;
    sbox[8'h7c] = 8'h10; sbox[8'h7d] = 8'hff; sbox[8'h7e] = 8'hf3; sbox[8'h7f] = 8'hd2;
    sbox[8'h80] = 8'hcd; sbox[8'h81] = 8'h0c; sbox[8'h82] = 8'h13; sbox[8'h83] = 8'hec;
    sbox[8'h84] = 8'h5f; sbox[8'h85] = 8'h97; sbox[8'h86] = 8'h44; sbox[8'h87] = 8'h17;
    sbox[8'h88] = 8'hc4; sbox[8'h89] = 8'ha7; sbox[8'h8a] = 8'h7e; sbox[8'h8b] = 8'h3d;
    sbox[8'h8c] = 8'h64; sbox[8'h8d] = 8'h5d; sbox[8'h8e] = 8'h19; sbox[8'h8f] = 8'h73;
    sbox[8'h90] = 8'h60; sbox[8'h91] = 8'h81; sbox[8'h92] = 8'h4f; sbox[8'h93] = 8'hdc;
    sbox[8'h94] = 8'h22; sbox[8'h95] = 8'h2a; sbox[8'h96] = 8'h90; sbox[8'h97] = 8'h88;
    sbox[8'h98] = 8'h46; sbox[8'h99] = 8'hee; sbox[8'h9a] = 8'hb8; sbox[8'h9b] = 8'h14;
    sbox[8'h9c] = 8'hde; sbox[8'h9d] = 8'h5e; sbox[8'h9e] = 8'h0b; sbox[8'h9f] = 8'hdb;
    sbox[8'ha0] = 8'he0; sbox[8'ha1] = 8'h32; sbox[8'ha2] = 8'h3a; sbox[8'ha3] = 8'h0a;
    sbox[8'ha4] = 8'h49; sbox[8'ha5] = 8'h06; sbox[8'ha6] = 8'h24; sbox[8'ha7] = 8'h5c;
    sbox[8'ha8] = 8'hc2; sbox[8'ha9] = 8'hd3; sbox[8'haa] = 8'hac; sbox[8'hab] = 8'h62;
    sbox[8'hac] = 8'h91; sbox[8'had] = 8'h95; sbox[8'hae] = 8'he4; sbox[8'haf] = 8'h79;
    sbox[8'hb0] = 8'he7; sbox[8'hb1] = 8'hc8; sbox[8'hb2] = 8'h37; sbox[8'hb3] = 8'h6d;
    sbox[8'hb4] = 8'h8d; sbox[8'hb5] = 8'hd5; sbox[8'hb6] = 8'h4e; sbox[8'hb7] = 8'ha9;
    sbox[8'hb8] = 8'h6c; sbox[8'hb9] = 8'h56; sbox[8'hba] = 8'hf4; sbox[8'hbb] = 8'hea;
    sbox[8'hbc] = 8'h65; sbox[8'hbd] = 8'h7a; sbox[8'hbe] = 8'hae; sbox[8'hbf] = 8'h08;
    sbox[8'hc0] = 8'hba; sbox[8'hc1] = 8'h78; sbox[8'hc2] = 8'h25; sbox[8'hc3] = 8'h2e;
    sbox[8'hc4] = 8'h1c; sbox[8'hc5] = 8'ha6; sbox[8'hc6] = 8'hb4; sbox[8'hc7] = 8'hc6;
    sbox[8'hc8] = 8'he8; sbox[8'hc9] = 8'hdd; sbox[8'hca] = 8'h74; sbox[8'hcb] = 8'h1f;
    sbox[8'hcc] = 8'h4b; sbox[8'hcd] = 8'hbd; sbox[8'hce] = 8'h8b; sbox[8'hcf] = 8'h8a;
    sbox[8'hd0] = 8'h70; sbox[8'hd1] = 8'h3e; sbox[8'hd2] = 8'hb5; sbox[8'hd3] = 8'h66;
    sbox[8'hd4] = 8'h48; sbox[8'hd5] = 8'h03; sbox[8'hd6] = 8'hf6; sbox[8'hd7] = 8'h0e;
    sbox[8'hd8] = 8'h61; sbox[8'hd9] = 8'h35; sbox[8'hda] = 8'h57; sbox[8'hdb] = 8'hb9;
    sbox[8'hdc] = 8'h86; sbox[8'hdd] = 8'hc1; sbox[8'hde] = 8'h1d; sbox[8'hdf] = 8'h9e;
    sbox[8'he0] = 8'he1; sbox[8'he1] = 8'hf8; sbox[8'he2] = 8'h98; sbox[8'he3] = 8'h11;
    sbox[8'he4] = 8'h69; sbox[8'he5] = 8'hd9; sbox[8'he6] = 8'h8e; sbox[8'he7] = 8'h94;
    sbox[8'he8] = 8'h9b; sbox[8'he9] = 8'h1e; sbox[8'hea] = 8'h87; sbox[8'heb] = 8'he9;
    sbox[8'hec] = 8'hce; sbox[8'hed] = 8'h55; sbox[8'hee] = 8'h28; sbox[8'hef] = 8'hdf;
    sbox[8'hf0] = 8'h8c; sbox[8'hf1] = 8'ha1; sbox[8'hf2] = 8'h89; sbox[8'hf3] = 8'h0d;
    sbox[8'hf4] = 8'hbf; sbox[8'hf5] = 8'he6; sbox[8'hf6] = 8'h42; sbox[8'hf7] = 8'h68;
    sbox[8'hf8] = 8'h41; sbox[8'hf9] = 8'h99; sbox[8'hfa] = 8'h2d; sbox[8'hfb] = 8'h0f;
    sbox[8'hfc] = 8'hb0; sbox[8'hfd] = 8'h54; sbox[8'hfe] = 8'hbb; sbox[8'hff] = 8'h16;
end


    // Hàm phụ để thay thế từng byte bằng S-box
    function [7:0] SubByte;
        input [7:0] byte;
        begin
            SubByte = sbox[byte];
        end
    endfunction

    // Hàm Rcon trả v�? giá trị hằng số vòng cho một vòng cụ thể
    function [31:0] Rcon;
        input integer round;
        begin
            case (round)
                1: Rcon = 32'h01000000;
                2: Rcon = 32'h02000000;
                3: Rcon = 32'h04000000;
                4: Rcon = 32'h08000000;
                5: Rcon = 32'h10000000;
                6: Rcon = 32'h20000000;
                7: Rcon = 32'h40000000;
                8: Rcon = 32'h80000000;
                9: Rcon = 32'h1b000000;
                10: Rcon = 32'h36000000;
                default: Rcon = 32'h00000000;
            endcase
        end
    endfunction

    // Hàm mở rộng khóa (Key Expansion)
    function [127:0] KeyExpansion;
        input [127:0] prev_key;
        input integer round_num;
        reg [127:0] new_key;
        reg [31:0] temp;
        integer j;
        begin
            // RotWord: Xoay các byte của từ cuối cùng
            temp = {prev_key[23:0], prev_key[31:24]};

            // SubWord: Thay thế các byte trong temp bằng giá trị từ S-box
            for (j = 0; j < 4; j = j + 1) begin
                temp[8 * j +: 8] = SubByte(temp[8 * j +: 8]);
            end

            // Rcon: XOR temp với hằng số vòng
            temp = temp ^ Rcon(round_num);

            // Tính khóa mới
            new_key[127:96] = prev_key[127:96] ^ temp;
            new_key[95:64] = prev_key[95:64] ^ new_key[127:96];
            new_key[63:32] = prev_key[63:32] ^ new_key[95:64];
            new_key[31:0] = prev_key[31:0] ^ new_key[63:32];

            KeyExpansion = new_key;
        end
    endfunction

/////// AES _ 128 ///////

    assign input_plaintxt = {buffer_wire_0,buffer_wire_1,buffer_wire_2,buffer_wire_3};
    assign input_key = {buffer_wire_4,buffer_wire_5,buffer_wire_6,buffer_wire_7};

    assign initial_state = AddRoundKey(round_keys[0], input_plaintxt);

//     Hàm AddRoundKey: XOR với các khóa con
    function [127:0] AddRoundKey(input [127:0] state, input [127:0] round_key);
        AddRoundKey = state ^ round_key;
    endfunction

//     function [127:0] AddRoundKey(input [127:0] state_in, input [127:0] round_key);
//     integer i;
//     reg [127:0] result;
//     begin
//         for (i = 0; i < 16; i = i + 1) begin
//             // XOR từng byte và gán kết quả vào vị trí tương ứng
//             result[i*8 +: 8] = state_in[i*8 +: 8] ^ round_key[i*8 +: 8];
//         end
//         AddRoundKey = result;
//     end
// endfunction

    reg [127:0] Sub1;
    // Hàm SubBytes: Thay thế mỗi byte trong trạng thái bằng một giá trị từ S-box
    function [127:0] SubBytes(input [127:0] state_in);
        integer i;
        reg [127:0] state_out;
        begin
            for (i = 0; i < 16; i = i + 1) begin
                state_out[i*8 +: 8] = sbox[state_in[i*8 +: 8]];  // Tra cứu từ S-box
            end
            SubBytes = state_out;
        end
    endfunction

    // Hàm ShiftRows: Dịch vòng các hàng của trạng thái

// function [127:0] ShiftRows(input [127:0] state_in);
//     reg [127:0] state_out;
//     begin
//         // Row 1: No shift
//         state_out[127:120] = state_in[127:120];
//         state_out[95:88] = state_in[95:88];
//         state_out[63:56] = state_in[63:56];
//         state_out[31:24] = state_in[31:24];

//         // Row 2: Shift left by 1 byte
//         state_out[119:112] = state_in[87:80];
//         state_out[87:80] = state_in[55:48];
//         state_out[55:48] = state_in[23:16];
//         state_out[23:16] = state_in[119:112];

//         // Row 3: Shift left by 2 bytes
//         state_out[111:104] = state_in[47:40];
//         state_out[79:72] = state_in[15:8];
//         state_out[47:40] = state_in[111:104];
//         state_out[15:8] = state_in[79:72];

//         // Row 4: Shift left by 3 bytes
//         state_out[103:96] = state_in[39:32];
//         state_out[71:64] = state_in[7:0];
//         state_out[39:32] = state_in[103:96];
//         state_out[7:0] = state_in[71:64];

//         ShiftRows = state_out;
//     end
// endfunction

function [127:0] ShiftRows(input [127:0] state_in);
    reg [7:0] state_matrix [3:0][3:0];  // Ma trận 4x4 lưu các byte
    reg [7:0] state_out_matrix [3:0][3:0];  // Ma trận 4x4 sau khi ShiftRows
    integer i, j;
    begin
        // Bước 1: Sắp xếp các byte của state_in thành ma trận 4x4
        state_matrix[0][0] = state_in[127:120];
        state_matrix[1][0] = state_in[119:112];
        state_matrix[2][0] = state_in[111:104];
        state_matrix[3][0] = state_in[103:96];
        
        state_matrix[0][1] = state_in[95:88];
        state_matrix[1][1] = state_in[87:80];
        state_matrix[2][1] = state_in[79:72];
        state_matrix[3][1] = state_in[71:64];
        
        state_matrix[0][2] = state_in[63:56];
        state_matrix[1][2] = state_in[55:48];
        state_matrix[2][2] = state_in[47:40];
        state_matrix[3][2] = state_in[39:32];
        
        state_matrix[0][3] = state_in[31:24];
        state_matrix[1][3] = state_in[23:16];
        state_matrix[2][3] = state_in[15:8];
        state_matrix[3][3] = state_in[7:0];

        // Bước 2: Thực hiện ShiftRows trên từng hàng
        // Hàng 1: Không dịch
        for (j = 0; j < 4; j = j + 1) begin
            state_out_matrix[0][j] = state_matrix[0][j];
        end

        // Hàng 2: Dịch sang trái 1 byte
        state_out_matrix[1][0] = state_matrix[1][1];
        state_out_matrix[1][1] = state_matrix[1][2];
        state_out_matrix[1][2] = state_matrix[1][3];
        state_out_matrix[1][3] = state_matrix[1][0];

        // Hàng 3: Dịch sang trái 2 byte
        state_out_matrix[2][0] = state_matrix[2][2];
        state_out_matrix[2][1] = state_matrix[2][3];
        state_out_matrix[2][2] = state_matrix[2][0];
        state_out_matrix[2][3] = state_matrix[2][1];

        // Hàng 4: Dịch sang trái 3 byte
        state_out_matrix[3][0] = state_matrix[3][3];
        state_out_matrix[3][1] = state_matrix[3][0];
        state_out_matrix[3][2] = state_matrix[3][1];
        state_out_matrix[3][3] = state_matrix[3][2];

        // Bước 3: Chuyển ma trận 4x4 v�? lại thành 128-bit đầu ra
        ShiftRows = {state_out_matrix[0][0], state_out_matrix[1][0], state_out_matrix[2][0], state_out_matrix[3][0],
                     state_out_matrix[0][1], state_out_matrix[1][1], state_out_matrix[2][1], state_out_matrix[3][1],
                     state_out_matrix[0][2], state_out_matrix[1][2], state_out_matrix[2][2], state_out_matrix[3][2],
                     state_out_matrix[0][3], state_out_matrix[1][3], state_out_matrix[2][3], state_out_matrix[3][3]};
       
    end
endfunction



  // Hàm xtime: Nhân với 2 trong GF(2^8)
    function [7:0] xtime(input [7:0] b);
        xtime = (b << 1) ^ ((b & 8'h80) ? 8'h1b : 8'h00);
    endfunction

    // Hàm nhân GF(2^8) với 2
    function [7:0] mul_by_2(input [7:0] b);
        mul_by_2 = xtime(b);
    endfunction

    // Hàm nhân GF(2^8) với 3 (3 * b = (2 * b) XOR b)
    function [7:0] mul_by_3(input [7:0] b);
        mul_by_3 = xtime(b) ^ b;
    endfunction

    // Hàm MixColumns chính
    function [127:0] MixColumns(input [127:0] state_in);
        reg [31:0] col0, col1, col2, col3;          // Các cột của ma trận 4x4
        reg [31:0] out_col0, out_col1, out_col2, out_col3; // Các cột sau khi MixColumns

        begin
            // Tách từng cột từ state_in
            col0 = state_in[127:96];
            col1 = state_in[95:64];
            col2 = state_in[63:32];
            col3 = state_in[31:0];

            // MixColumns cho từng cột
            out_col0 = {mul_by_2(col0[31:24]) ^ mul_by_3(col0[23:16]) ^ col0[15:8] ^ col0[7:0],
                        col0[31:24] ^ mul_by_2(col0[23:16]) ^ mul_by_3(col0[15:8]) ^ col0[7:0],
                        col0[31:24] ^ col0[23:16] ^ mul_by_2(col0[15:8]) ^ mul_by_3(col0[7:0]),
                        mul_by_3(col0[31:24]) ^ col0[23:16] ^ col0[15:8] ^ mul_by_2(col0[7:0])};

            out_col1 = {mul_by_2(col1[31:24]) ^ mul_by_3(col1[23:16]) ^ col1[15:8] ^ col1[7:0],
                        col1[31:24] ^ mul_by_2(col1[23:16]) ^ mul_by_3(col1[15:8]) ^ col1[7:0],
                        col1[31:24] ^ col1[23:16] ^ mul_by_2(col1[15:8]) ^ mul_by_3(col1[7:0]),
                        mul_by_3(col1[31:24]) ^ col1[23:16] ^ col1[15:8] ^ mul_by_2(col1[7:0])};

            out_col2 = {mul_by_2(col2[31:24]) ^ mul_by_3(col2[23:16]) ^ col2[15:8] ^ col2[7:0],
                        col2[31:24] ^ mul_by_2(col2[23:16]) ^ mul_by_3(col2[15:8]) ^ col2[7:0],
                        col2[31:24] ^ col2[23:16] ^ mul_by_2(col2[15:8]) ^ mul_by_3(col2[7:0]),
                        mul_by_3(col2[31:24]) ^ col2[23:16] ^ col2[15:8] ^ mul_by_2(col2[7:0])};

            out_col3 = {mul_by_2(col3[31:24]) ^ mul_by_3(col3[23:16]) ^ col3[15:8] ^ col3[7:0],
                        col3[31:24] ^ mul_by_2(col3[23:16]) ^ mul_by_3(col3[15:8]) ^ col3[7:0],
                        col3[31:24] ^ col3[23:16] ^ mul_by_2(col3[15:8]) ^ mul_by_3(col3[7:0]),
                        mul_by_3(col3[31:24]) ^ col3[23:16] ^ col3[15:8] ^ mul_by_2(col3[7:0])};

            // Kết hợp lại các cột để tạo ra đầu ra 128-bit
            MixColumns = {out_col0, out_col1, out_col2, out_col3};
            Sub1 = MixColumns;
        end

    endfunction



/////////////////////////

always @(posedge clk or posedge reset) begin
    if (reset) begin
         round_key <= 128'h0;
         final_key <= 128'h0;
    end else if (done_ex == 1 && done_AES ==0) begin
        case (round)
            // 0: round_key <= {buffer_wire_4, buffer_wire_5, buffer_wire_6, buffer_wire_7};
            0: round_key <=  round_keys[1];
            1: round_key <=  round_keys[2];
            2: round_key <=  round_keys[3];
            3: round_key <=  round_keys[4];
            4: round_key <=  round_keys[5];
            5: round_key <=  round_keys[6];
            6: round_key <= round_keys[7];
            7: round_key <= round_keys[8];
            8: round_key <= round_keys[9];
            9: round_key <= round_keys[10];
        endcase
    end
end


always @(posedge clk or posedge reset) begin
    if (reset) begin
        // �?ặt lại tất cả các round_keys và tín hiệu done
        for (i = 0; i <= 10; i = i + 1) begin
            round_keys[i] <= 128'b0;
        end
        done_ex <= 0;
        done_AES <= 0;
        fsm <= 0;
        round_index <= 1;
        state <= 128'h0;
        round <= 4'b0;
        ciphertext <= 128'h0;           // Reset c�? done
        result <= 128'h0;     // Reset biến tạm lưu kết quả

    end else if (enable_AES == 32'd1 && done_AES == 0) begin
        case (fsm)
            0: begin
                // Khởi tạo round_keys[0] với input_key
                round_keys[0] <= input_key;
                done_AES <= 0;
                done_ex <= 0;
                fsm <= 1; // IDLE nạp vào 
            end
            1: begin
                // Tạo khóa mở rộng cho từng vòng, mỗi chu kỳ `clk` tính một khóa
                if (round_index <= 10) begin
                    round_keys[round_index] <= KeyExpansion(round_keys[round_index - 1], round_index);
                    round_index <= round_index + 1;
                end else begin
                    done_ex <= 1;
                    fsm <= 2;   // Calculting Key_expansion
                end
            end
            2: begin
                // Hiển thị từng khóa mở rộng sau khi hoàn tất
                $display("AES Key Expansion 128-bit:");
                for (i = 0; i <= 10; i = i + 1) begin
                    $display("Round %0d key: %h", i, round_keys[i]);
                end

                if (round == 0) begin
                    // Bước khởi tạo: XOR plaintext với khóa con đầu tiên (w[0] đến w[3])
                    state <= initial_state;
                    round <= 1;
                    done_AES <= 0;  // Quá trình đang diễn ra nên chưa bật c�? done
                end else if (round < 10) begin
                    // Thực hiện SubBytes, ShiftRows, MixColumns và AddRoundKey cho 9 vòng lặp chính
                    state <= AddRoundKey(MixColumns(ShiftRows(SubBytes(state))), round_key);
                    round <= round + 1;
                end else if (round == 10) begin
                    // Vòng cuối cùng không có MixColumns
                    state <= AddRoundKey(ShiftRows(SubBytes(state)), round_key);
                    round <= round + 1;
                end else if (round == 11) begin
                    ciphertext <= state;
                    done_AES <= 1; // �?ánh dấu quá trình mã hóa hoàn thành
                    round = 0;
                end

//                fsm <= 3;

            end
            default: begin
                // Ch�? sau khi hoàn tất
                fsm <= 3;
            end
        endcase
    end
end

endmodule


