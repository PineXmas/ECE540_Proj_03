// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Sun Mar  1 23:20:02 2020
// Host        : Pine-Ripper running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk_100, clk_110, clk_157, clk_183, clk_220, 
  clk_275, reset, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_100,clk_110,clk_157,clk_183,clk_220,clk_275,reset,clk_in1" */;
  output clk_100;
  output clk_110;
  output clk_157;
  output clk_183;
  output clk_220;
  output clk_275;
  input reset;
  input clk_in1;
endmodule
