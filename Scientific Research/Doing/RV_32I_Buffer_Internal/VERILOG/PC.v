// module PC(
//     input clk,
//     input reset,
//     input [31:0] pc_in,
//     input [31:0] pc_ecall,
//     input ecall_detected,     // Tín hiệu cho biết có lệnh ecall

//     output reg [31:0] pc_out
//     // output reg ena_ins,       // ena signal 
//     // output reg wea
// );

// always @(posedge clk or posedge reset) begin
//         if (reset) begin
//             pc_out <= 32'b0;    // Khi reset, pc_out được đặt về 0
//             // ena_ins <= 0;       // Disable instruction fetch when reset
//             // wea <= 0;
//         end
//         else if (ecall_detected) begin
//             pc_out <= pc_ecall; // Khi gặp ecall, giữ nguyên giá trị của pc_out
//             // ena_ins <= 0;       // Disable instruction fetch on ecall
//             // wea <= 0;
//         end
//         else begin
//             pc_out <= pc_in;    // Cập nhật pc_out bình thường nếu không có ecall
//             // ena_ins <= 1;       // Enable instruction fetch
//             // wea <= 0;    
//         end
//     end

// endmodule


module PC(
    input clk,
    input reset,
    input start,               // Cờ start để kiểm soát hoạt động
    input [31:0] pc_in,
    input [31:0] pc_ecall,
    input ecall_detected,     // Tín hiệu cho biết có lệnh ecall

    output reg [31:0] pc_out
    // output reg ena_ins,       // ena signal 
    // output reg wea
);

always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 32'b0;    // Khi reset, pc_out được đặt về 0
            // ena_ins <= 0;       // Disable instruction fetch when reset
            // wea <= 0;
        end
        else if (start) begin
            if (ecall_detected) begin
                pc_out <= pc_ecall; // Khi gặp ecall, gán giá trị pc_ecall vào pc_out
            end else begin
                pc_out <= pc_in;    // Nếu không, gán giá trị pc_in vào pc_out
            end
        end else begin
            pc_out <= 32'b0;    // Khi start không được kích hoạt, pc_out được đặt về 0
        end
    end
endmodule
