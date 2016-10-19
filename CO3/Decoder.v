`timescale 1ns / 1ps

module Decoder(OP, Reg_Dst, Jump, Branch, Mem_Read, Mem_to_Reg, ALU_OP, Mem_Write, ALU_Src, Reg_Write);

	input [5:0] OP;
	output wire Reg_Dst, Jump, Branch, Mem_Read, Mem_to_Reg, Mem_Write, ALU_Src, Reg_Write;
	output wire [1:0] ALU_OP;
	
	/////  OP Code  /////
	//  R-type 000000  //
	//  load   100011  //
	//  store  101011  //
	//  beq    000100  //
	//  addi   001000  //
	//  j      000010  //
	/////////////////////
	
	assign Reg_Dst = (OP == 6'b000000) ? 1 : 0;
	assign Mem_Read = (OP == 6'b100011) ? 1 : 0;
	assign Mem_to_Reg = (OP == 6'b100011) ? 1 : 0;
	assign Mem_Write = (OP == 6'b101011) ? 1 : 0;
	
	////  ALUOP  ////
	//  R-type 10  //
	//  beq    01  //
	//  else   00  //
	/////////////////
	
	assign ALU_Src = (OP[5]==1'b1 ||OP == 6'b001000)?1:0;
	assign Reg_Write = (OP == 6'b000000 || OP == 6'b 100011 || OP == 6'b001000)?1:0;
	assign Jump = (OP ==6'b000010)?1:0;
	assign Branch = (OP == 6'b000100)?1:0;
	assign ALU_OP = (OP == 6'b000000)?2'b10:
												(
												(OP == 6'b000100)?2'b01:2'b00
												
												
												);
	
endmodule
