/**
 * @file data_mem.v
 * 
 * This module is a memory module with read and write capabilities.
 *
 * @param DATA_WIDTH The width of the data bus (default is 32).
 * @param ADDR_WIDTH The width of the address bus (default is 32).
 * @param MEM_SIZE   The number of memory locations (default is 64).
 *
 * @input clk        Inputs clock signal.
 * @input wr_en      Write enable signal.
 * @input wr_addr    Writes Address.
 * @input wr_data    Writes Data.
 * 
 * @return rd_data_mem Output read data.
*/

module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 64) (
    input       clk, wr_en,
    input       [ADDR_WIDTH-1:0] wr_addr, wr_data,
    output      [DATA_WIDTH-1:0] rd_data_mem
);

reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];
// Memory partition for GPIO pins (0x02001000 to 0x02001FFF)
reg [DATA_WIDTH-1:0] gpio_data_ram [0:27]; // 28 memory locations for GPIO


//! combinational read logic
//! word-aligned memory access
//! if address is greater than 0x02000000, then it is a data memory access
//! if it is less than 0x02000000, then it is an instruction memory access
assign rd_data_mem = ((wr_en == 0) && (wr_addr >= 32'h02000000) && (wr_addr < 32'h02001000)) ? 
                     data_ram[wr_addr[DATA_WIDTH-1:2] % MEM_SIZE] :
                     ((wr_en == 0) && (wr_addr >= 32'h02001000) && (wr_addr <= 32'h02001FFF)) ? 
                     gpio_data_ram[wr_addr[DATA_WIDTH-1:2] % 16] : 0;

//! synchronous write logic
always @(posedge clk) begin
    if (wr_en && (wr_addr >= 32'h02000000) && (wr_addr < 32'h02001000)) begin
        data_ram[wr_addr[DATA_WIDTH-1:2] % MEM_SIZE] <= wr_data;
    end else if (wr_en && (wr_addr >= 32'h02001000) && (wr_addr <= 32'h02001FFF)) begin
        gpio_data_ram[wr_addr[DATA_WIDTH-1:2] % 16] <= wr_data;
    end
end

endmodule
