`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:10:53 03/19/2026 
// Design Name: 
// Module Name:    instr_reg 
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
module instr_reg(
input clk,
input instr_write,
input [15:0]instr_in,
output reg [15:0]instr_out);

always@(posedge clk)
begin
if (instr_write)
instr_out<=instr_in;
end


endmodule
