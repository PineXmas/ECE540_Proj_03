// mean_v2.v - Rewritten in a pipeline form
// Thong Doan
//
// Perform addition binarily

module mean_v2
#(
	parameter		 N_INPUTS = 8,
	localparam   HALF_INPUTS = N_INPUTS / 2 
)
(
	input				        clk,		                      // system clock
	input				        reset,		                    // system reset
	input	[15:0]		    operands[N_INPUTS - 1 : 0 ],
	output	reg [31:0]  result		                    // result from multiply
);

	//////////////////////////////////////////////////
	// DECLARATIONS
	//////////////////////////////////////////////////

	// registers used for retimable
	reg [31:0] sums [N_INPUTS-1:0];
	
	integer i;

	reg	[31:0] res = 0;

	//////////////////////////////////////////////////
	// LOGIC
	//////////////////////////////////////////////////
  
  // pipelining
  always @(posedge clk) begin
  
    // binarily accumulate the sums
    for (i=0; i<HALF_INPUTS-1; i++) begin
      sums[i] <= sums[i*2 + 1] + sums[i*2 + 2];
    end
    
    // binarily compute the sums of every pair of operands
    for (i=HALF_INPUTS-1; i<N_INPUTS-1; i++) begin
      sums[i] <= {16'b0, operands[(i-(HALF_INPUTS-1))*2]} + {16'b0, operands[(i-(HALF_INPUTS-1))*2 + 1]};
    end
    
    // compute mean
    result <= sums[0] / N_INPUTS;
  end

endmodule