
module x74367(

  input  [1:0] G,
  input  [5:0] A,
  output [5:0] Y

);

assign Y = {
  ~G[1] ? A[5:4] : 2'b0,
  ~G[0] ? A[3:0] : 4'b0
};

endmodule
