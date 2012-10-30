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

`include "key_codes.vh"

module life_cnt #
(
	parameter X=3'd8,
	parameter Y=3'd8,
	parameter LOG2X=3,
	parameter LOG2Y=3
) (
	input clk,
	input reset,
	input [2:0]keys,
	output reg nxt_bit,
	output reg [(LOG2X+LOG2Y-1):0]cnt
);

reg nxt;
wire last_cnt;
wire key_nxt = (keys == `KEY_NXT);

assign last_cnt = (cnt == {{(LOG2X+LOG2Y-1){1'b1}}, 1'b0});

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
		if (last_cnt)
			nxt_bit <= nxt;
		// key is being released
		if (key_nxt)
			nxt <= 1'b1;
		else if (last_cnt)
			nxt <= 1'b0;

		cnt <= cnt + 1;
	end
end

endmodule
