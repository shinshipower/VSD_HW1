`timescale 1ns / 1ps

module ALU_ctrl(Funct, ALU_OP, ALU_Ctrl_Out);

   input [5:0] Funct;
	input [1:0] ALU_OP;
   output wire [3:0] ALU_Ctrl_Out;
	
	////  ALUOP  ////   ////  Function  ////
	//  R-type 10  //   //   add 100000   //
	//  beq    01  //   //   sub 100010   //
	//  else   00  //   //   slt 101010   //
	/////////////////   ////////////////////
	
	///  ALUOP  Function  ALU_Ctrl  ///
	//    10     000000     0000     //
	//    10     100000     0010     //
	//    10     100010     0110     //
	//    10     101010     0111     //
	//    01     XXXXXX     0110     //
	//    00     XXXXXX     0010     //
	///////////////////////////////////
	
	assign ALU_Ctrl_Out[3] = /* add your code here */1'b0;
	assign ALU_Ctrl_Out[2] = /* add your code here */ALU_OP[0] | (ALU_OP[1] & Funct[1]);
	assign ALU_Ctrl_Out[1] = /* add your code here */~ALU_OP[1] | Funct[5];
	assign ALU_Ctrl_Out[0] = /* add your code here */ALU_OP[1] & Funct[3];
	
endmodule
