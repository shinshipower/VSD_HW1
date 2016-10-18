`timescale 1ns/10ps
`include "top.sv"

module top_tb;
  logic clk,rst;
 
  logic [31:0]instruction;
  logic alu_overflow;
  
  integer i;

  top TOP(.clk(clk), .rst(rst), .instruction(instruction), .alu_overflow(alu_overflow));
  
  //clock gen.
  always #5 clk=~clk;
  
  initial begin
  clk=0;
  rst=1'b1;
  
  #6  rst=1'b0;
  #4  rst=1'b0;
  
  `ifndef prog1
      //default program
      instruction = 32'b0_100010_00010_0000_0000_0000_0000_0111; //MOVI  R2 = 5'b00111
  #35 instruction = 32'b0_101000_00000_00000_0000_0000_0001_000; //ADDI  R0 = R0 + 5'b01000
  #40 instruction = 32'b0_101000_00001_00001_0000_0000_0000_010; //ADDI  R1 = R1 + 5'b00010
  #40 instruction = 32'b0_100000_00011_00000_00001_00000_00001;  //SUB   R3 = R0 - R1
  #40 instruction = 32'b0_100000_00100_00001_00010_00000_00000;  //ADD   R4 = R1 + R2
  #40 instruction = 32'b0_100000_00101_00001_00010_00000_00010;  //AND   R5 = R1 & R2
  #40 instruction = 32'b0_100000_00110_00010_00100_00000_00100;  //OR    R6 = R2 | R4
  #40 instruction = 32'b0_100000_00111_00011_00101_00000_00011;  //XOR   R7 = R3 ^ R5
  #40 instruction = 32'b0_100000_01000_00100_00001_00000_01000;  //SLLI  R8 = R4 << 5'b00001;
  #40 instruction = 32'b0_100000_01001_00001_00010_00000_01011;  //ROTRI R9 = R1 rotate_r 5'b00010
  #40 instruction = 32'b0_101100_01010_00000_0000_0000_0011_111; //ORI   R10 = R0 | 5'b11111
  #40 instruction = 32'b0_101011_01011_00001_0000_0000_0001_010; //XORI  R11 = R1 ^ 5'b01010
  #40 instruction = 32'b0_100000_01100_00011_00001_00000_01001;  //SRLI  R12 = R3 >> 5'b00001
  #40 instruction = 32'b0_100000_00000_00000_00000_00000_01001;  //NOP
  `elsif prog1
      //Design your own test pattern 
      //Note that the time you send a new instruction depends on when the previous instruction is carried out.

  `endif
  
  #10 $display( "done" );

  //test & debug block
  //display register file contents to verify the results
  `ifndef prog1
  assert #0 (TOP.regfile1.rw_reg[2] == 32'd7) $display("instruction 0 correct!"); else $display("instruction 0 failed!");
  assert #0 (TOP.regfile1.rw_reg[0] == 32'd8) $display("instruction 1 correct!"); else $display("instruction 1 failed!");
  assert #0 (TOP.regfile1.rw_reg[1] == 32'd2) $display("instruction 2 correct!"); else $display("instruction 2 failed!");
  assert #0 (TOP.regfile1.rw_reg[3] == 32'd6) $display("instruction 3 correct!"); else $display("instruction 3 failed!");
  assert #0 (TOP.regfile1.rw_reg[4] == 32'd9) $display("instruction 4 correct!"); else $display("instruction 4 failed!");
  assert #0 (TOP.regfile1.rw_reg[5] == 32'd2) $display("instruction 5 correct!"); else $display("instruction 5 failed!");
  assert #0 (TOP.regfile1.rw_reg[6] == 32'd15) $display("instruction 6 correct!"); else $display("instruction 6 failed!");
  assert #0 (TOP.regfile1.rw_reg[7] == 32'd4) $display("instruction 7 correct!"); else $display("instruction 7 failed!");
  assert #0 (TOP.regfile1.rw_reg[8] == 32'd18) $display("instruction 8 correct!"); else $display("instruction 8 failed!");
  assert #0 (TOP.regfile1.rw_reg[9] == 32'd2147483648) $display("instruction 9 correct!"); else $display("instruction 9 failed!");
  assert #0 (TOP.regfile1.rw_reg[10] == 32'd31) $display("instruction 10 correct!"); else $display("instruction 10 failed!");
  assert #0 (TOP.regfile1.rw_reg[11] == 32'd8) $display("instruction 11 correct!"); else $display("instruction 11 failed!");
  assert #0 (TOP.regfile1.rw_reg[12] == 32'd3) $display("instruction 12 correct!"); else $display("instruction 12 failed!");
  `endif

  for( i=0;i<32;i=i+1 ) $display( "register[%d]=%d",i,TOP.regfile1.rw_reg[i] ); 
  #100 $finish;
  end

	initial begin
		$fsdbDumpfile("top.fsdb");
		$fsdbDumpvars;
		#10000000 $finish;
	end
  
endmodule
  
  
