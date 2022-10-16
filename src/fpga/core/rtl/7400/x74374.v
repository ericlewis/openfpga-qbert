
module x74374 (
  input clk,
  input [7:0] D,
  output [7:0] Q,
  input OE
);

assign Q = ~OE ? rD : 8'd0;
reg [7:0] rD;

always @(posedge clk)
  rD <= D;

endmodule