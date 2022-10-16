
module x74189(

  input clk,
  input [3:0] din,
  input [3:0] addr,
  input cs,
  input wr,
  output [3:0] Q

);

assign Q = ~cs ? dout : 4'd0;

reg [3:0] memory[15:0];
reg [3:0] dout;

always @(posedge clk) begin
  if (~cs) begin
    if (~wr) memory[addr] <= ~din;
    else dout <= memory[addr];
  end
end

endmodule
