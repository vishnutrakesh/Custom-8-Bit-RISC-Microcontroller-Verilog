`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:16:51 04/29/2026 
// Design Name: 
// Module Name:    gpio 
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
module gpio(
input clk,
input reset,

// bus interface
input [7:0]addr,
input [7:0]data_in,
input mem_write,
input mem_read,
output reg [7:0]data_out,

// physical pins
output reg [7:0]led,
input [7:0]switches
);

// WRITE (STORE)
always @(posedge clk or posedge reset)
begin
    if (reset)
        led<=8'b00000000;
    else if (mem_write)
        led<=data_in;
end

// READ (LOAD)
always @(*)
begin
    data_out=8'b00000000;

    if (mem_read) begin
        case (addr)
            8'd7: data_out = led;        
            8'd6: data_out = switches; 
            default: data_out = 8'b00000000;
        endcase
    end
end

endmodule
