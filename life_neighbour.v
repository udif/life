`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:14:54 09/09/2012 
// Design Name: 
// Module Name:    life_neighbour 
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
module life_neighbour #
(
	parameter X=3'd8,
	parameter Y=3'd8,
	parameter LOG2X=3,
	parameter LOG2Y=3
) (
	input [(X*Y)-1:0]data,
	input [(LOG2X+LOG2Y-1):0]cnt,
	output c, l, r, u, d, lu, ld, ru, rd
 );

//reg [5:0]cnt;
wire [LOG2X-1:0]x;
wire [LOG2Y-1:0]y;

// [lu] [u] [ru]
// [l]  [c] [r]
// [ld] [d] [rd]

assign c  = data[(X*Y-1)];
assign x  = cnt[(LOG2X-1):0];
assign y  = cnt[(LOG2Y-1+LOG2X):LOG2X];
assign r  = (x == (X-1)) ? 1'b0 : data[0];
assign l  = (x == 3'd0)  ? 1'b0 : data[(X*Y-2)];
assign d  = (y == (Y-1)) ? 1'b0 : data[(X-1)];
assign u  = (y == 3'd0)  ? 1'b0 : data[(X*(Y-1)-1)];
assign rd = ((x == (X-1)) || (y == (Y-1))) ? 1'b0 : data[X];
assign ld = ((x == 3'd0)  || (y == (Y-1))) ? 1'b0 : data[X-2];
assign ru = ((x == (X-1)) || (y == 3'd0))  ? 1'b0 : data[X*(Y-1)];
assign lu = ((x == 3'd0)  || (y == 3'd0))  ? 1'b0 : data[X*(Y-1)-2];

endmodule
