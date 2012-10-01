`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:14:54 09/09/2012 
// Design Name: 
// Module Name:    life_pipe
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
module life_pipe #
(
	parameter X=3'd8,
	parameter Y=3'd8,
	parameter LOG2X=3,
	parameter LOG2Y=3
) (
	input clk,
	input reset,
	input new_data,
	output pipe_out
);

reg [X:0]pipe;

always @(posedge clk, negedge reset)
begin
	if (~reset)
		pipe <= {(X+1){1'b0}};
	else
		pipe <= {pipe[X-1:0], new_data};
end

assign pipe_out = pipe[X];

endmodule
