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
module life_1 #
(
	parameter X=8,
	parameter Y=8,
	parameter HIGH_BITS=(X+3), // minimum value is (X+3)
	parameter LOG2X=3,
	parameter LOG2Y=3
) (
	input clk,
	input reset,
	input key_flip, key_nxt,
	input key_flip_d,
	output [(LOG2X+LOG2Y-1):0]cnt,
	input [LOG2X-1:0]cursor_x,
	input [LOG2Y-1:0]cursor_y,
	input data_high_lsb,
	output data_low_lsb,
	output nxt_bit,
	output [2:0]data_low_X_XM2,
	output [Y-1:0]col
 );

wire [(X*Y-HIGH_BITS-1):0]data_low;
assign data_low_lsb = data_low[0];
assign data_low_X_XM2 = data_low[X:(X-2)];

life_data_low  #(
  .X(X),
  .Y(Y),
  .HIGH_BITS(HIGH_BITS),
  .LOG2X(LOG2X),
  .LOG2Y(LOG2Y)
) l_data_l (
	.clk(clk),
	.reset(reset),
	.key_flip(key_flip),
	.key_flip_d(key_flip_d),
	.cursor_x(cursor_x),
	.cursor_y(cursor_y),
	.data_low(data_low),
	.data_high_lsb(data_high_lsb)
);

life_cnt  #(
  .X(X),
  .Y(Y),
  .LOG2X(LOG2X),
  .LOG2Y(LOG2Y)
) l_cnt (
	.clk(clk),
	.reset(reset),
	.key_nxt(key_nxt),
	.nxt_bit(nxt_bit),
	.cnt(cnt)
);

life_col  #(
  .X(X),
  .Y(Y),
  .LOG2X(LOG2X),
  .LOG2Y(LOG2Y)
) l_col (
	.clk(clk),
	.reset(reset),
	.top_row(data_low[(X-1):0]),
	.cnt(cnt),
	.col(col)
);

endmodule
