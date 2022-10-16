
module x74283(
  input [3:0] A,
  input [3:0] B,
  input C0,
  output reg [3:0] S,
  output reg C4
);

always @*
  { C4, S } = A + B + { 3'd0, C0 };

endmodule