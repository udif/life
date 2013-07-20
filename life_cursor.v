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

`include "key_codes.vh"

module life_cursor #
(
	parameter X=3'd8,
	parameter Y=3'd8,
	parameter LOG2X=3,
	parameter LOG2Y=3
) (
	input clk,
	input reset,
	input [2:0]keys,
	input [(LOG2X+LOG2Y-1):0]cnt,
	output reg cell_flip,
	output reg [LOG2Y-1:0]cursor_y,
	output reg [LOG2X-1:0]cursor_x
);

wire key_down, key_up, key_left, key_right;
reg flip_detect;

assign key_down  = (keys == `KEY_DOWN);
assign key_up    = (keys == `KEY_UP);
assign key_left  = (keys == `KEY_LEFT);
assign key_right = (keys == `KEY_RIGHT);
assign key_flip  = (keys == `KEY_FLIP);

always @(posedge clk, negedge reset)
begin
	if (~reset)
	begin
		cursor_y <= {LOG2Y{1'b0}};
		cursor_x <= {LOG2Y{1'b0}};
		flip_detect <= 1'b0;
	end
	else
	begin
		if (key_down)
			cursor_y <= cursor_y + 1;
		else if (key_up)
			cursor_y <= cursor_y - 1;
		
		if (key_left)
			cursor_x <= cursor_x + 1;
		else if (key_right)
			cursor_x <= cursor_x - 1;

		// since the array is constantly moving, we will change cells only
		// when cnt is 0. this means we need to save the key_flip event until then
		if (cnt != {(LOG2X+LOG2Y){1'b1}})
			flip_detect <= flip_detect | key_flip;
		else
			flip_detect <= key_flip;

		cell_flip <= (flip_detect && (cnt == {(LOG2X+LOG2Y){1'b1}}));
	end
end

endmodule
