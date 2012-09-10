`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:14:54 09/09/2012 
// Design Name: 
// Module Name:    array2
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
module array2(
	input clk,
	input data_in,
	input l, r, u, d, lu, ld, ru, rd,
	output reg [5:0]cnt,
	output data_out
 );

reg [63:0]data;
wire [1:0]sum1;
wire [1:0]sum2;
wire [1:0]sum3;
wire [3:0]total;
wire new_data;

always @(posedge clk)
begin
	data <= {data[62:0], new_data};
	cnt <= cnt + 1;
end

assign data_out = data[63];
assign sum1 = {1'b0, lu} + {1'b0, u}       + {ru, 1'b0};
assign sum2 = {1'b0, l}  +                   {r,  1'b0};
assign sum3 = {1'b0, ld} + {1'b0, d}       + {rd, 1'b0};
assign total = {1'b0, sum1} + {1'b0, sum2} + {1'b0, sum3};
assign new_data = (total == 4'd3) | (total == 4'd2) & data_in;
endmodule
