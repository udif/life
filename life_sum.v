`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:14:54 09/09/2012 
// Design Name: 
// Module Name:    life_sum 
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
module life_sum #
(
	parameter X=3'd8,
	parameter Y=3'd8,
	parameter LOG2X=3,
	parameter LOG2Y=3
) (
	output new_data,
	input c, l, r, u, d, lu, ld, ru, rd
);

wire [2:0]sum1;

assign sum1 = {2'b0, lu} + {2'b0, u} + {2'b0, ru} + {2'b0, ld} + {2'b0, d} + {2'b0, rd} + {2'b0, l};
// Notice that 2 or 3 must really be 2 or 3 and not 10 or 11 because we can't get those by summing 9 1's.
assign new_data = (sum1[2:1] == 2'd0) & c & r |
                  (sum1 == 3'd2) & ~c & r |
						(sum1 == 3'd2) & c & ~r |
						(sum1[2:1] == 2'd1) & ~c & ~r;

endmodule
