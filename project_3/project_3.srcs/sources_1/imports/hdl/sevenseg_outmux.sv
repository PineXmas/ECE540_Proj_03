`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date:		22-Feb-2019
// Author:			Ignacio Genovese based on the design of Roy Kravitz, Portland State University
//
// Module Name:		sevenseg_outmux 
// Project Name:	New ECE 540 Project 3
// Target Devices: 
// Tool versions: 
// Description:
// 	Output multiplexer.  Generates the digits for the 7-segment display depending
//	on the mux select bits.  
//
// This version of the output multiplexer converts the binary inputs to BCD so they are displayed in decimal (base 10).
// The binary to BCD converter code was written by John Clayton and retrieved rom opencores.org:
//  Link: http://opencores.org/project,binary_to_bcd
//
// Dependencies: 	binary_to_bcd.v
//
// Revision:		0.1 - File Created 
// 
// Additional Comments: 
//
// Link: http://verilog-code.blogspot.com/2014/01/design-and-implementation-of-16-bit.html
//////////////////////////////////////////////////////////////////////////////////
module sevenseg_outmux
#(
	parameter			N_INPUTS = 20
)
(
	input					clk,		// system clock
	input					reset,		// system reset
	input	[N_INPUTS : 0]	mux_sel,
	input	[15:0]			operands[N_INPUTS - 1 : 0 ],
	input		[31:0]		result,		// result from multiply
	input  integer          position,
	output	reg	[4:0]		dig7, dig6,	// digits for 7-segment display
							dig5, dig4,	// dig7 is the leftmost digit
							dig3, dig2,	// dig0 is the rightmost digit
							dig1, dig0,
	output	reg	[15:0]		leds,		// led drivers for Nexys4 LEDs
	output	reg	[7:0]		decpts		// decimal points for Nexys 4 7-segment display
);

// internal variables
reg		[31:0]	bcd_converter_in;			// binary value to convert to BCD
wire	[31:0]	bcd_converter_out;			// BCD output from converter
wire			start_conversion;			// start conversion signal to the BCD converter
wire			done_conversion;			// done signal from the BCD converter
reg				truncated;					// result is truncated (e.g. >99999999)

reg		[15:0]	a_dly, b_dly;				// delayed A and B operand registers to detect changes
reg		[31:0]	result_dly;					// delayed result register to detect changes

reg		[15:0]	operands_dly[N_INPUTS - 1 : 0];

//wire			cnvt;						// convert to BCD signal
reg 			cnvt;						// convert to BCD signal
reg				cnvt_ff;					// convert to BCD delay flip-flop	
reg				start_conversion_d;			// start conversion signal delayed	


// instantiate the binary to BCD converter
binary_to_bcd 
#(
	.BITS_IN_PP(32),  
	.BCD_DIGITS_OUT_PP(8),
	.BIT_COUNT_WIDTH_PP(8)
) BINBCD
(
	.clk_i(clk),
	.ce_i(1'b1),
	.rst_i(reset),
	.start_i(start_conversion),
	.dat_binary_i(bcd_converter_in),
	.dat_bcd_o(bcd_converter_out),
	.done_o(done_conversion)
 );

 
// integer position, i;
 integer i;
 tri [31:0] position_tri;
 genvar gen_i;
 wire [15:0] pos;

//  // ==================================================
//  // [PROBLEM 1] original code
//  // ==================================================
//  always@(*) begin
//    position = 0;
//    for( i = 0; i < N_INPUTS; i = i+1 )
//      if( mux_sel[i+1] )
//        position = i;
//  end

//  // ==================================================
//  // [PROBLEM 1] fix 1
//  // ==================================================
// 	generate
// 		for( gen_i = 0; gen_i < N_INPUTS; gen_i++)
// 				assign position_tri = mux_sel[gen_i+1] ? gen_i : 'z;
// 	endgenerate
 	
// 	assign position = mux_sel[0] ? '0 : position_tri;

  // ==================================================
  // [PROBLEM 1] fix 2: by using directly "position" signal from outside
  // ==================================================

 assign pos = N_INPUTS - position[15:0];
// generate the input to the BCD converter.
// multiplexes soureces to the input to the BCD converter

always @(*)
begin
	if( mux_sel != {{N_INPUTS{1'b0}}, 1'b1}  )
	begin
		bcd_converter_in = {16'h0, operands[position]};
		truncated = 1'b0;
	end
	else
	begin
		if (result <= 32'd99999999) begin
			bcd_converter_in = result;
			truncated = 1'b0;
		end
		else begin
			bcd_converter_in = 32'd99999999;
			truncated = 1'b1;
		end
	end
end

// generate the start signal for the BCD conversion.
// looks for changes in one or both of the operands

// delay the operand and result registers to detect changes
always @(posedge clk) begin
	if (reset) begin
		for( i = 0 ; i < N_INPUTS; i = i + 1)
			operands_dly[i] <= 16'd0;
		result_dly <= 32'd0;
	end
	else begin
		for( i = 0 ; i < N_INPUTS; i = i + 1)
			operands_dly[i] <= operands[i];
		result_dly <= result;
	end
end // delay the operands and result registers to detect changes

// implmenent the request BCD conversion logic

//  // ==================================================
//  // [PROBLEM 2] orginal code
//  // ==================================================
//  always @(*)
//  begin
//    cnvt = (result != result_dly);
//    for( i = 0; i < N_INPUTS; i = i + 1)
//      cnvt = cnvt | (operands[i] != operands_dly[i]);
//  end
  
  // ==================================================
  // [PROBLEM 2] fix
  // ==================================================
  
  reg [N_INPUTS : 0] result_not_equal;
  int j;
  
  // compute intermediate not-equal results, as register
//  always @(*) begin
//    result_not_equal[N_INPUTS] = result != result_dly;
//    for (i=0; i<N_INPUTS; i++) begin
//      result_not_equal[i] = operands[i] != operands_dly[i];
//    end
//  end
  always @(posedge clk) begin
    result_not_equal[N_INPUTS] <= result != result_dly;
    
    for (i=0; i<N_INPUTS; i++) begin
      result_not_equal[i] <= operands[i] != operands_dly[i];
    end
  end
  
  // compute cnvt signal as a register
  always @(posedge clk) begin
    cnvt <= | result_not_equal;
  end 

always @(posedge clk) begin
	if (reset) begin
		cnvt_ff <= 1'b0;
	end
	else if (cnvt) begin
		cnvt_ff <= 1'b1;
	end else if (done_conversion) begin
		cnvt_ff <= 1'b0;
	end
	else begin
		cnvt_ff <= cnvt_ff;
	end
end // convert flip-flop

// implement the start conversion command to the binary to BCD converter
// make the signal last a single cycle

always @(posedge clk) begin
	if (reset) begin
		start_conversion_d <= 1'b0;
	end
	else begin
		start_conversion_d <= cnvt_ff;
	end
end
assign start_conversion = cnvt_ff & ~start_conversion_d;	

// generate the 7-segment digits, decimal points, and LEDs 
always @(posedge clk) begin
	if (reset) begin
		{dig7, dig6, dig5, dig4} <= 20'b10110_01110_01100_01110;	// "-ECE"
		{dig3, dig2, dig1, dig0} <= 20'b00101_00100_00000_10110; 	// "540-"
		leds <= 16'b1111111111111111;								// all LEDs on
		decpts <= 8'b11111111;										// all decimal points on
	end  //reset
	else begin


		if( mux_sel != {{N_INPUTS{1'b0}}, 1'b1}  )
		begin
			{dig7, dig6, dig5, dig4} <= {15'h0, 1'b0, bcd_converter_out[19:16]};			// "A:   <dig><dig><dig><dig><dig>"			
			{dig3, dig2, dig1, dig0} <= {1'b0, bcd_converter_out[15:12], 1'b0, bcd_converter_out[11:8],	1'b0, bcd_converter_out[7:4], 1'b0, bcd_converter_out[3:0]};												
			leds <= pos;																					// a (in hex)
			decpts <= 8'b00000000;																			// all decimal points off
		end
		else
		begin
			{dig7, dig6, dig5, dig4} <= {1'b0, bcd_converter_out[31:28], 1'b0, bcd_converter_out[27:24],	//<dig><dig><dig><dig><dig><dig><dig><dig>			
												1'b0, bcd_converter_out[23:20], 1'b0, bcd_converter_out[19:16]};				
			{dig3, dig2, dig1, dig0} <= {1'b0, bcd_converter_out[15:12], 1'b0, bcd_converter_out[11:8],	
												1'b0, bcd_converter_out[7:4], 1'b0, bcd_converter_out[3:0]};
												
			leds <= 16'b1111111111111111;																			// lower 16-bits of result (in hex)
			decpts <= (truncated) ? 8'b11111111 : 8'b00000000;												// <trunc><off><off><off><off><off><off><off>												
		end
	end  // done conversion
end	  // generate 7-segment digits, leds, and decimal points
	
endmodule
		
		

