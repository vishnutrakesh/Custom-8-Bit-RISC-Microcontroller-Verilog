`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:53:56 04/23/2026 
// Design Name: 
// Module Name:    cpu 
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
module cpu(
input clk,
input reset,
// GPIO pins
output [7:0]led,
input  [7:0]switches,
// Timer flag
output timer_flag);
 
wire [7:0] pc_out;
wire [15:0]instruction;
wire [15:0]ir_out;
wire [2:0]rs1, rs2, rd;
wire [7:0]reg_data1, reg_data2;
wire [7:0]alu_in2, alu_result;
 
//8-bit immediate (bits [7:0] of instruction)
wire [7:0]imm_ext = {5'b00000, ir_out[2:0]}; 
wire reg_write, alu_src, mem_read, mem_write;
wire pc_src, pc_write, ir_write;
wire [2:0]alu_op;
wire [2:0]cu_state;
wire zero;
 
// ALU result register: latches result at end of execute
reg [7:0]alu_result_reg;
always@(posedge clk)
begin
if (cu_state==3'b010)
alu_result_reg<=alu_result;
end
 
// Memory/peripheral data bus
wire [7:0]mem_data_out;
wire [7:0]gpio_data_out;
wire [7:0]timer_data_out;
wire [7:0]bus_data_out;
wire mem_cs, gpio_cs, timer_cs;
 
// Address for memory/peripheral access=ALU result latched from execute
wire [7:0]mem_addr=alu_result_reg;

//PC
pc PC(
    .clk(clk),
    .reset(reset),
    .pc_write(pc_write),
    .pc_sel(pc_src),
    .branch_addr(reg_data1),
    .pc_out(pc_out));
 
//Instruction Memory 
instr_mem IM(pc_out, instruction);
 
//Instruction Register
instr_reg IR(clk, ir_write, instruction, ir_out);
 
assign rd=ir_out[11:9];
assign rs1=ir_out[8:6];
assign rs2=ir_out[5:3];  // only valid for non-ADDI instructions
 
// Writeback data: LOAD gets bus data, all others get ALU result
wire [7:0]wb_data=(ir_out[15:12]==4'b0111)? bus_data_out:alu_result_reg;
 
//Register File
regf RF(clk,
    reg_write,
    rs1,
    rs2,
    rd,
    wb_data,
    reg_data1,
    reg_data2);
 
// MUX: reg_data2 or 8 bit immediate
mux MUX(reg_data2, imm_ext, alu_src, alu_in2);
 
// ALU
alu ALU(reg_data1, alu_in2, alu_op, alu_result, zero);
 
// Control unit
cu CU(
    clk,
    reset,
    ir_out[15:12],
    zero,
    reg_write,
    alu_src,
    alu_op,
    mem_read,
    mem_write,
    pc_src,
    pc_write,
    ir_write,
    cu_state);
 
// Data memory (0x00-0x7F)
data_mem DM(
    .clk(clk),
    .addr(mem_addr),
    .data_in(reg_data2),
    .mem_read(mem_read & mem_cs),
    .mem_write(mem_write & mem_cs),
    .data_out(mem_data_out));
 
// GPIO (0x80-0x81)
gpio GPIO(
    .clk(clk),
    .reset(reset),
    .addr(mem_addr),
    .data_in(reg_data2),
    .mem_write(mem_write & gpio_cs),
    .mem_read(mem_read & gpio_cs),
    .data_out(gpio_data_out),
    .led(led),
    .switches(switches));
 
// Timer (0x82-0x83)
timer TIMER(
    .clk(clk),
    .reset(reset),
    .addr(mem_addr),
    .data_in(reg_data2),
    .mem_write(mem_write & timer_cs),
    .mem_read(mem_read & timer_cs),
    .data_out(timer_data_out),
    .timer_flag(timer_flag));
 
// Bus decoder
bus_decoder BD(
    .addr(mem_addr),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .data_mem_out(mem_data_out),
    .gpio_data_out(gpio_data_out),
    .timer_data_out(timer_data_out),
    .data_out(bus_data_out),
    .mem_cs(mem_cs),
    .gpio_cs(gpio_cs),
    .timer_cs(timer_cs));
 
endmodule
