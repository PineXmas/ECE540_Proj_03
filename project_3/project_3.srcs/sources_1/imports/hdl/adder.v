// adder.v - Compute sum of two numbers
// Thong Doan
//
// For support the mean calculation

module adder(
  input             clk,      // clock
  input             reset,    // reset
  input [31:0]      a,        // 1st operand
  input [31:0]      b,        // 2nd operand
  output reg [31:0] sum       // the sum
);

  always @(posedge clk) begin
    if (reset) begin
      sum <= 0;
    end
    else begin
      sum <= a + b;
    end
  end
  
endmodule