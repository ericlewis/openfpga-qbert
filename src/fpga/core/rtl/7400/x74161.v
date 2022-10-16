
module x74161 (
  input cl,
  input clk,
  input ld,
  input ep,
  input et,
  input [3:0] P,
  output reg [3:0] Q,
  output co
);

wire [3:0] nq = Q + 4'd1;
assign co = et & (&Q);

always @(posedge clk) begin
  if (~cl) Q <= 4'd0;
  if (~ld) Q <= P;
  if (ld & ep & et) Q <= nq;
end

endmodule