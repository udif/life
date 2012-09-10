`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:14:54 09/09/2012 
// Design Name: 
// Module Name:    array 
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
module array1(
	input clk,
	input data_in,
	input [5:0]cnt,
	output data_out,
	//output [2:0]x,
	//output [2:0]y,
	output l, r, u, d, lu, ld, ru, rd
 );

reg [63:0]data;
//reg [5:0]cnt;
wire [2:0]x;
wire [2:0]y;
always @(posedge clk)
begin
	data <= {data[62:0], data_in};
	//cnt <= cnt + 1;
end

// [lu] [u]        [ru]
// [l]  [data_out] [r]
// [ld] [d]        [rd]

assign data_out = data[63];
assign x = cnt[2:0];
assign y = cnt[5:3];
assign r = (x == 3'd7) ? 1'b0 : data[0];
assign l = (x == 3'd0) ? 1'b0 : data[62];
assign d = (y == 3'd7) ? 1'b0 : data[7];
assign u = (y == 3'd0) ? 1'b0 : data[55];
assign rd = ((x == 3'd7) || (y == 3'd7)) ? 1'b0 : data[8];
assign ld = ((x == 3'd0) || (y == 3'd7)) ? 1'b0 : data[6];
assign ru = ((x == 3'd7) || (y == 3'd0)) ? 1'b0 : data[56];
assign lu = ((x == 3'd0) || (y == 3'd0)) ? 1'b0 : data[54];

endmodule
