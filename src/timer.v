`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:19:27 04/29/2026 
// Design Name: 
// Module Name:    timer 
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
module timer(
input clk,
input reset,
// bus interface
input [7:0]addr,
input [7:0]data_in,
input mem_write,
input mem_read,
output reg [7:0]data_out,
// timer output
output reg timer_flag);    // goes high for 1 cycle when counter == compare

reg [7:0]counter;
reg [7:0]compare;
 
// Counter increments every clock cycle
always @(posedge clk or posedge reset)
begin
if (reset) begin
counter<=8'h00;
compare<=8'hFF;// default: flag every 255 cycles
end
else
begin
// Write compare register via STORE to 0x83
if (mem_write)
compare<=data_in;
 
// Increment counter, reset on match
if (counter == compare)
counter<=8'h00;
else
counter<=counter+1;
end
end
 
// Timer flag: high for 1 cycle on compare match
always @(*)
begin
timer_flag=(counter==compare);
end
 
// Bus read
always @(*)
begin
data_out=8'b00000000;
if (mem_read) 
begin
case (addr)
8'd5: data_out=compare;
default: data_out=8'b00000000;
endcase
end
end
 
endmodule
