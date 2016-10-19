`timescale 1ns / 10ps //Modified as VSD needed

module Reg(CLK, RST, RS_ID, RT_ID, Reg_W_ID, Reg_Write, Reg_WData, Reg_RData1, Reg_RData2);

	input CLK, RST;
	input [4:0] RS_ID, RT_ID, Reg_W_ID;
	input Reg_Write;
	input [15:0] Reg_WData;
	output [15:0] Reg_RData1;
	output [15:0] Reg_RData2;
	logic [31:0] rw_reg [31:0];
	integer i;
	
	assign Reg_RData1 = rw_reg[ RS_ID ];
	assign Reg_RData2 = rw_reg[ RT_ID ];
	
	always@(posedge CLK and posedge RST) begin
			if(RST) begin
				for (i = 0 ; i < 32; i = i+1) begin
					rw_reg[i] = d'0;
				end			
			end
			else begin
				rw_reg[ Reg_W_ID ] <= Reg_Write ? Reg_WData : rw_reg[ Reg_W_ID ];
			end
	end

endmodule
