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
module life #
(
	parameter X=3'd8,
	parameter Y=3'd8,
	parameter LOG2X=3,
	parameter LOG2Y=3
) (
	input clk,
	output [(X*Y-1):0]data
 );

wire new_data;
wire pipe_out;
wire c, l, r, u, d, lu, ld, ru, rd;

life_data  #(
  .X(X),
  .Y(Y),
  .LOG2X(LOG2X),
  .LOG2Y(LOG2Y)
) l_d (
	.clk(clk),
	.data(data)
);

life_cnt  #(
  .X(X),
  .Y(Y),
  .LOG2X(LOG2X),
  .LOG2Y(LOG2Y)
) l_c (
	.clk(clk),
	.cnt(cnt)
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
) l_s (
	.new_data(new_data),
	.c(c), .l(l), .r(r), .u(u), .d(d),
	.lu(lu), .ld(ld), .ru(ru), .rd(rd)
);

life_pipe  #(
  .X(X),
  .Y(Y),
  .LOG2X(LOG2X),
  .LOG2Y(LOG2Y)
) l_p (
	.clk(clk),
	.new_data(new_data),
	.pipe_out(pipe_out)
);
endmodule
