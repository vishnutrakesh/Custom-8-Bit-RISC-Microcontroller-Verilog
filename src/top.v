`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:57:34 04/29/2026 
// Design Name: 
// Module Name:    top 
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
module top(
input clk,          // 50MHz board clock
input reset,        // active high reset button
input  [7:0] sw,    // slide switches
output [7:0] led,   // LEDs
output timer_flag   // can connect to an extra LED for timer blink
);
 
// Clock divider: slow down 50MHz to 1Hz for visible LED blinking
// 50,000,000/2=25,000,000 counts for 1Hz toggle
reg [25:0] clk_div;
reg slow_clk;

always@(posedge clk or posedge reset)
begin
if (reset)
begin
clk_div<=0;
slow_clk<=0;
end
else if(clk_div == 26'd24_999_999)
begin
clk_div <= 0;
slow_clk<=~slow_clk;
end
else
clk_div<=clk_div + 1;
end
 
// CPU instance
cpu CPU(
    .clk(slow_clk),
    .reset(reset),
    .led(led),
    .switches(sw),
    .timer_flag(timer_flag));
 
endmodule
