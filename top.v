`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:14:54 09/09/2012 
// Design Name: 
// Module Name:    top
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
module top;

parameter X=16;
parameter Y=16;
parameter LOG2X=4;
parameter LOG2Y=4;



reg clk, reset;
reg key_nxt, key_flip, key_down, key_up, key_left, key_right;
wire [X-1:0]row;
wire [Y-1:0]col;
integer i, j, g;

reg [(X*Y-1):0]disp_array;

life  #(
  .X(X),
  .Y(Y),
  .HIGH_BITS(32),
  .LOG2X(LOG2X),
  .LOG2Y(LOG2Y)
) l (
	.clk(clk),
	.reset(reset),
	.keys(keys),
	.row(row),
	.col(col)
);

initial
begin
	clk <= 1'b0;
	reset <= 1'b0;
	#15 reset <= 1'b1;
end

always
	#10 clk <= ~clk;

initial
begin
	#20
	top.l.l_data_l.data_low[8*X+7] = 1'b1;
	top.l.l_data_l.data_low[8*X+8] = 1'b1;
	top.l.l_data_l.data_low[8*X+9] = 1'b1;
	top.l.l_data_l.data_low[7*X+8] = 1'b1;
	top.l.l_data_l.data_low[9*X+8] = 1'b1;
end

always @(posedge clk)
begin
	for (i = 0; i < Y; i = i + 1)
		if (row[i])
			disp_array[(i*X) +: X] <= col;
end

task display_data;
begin
	for (i = 0; i < Y; i = i + 1)
	begin
		for (j = 0; j < X; j = j + 1)
			$write("%d ", disp_array[i*X+j]);
		$write("\n");
	end
end
endtask
		
initial
begin
	$display("dumping");
	$dumpfile("life.lxt");
	$dumpvars(0, top);
	$dumpon;
	key_left = 1'b0;
	key_right = 1'b0;
	key_down = 1'b0;
	key_up = 1'b0;
	key_flip = 1'b0;
	key_nxt = 1'b0;
	repeat(X*Y)
		@(posedge clk);
	for (g = 0; g < 15; g = g + 1)
	begin
		$display ("Gen %d", g);
		display_data();
	repeat(X*Y)
		@(posedge clk);
	end
	$finish;
end

initial
begin
	repeat (5)
		@(posedge clk);
	repeat (10)
	begin
		key_nxt <= 1'b0;
		@(posedge clk);
		key_nxt <= 1'b1;
		repeat (X*Y-1)
			@(posedge clk);
	end
end
	
endmodule
