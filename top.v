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

parameter X=8;
parameter Y=8;
parameter LOG2X=3;
parameter LOG2Y=3;



reg clk, reset;
reg key_nxt, key_flip, key_down, key_up, key_left, key_right;
wire [X-1:0]row;
wire [Y-1:0]col;
integer i, j, g;

reg [(X*Y-1):0]disp_array;

life  #(
  .X(X),
  .Y(Y),
  .LOG2X(LOG2X),
  .LOG2Y(LOG2Y)
) l (
	.clk(clk),
	.reset(reset),
	.key_nxt(key_nxt),
	.key_flip(key_flip),
	.key_down(key_down),
	.key_up(key_up),
	.key_left(key_left),
	.key_right(key_right),
	.row(row),
	.col(col)
);

initial
begin
	clk <= 1'b0;
	reset <= 1'b0;
	#15 reset <= 1'b1;
	repeat (1000)
		#10 clk <= ~clk;
end

initial
begin
	#20
	top.l.l_data.data[4*X+4] = 1'b1;
	top.l.l_data.data[4*X+5] = 1'b1;
	top.l.l_data.data[4*X+6] = 1'b1;
	top.l.l_data.data[5*X+6] = 1'b1;
	top.l.l_data.data[6*X+5] = 1'b1;
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
	key_nxt = 1'b1;
	repeat(X*Y)
		@(posedge clk);
	for (g = 0; g < 3; g = g + 1)
	begin
		$display ("Gen %d", g);
		display_data();
		repeat(X*Y)
			@(posedge clk);
	end
end
	
endmodule
