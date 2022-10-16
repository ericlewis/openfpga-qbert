
module x7474(
  input clk1,
  input clr1,
  input pre1,
  input D1,
  output reg Q1,
  output nQ1,
  input clk2,
  input clr2,
  input pre2,
  input D2,
  output reg Q2,
  output nQ2
);

reg ppre1, ppre2;

always @(posedge clk1)
  if (~clr1)
    Q1 <= 1'b0;
  else if (~pre1 & ppre1)
    Q1 <= 1'b1;
  else begin
    Q1 <= D1;
    ppre1 <= pre1;
  end

always @(posedge clk2)
  if (~clr2)
    Q2 <= 1'b0;
  else if (~pre2 & ppre2)
    Q2 <= 1'b1;
  else begin
    Q2 <= D2;
    ppre2 <= pre2;
  end

assign nQ1 = ~Q1;
assign nQ2 = ~Q2;


endmodule