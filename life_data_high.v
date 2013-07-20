`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:14:54 09/09/2012 
// Design Name: 
// Module Name:    life_data
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

module life_data_high #
(
	parameter X=8,
	parameter Y=8,
	parameter HIGH_BITS=(X+3), // minimum value
	parameter LOG2X=3,
	parameter LOG2Y=3
) (
	input clk,
	input reset,
	input nxt_bit,
	input cell_flip,
	input [LOG2X-1:0]cursor_x,
	input [LOG2Y-1:0]cursor_y,
	input pipe_out,
	input data_low_lsb,
	output reg [(X*Y-1):(X*Y-HIGH_BITS)]data_high
);

reg [(X*Y-1):(X*Y-HIGH_BITS)]data_high_next;

always @(*)
begin
	
   // data = (data >> 1) | ((data & 1) << (X*Y-1));
   // data = data & ~(1LL << ((Y-1)*X-3)) | (pipe_out  ? (1LL << ((Y-1)*X-3)) : 0);

	// First rotate left
	data_high_next = {data_low_lsb, data_high[(X*Y-1):(X*Y-HIGH_BITS+1)]};
	if (nxt_bit) // game is running
	begin
		// update
		data_high_next[(Y-1)*X-3] = pipe_out;
	end
	if (cell_flip)
		data_high_next[{cursor_y, cursor_x}] = !data_high_next[{cursor_y, cursor_x}];
end

always @(posedge clk, negedge reset)
begin
	if (~reset)
		data_high <= {HIGH_BITS{1'b0}};
	else
		data_high <= data_high_next;
end

endmodule
