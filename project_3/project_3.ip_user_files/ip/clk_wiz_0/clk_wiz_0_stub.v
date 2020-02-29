// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2.1 (win64) Build 2288692 Thu Jul 26 18:24:02 MDT 2018
// Date        : Fri Feb 28 18:23:45 2020
// Host        : caplab10 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               N:/Projects/ECE540_Proj_03/project_3/project_3.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk_100, clk_110, clk_157, clk_183, clk_220, reset, 
  locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_100,clk_110,clk_157,clk_183,clk_220,reset,locked,clk_in1" */;
  output clk_100;
  output clk_110;
  output clk_157;
  output clk_183;
  output clk_220;
  input reset;
  output locked;
  input clk_in1;
endmodule
