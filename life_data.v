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
module life_data #
(
	parameter X=8,
	parameter Y=8,
	parameter LOG2X=3,
	parameter LOG2Y=3
) (
	input clk,
	input reset,
	input nxt_bit,
	input key_flip,
	input key_run,
	input [(LOG2X+LOG2Y-1):0]cnt,
	input pipe_out,
	output reg [(X*Y-1):0]data
);

reg [(X*Y-1):0]data_next;
reg key_flip_d;

always @(*)
begin
	
   // data = (data >> 1) | ((data & 1) << (X*Y-1));
   // data = data & ~(1LL << ((Y-1)*X-3)) | (pipe_out  ? (1LL << ((Y-1)*X-3)) : 0);

	data_next = data; // default
	if (nxt_bit) // game is running
	begin
		// First rotate left
		data_next = {data[0], data[(X*Y-1):1]};
		// update
		data_next[(Y-1)*X-3] = pipe_out;
	end
	else if (key_flip_d && !key_flip)
		data_next[cnt] = !data_next[cnt];
end

always @(posedge clk)
begin
	key_flip_d  <= key_flip;
end

always @(posedge clk, negedge reset)
begin
	if (~reset)
		data <= {(X*Y){1'b0}};
	else
		data <= data_next;
end

endmodule
