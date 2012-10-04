`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:14:54 09/09/2012 
// Design Name: 
// Module Name:    life_cnt
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
module life_cnt #
(
	parameter X=3'd8,
	parameter Y=3'd8,
	parameter LOG2X=3,
	parameter LOG2Y=3
) (
	input clk,
	input reset,
	input key_nxt,
	input key_run,
	input key_down, key_up, key_left, key_right,
	output reg nxt_bit,
	output reg [(LOG2X+LOG2Y-1):0]cnt
);

reg key_nxt_d;
reg key_down_d, key_up_d, key_left_d, key_right_d;
reg nxt;
wire last_cnt;

assign last_cnt = (cnt == {{(LOG2X+LOG2Y-1){1'b1}}, 1'b0});

always @(posedge clk)
begin
	key_nxt_d <= key_nxt;
	key_down_d  <= key_down;
	key_up_d    <= key_up;
	key_left_d  <= key_right;
	key_right_d <= key_right;
end

always @(posedge clk, negedge reset)
begin
	if (~reset)
	begin
		nxt_bit <= 1'b0;
		nxt <= 1'b0;
		cnt <= {(LOG2X+LOG2Y){1'b0}};
	end
	else
	begin
		nxt_bit <= !last_cnt || nxt;
		if (last_cnt)
			nxt <= 1'b0;
		// key is being released
		else if (!key_nxt && key_nxt_d)
			nxt <= 1'b1;

		if (key_run)
		begin
			if (nxt_bit)
				cnt <= cnt + 1;
		end
		else
		begin
			if (key_down_d && !key_down)
				cnt[(LOG2X+LOG2Y-1):LOG2X] <= cnt[(LOG2X+LOG2Y-1):LOG2X] + 1;
			else if (key_up_d && !key_up)
				cnt[(LOG2X+LOG2Y-1):LOG2X] <= cnt[(LOG2X+LOG2Y-1):LOG2X] - 1;
			if (key_left_d && !key_left)
				cnt[(LOG2X-1):0] <= cnt[(LOG2X-1):0] + 1;
			else if (key_right_d && !key_right)
				cnt[(LOG2X-1):0] <= cnt[(LOG2X-1):0] - 1;
		end
	end
end

endmodule
