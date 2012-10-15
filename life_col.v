`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:14:54 09/09/2012 
// Design Name: 
// Module Name:    life_col
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
module life_col #
(
	parameter X=3'd8,
	parameter Y=3'd8,
	parameter LOG2X=3,
	parameter LOG2Y=3
) (
	input clk,
	input reset,
	input [(X-1):0]top_row,
	input [(LOG2X+LOG2Y-1):0]cnt,
	output reg [Y-1:0]col
);

always @(posedge clk, negedge reset)
begin
	if (~reset)
		col <= {Y{1'b0}};
	else if (cnt[LOG2X-1:0] == {LOG2X{1'b0}})
		col <= top_row;
end

endmodule
