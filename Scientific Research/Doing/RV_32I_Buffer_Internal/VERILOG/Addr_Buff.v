module ABC (
    input clk,
    input reset,

    // Data input
    input wire [31:0] addr_data_mem,
    input wire [31:0] addr_buff,
    input wire [31:0] offset,

    // Control signal input 
    input wire load_buff,
    input wire store_buff,

    // Output data 
    output reg [31:0] addr_data_mem_o,
    output reg [31:0] addr_buff_o,
    output reg [31:0] offset_o
);

    reg [31:0] internal_addr_data;
    reg [31:0] internal_addr_buff;
    reg [31:0] internal_offset;
    reg [31:0] temp_offset;

    // Reset temp_offset at the start
    initial begin
        temp_offset = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all internal and output registers
            internal_addr_data <= 0;
            internal_addr_buff <= 0;
            internal_offset <= 0;
            temp_offset <= 0;

            addr_data_mem_o <= 0;
            addr_buff_o <= 0;
            offset_o <= 0;

        end else if (load_buff) begin
            // Load data into internal registers
            internal_addr_data <= addr_data_mem;
            internal_addr_buff <= addr_buff;
            internal_offset    <= offset;

            // Reset outputs while loading
            addr_data_mem_o <= 0;
            addr_buff_o <= 0;
            offset_o <= 0;

        end else if (store_buff) begin
            // Store data into output registers if temp_offset is less than internal_offset + 1
            if (temp_offset < internal_offset + 1) begin
                addr_data_mem_o <= internal_addr_data;
                addr_buff_o <= internal_addr_buff;
                offset_o <= internal_offset;

                temp_offset <= temp_offset + 1;

            end else begin
                // Clear internal and output registers when condition fails
                internal_addr_data <= 0;
                internal_addr_buff <= 0;
                internal_offset <= 0;
                temp_offset <= 0;

                addr_data_mem_o <= 0;
                addr_buff_o <= 0;
                offset_o <= 0;
            end

        end else begin
            // Default state: keep all values unchanged
            internal_addr_data <= internal_addr_data;
            internal_addr_buff <= internal_addr_buff;
            internal_offset <= internal_offset;
            temp_offset <= temp_offset;

            addr_data_mem_o <= addr_data_mem_o;
            addr_buff_o <= addr_buff_o;
            offset_o <= offset_o;
        end
    end

endmodule
