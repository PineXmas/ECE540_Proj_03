// nexys4fpga.v - Top level module for Nexys4 as used in the Average Calculator project
//
// Copyright Roy Kravitz, 2016
// 
// Created By:		Ignacio Genovese - Roy Kravitz
// Last Modified:	22-Feb-2019(IG)
//
// Revision History:
// -----------------
// Feb-2019     IG		Modified the Vedic Multiplier project, coonverted to an average calculator
// Aug-2016		RK		Created this module for the Nexys4 DDR (and Nexys 4) board
//
// Description:
// ------------
// Top level module for the average calculator project
// on the Nexys4 FPGA Board (Xilinx XC7A100T-CSG324)
//
// Uses the center pushbutton to load the N_INPUTS 16-bit operands:
//	btnl				"Previous" button
//	btnu				"Previous" button (alt function)
//	btnr				"Next" button
//	btnd				"Next" button (alt function)
//  btnc				"Reset" button - Resets the multiplier 
//	btnCpuReset			CPU RESET Button - System reset.  Asserted low by Nexys 4 board
//
//	sw[15:0]			Used to set the values of each operand (hex)
//	7-segment display	Displays the operands while they are entered and the result after it
//						is calculated.
//	led[15:0]			Display operands and results (low 16-bits) in Hex
//
// External port names match pin names in the constraints file
//
// Only change the module "mean" to "mean_v2"
//
///////////////////////////////////////////////////////////////////////////

module nexys4fpga_v1 (
	input 				clk,                 	// 100MHz clock from on-board oscillator
	input				btnL, btnR,				// pushbutton inputs - left (db_btns[4])and right (db_btns[2])
	input				btnU, btnD,				// pushbutton inputs - up (db_btns[3]) and down (db_btns[1])
	input				btnC,					// pushbutton inputs - center button -> db_btns[5]
	input				btnCpuReset,			// red pushbutton input -> db_btns[0]
	input	[15:0]		sw,						// switch inputs
	
	output	[15:0]		led,  					// LED outputs	
	
	output 	[6:0]		seg,					// Seven segment display cathode pins
	output              dp,
	output	[7:0]		an,						// Seven segment display anode pins	
	
	output	[7:0]		JA						// JA Header
); 

	// parameters
	parameter SIMULATE = 0;
	localparam	N_INPUTS = 15;

	// internal variables
	wire 	[15:0]		db_sw;					// debounced switches
	wire 	[5:0]		db_btns;				// debounced buttons
	
	wire				sysclk;					// 100MHz clock from on-board oscillator	
	wire				sysreset;				// system reset signal - asserted high to force reset
	wire				mult_reset;				// multiplier reset
	
	wire 	[4:0]		dig7, dig6,				// 7-segment display digits
						dig5, dig4,
						dig3, dig2, 
						dig1, dig0;					
	wire 	[7:0]		decpts;					// decimal points	
	wire    [7:0]       segs_int; 				// sevensegment module the segments and the decimal point
	
	reg		[15:0]				inputs [N_INPUTS - 1 : 0];	//Operands
	wire	[N_INPUTS : 0]	load;

	reg		[15:0]		a, b;					// Multiplicand (a) and Multiplier (b) registers
	wire	[31:0]		c;						// Output from the multiplier
	reg		[31:0]		result;					// Multiplication result register
	

	wire				loadResult;				// load signal for the result register 
	
	wire				nextBtn, prevBtn;		// next and previous buttons for operand entry and control
	wire	[N_INPUTS:0]		sel;					// selects for the output multiplexer
	
	wire				clk_100;
	
	//instantiate the debounce module
	debounce
	#(
		.RESET_POLARITY_LOW(0),
		.SIMULATE(SIMULATE)
	)  	DB
	(
		.clk(sysclk),	
		.pbtn_in({btnC,btnL,btnU,btnR,btnD,btnCpuReset}),
		.switch_in(sw),
		.pbtn_db(db_btns),
		.swtch_db(db_sw)
	);	
		
	// instantiate the 7-segment, 8-digit display
	sevensegment
	#(
		.RESET_POLARITY_LOW(0),
		.SIMULATE(SIMULATE)
	) SSB
	(
		// inputs for control signals
		.d0(dig0),
		.d1(dig1),
 		.d2(dig2),
		.d3(dig3),
		.d4(dig4),
		.d5(dig5),
		.d6(dig6),
		.d7(dig7),
		.dp(decpts),
		
		// outputs to seven segment display
		.seg(segs_int),			
		.an(an),
		
		// clock and reset signals (100 MHz clock, active high reset)
		.clk(sysclk),
		.reset(sysreset),
		
		// ouput for simulation only
		.digits_out()
	);

	// instantiate the control logic
	control_unit 
	#(
		.N_INPUTS 	(N_INPUTS)
	)
	CTL (
		.clk(sysclk),
		.reset(mult_reset),	
		.nextBtn(nextBtn),	
		.prevBtn(prevBtn),	
		.load(load),
		.loadResult(loadResult),
		.mux_sel(sel)
	);
	
	sevenseg_outmux 
	#(
		.N_INPUTS	(N_INPUTS)
	)
	OUTMUX (
		.clk(sysclk),
		.reset(mult_reset),
		.mux_sel(sel),
		.operands(inputs),
		.result(result),
		.dig7(dig7),
		.dig6(dig6),
		.dig5(dig5),
		.dig4(dig4),
		.dig3(dig3),
		.dig2(dig2),
		.dig1(dig1),
		.dig0(dig0),
		.leds(led),
		.decpts(decpts)
	);	

	mean_v2
	#(
		.N_INPUTS	(N_INPUTS)
	)
	u_mean
	(
		.clk		(sysclk),
		.reset		(mult_reset),
		.operands	(inputs),
		.result		(c)
	);
	
	// connect the system-wide signals
	assign sysreset = ~db_btns[0];					// btnCpuReset is asserted low so invert it
	assign mult_reset =  db_btns[5] | sysreset;		// btnC (center button) is asserted high	
		


  	clk_wiz_0 generated_clock(
        // Clock out ports
        .clk_220(clk_100),     // output clk_out1
        // Status and control signals
        .reset(sysreset), // input reset
       // Clock in ports
        .clk_in1(clk)
    );      // input clk_in1

	assign sysclk = clk_100;
	
	// connect to the 7-segment display and LEDs
	assign dp = segs_int[7];
	assign seg = segs_int[6:0];	
	
	// connect the Jx connections
	assign JA = {2'b00, mult_reset, sysclk, sysreset, 2'b00, loadResult};
	
	// connect the control signals
	assign prevBtn = db_btns[4] | db_btns[3];
	assign nextBtn = db_btns[2] | db_btns[1];	
	

	//Load operands
	integer position, i;
 	always@(*)
 	begin
 		position = 0;
 		for( i = 0; i < N_INPUTS; i = i+1 )
 			if( sel[i+1] ) //as sel[0] is for result
 				position = i;
 	end

	always@(posedge sysclk)
	begin
		if(mult_reset)
		begin
			for( i = 0; i < N_INPUTS; i = i+1 )
				inputs[i] <= 16'd0;
		end
		else
		begin
			inputs[position] <= db_sw;
		end
	end

	
	// implement the result (from the multiplier) register
	always @(posedge sysclk) begin
		if (mult_reset) begin
			result <= 32'd0;
		end
		else if (loadResult) begin
			result <= 	c;
		end
		else begin
			result <= result;
		end
	end // Result register		
			
endmodule