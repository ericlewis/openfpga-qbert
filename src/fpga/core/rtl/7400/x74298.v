
module x74298(
  input clk,
  input [3:0] A,
  input [3:0] B,
  input s,
  output reg [3:0] Y
);

always @(negedge clk)
  Y <= s ? B : A;

endmodule
