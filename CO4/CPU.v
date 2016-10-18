`timescale 1ns / 1ps

module CPU(CLK, START);

	input CLK, START;
	//PC and Instruction memory net
	wire [15:0] PC_In;
	wire [15:0] PC_Out;
	wire [25:0] Instr;
	
	wire [25:0] InstrID;
	
	//Register file net
	wire [2:0] RS_ID, RT_ID, RT_ID_EX, RD_ID, RD_ID_EX, Reg_W_ID;
	wire [15:0] Reg_RData1,Reg_RData1_EX, Reg_RData2,Reg_RData2_EX,Reg_RData2_MEM, Reg_WData;
	
	//Decoder(Control) net
	wire [5:0] OP;
	wire Reg_Dst;
	wire Jump;
	wire Branch;
	wire Mem_Read;
	wire Mem_to_Reg;
	wire [1:0] ALU_OP;
	wire Mem_Write;
	wire ALU_Src;	
	wire Reg_Write;
	
	wire Reg_Dst_EX;
	wire Jump_EX;
	wire Branch_EX;
	wire Mem_Read_EX;
	wire Mem_to_Reg_EX;
	wire [1:0] ALU_OP_EX;
	wire Mem_Write_EX;
	wire ALU_Src_EX;	
	wire Reg_Write_EX;
	
	wire Jump_MEM;
	wire Branch_MEM;
	wire Mem_Read_MEM;
	wire Mem_Write_MEM;
	wire Mem_to_Reg_MEM;
	wire Reg_Write_MEM;
	
	wire Mem_to_Reg_WB;
	wire Reg_Write_WB;
	


	
	
	//Sign-extend net
	wire [13:0] Immediate_In;
	wire [15:0] Extend_Sign,Extend_Sign_EX;
	
	//ALU control net
	wire [5:0] Funct;
	wire [5:0] Funct_EX;
	wire [3:0] ALU_Ctrl_Out;
	
	//ALU net
	wire [15:0] ALU_Src1, ALU_Src2, ALU_Result, ALU_Result_MEM, ALU_Result_WB;
	wire Zero, Zero_MEM;
	
	//Data memory net
	wire [15:0] DM_RData, DM_WData, Address,DM_RData_WB;
	
	//MUXs net
	wire [15:0] MUX_Src2_to_ALU;
	wire [15:0] MUX_Mem_to_Reg_Out;
	wire [2:0]  MUX_Inst_to_Reg, MUX_Inst_to_Reg_MEM, MUX_Inst_to_Reg_WB;
	wire [15:0] MUX_Branch_Out;
	wire [15:0] MUX_Jump_Out;
	wire [15:0] Jump_Address, Jump_Address_EX, Jump_Address_MEM;
	
	//Adders net
	wire [15:0] PC_Count_Add_Src1, PC_Count_Add_Src2, PC_Count_Add_Result,PC_Count_Add_Result_ID,PC_Count_Add_Result_EX;
	wire [15:0] Branch_Add_Src1, Branch_Add_Src2, Branch_Add_Result, Branch_Add_Result_MEM;
	
	//Other net
	wire Branch_Select;
	
	//Old module
	PC i_PC(CLK, START, PC_In, PC_Out);
	
	IM i_IM(START, PC_Out, Instr);
	
	Reg i_Reg(CLK, RS_ID, RT_ID, Reg_W_ID, Reg_Write_WB, Reg_WData, Reg_RData1, Reg_RData2);
	
	Decoder i_Decoder(OP, Reg_Dst, Jump, Branch, Mem_Read, Mem_to_Reg, ALU_OP, Mem_Write, ALU_Src, Reg_Write);
	
	sign_extend i_Sign_Extend(Immediate_In, Extend_Sign);
	
	ALU_ctrl i_ALU_Ctrl(Funct_EX, ALU_OP_EX, ALU_Ctrl_Out);
	
	ALU i_ALU(ALU_Src1, ALU_Src2, ALU_Ctrl_Out, ALU_Result, Zero);
	
	DM i_DM(CLK, Address, Mem_Write_MEM, Mem_Read_MEM, DM_WData, DM_RData);
	
	MUX_2_to_1 #(.size(16))MUX_Mem_to_Reg(ALU_Result_WB, DM_RData_WB, Mem_to_Reg_WB, MUX_Mem_to_Reg_Out);
	
	MUX_2_to_1 #(.size(3)) MUX_Reg_Dst(RT_ID_EX, RD_ID_EX, Reg_Dst_EX, MUX_Inst_to_Reg);
	
	MUX_2_to_1 #(.size(16))MUX_ALUSrc(Reg_RData2_EX, Extend_Sign_EX, ALU_Src_EX, MUX_Src2_to_ALU);
	
	//New module
	MUX_2_to_1 #(.size(16))MUX_Branch(PC_Count_Add_Result, Branch_Add_Result_MEM, Branch_Select, MUX_Branch_Out);
	
	MUX_2_to_1 #(.size(16))MUX_Jump(MUX_Branch_Out, Jump_Address_MEM, Jump_MEM, MUX_Jump_Out);
	
	Add PC_Count_Add(PC_Count_Add_Src1, PC_Count_Add_Src2, PC_Count_Add_Result);
	
	Add Branch_Add(Branch_Add_Src1, Branch_Add_Src2, Branch_Add_Result);
	
	
	//Pipe Announcement
	pipelinereg #(.size(26)) pipeInstr(CLK,Instr,InstrID);
	
	pipelinereg #(.size(16)) pipePC(CLK,PC_Count_Add_Result,PC_Count_Add_Result_ID);
	pipelinereg #(.size(16)) pipePC_ID(CLK,PC_Count_Add_Result_ID,PC_Count_Add_Result_EX);
	
	pipelinereg #(.size(1)) pipeCtrl1(CLK,Reg_Dst,Reg_Dst_EX);
	pipelinereg #(.size(1)) pipeCtrl2(CLK,Jump,Jump_EX);
	pipelinereg #(.size(1)) pipeCtrl3(CLK,Branch,Branch_EX);
	pipelinereg #(.size(1)) pipeCtrl4(CLK,Mem_Read,Mem_Read_EX);
	pipelinereg #(.size(1)) pipeCtrl5(CLK,Mem_to_Reg,Mem_to_Reg_EX);
	pipelinereg #(.size(2)) pipeCtrl6(CLK,ALU_OP,ALU_OP_EX);
	pipelinereg #(.size(1)) pipeCtrl7(CLK,Mem_Write,Mem_Write_EX);
	pipelinereg #(.size(1)) pipeCtrl8(CLK,ALU_Src,ALU_Src_EX);
	pipelinereg #(.size(1)) pipeCtrl9(CLK,Reg_Write,Reg_Write_EX);
	
	pipelinereg #(.size(3)) pipeID1(CLK,RT_ID,RT_ID_EX);
	pipelinereg #(.size(3)) pipeID2(CLK,RD_ID,RD_ID_EX);
	pipelinereg #(.size(16)) pipeID3(CLK,Extend_Sign,Extend_Sign_EX);
	pipelinereg #(.size(6)) pipeID4(CLK,Funct,Funct_EX);
	pipelinereg #(.size(16)) pipeID5(CLK,Reg_RData1,Reg_RData1_EX);
	pipelinereg #(.size(16)) pipeID6(CLK,Reg_RData2,Reg_RData2_EX);
	pipelinereg #(.size(16)) pipeID7(CLK,Jump_Address,Jump_Address_EX);
	
	pipelinereg #(.size(1)) pipeCEX1(CLK,Jump_EX,Jump_MEM);
	pipelinereg #(.size(1)) pipeCEX2(CLK,Branch_EX,Branch_MEM);
	pipelinereg #(.size(1)) pipeCEX3(CLK,Mem_Read_EX,Mem_Read_MEM);
	pipelinereg #(.size(1)) pipeCEX4(CLK,Mem_Write_EX,Mem_Write_MEM);
	pipelinereg #(.size(1)) pipeCEX5(CLK,Mem_to_Reg_EX,Mem_to_Reg_MEM);
	pipelinereg #(.size(1)) pipeCEX6(CLK,Reg_Write_EX,Reg_Write_MEM);
	
	pipelinereg #(.size(16)) pipeEX1(CLK,Jump_Address_EX,Jump_Address_MEM);
	pipelinereg #(.size(16)) pipeEX2(CLK,Branch_Add_Result,Branch_Add_Result_MEM);
	pipelinereg #(.size(1)) pipeEX3(CLK,Zero,Zero_MEM);
	pipelinereg #(.size(16)) pipeEX4(CLK,ALU_Result,ALU_Result_MEM);
	pipelinereg #(.size(16)) pipeEX5(CLK,Reg_RData2_EX,Reg_RData2_MEM);
	pipelinereg #(.size(3)) pipeEX6(CLK,MUX_Inst_to_Reg,MUX_Inst_to_Reg_MEM);
	
	
	
	
	pipelinereg #(.size(1)) pipeCMEM1(CLK,Mem_to_Reg_MEM,Mem_to_Reg_WB);
	pipelinereg #(.size(1)) pipeCMEM2(CLK,Reg_Write_MEM,Reg_Write_WB);
	
	
	pipelinereg #(.size(16)) pipeMEM1(CLK,DM_RData,DM_RData_WB);
	pipelinereg #(.size(16)) pipeMEM2(CLK,ALU_Result_MEM,ALU_Result_WB);
	pipelinereg #(.size(3)) pipeMEM3(CLK,MUX_Inst_to_Reg_MEM,MUX_Inst_to_Reg_WB);
	

	
	
	//PC net assignment
	assign PC_In = MUX_Jump_Out;
	
	//Register file net assignment
	assign RS_ID = InstrID[19:17];
	assign RT_ID = InstrID[16:14];
	assign RD_ID = InstrID[13:11];
	assign Reg_W_ID = MUX_Inst_to_Reg_WB;
	assign Reg_WData = MUX_Mem_to_Reg_Out;
	
	//Decoder(Control) net assignment
	assign OP = InstrID[25:20];
	
	//Sign-extend net assignment
	assign Immediate_In = InstrID[13:0];
	
	//ALU control net assignment
	assign Funct = InstrID[5:0];
	
	//ALU net assignment
	assign ALU_Src1 = Reg_RData1_EX;
	assign ALU_Src2 = MUX_Src2_to_ALU;
	
	//Data memory net assignment
	assign DM_WData = Reg_RData2_MEM;
	assign Address = ALU_Result_MEM;
	
	//MUXs net assignment
	assign Jump_Address = /*add your code here*/ InstrID[15:0];
	
	//Adders net assignment
	assign PC_Count_Add_Src1 = /*add your code here*/ PC_Out
	;
	assign PC_Count_Add_Src2 = /*add your code here*/ 1;
	assign Branch_Add_Src1 = /*add your code here*/ PC_Count_Add_Result_EX;
	assign Branch_Add_Src2 = /*add your code here*/ Extend_Sign_EX;
	
	//Other net assignment
	assign Branch_Select = /*add your code here*/ Branch_MEM & Zero_MEM;
	
	

	
endmodule
