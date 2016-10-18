`timescale 1ns/10ps
`include "IM.sv"
`include "top.sv"

module top_tb;
  logic clk,rst;
 
  logic [31:0]instruction;
  logic IM_read , IM_enable;
  logic [9:0]IM_address; 
  
  integer i;

  top TOP(.clk(clk), .rst(rst) , .instruction(instruction) , .IM_read(IM_read) , .IM_enable(IM_enable) , .IM_address(IM_address));
  IM IM1(.clk(clk), .rst(rst), .IM_read(IM_read) , .IM_write() , .IM_enable(IM_enable) , .IM_in() , .IM_address(IM_address) , .IMout(instruction));
  
  //clock gen.
  always #5 clk=~clk;

  initial begin
  clk=0;
  rst=1'b1;
  
  #6  rst=1'b0;
  #4  rst=1'b0; 
  
  `ifdef prog0 //default program
  $readmemb("mins.prog",IM1.mem_data);
  `elsif prog1
  $readmemb("mins.prog.a1",IM1.mem_data);
  `elsif prog2
  $readmemb("mins.prog.a2",IM1.mem_data);
  `endif
  
  #3000 $display( "done" );
  `ifdef prog0
  assert #0 (TOP.regfile1.rw_reg[0] == 32'd11) $display("instruction 0 correct!"); else $display("instruction 0 failed!");
  assert #0 (TOP.regfile1.rw_reg[1] == 32'd4) $display("instruction 1 correct!"); else $display("instruction 1 failed!");
  assert #0 (TOP.regfile1.rw_reg[2] == 32'd15) $display("instruction 2 correct!"); else $display("instruction 2 failed!");
  assert #0 (TOP.regfile1.rw_reg[3] == 32'd7) $display("instruction 3 correct!"); else $display("instruction 3 failed!");
  assert #0 (TOP.regfile1.rw_reg[4] == 32'd15) $display("instruction 4 correct!"); else $display("instruction 4 failed!");
  assert #0 (TOP.regfile1.rw_reg[14] == 32'd7) $display("instruction 5 correct!"); else $display("instruction 5 failed!");
  assert #0 (TOP.regfile1.rw_reg[5] == 32'd7) $display("instruction 6 correct!"); else $display("instruction 6 failed!");
  assert #0 (TOP.regfile1.rw_reg[6] == 32'd15) $display("instruction 7 correct!"); else $display("instruction 7 failed!");
  assert #0 (TOP.regfile1.rw_reg[7] == 32'd8) $display("instruction 8 correct!"); else $display("instruction 8 failed!");
  assert #0 (TOP.regfile1.rw_reg[8] == 32'd60) $display("instruction 9 correct!"); else $display("instruction 9 failed!");
  assert #0 (TOP.regfile1.rw_reg[9] == 32'd67108864) $display("instruction 10 correct!"); else $display("instruction 10 failed!");
  assert #0 (TOP.regfile1.rw_reg[10] == 32'd31) $display("instruction 11 correct!"); else $display("instruction 11 failed!");
  assert #0 (TOP.regfile1.rw_reg[11] == 32'd14) $display("instruction 12 correct!"); else $display("instruction 12 failed!");
  assert #0 (TOP.regfile1.rw_reg[12] == 32'd3) $display("instruction 12 correct!"); else $display("instruction 13 failed!");
  `endif
  
  //test & debug block
  //display register file contents to verify the results
  for( i=0;i<32;i=i+1 ) $display( "register[%d]=%d",i,TOP.regfile1.rw_reg[i] ); 
  #100 $finish;
  end

	initial begin
		$fsdbDumpfile("top.fsdb");
		$fsdbDumpvars;
		#10000000 $finish;
	end
  
endmodule
  
  
