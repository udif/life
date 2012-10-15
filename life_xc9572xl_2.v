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
module life_2 #
(
	parameter X=8,
	parameter Y=8,
	parameter HIGH_BITS=(X+3), // minimum value is (X+3)
	parameter LOG2X=3,
	parameter LOG2Y=3
) (
	input clk,
	input reset,
	input nxt_bit,
	output key_flip_d,
	input key_flip, key_down, key_up, key_left, key_right,
	input data_low_lsb,
	input [2:0]data_low_X_XM2,
	input [(LOG2X+LOG2Y-1):0]cnt,
	output [X-1:0]row,
	output data_high_lsb
 );

wire new_data;
wire pipe_out;
wire c, l, r, u, d, lu, ld, ru, rd;
wire [LOG2X-1:0]cursor_x;
wire [LOG2Y-1:0]cursor_y;
wire [(X*Y-1):(X*Y-HIGH_BITS)]data_high;
reg [(X*Y-1):0]data;

assign data_high_lsb = data_high[(X*Y-HIGH_BITS)];

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
	.key_flip(key_flip),
	.key_flip_d(key_flip_d),
	.pipe_out(pipe_out),
	.cursor_x(cursor_x),
	.cursor_y(cursor_y),
	.data_low_lsb(data_low_lsb),
	.data_high(data_high)
);

life_cursor  #(
  .X(X),
  .Y(Y),
  .LOG2X(LOG2X),
  .LOG2Y(LOG2Y)
) l_cursor (
	.clk(clk),
	.reset(reset),
	.key_down(key_down),
	.key_up(key_up),
	.key_left(key_left),
	.key_right(key_right),
	.cursor_x(cursor_x),
	.cursor_y(cursor_y)
);

always @(*)
begin
	data = {(X*Y){1'b0}};
	data[(X*Y-1):(X*Y-HIGH_BITS)] = data_high;
	data[X:(X-2)] = data_low_X_XM2;
	data[0] = data_low_lsb;
end

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

endmodule
