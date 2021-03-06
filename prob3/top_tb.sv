`timescale 1ns/10ps
`include "IM.sv"
`include "DM.sv"
`include "top.sv"


module top_tb;

  logic clk;
  logic rst;
  integer i;
  
  logic [31:0]ir;

  //IM
  logic IM_read, IM_enable;
  logic [9:0] IM_address;
  
  //DM
  logic DM_read , DM_write , DM_enable;
  logic [31:0] DM_in;
  logic [11:0] DM_address;
  logic [31:0] DM_out;
 
  top TOP(.clk(clk), .rst(rst) , .instruction(ir) , .IM_read(IM_read) , .IM_enable(IM_enable) , .IM_address(IM_address) , .DM_out(DM_out) , .DM_read(DM_read) , .DM_write(DM_write) , .DM_enable(DM_enable) , .DM_address(DM_address) ,  .DM_in(DM_in)); 
 
  DM DM1(   .clk(clk),
            .rst(rst),
  			.DM_read(DM_read),
  			.DM_write(DM_write),
  			.DM_enable(DM_enable),
  			.DM_in(DM_in),
  			.DM_out(DM_out),
  			.DM_address(DM_address));

  IM IM1(   .clk(clk),
  			.rst(rst),
  			.IM_address(IM_address),
  			.IM_read(IM_read),
  			.IM_write(),
  			.IM_enable(IM_enable),
  			.IM_in(),
  			.IM_out(ir)); 
  
  
  
  //clock gen.
  always #5 clk=~clk;
  
 initial begin
  clk=0;
  rst=1'b1;
  #20 rst=1'b0;

  `ifdef prog0
  $readmemb("mins.prog",IM1.mem_data);
  `elsif prog1
  $readmemb("mins.prog.a1",IM1.mem_data);
  `elsif prog2
  $readmemb("mins.prog.a2",IM1.mem_data);
  `endif
       
  	#2000
      $display( "done" );
      //debug
      //for( i=0;i<31;i=i+1 ) $display( "IM[%h]=%h",i,IM1.mem_data[i] ); 
      for( i=0;i<32;i=i+1 ) $display( "register[%d]=%d",i,TOP.regfile1.rw_reg[i] ); 
      //for( i=0;i<31;i=i+1 ) $display( "DM[%d]=%d",i,DM1.mem_data[i] );
            
      $finish;
  end
  
  initial begin
  $fsdbDumpfile("top.fsdb");
  $fsdbDumpvars(0, top_tb);
  #10000000 $finish;
  end
endmodule
