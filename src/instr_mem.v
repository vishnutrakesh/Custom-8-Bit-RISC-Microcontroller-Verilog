`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:25:31 03/08/2026 
// Design Name: 
// Module Name:    instr_mem 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module instr_mem(
input [7:0]addr,
output [15:0]instr
);

reg [15:0]memory[255:0];
assign instr=memory[addr];

integer i;

initial begin

memory[0]=16'b0110_100_000_000_101; // R4 = 5
memory[1]=16'b0110_111_000_000_011; // R7 = 3
memory[2]=16'b0000_100_100_111_000; // R4 = 8
memory[3]=16'b0110_001_000_000_111; // R1 = 7 (LED addr)
memory[4]=16'b0110_010_000_000_110; // R2 = 6 (switch addr)
memory[5]=16'b0110_011_000_000_101; // R3 = 5 (timer addr)
memory[6]=16'b0110_100_000_000_101; // R4 = 5
memory[7]=16'b1000_000_001_100_000; // STORE R4 ? LED
memory[8]=16'b0111_101_010_000_000; // LOAD R5 ? switches
memory[9]=16'b1000_000_001_101_000; // STORE R5 ? LED
memory[10]=16'b0110_110_000_000_011; // R6 = 3
memory[11]=16'b1000_000_011_110_000; // STORE R6 ? timer
memory[12]=16'b0110_111_000_000_100; // R7 = 4 (loop)
memory[13]=16'b1001_000_111_000_000; // JMP R7
memory[14]=16'b1111_000_000_000_000; // HALT

end

endmodule