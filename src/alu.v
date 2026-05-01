`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:47:14 03/04/2026 
// Design Name: 
// Module Name:    alu 
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
module alu(
input [7:0]a,
input [7:0]b,
input [2:0]alu_op,
output reg [7:0] res,
output zero);

always @(*)
begin
case(alu_op)
3'b000:res=a+b;//add
3'b001:res=a-b;//sub
3'b010:res=a&b;//AND
3'b011:res=a|b;//OR
3'b100:res=~a;//complement
3'b101:res=a^b;//XOR
default:res=8'b00000000;
endcase
end

assign zero=(res==8'b00000000);

endmodule