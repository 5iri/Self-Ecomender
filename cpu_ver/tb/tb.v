`timescale 1 ns/1 ns

module tb;

// Registers to send inputs
reg clk;
reg reset;
reg Ext_MemWrite;
reg [31:0] Ext_WriteData, Ext_DataAdr;

// Wire outputs from the instantiated module
wire [31:0] WriteData, DataAdr, ReadData;
wire MemWrite;
wire [31:0] PC, Result;

// Instantiate the top module
top uut (
    .clk(clk),
    .reset(reset),
    .Ext_MemWrite(Ext_MemWrite),
    .Ext_WriteData(Ext_WriteData),
    .Ext_DataAdr(Ext_DataAdr),
    .MemWrite(MemWrite),
    .WriteData(WriteData),
    .DataAdr(DataAdr),
    .ReadData(ReadData),
    .PC(PC),
    .Result(Result)
);

// Clock generation: 100 MHz frequency (10 ns period)
initial begin
    clk = 0;
    forever #5 clk = ~clk; // Toggle clock every 5 ns
end

// Simulation setup
initial begin
    // Apply reset
    reset = 1; // Assert reset
    Ext_MemWrite = 0;
    Ext_WriteData = 0;
    Ext_DataAdr = 0;

    #20 reset = 0; // Deassert reset after 20 ns

    // Test Case 1: Write to memory
    #10;
    Ext_MemWrite = 1;
    Ext_WriteData = 32'hA5A5A5A5; // Test value
    Ext_DataAdr = 32'h00000004;  // Test address

    #10;
    Ext_MemWrite = 1;
    Ext_WriteData = 32'h12345678; // Another test value
    Ext_DataAdr = 32'h00000008;  // Another test address

    // Test Case 2: Stop writing and let the system process
    #10;
    Ext_MemWrite = 0;

    // Run the simulation for a specific duration
    #200; // Let the simulation run for 200 ns

    // End simulation
    $finish;
end

// Monitor key signals
initial begin
    $monitor(
        "Time: %0dns | reset: %b | clk: %b | MemWrite: %b | WriteData: %h | DataAdr: %h | ReadData: %h | PC: %h | Result: %h",
        $time, reset, clk, MemWrite, WriteData, DataAdr, ReadData, PC, Result
    );
end

// Task to print data memory content
task print_data_memory;
    integer i;
    begin
        $display("\n--- Data Memory Contents ---");
        for (i = 0; i < 32; i = i + 1) begin // Assuming data_mem has 32 entries
            $display("data_mem[%0d] = %h", i, uut.data_mem[i]);
        end
        $display("----------------------------\n");
    end
endtask

// Trigger data memory printing at specific times
always @(posedge clk) begin
    if (!reset) begin
        // Print memory contents periodically (e.g., every 50 ns)
        if ($time % 50 == 0) begin
            print_data_memory();
        end
    end
end


endmodule
