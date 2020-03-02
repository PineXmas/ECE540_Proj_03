`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date:		01-Sep-2016
// Author:			Roy Kravitz, Portland State University
//
// Module Name:		control_unit 
// Project Name:	New ECE 540 Project 3
// Target Devices: 
// Tool versions: 
// Description:
// 	Control logic for ECE540 Project 3.  Translates button presses into load signal
//	for the operand and result registers and generates the select for the display mux(es)
//
// Dependencies: 	NONE
//
// Revision:		0.1 - File Created 
// 
//////////////////////////////////////////////////////////////////////////////////
module control_unit
#(
	N_INPUTS				= 20
)
(
	input 			clk,		// input clock
	input			reset,		// reset signal (asserted high)
	input			nextBtn,	// "next" and "previous" buttons.  Asserted high when a button is pressed
	input			prevBtn,	//
	output	[N_INPUTS     : 0]	load,
	output	[N_INPUTS     : 0]	mux_sel, //mux_sel[0] is for result
	output						loadResult
);

reg					nextB_d, prevB_d;			// next and previous buttons delayed by a cycle
												// used to make sure the buttons are asserted for a single cycle
wire				nextBtn_int, prevBtn_int;	// next and previous buttons conditioned for single cycle	

reg	[N_INPUTS : 0]	state;
											

// turn nextBtn and prevBtn into single cycle pulses
always @(posedge clk) begin
	if (reset) begin
		nextB_d <= 1'b0;
		prevB_d <= 1'b0;
	end
	else begin
		nextB_d <= nextBtn;
		prevB_d <= prevBtn;
	end
end
assign nextBtn_int = nextBtn & ~nextB_d;
assign prevBtn_int = prevBtn & ~prevB_d;

// shift register control
always @(posedge clk) begin
	if (reset) begin
		state <= {1'b1, {N_INPUTS{1'b0}}};//;  {3'b100};			// initialize state to load A operand register
	end
	else if (nextBtn_int) begin
		state <= { state[0],(state >> 1)};//{state[0], state[2:1]};	// rotate right 1 bit
	end else if (prevBtn_int) begin
		state <=  { (state << 1), state[N_INPUTS]}; //{state[1:0], state[2]};	// rotate left 1 bit
	end
	else begin
		state <= state;						// no button presses so retain state
	end
end // shift register control

// generate control signals from the sstate register
assign load = state;
assign loadResult = state[0];
assign mux_sel = state;


endmodule