`timescale 1ns / 1ps

module RISC_Top_tb();

    // Tín hiệu mô ph�?ng
    reg clk;
    reg reset;
    reg [31:0] ins_mem[0:8191];  
    
    // �?ầu ra từ CPU Pipeline
    // wire [63:0] pc_out;
    // wire [31:0] inst;
    reg [95:0]  Inst_ROM [0:1024];
    reg [63:0] Data_RAM [0:1024];

    integer dmem = 0;
    integer dins = 0;

    reg [31:0] CPU_addrin;
    reg [31:0] CPU_datain;
    reg [31:0] CPUi_addrin;
    reg [31:0] CPUi_datain;
    
    reg [7:0]  CPU_we;
    reg start_in;
    wire state_done;
    integer addr_cycle_count = 0;
   


    // Kết nối module CPU Pipeline
    RISC_Top CPU (
        .clk(clk),
        .reset(reset),
        .start_in(start_in),
        .DMAD_addr_in(CPU_addrin),
        .DMAD_data_in(CPU_datain),
        .DMAD_wea_in(CPU_we),

        .DMAI_addr_in(CPUi_addrin),
        .DMAI_data_in(CPUi_datain),
        .DMAI_wea_in(CPU_we),
        .state_done(state_done)
    );


    // Tạo xung nhịp (clock signal)
    

    initial begin
     clk = 0;
     
        // Khởi tạo tín hiệu
    $dumpfile("Riscv_pipeline.vcd");  // Tên file VCD
    $dumpvars(0, RISC_Top_tb);        // Tên module 
    // Ghi rõ tín hiệu inst_out vào file VCD
     $readmemh("C:/Users/ADMIN/Desktop/Scientific\ Research/Doing/RV_32I_Buffer_Internal/Verilog/Inst_ROM.txt", Inst_ROM);
     $readmemh("C:/Users/ADMIN/Desktop/Scientific\ Research/Doing/RV_32I_Buffer_Internal/Verilog/Data_Mem.txt", Data_RAM);
    // $readmemh("C:\\Users\\ADMIN\\Desktop\\NCKH\\RV_32_Cus\\Inst_ROM.txt", ins_mem);
    end 
    always begin
    clk = ~clk;
    #5; 
        if (state_done) begin
            $finish;
        end
    end
    initial begin
    start_in = 0;
        CPU_we = 8'b00000000; // tín hiệu cho phép đ�?c hoặc ghi bram = 0 là wr = 0
        reset <= 1;
        #10;
        reset <= 0;
        // CPU_en = 1'b1;
        #20;
        //Get Data for Data Memory
        for (dmem = 0; dmem<1000; dmem=dmem+1) begin //Amount of Datas
            #10;
            CPU_we = 8'b11111111;
            CPU_addrin <= Data_RAM[dmem][63:32];
            CPU_datain <= Data_RAM[dmem][31:0];

            CPUi_addrin <= Inst_ROM[dmem][95:32];
            CPUi_datain <= Inst_ROM[dmem][31:0];
            #10;
            CPU_we = 8'b00000000;
        end
        
//        for (dmem = 0; dmem<350; dmem=dmem+1) begin //Amount of Datas
//             // Counter to track address transmission interval
//            #10;
//            CPU_we = 8'b11111111;
            
//            // Data is transmitted every 10 ns
//            CPU_datain <= Data_RAM[dmem][31:0];
//            CPUi_datain <= Inst_ROM[dmem][31:0];
        
//            // Address is transmitted every 80 ns
//            if (addr_cycle_count == 0) begin
//                CPU_addrin <= Data_RAM[dmem][63:32];
//                CPUi_addrin <= Inst_ROM[dmem][95:32];
//            end
            
//            addr_cycle_count = (addr_cycle_count + 1) % 8; // Reset counter every 8 cycles (80 ns)
    
//        #10;
//        CPU_we = 8'b00000000;
//    end

        CPU_we = 8'b0000000;
        start_in = 1'b1;
    end


      // Tạo xung nhịp với chu kỳ 10ns (tần số 100 MHz)

//repeat (770) begin
//#10;
//    //         #10;  // Ch�? 10ns giữa các chu kỳ
//     end
//  $finish;
//    end
    // initial begin
    //     clk = 0;
    //     reset = 0;

    //     // Giai đoạn reset
    //     $display("Resetting CPU...");
    //     reset = 1;  // Kích hoạt reset
    //     #660;        // Ch�? 10ns

    //     reset = 0;  // Hủy reset

    //     // Kiểm tra các bước hoạt động của CPU
    //     $display("Start CPU execution...");

    //     // �?ể CPU chạy trong một số chu kỳ và kiểm tra kết quả
    //     repeat (5000) begin
    //         #10;  // Ch�? 10ns giữa các chu kỳ
    //     end

    //     // Kết thúc mô ph�?ng
    //     $finish;
    // end

endmodule
