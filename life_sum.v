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

wire [1:0]sum1, sum2, sum3;
wire [2:0]total;

assign sum1 = {1'b0, lu} + {1'b0, u} + {ru, 1'b0};
assign sum2 = {1'b0, l}  +             {r,  1'b0};
assign sum3 = {1'b0, ld} + {1'b0, d} + {rd, 1'b0};
// Notice we throw the 4th bit even though the sum can be 8 or 9
assign total = {1'b0, sum1} + {1'b0, sum2} + {1'b0, sum3};
// Notice that 2 or 3 must really be 2 or 3 and not 10 or 11 because we can't get those by summing 9 1's.
assign new_data = (total == 3'd3) | (total == 3'd2) & c;

endmodule
