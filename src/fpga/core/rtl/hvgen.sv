module HVGEN (
  input vclk,
  input [23:0] rgbin,
  output [23:0] rgbout,
  input colfix,
  output reg hb = 1,
  output reg vb = 1,
  output reg hs = 1,
  output reg vs = 1
);

reg [8:0] hcnt;
reg [7:0] vcnt;
assign rgbout = hb | vb ? 24'd0 : rgbin;
always @(posedge vclk) begin
  hcnt <= hcnt + 1'b1;
  case (hcnt)
    0: hb <= colfix ? 1'b1 : 1'b0; // keep hbl active if colfix
    3: hb <= 1'b0;
    265: hb <= 1'b1;
    283: hs <= 1'b0;
    303: hs <= 1'b1;
    317: begin
      vcnt <= vcnt + 1'b1;
      hcnt <= 1'b0;
      case (vcnt)
        239: vb <= 1'b1;
        251: vs <= 1'b0;
        254: vs <= 1'b1;
        255: begin vcnt <= 1'b0; vb <= 1'b0; end
      endcase
    end
  endcase
end

endmodule