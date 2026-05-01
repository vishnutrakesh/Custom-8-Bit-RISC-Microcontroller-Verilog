`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:23:49 04/29/2026 
// Design Name: 
// Module Name:    bus_decoder 
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
module bus_decoder(
input [7:0] addr,
input mem_read,
input mem_write,
// data buses
input [7:0]data_mem_out,
input [7:0]gpio_data_out,
input [7:0]timer_data_out,
// outputs to CPU
output reg [7:0]data_out,
// chip selects
output mem_cs,
output gpio_cs,
output timer_cs);
 
// Address decode:
assign mem_cs=(addr<=8'd4);
assign gpio_cs=(addr==8'd7 || addr==8'd6);
assign timer_cs=(addr==8'd5);
 
// Route read data back to CPU
always @(*)
begin
if (mem_read)
begin
if (mem_cs)
data_out=data_mem_out;
else if (gpio_cs)
data_out=gpio_data_out;
else if (timer_cs)
data_out=timer_data_out;
else
data_out=8'b00000000;
end
else
data_out=8'b00000000;
end
 
endmodule
