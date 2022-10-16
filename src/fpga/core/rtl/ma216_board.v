
module ma216_board(
  input clk,
  input clk_sys,
  input reset,

  input [5:0] IP2720,

  output [7:0] audio,

  input rom_init,
  input [17:0] rom_init_address,
  input [7:0] rom_init_data
);

assign audio = U7_8;

wire [15:0] AB;
wire [7:0] DBo;
wire WE, irq, U14_AR;
wire [7:0] U4_O, U5_dout, U6_dout;
wire [7:0] U15_D_O;
reg [7:0] SB1, U11_18, U7_8;


reg [7:0] DBi;

always @(posedge clk)
  DBi <= ~U4_O[0] ? U15_D_O : U5_dout | U6_dout;

cpu6502 U3(
  .clk(clk),
  .reset(reset),
  .AB(AB),
  .DI(DBi),
  .DO(DBo),
  .WE(WE),
  .IRQ(~irq),
  .NMI(~U14_AR),
  .RDY(1'b1)
);

x74138 U4(
  .G1(1'b1),
  .G2A(1'b0),
  .G2B(1'b0),
  .A(AB[14:12]),
  .O(U4_O)
);

dpram #(.addr_width(11),.data_width(8)) U5 (
  .clk(clk_sys),
  .addr(AB[10:0]),
  .dout(U5_dout),
  .ce(U4_O[7]),
  .oe(AB[11]),
  .we(rom_init & rom_init_address < 18'h1C800),
  .waddr(rom_init_address),
  .wdata(rom_init_data)
);

dpram #(.addr_width(11),.data_width(8)) U6 (
  .clk(clk_sys),
  .addr(AB[10:0]),
  .dout(U6_dout),
  .ce(U4_O[7]),
  .oe(~AB[11]),
  .we(rom_init & rom_init_address < 18'h1D000),
  .waddr(rom_init_address),
  .wdata(rom_init_data)
);

// U7 U8
always @(posedge clk)
  if (~U4_O[1]) U7_8 <= DBo;

// U11 U18
always @(posedge clk)
  if (~U4_O[3]) U11_18 <= DBo;

reg votrax_clk; // todo: create 720KHz clock
always @(posedge clk)
  votrax_clk <= ~votrax_clk;

sc01 U14(
  .clk(votrax_clk), // 720KHz?
  .PhCde(~DBo[5:0]),
  .Pitch(),
  .LatchCde(U4_O[2]),
  .audio(),
  .AR(U14_AR)
);

riot U15(
  .PHI2(clk),
  .RES_N(~reset),
  .CS1(~U4_O[0]),
  .CS2_N(U4_O[0]),
  .RS_N(AB[9]),
  .R_W(~WE),
  .A(AB[6:0]),
  .D_I(DBo),
  .D_O(U15_D_O),
  .PA_I({ &IP2720[3:0], 1'b0, ~IP2720 }),
  .PA_O(),
  .DDRA_O(),
  .PB_I({ ~U14_AR, 1'b1, ~SB1[5:0] }),
  .PB_O(),
  .DDRB_O(),
  .IRQ_N(irq)
);

endmodule