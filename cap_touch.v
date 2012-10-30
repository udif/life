`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:23:59 10/18/2012 
// Design Name: 
// Module Name:    cap_touch 
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
module cap_touch(
	input clk, reset,
	input key_up,
	input key_down,
	input key_left,
	input key_right,
	output reg [2:0]keys,
	output reg clk_1, clk_2
);


//
// The LFSR constants were taken from automatically generated code by:
// http://outputlogic.com/?page_id=275
// This requires the following copyright message
// The code itself was not used

//-----------------------------------------------------------------------------
// Copyright (C) 2009 OutputLogic.com
// This source file may be used and distributed without restriction
// provided that this copyright statement is not removed from the file
// and that any derivative work contains the original copyright notice
// and the associated disclaimer.
//
// THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS
// OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
// WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
//-----------------------------------------------------------------------------

`include "key_codes.vh"

reg [9:0]lfsr;
reg [6:0]lfsr2;

wire phase_1 = (lfsr == 10'hbe);
wire phase_2 = (lfsr == 10'h2d);
wire phase_3 = (lfsr == 10'h200);

wire lfsr_0_next = lfsr[9] ~^ lfsr[6];
always @(posedge clk)
begin
	if (reset)
		lfsr <= 10'd0;
	else if (!key_up && !key_down && !key_left)
		lfsr <= 10'd0;
	else if (!phase_3)
	begin
		lfsr <= {lfsr[8:0], lfsr_0_next};
	end
	keys <= reset ? 3'd0 :
	        (((keys == `KEY_UP)    & ~phase_3) | key_up)    ? `KEY_UP    :
	        (((keys == `KEY_DOWN)  & ~phase_3) | key_down)  ? `KEY_DOWN  :
	        (((keys == `KEY_LEFT)  & ~phase_3) | key_left)  ? `KEY_LEFT  :
	        (((keys == `KEY_RIGHT) & ~phase_3) | key_right) ? `KEY_RIGHT : 3'd0;

	if (reset)
	begin
		clk_1 <= 1'b0;
		clk_2 <= 1'b0;
	end
	else if (phase_1)
	begin
		clk_1 <= 1'b1;
		clk_2 <= 1'b0;
	end
	else if (phase_2)
	begin
		clk_1 <= 1'b0;
		clk_2 <= 1'b1;
	end
	else if (phase_3)
	begin
		clk_1 <= 1'b0;
		clk_2 <= 1'b0   ;
	end
end

wire lfsr2_done = (lfsr == 10'h200);
wire lfsr2_0_next = lfsr[9] ~^ lfsr[6];
always @(posedge clk)
begin
	if (reset)
	begin
		lfsr2 <= 7'd0;
	end
	else if (!key_up && !key_down && !key_left)
		lfsr2 <= 7'd0;
	else if (!lfsr2_done)
	begin
		lfsr2 <= {lfsr2[8:0], lfsr_0_next};
	end
end

endmodule
