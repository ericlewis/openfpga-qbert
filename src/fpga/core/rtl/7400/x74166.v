
// not fully implemented
module x74166(
  input clk,
  input LD,
  input [7:0] D,
  output Q
);

assign Q = SR[7];
reg [7:0] SR;


always @(posedge clk) begin
  if (~LD) SR <= D;
  else SR <= { SR[6:0], 1'b0 };
end

endmodule