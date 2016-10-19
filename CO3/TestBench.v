`timescale 1ns / 1ps
`define test_file "test1.txt"
`define total_cycles 10 //2 cycles
`include "CPU.v"

module TestBench();

	reg CLK, START;
	reg [15:0] count;
	integer i;
	
	CPU i_CPU(CLK, START);
	
	initial begin
		CLK = 0;
		START = 0;
		count = 0;
		for(i = 0; i < 32; i = i + 1)
			i_CPU.i_IM.InstrMemory[i] = 0;
		$readmemb(`test_file, i_CPU.i_IM.InstrMemory);

		for(i = 0; i < 8; i = i + 1) begin
			i_CPU.i_Reg.Register[i] = 0;
			i_CPU.i_DM.DataMemory[i] = 0;
		end
			
		#5
		//start
		#(`total_cycles * 10)
		//running
		#5
		//end
		$stop;
	end
	
	always #5 CLK = ~CLK;
	
	always@(posedge CLK) begin
		if(START == 0)
			START <= 1;
		else
			START <= START;
	end
	
	always@(posedge CLK) begin
		if(START == 1 && count > 0) begin
			#1
			$write("After %0dth cycle:\n", count);
			for(i = 0; i < 8; i = i + 1)
				$write("Reg[%0d] = %0d    ", i, i_CPU.i_Reg.Register[i]);
			$write("\n");
			for(i = 0; i < 8; i = i + 1)
				$write("DM[%0d] = %0d    ", i, i_CPU.i_DM.DataMemory[i]);
			$write("\n\n");
			count <= count + 1;
		end
		else begin
			#1
			count <= count + 1;
		end
	end

endmodule
