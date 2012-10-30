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
	output reg [LOG2Y-1:0]cursor_y,
	output reg [LOG2X-1:0]cursor_x
);

wire key_down, key_up, key_left, key_right;
reg key_down_d, key_up_d, key_left_d, key_right_d;

assign key_down  = (keys == `KEY_DOWN);
assign key_up    = (keys == `KEY_UP);
assign key_left  = (keys == `KEY_LEFT);
assign key_right = (keys == `KEY_RIGHT);

always @(posedge clk)
begin
	key_down_d  <= key_down;
	key_up_d    <= key_up;
	key_left_d  <= key_left;
	key_right_d <= key_right;
end
	
always @(posedge clk, negedge reset)
begin
	if (~reset)
	begin
		cursor_y <= {LOG2Y{1'b0}};
		cursor_x <= {LOG2Y{1'b0}};
	end
	else
	begin
		if (key_down_d && !key_down)
			cursor_y <= cursor_y + 1;
		else if (key_up_d && !key_up)
			cursor_y <= cursor_y - 1;
		
		if (key_left_d && !key_left)
			cursor_x <= cursor_x + 1;
		else if (key_right_d && !key_right)
			cursor_x <= cursor_x - 1;
	end
end

endmodule
