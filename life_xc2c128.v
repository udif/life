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

module life #
(
	parameter X=8,
	parameter Y=8,
	parameter HIGH_BITS=(X+3), // minimum value
	parameter LOG2X=3,
	parameter LOG2Y=3
) (
	input clk,
	input reset,
        input [2:0]keys,
	output [X-1:0]row,
	output [Y-1:0]col
 );

wire new_data;
wire pipe_out;
wire c, l, r, u, d, lu, ld, ru, rd;
wire [(LOG2X+LOG2Y-1):0]cnt;
wire [(X*Y-1):0]data;
wire nxt_bit;
wire [LOG2X-1:0]cursor_x;
wire [LOG2Y-1:0]cursor_y;

life_data_low  #(
  .X(X),
  .Y(Y),
  .HIGH_BITS(HIGH_BITS),
  .LOG2X(LOG2X),
  .LOG2Y(LOG2Y)
) l_data_l (
	.clk(clk),
	.reset(reset),
	.cell_flip(cell_flip),
	.cursor_x(cursor_x),
	.cursor_y(cursor_y),
	.data_low(data[(X*Y-HIGH_BITS-1):0]),
	.data_high_lsb(data[(X*Y-HIGH_BITS)])
);

life_data_high  #(
  .X(X),
  .Y(Y),
  .HIGH_BITS(HIGH_BITS),
  .LOG2X(LOG2X),
  .LOG2Y(LOG2Y)
) l_data_h (
	.clk(clk),
	.reset(reset),
	.nxt_bit(nxt_bit),
	.cell_flip(cell_flip),
	.pipe_out(pipe_out),
	.cursor_x(cursor_x),
	.cursor_y(cursor_y),
	.data_low_lsb(data[0]),
	.data_high(data[(X*Y-1):(X*Y-HIGH_BITS)])
);

life_cursor  #(
  .X(X),
  .Y(Y),
  .LOG2X(LOG2X),
  .LOG2Y(LOG2Y)
) l_cursor (
	.clk(clk),
	.reset(reset),
	.keys(keys),
	.cursor_x(cursor_x),
	.cursor_y(cursor_y)
);

life_cnt  #(
  .X(X),
  .Y(Y),
  .LOG2X(LOG2X),
  .LOG2Y(LOG2Y)
) l_cnt (
	.clk(clk),
	.reset(reset),
	.keys(keys),
	.nxt_bit(nxt_bit),
	.cnt(cnt)
);

life_row  #(
  .X(X),
  .Y(Y),
  .LOG2X(LOG2X),
  .LOG2Y(LOG2Y)
) l_row (
	.clk(clk),
	.reset(reset),
	.cnt(cnt),
	.row(row)
);

life_col  #(
  .X(X),
  .Y(Y),
  .LOG2X(LOG2X),
  .LOG2Y(LOG2Y)
) l_col (
	.clk(clk),
	.reset(reset),
	.cnt(cnt),
	.top_row(data[X-1:0]),
	.col(col)
);

life_neighbour  #(
  .X(X),
  .Y(Y),
  .LOG2X(LOG2X),
  .LOG2Y(LOG2Y)
) l_n (
	.data(data),
	.cnt(cnt),
	.c(c), .l(l), .r(r), .u(u), .d(d),
	.lu(lu), .ld(ld), .ru(ru), .rd(rd)
);

life_sum  #(
  .X(X),
  .Y(Y),
  .LOG2X(LOG2X),
  .LOG2Y(LOG2Y)
) l_sum (
	.new_data(new_data),
	.c(c), .l(l), .r(r), .u(u), .d(d),
	.lu(lu), .ld(ld), .ru(ru), .rd(rd)
);

life_pipe  #(
  .X(X),
  .Y(Y),
  .LOG2X(LOG2X),
  .LOG2Y(LOG2Y)
) l_pipe (
	.clk(clk),
	.reset(reset),
	.new_data(new_data),
	.pipe_out(pipe_out)
);
endmodule
