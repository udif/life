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
	parameter X=3'd8,
	parameter Y=3'd8,
	parameter LOG2X=3,
	parameter LOG2Y=3
) (
	input clk,
	input pipe_out,
	output reg [(X*Y-1):0]data
);

always @(posedge clk)
begin
   // data = (data >> 1) | ((data & 1) << (X*Y-1));
   // data = data & ~(1LL << ((Y-1)*X-3)) | (pipe_out  ? (1LL << ((Y-1)*X-3)) : 0);
	data <= {data[0], data[(X*Y-1):((Y-1)*X-2)], pipe_out, data[((Y-1)*X-4):1]};
end

endmodule
