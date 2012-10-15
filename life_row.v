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
module life_row #
(
	parameter X=3'd8,
	parameter Y=3'd8,
	parameter LOG2X=3,
	parameter LOG2Y=3
) (
	input clk,
	input reset,
	input [(LOG2X+LOG2Y-1):0]cnt,
	output reg [X-1:0]row
);

always @(posedge clk, negedge reset)
begin
	if (~reset)
		row <= {X{1'b0}};
	else
		row <= (1 << cnt[LOG2X+LOG2Y-1:LOG2Y]);
end

endmodule
