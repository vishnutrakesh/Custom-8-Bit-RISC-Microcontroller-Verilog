`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:59:03 03/08/2026 
// Design Name: 
// Module Name:    pc 
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
module pc(
input clk,
input reset,
input pc_write,
input pc_sel,
input [7:0]branch_addr,
output reg [7:0]pc_out);

always@(posedge clk or posedge reset)
begin
if (reset)
pc_out<=8'b00000000;//PC set to zero
else if (pc_sel)
pc_out<=branch_addr;//PC jumps to branch_addr if pc_sel==1
else if (pc_write)
pc_out<=pc_out+1;//moves to next instruction
end

endmodule
