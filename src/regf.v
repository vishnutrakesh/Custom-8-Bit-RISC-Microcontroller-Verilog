`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:48:20 03/08/2026 
// Design Name: 
// Module Name:    regf 
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
module regf(
input clk,
input reg_write,
input [2:0]rs1,
input [2:0]rs2,
input [2:0]rd,
input [7:0]ip_data,
output [7:0]op_reg1,
output [7:0]op_reg2
);

reg [7:0]registers[7:0];

// Initialize registers (IMPORTANT for simulation)
integer i;
initial
begin
for(i=0;i<8;i=i+1)
registers[i]=8'b00000000;
end

// Read ports
assign op_reg1=(rs1==3'b000)? 8'b00000000 : registers[rs1];
assign op_reg2=(rs2==3'b000)? 8'b00000000 : registers[rs2];

// Write port
always @(posedge clk)
begin
if (reg_write && rd != 3'b000) // R0 hardwired to zero
registers[rd]<=ip_data;
end

endmodule
