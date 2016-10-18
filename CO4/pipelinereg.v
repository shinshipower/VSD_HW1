`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:02:59 11/28/2012 
// Design Name: 
// Module Name:    pipelinereg 
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
module pipelinereg(CLK,reg_in,reg_out);
	parameter size=0;
	input CLK;
	input [size-1:0] reg_in;
	output [size-1:0] reg_out;
	reg [size-1:0] reg_out;
	
	initial begin
		reg_out=0;
	end
	
	always@(posedge CLK) begin
		reg_out<=reg_in;
	end


endmodule
