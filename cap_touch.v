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
	input clk_in, reset,
	input key_up,
	input key_down,
	input key_left,
	input key_right,
	input key_flip,
	input key_nxt,
	output reg [2:0]keys,
	output lfsr_done, lfsr2_done,
	output reg clk
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
reg [2:0]keys_static;
reg [2:0]keys_static_d;

wire lfsr_0_next = lfsr[9] ~^ lfsr[6];
wire lfsr2_0_next = lfsr2[6] ~^ lfsr2[5];

assign lfsr_done  = (lfsr  == 10'h200);
assign lfsr2_done = (lfsr2 == 7'h40);

always @(posedge clk_in)
begin
	//
	// Main prescaler - divide by 1023
	//
	if (~reset)
		lfsr <= 10'd0;
	else if (lfsr_done)
		lfsr <= 10'd0;
	else
		lfsr <= {lfsr[8:0], lfsr_0_next};

	//
	// clock output
	//
	if (~reset)
		clk <= 1'b0;
	else if (lfsr_done)
		clk <= ~clk;

	//
	// 2nd prescaler for debounce delay
	//
	if (~reset)
		lfsr2 <= 7'd0;
//	else if (!key_up && !key_down && !key_left && !key_right && !key_flip && !key_nxt)
	else if (keys == `KEY_IDLE)
		lfsr2 <= 7'd0;
	else if (lfsr2_done)
		lfsr2 <= 7'd0;
	// Increment when 1st prescaler wraps around
	else if (lfsr_done)
		lfsr2 <= {lfsr2[5:0], lfsr2_0_next};
	//
	// Debounce logic:
	//
	// Set when key pulse received
	// Cleared when lfsr2 is done
	// Holds otherwise
	//
	keys_static <=
		~reset ? `KEY_IDLE :
		(((keys == `KEY_UP)    & ~lfsr2_done) | ~key_up)    ? `KEY_UP    :
		(((keys == `KEY_DOWN)  & ~lfsr2_done) | ~key_down)  ? `KEY_DOWN  :
		(((keys == `KEY_LEFT)  & ~lfsr2_done) | ~key_left)  ? `KEY_LEFT  :
		(((keys == `KEY_RIGHT) & ~lfsr2_done) | ~key_right) ? `KEY_RIGHT :
		(((keys == `KEY_FLIP)  & ~lfsr2_done) | ~key_flip)  ? `KEY_FLIP  :
		(((keys == `KEY_NXT)   & ~lfsr2_done) | ~key_nxt)   ? `KEY_NXT   : 3'd0;
	keys_static_d <= ~reset ? `KEY_IDLE : (lfsr_done && clk) ? keys_static : keys_static_d;

	// generate key event for a single clk cycle, update on falling edge
	keys <=
		~reset ? `KEY_IDLE :
		// Change only on falling edge of external clock
		(!(lfsr_done && clk)) ? keys :
		// if keys change from idle to non-idle, use them, otherwise go to idle
		((keys_static_d == `KEY_IDLE) && (keys_static != `KEY_IDLE)) ? keys_static : `KEY_IDLE;
		
end

endmodule
