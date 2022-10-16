
module x74379 (
  input clk,
  input [3:0] D,
  output reg [3:0] Q,
  input G
);

//assign Q = ~G;

//assign Q = ~G ? r : 4'd0;
//reg [3:0] r;

always @(posedge clk)
  Q <= ~G ? ~D : 4'd0;

endmodule