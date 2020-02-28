module mean
#(
	parameter			N_INPUTS = 20
)
(
	input				clk,		// system clock
	input				reset,		// system reset
	input	[15:0]		operands[N_INPUTS - 1 : 0 ],
	output	[31:0]		result		// result from multiply
);

	integer i;
	reg	[31:0] res;

	always@(*)
	begin
	res = 32'd0;
	for( i = 0; i < N_INPUTS; i = i + 1 )
		res = res+operands[i];
	end

	assign result = res/N_INPUTS;



endmodule