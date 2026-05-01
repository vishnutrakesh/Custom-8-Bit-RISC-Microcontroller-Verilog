`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:19:19 04/22/2026 
// Design Name: 
// Module Name:    cu 
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
module cu(
input clk,
input reset,
input [3:0]opcode,
input zero,
output reg reg_write,
output reg alu_src,
output reg [2:0]alu_op,
output reg mem_read,
output reg mem_write,
output reg pc_src,
output reg pc_write,
output reg ir_write,
output reg[2:0]state);

parameter fetch=3'b000, //fsm states
decode=3'b001,
execute=3'b010,
memory=3'b011,
writeback=3'b100,
halt=3'b101;

//state transition

always @(posedge clk or posedge reset)
begin
if (reset)
state<=fetch;
else
begin
case(state)

fetch:state<=decode;

decode:
begin
if (opcode==4'b1111)
state<=halt;
else
state<=execute;
end

execute:
begin
if(opcode==4'b0111||opcode==4'b1000)//load or store
state<=memory;
else
state<=writeback;
end

memory:
begin
if (opcode==4'b0111)
state<=writeback;
else
state<=fetch;
end

writeback:
state<=fetch;

halt:
state<=halt;

default:state<=fetch;

endcase
end
end

//control signals

always @(*)
begin
reg_write=0;
alu_src=0;
alu_op=3'b000;
mem_read=0;
mem_write=0;
pc_src=0;
pc_write=0;
ir_write=0;

case(state)

fetch:
begin
ir_write=1;
pc_write=1;
end

decode:
begin
end

execute:
begin
case (opcode)
4'b0000:// ADD
begin
alu_op=3'b000;
alu_src=0;
end

4'b0001:// SUB
begin
alu_op=3'b001;
alu_src=0;
end

4'b0010:// AND
begin
alu_op=3'b010;
alu_src=0;
end

4'b0011:// OR
begin
alu_op=3'b011;
alu_src=0;
end

4'b0100:// NOT
begin
alu_op=3'b100;
alu_src=0;
end

4'b0101:// XOR
begin
alu_op=3'b101;
alu_src=0;
end

4'b0110:// ADDI
begin
alu_op=3'b000;
alu_src=1;
end

4'b0111:// LOAD address = rs1 + imm
begin
alu_op=3'b000;
alu_src=1;
end

4'b1000:// STORE address = rs1 + imm
begin
alu_op=3'b000;
alu_src=1;
end

4'b1001:// JMP
begin
pc_src=1;
end

4'b1010:// JZ
begin
if (zero)
pc_src = 1;
end

endcase
end

//memory

memory:
begin
if (opcode==4'b0111)
mem_read=1;//load
else if (opcode==4'b1000)
mem_write=1;//store
end

//writeback

writeback:
begin
if (opcode == 4'b0000 || opcode == 4'b0001 || opcode == 4'b0010 || opcode == 4'b0011 || opcode == 4'b0100 || opcode == 4'b0101 || opcode == 4'b0110 || opcode == 4'b0111)
reg_write=1;
end

//halt

halt:
begin
end
endcase
end

endmodule
