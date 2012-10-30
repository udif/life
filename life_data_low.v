`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:14:54 09/09/2012 
// Design Name: 
// Module Name:    life_data_low
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

`include "key_codes.vh"

module life_data_low #
(
	parameter X=8,
	parameter Y=8,
	parameter HIGH_BITS=(X+3), // minimum value
	parameter LOG2X=3,
	parameter LOG2Y=3
) (
	input clk,
	input reset,
	input data_high_lsb,
	input [2:0]keys,
	input [LOG2X-1:0]cursor_x,
	input [LOG2Y-1:0]cursor_y,
	output reg [(X*Y-HIGH_BITS-1):0]data_low
);

reg [(X*Y-HIGH_BITS-1):0]data_low_next;
wire key_flip;

assign key_flip = (keys == `KEY_FLIP);

always @(*)
begin
	
   // data = (data >> 1) | ((data & 1) << (X*Y-1));
   // data = data & ~(1LL << ((Y-1)*X-3)) | (pipe_out  ? (1LL << ((Y-1)*X-3)) : 0);

	// First rotate left
	data_low_next = {data_high_lsb, data_low[(X*Y-HIGH_BITS-1):1]};
	if (key_flip)
		data_low_next[{cursor_y, cursor_x}] = !data_low_next[{cursor_y, cursor_x}];
end

always @(posedge clk, negedge reset)
begin
	if (~reset)
		data_low <= {(X*Y-HIGH_BITS){1'b0}};
	else
		data_low <= data_low_next;
end

endmodule
