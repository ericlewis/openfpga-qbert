

module x74244(

  input [7:0] A,
  input [1:0] OE,
  output [7:0] Y

);

assign Y = {
  OE[1] ? 4'd0 : A[7:4],
  OE[0] ? 4'd0 : A[3:0]
};

endmodule
