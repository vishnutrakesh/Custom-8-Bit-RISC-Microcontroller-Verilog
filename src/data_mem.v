`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:50:58 04/23/2026 
// Design Name: 
// Module Name:    data_mem 
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
module data_mem(
input clk,
input [7:0]addr,
input [7:0]data_in,
input mem_read,
input mem_write,
output reg [7:0]data_out);

reg [7:0]memory[0:127];//128bytes
integer i;

initial begin
for (i=0;i<128;i=i+1)
memory[i]=8'h00;
end
 
always @(posedge clk) begin
if (mem_write && addr <= 8'h7F)
memory[addr]<=data_in;
end
 
always @(*) begin
if (mem_read && addr <= 8'h7F)
data_out=memory[addr];
else
data_out=8'h00;
end
 
endmodule
