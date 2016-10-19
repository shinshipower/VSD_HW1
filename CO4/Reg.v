`timescale 1ns / 10ps

module Reg(CLK, RST, RS_ID, RT_ID, Reg_W_ID, Reg_Write, Reg_WData, Reg_RData1, Reg_RData2);

	input CLK, RST;
	input [4:0] RS_ID, RT_ID, Reg_W_ID;
	input Reg_Write;
	input [31:0] Reg_WData;
	output [31:0] Reg_RData1;
	output [31:0] Reg_RData2;
	logic [31:0] rw_reg [31:0]; // this is modified for VSD acquire
	reg signed [31:0] Reg_RData1;
	reg signed [31:0] Reg_RData2;
	integer i;	

	//assign Reg_RData1 = Register[ RS_ID ];
	//assign Reg_RData2 = Register[ RT_ID ];
	
	always@(negedge CLK) begin
			if(!RST) begin
				rw_reg[ Reg_W_ID ] <= Reg_Write ? Reg_WData : Register[ Reg_W_ID ];
			end
			else begin
				rw_reg[ Reg_W_ID] <= d'0;
			end
	end

	always@(posedge CLK) begin
			if(!RST) begin
				Reg_RData1 = rw_reg[ RS_ID ];
				Reg_RData2 = rw_reg[ RT_ID ];
			end
			else begin
				Reg_RData1 = d'0;
				Reg_RData2 = d'0;
			end
	end
	
	always@(posedge RST) begin
			if(RST) begin
				for(i = 0; i<32; i=i+1) begin
					rw_reg[i] <= d'0;
				end
			end
	end
	
	
endmodule
