
module x74157(
  input [3:0] A,
  input [3:0] B,
  input s,
  input en,
  output [3:0] Y
);

wire [3:0] o = s == 1'b1 ? B : A;
assign Y = en == 1'b0 ? o : 4'd0;

endmodule
