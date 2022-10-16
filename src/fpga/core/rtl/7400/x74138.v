
module x74138(

  input G1,  // 6 E3
  input G2A, // 5 E2
  input G2B, // 4 E1
  input  [2:0] A,
  output reg [7:0] O

);

always @*
  if (~G2B & ~G2A & G1)
    case (A)
      3'b000: O = 8'b1111_1110;
      3'b001: O = 8'b1111_1101;
      3'b010: O = 8'b1111_1011;
      3'b011: O = 8'b1111_0111;
      3'b100: O = 8'b1110_1111;
      3'b101: O = 8'b1101_1111;
      3'b110: O = 8'b1011_1111;
      3'b111: O = 8'b0111_1111;
    endcase
  else
    O = 8'b1111_1111;

endmodule
