
module mylstar_board
(
  input         clk_sys,
  input         reset,

  input         CLK,
  input         CLK5,
  input         CPU_CLK,
  input         CPU_CORE_CLK,

  output        HBlank,
  output        HSync,
  output        VBlank,
  output        VSync,

  output  [7:0] red,
  output  [7:0] green,
  output  [7:0] blue,

  input   [7:0] IP1710,
  input   [7:0] IP4740,
  input   [7:0] IPA1J2,
  output  [5:0] OP2720,
  output  [4:0] OP3337,
  output  [7:0] OP4740,

  input   [7:0] dip_switch,

  input rom_init,
  input [17:0] rom_init_address,
  input [7:0] rom_init_data,
  input [7:0] rom_index,
  
  input vflip,
  input hflip
);


assign VSync = K15_4;
assign HSync = K17_Q[0];
assign HBlank = HBLANK;
assign VBlank = VBLANK;
assign red = { G13_Q, 4'd0 };
assign green = { G15_Q, 4'd0 };
assign blue = { G14_Q, 4'd0 };
assign OP2720 = A10[5:0];
assign OP4740 = A9[7:0];
assign OP3337 = A8[4:0];

wire IOM;
wire RD_n, WR_n;
wire [7:0] cpu_dout, C5_Q, C6_Q, C7_Q, C8_9_Q, C9_10_Q, C10_11_Q;
wire [7:0] C11_12_Q, C12_13_Q, C13_14_Q, C14_15_Q, C16_Q;
wire [5:0] B4_Y;
wire [7:0] B9_Y, B8_Y, B6_Y, B10_Y;
wire [3:0] B7_1Y, B7_2Y;
wire [3:0] D1_1Y, D1_2Y, D2_Y, D3_Y, D4_Y, D5_Y, D6_Y, D7_Y, D8_Y, D9_Y, D10_Y;
wire [19:0] addr;
wire J16_co, J17_co, F16_co, H5_co, H6_co;
wire [3:0] J16_Q, J17_Q, K17_Q, D17_Q, F16_Q;
reg [5:0] G16_Q, G17_Q;
reg [7:0] A8, E16, A9, A10;
wire J13_nQ1, J13_Q1, J13_Q2, L10_Q1;
wire [7:0] E1_2_Q, E2_3_Q, E4_Q;
wire [3:0] F5_S, E5_S, D16_S, D13_Y;
wire [3:0] G1_Y, G2_Y, G3_Y, G4_Y, G5_Y, G6_Q, G7_Y, G9_Y;
wire [3:0] J1_Q, J2_Q, J3_Q, J4_Q, J5_Q, J6_Q, J10_Q, J11_Q;
wire [3:0] H1_Q, H2_Q, H3_Q, H4_Q, H5_Q, H6_Q, H7_Y, H8_Y, H9_Y, H10_Y, H12_Y, H13_Y;
wire [3:0] K1_Q, K2_Q, K3_Q;
wire [3:0] L12_Q;
wire F5_C4;
wire G8_nQ1, G8_Q1, G8_nQ2;
wire [7:0] K4_D, K5_D, K6_D, K7_8_D, G10_Ao, G10_Bo, G11_Q;
wire L4_5_Q, L5_6_Q, L6_7_Q, L7_8_Q;
wire [3:0] K9_Y, K10_Y, K11_Y, G12_Y, G13_Q, G14_Q, G15_Q;
wire [7:0] E7_Q, E8_Ao, E8_Bo, E9_10_Bo, E10_11_Q, D11_Q, D12_Y, E11_12_Q, E13_Q;

wire nCOLSEL = B7_2Y[2];
wire nBOJRSEL1 = B5_3;
wire nBOJRWR = F6_8;
wire nBRSEL = B6_Y[7];
wire nFRSEL = B6_Y[6];
wire nWR = B4_Y[0];
wire nBRWR = F6_6;
wire nFRWR = F6_3;
wire BANK_SEL = A8[4];
wire VERTFLOP = vflip ? ~A8[2]: A8[2];
wire HORIZFLIP = hflip ? ~A8[1]: A8[1];
wire FB_PRIORITY = A8[0];
wire BLANK = J12_1;
wire HBLANK = K17_Q[0];
wire VBLANK = ~E17_8;
wire nVBLANK = E17_8;
wire nVHBLANK = H14_3;
wire SFBW = K14_3;
wire SBBW = K14_8;
wire nRD1 = B4_Y[2];
wire BGA1 = F17_8;
wire LATCH_CLK = K16_6;
wire SHIFTED_HB = J13_Q2;
wire nSRLD = L11_6;
wire [12:0] RA = { K1_Q, K2_Q, K3_Q, L12_Q[3] };
wire S1 = K13_3;
wire S2 = G9_Y[1];
wire S3 = K16_8;
wire S5 = K13_8;
wire RDY1 = J9_8;
wire [8:0] H = { K17_Q[0], J17_Q, J16_Q };
wire [7:0] HH = { G17_Q[4:0], G16_Q[5:3] };
wire [7:0] VV = { D15_8, D15_6, D15_3, D15_11, E15_8, E15_6, E15_11, E15_3 };
wire nHH0s = F15_12;
wire nH0 = F15_4;
wire nVV0 = K15_10;

wire [7:0] P1_B11 = IP1710;
wire [7:0] P1_B14 = IP4740;

wire [7:0] A1J2 = ~B10_Y[2] ? IPA1J2 : 8'd0;  

wire [7:0] ram_dout = C5_Q | C6_Q | C7_Q | C9_10_Q | C8_9_Q | C10_11_Q;
wire [7:0] rom_dout = C11_12_Q | C12_13_Q | C13_14_Q | C14_15_Q | C16_Q;
wire [7:0] cpu_din = ram_dout | rom_dout | G10_Ao | B11 | B12 | B14 | E8_Ao;

// A8
always @(posedge nWR)
  if (~B9_Y[3]) A8 <= cpu_dout;

// A9
always @(posedge nWR)
  if (~B9_Y[4]) A9 <= cpu_dout;

// A10
always @(posedge nWR)
  if (~B9_Y[2]) A10 <= cpu_dout;

reg nmi;
wire INTA_n;
always @(posedge CPU_CLK) begin
  nmi <= VSync;
  if (~INTA_n) nmi <= 1'b0;
end

i8088 B1(
  .CORE_CLK(CPU_CORE_CLK),
  .CLK(CPU_CLK),
  .RESET(reset),
  .READY(1'b1),
  .INTR(0),
  .NMI(nmi),
  .INTA_n(INTA_n),
  .addr(addr),
  .dout(cpu_dout),
  .din(cpu_din),
  .IOM(IOM),
  .RD_n(RD_n),
  .WR_n(WR_n)
);

x74367 B4(
  .G(2'b0),
  .A({ 2'b0, RD_n, RD_n, IOM, WR_n }),
  .Y(B4_Y)
);

// B5
wire B5_3 = B7_2Y[0] & B7_2Y[1];
wire B5_6 = B6_Y[2] & B6_Y[3];
wire B5_8 = B6_Y[4] & B6_Y[5];

x74138 B6(
  .G1(1'b1),
  .G2A(B4_Y[1]),
  .G2B(B7_1Y[0]),
  .A(addr[13:11]),
  .O(B6_Y)
);

x74139 B7(
  .E1(B4_Y[1]),
  .E2(B8_Y[2]),
  .A1(addr[15:14]),
  .A2(addr[12:11]),
  .O1(B7_1Y),
  .O2(B7_2Y)
);

x74138 B8(
  .G1(1'b1),
  .G2A(B4_Y[1]),
  .G2B(1'b0),
  .A(addr[15:13]),
  .O(B8_Y)
);

x74138 B9(
  .G1(~addr[3]),
  .G2A(B7_2Y[3]),
  .G2B(B4_Y[0]),
  .A(addr[2:0]),
  .O(B9_Y)
);

x74138 B10(
  .G1(~addr[3]),
  .G2A(B7_2Y[3]),
  .G2B(nRD1),
  .A(addr[2:0]),
  .O(B10_Y)
);

wire [7:0] B11 = ~B10_Y[1] ? P1_B11 : 8'd0;

wire [7:0] B12 = ~B10_Y[0] ? dip_switch : 8'd0;

wire [7:0] B14 = ~B10_Y[4] ? P1_B14 : 8'd0;

// TODO: load from MRA and fill with $FF if empty
wire [10:0] nvram_addr = rom_init ? rom_init_address[10:0] : addr[10:0];
wire [7:0] nvram_din = rom_init ? 8'hff : cpu_dout;
wire nvram_wr = rom_init ? 1'b0 : B4_Y[0];

// nvram 1
ram #(.addr_width(11),.data_width(8)) C5 (
  .clk(clk_sys),
  .din(nvram_din),
  .addr(nvram_addr),
  .cs(rom_init ? 1'b0 : B6_Y[0]),
  .oe(B4_Y[2]),
  .wr(nvram_wr),
  .Q(C5_Q)
);

// nvram 2
ram #(.addr_width(11),.data_width(8)) C6 (
  .clk(clk_sys),
  .din(nvram_din),
  .addr(nvram_addr),
  .cs(rom_init ? 1'b0 : B6_Y[1]),
  .oe(B4_Y[2]),
  .wr(nvram_wr),
  .Q(C6_Q)
);

ram #(.addr_width(11),.data_width(8)) C7 (
  .clk(clk_sys),
  .din(cpu_dout),
  .addr(addr[10:0]),
  .cs(B6_Y[2]),
  .oe(B4_Y[2]),
  .wr(B4_Y[0]),
  .Q(C7_Q)
);

ram #(.addr_width(11),.data_width(8)) C8_9 (
  .clk(clk_sys),
  .din(cpu_dout),
  .addr(addr[10:0]),
  .cs(B6_Y[3]),
  .oe(B4_Y[2]),
  .wr(B4_Y[0]),
  .Q(C8_9_Q)
);

ram #(.addr_width(11),.data_width(8)) C9_10 (
  .clk(clk_sys),
  .din(cpu_dout),
  .addr(addr[10:0]),
  .cs(B6_Y[4]),
  .oe(B4_Y[2]),
  .wr(B4_Y[0]),
  .Q(C9_10_Q)
);

ram #(.addr_width(11),.data_width(8)) C10_11 (
  .clk(clk_sys),
  .din(cpu_dout),
  .addr(addr[10:0]),
  .cs(B6_Y[5]),
  .oe(B4_Y[2]),
  .wr(B4_Y[0]),
  .Q(C10_11_Q)
);

reg [12:0] PRG_addr;
always @(posedge clk_sys) PRG_addr <= addr[12:0];
dpram  #(.addr_width(13),.data_width(8)) C11_12 (
  .clk(clk_sys),
  .addr(PRG_addr),
  .dout(C11_12_Q),
  .ce(B8_Y[7]),
  .oe(B4_Y[3]),
  .we(rom_init & rom_init_address < 18'h4000),
  .waddr(rom_init_address),
  .wdata(rom_init_data)
);

dpram  #(.addr_width(13),.data_width(8)) C12_13 (
  .clk(clk_sys),
  .addr(PRG_addr),
  .dout(C12_13_Q),
  .ce(B8_Y[6]),
  .oe(B4_Y[3]),
  .we(rom_init & rom_init_address < 18'h6000),
  .waddr(rom_init_address),
  .wdata(rom_init_data)
);

dpram  #(.addr_width(13),.data_width(8)) C13_14 (
  .clk(clk_sys),
  .addr(PRG_addr),
  .dout(C13_14_Q),
  .ce(B8_Y[5]),
  .oe(B4_Y[3]),
  .we(rom_init & rom_init_address < 18'h8000),
  .waddr(rom_init_address),
  .wdata(rom_init_data)
);

dpram  #(.addr_width(13),.data_width(8)) C14_15 (
  .clk(clk_sys),
  .addr(PRG_addr),
  .dout(C14_15_Q),
  .ce(B8_Y[4]),
  .oe(B4_Y[3]),
  .we(rom_init & rom_init_address < 18'ha000),
  .waddr(rom_init_address),
  .wdata(rom_init_data)
);

dpram  #(.addr_width(13),.data_width(8)) C16 (
  .clk(clk_sys),
  .addr(PRG_addr),
  .dout(C16_Q),
  .ce(B8_Y[3]),
  .oe(B4_Y[3]),
  .we(rom_init & rom_init_address < 18'hc000),
  .waddr(rom_init_address),
  .wdata(rom_init_data)
);

x74139 D1(
  .E1(1'b0),
  .E2(J13_nQ1),
  .A1(addr[1:0]),
  .A2({ 1'b0, nFRWR }),
  .O1(D1_1Y),
  .O2(D1_2Y)
);

x74374 D11(
  .clk(G16_Q[1]),
  .D({ E10_11_Q[6:0], VV[2] }),
  .Q(D11_Q),
  .OE(F15_10)
);

x74244 D12(
  .A(addr[11:4]),
  .Y(D12_Y),
  .OE({ nBOJRSEL1, nBOJRSEL1 })
);

x74157 D13(
  .A({ VV[1], VV[0], BGA1, F17_6 }),
  .B(addr[3:0]),
  .s(F15_10),
  .en(1'b0),
  .Y(D13_Y)
);

// D15
wire D15_3  = D16_S[1] ^ VERTFLOP;
wire D15_6  = D16_S[2] ^ VERTFLOP;
wire D15_8  = D16_S[3] ^ VERTFLOP;
wire D15_11 = D16_S[0] ^ VERTFLOP;

x74283 D16(
  .A({ 3'd0, VERTFLOP }),
  .B(E16[7:4]),
  .C0(1'b0),
  .S(D16_S)
);

x74161 D17(
  .cl(1'b1),
  .ep(1'b1),
  .et(F16_co),
  .clk(HBLANK),
  .P(4'd0),
  .ld(1'b1),
  .Q(D17_Q)
);

wire [7:0] E1_2_dout;
assign E1_2_Q = ~E1_2_dout;
reg [5:0] FGREG_addr;
always @(posedge clk_sys) FGREG_addr <= H[5:0];
dpram #(.addr_width(10),.data_width(8)) E1_2(
  .clk(clk_sys),
  .addr(FGREG_addr),
  .dout(E1_2_dout),
  .ce(1'b0),
  .oe(1'b0),
  .we(~nFRWR & addr[0] & ~addr[1]),
  .waddr(addr[7:2]),
  .wdata(cpu_dout[7:0])
);

wire [7:0] E2_3_dout;
assign E2_3_Q = ~E2_3_dout;
dpram #(.addr_width(10),.data_width(8)) E2_3(
  .clk(clk_sys),
  .addr(FGREG_addr),
  .dout(E2_3_dout),
  .ce(1'b0),
  .oe(1'b0),
  .we(~nFRWR & ~addr[0] & addr[1]),
  .waddr(addr[7:2]),
  .wdata(cpu_dout[7:0])
);

wire [7:0] E4_dout;
assign E4_Q = ~E4_dout;
dpram #(.addr_width(10),.data_width(8)) E4(
  .clk(clk_sys),
  .addr(FGREG_addr),
  .dout(E4_dout),
  .ce(1'b0),
  .oe(1'b0),
  .we(~nFRWR & ~addr[0] & ~addr[1]),
  .waddr(addr[7:2]),
  .wdata(cpu_dout[7:0])
);

x74283 E5(
  .A(E4_Q[7:4]),
  .B(VV[7:4]),
  .C0(F5_C4),
  .S(E5_S)
);

// E6
wire E6_8 = ~(nVBLANK & HBLANK & (&E5_S));

wire [7:0] E7_doutb;
dpram #(.addr_width(10),.data_width(8)) E7(
  .clk(clk_sys),
  .addr({ F16_Q[2:0], H[7:1] }),
  .dout(E7_Q),
  .ce(1'b0),
  // .oe(SBBW ? 1'b0 : nRD1), // ? no difference?
  .oe(1'b0),
  .we(~nBRWR),
  // .we(SBBW ? 1'b0 : ~nBRWR), // break test mode
  .waddr(addr[9:0]),
  .wdata(cpu_dout[7:0]),
  .doutb(E7_doutb)
);

assign E8_Ao = ~nBRSEL & ~nRD1 ? E7_doutb : 8'd0;

dpram #(.addr_width(10),.data_width(8)) E10_11(
  .clk(clk_sys),
  .addr({ VV[7:3], HH[7:3] }),
  .ce(1'b0),
  .oe(nVHBLANK),
  .we(SBBW ? ~nH0 : 1'b0), // fix rolling cube
  .waddr({ F16_Q[2:0], H[7:1] }),
  .wdata(E7_Q),
  .dout(E10_11_Q)
);

reg [12:0] E11_12_addr;
always @(posedge clk_sys) E11_12_addr <= { L10_Q1, D11_Q|D12_Y, D13_Y };
dpram  #(.addr_width(13),.data_width(8)) E11_12 (
  .clk(clk_sys),
  .addr(E11_12_addr),
  .dout(E11_12_Q),
  .ce(1'b0),
  //.ce(L10_Q1),
  .oe(1'b0),
  .we(rom_init & rom_init_address < 18'h2000),
  .waddr(rom_init_address),
  .wdata(rom_init_data)
);

// E15
wire E15_3  = E16[0] ^ VERTFLOP;
wire E15_6  = E16[2] ^ VERTFLOP;
wire E15_8  = E16[3] ^ VERTFLOP;
wire E15_11 = E16[1] ^ VERTFLOP;

// E16
always @(posedge G17_Q[5])
  E16 <= { D17_Q, F16_Q };

// E17 (vblank)
wire E17_8 = ~(&D17_Q);

x74283 F5(
  .A(E4_Q[3:0]),
  .B(VV[3:0]),
  .C0(1'b0),
  .S(F5_S),
  .C4(F5_C4)
);

// F6
wire F6_3 = nFRSEL | nWR;
wire F6_6 = nBRSEL | nWR;
wire F6_8 = nBOJRSEL1 | nWR;
wire F6_11 = nCOLSEL | nWR;

// F15
wire F15_2 = ~(D12_Y[7]|D11_Q[7]);
wire F15_4 = ~J16_Q[0];
wire F15_6 = ~F16_Q[3];
wire F15_8 = ~G16_Q[2];
wire F15_10 = ~nBOJRSEL1;
wire F15_12 = ~G16_Q[0];

x74161 F16(
  .cl(1'b1),
  .ep(1'b1),
  .et(1'b1),
  .clk(HBLANK),
  .P(4'd0),
  .ld(1'b1),
  .Q(F16_Q),
  .co(F16_co)
);

// F17
wire F17_6 = 1'b1 ^ G16_Q[4];
wire F17_8 = F15_8 ^ G16_Q[4];

x74157 G1(
  .A(E1_2_Q[7:4]),
  .B(4'b1111),
  .s(S1),
  .en(1'b0),
  .Y(G1_Y)
);

x74157 G2(
  .A(E1_2_Q[3:0]),
  .B(4'b1111),
  .s(S1),
  .en(1'b0),
  .Y(G2_Y)
);

x74157 G3(
  .A(E2_3_Q[7:4]),
  .B(4'b1111),
  .s(S1),
  .en(1'b0),
  .Y(G3_Y)
);

x74157 G4(
  .A(E2_3_Q[3:0]),
  .B(4'b1111),
  .s(S1),
  .en(1'b0),
  .Y(G4_Y)
);

x74157 G5(
  .A(F5_S),
  .B(4'b1111),
  .s(S1),
  .en(1'b0),
  .Y(G5_Y)
);

x74161 G6(
  .cl(1'b1),
  .ep(J7_12),
  .et(J7_12),
  .clk(CLK5),
  .P(4'd0),
  .ld(HBLANK),
  .Q(G6_Q)
);

x74157 G7(
  .A(G6_Q),
  .B(H[6:3]),
  .s(S1),
  .en(1'b0),
  .Y(G7_Y)
);

x7474 G8(
  .clk1(J7_8),
  .clr1(HBLANK),
  .pre1(1'b1),
  .D1(G8_nQ1),
  .Q1(G8_Q1),
  .nQ1(G8_nQ1),
  .clk2(CLK),
  .clr2(S3),
  .pre2(1'd1),
  .D2(H6_co),
  .nQ2(G8_nQ2)
);

x74157 G9(
  .A({ 2'b0, J8_3, G8_Q1 }),
  .B({ 2'b0, H14_6, H[7] }),
  .s(S1),
  .en(1'b0),
  .Y(G9_Y)
);

x74245 G10(
  .Ai(cpu_dout[7:0]),
  .Ao(G10_Ao),
  .Bi(E11_12_Q|E13_Q),
  .Bo(G10_Bo),
  .dir(nRD1),
  .G(nBOJRSEL1)
);

x74374 G11(
  .clk(~HH[0]),
  .D(E11_12_Q|E13_Q),
  .Q(G11_Q),
  .OE(1'b0)
);

x74157 G12(
  .A(G11_Q[3:0]),
  .B(G11_Q[7:4]),
  .s(nHH0s),
  .en(1'b0),
  .Y(G12_Y)
);

// G13, G14 & G15 are now dpram

dpram #(.addr_width(4),.data_width(4)) G13(
  .clk(CLK),
  .addr(H12_Y),
  .ce(1'b0),
  .oe(1'b0),
  .we(~H14_8),
  .waddr(addr[4:1]),
  .wdata(cpu_dout[3:0]),
  .dout(G13_Q)
);

dpram #(.addr_width(4),.data_width(4)) G14(
  .clk(CLK),
  .addr(H12_Y),
  .ce(1'b0),
  .oe(1'b0),
  .we(~H14_11),
  .waddr(addr[4:1]),
  .wdata(cpu_dout[3:0]),
  .dout(G14_Q)
);

dpram #(.addr_width(4),.data_width(4)) G15(
  .clk(CLK),
  .addr(H12_Y),
  .ce(1'b0),
  .oe(1'b0),
  .we(~H14_11),
  .waddr(addr[4:1]),
  .wdata(cpu_dout[7:4]),
  .dout(G15_Q)
);

// G16
always @(posedge CLK5)
  G16_Q <= { H16_3, H16_11, H16_8, J16_Q[2:0] };

// G17
always @(posedge CLK5)
  G17_Q <= { K14_6, H17_6, H17_3, H17_11, H17_8, H16_6 };

x74189 H1(
  .clk(clk_sys),
  .din(G1_Y),
  .addr(G7_Y),
  .cs(G9_Y[0]),
  .wr(S2),
  .Q(H1_Q)
);

x74189 H2(
  .clk(clk_sys),
  .din(G1_Y),
  .addr(G7_Y),
  .cs(J7_10),
  .wr(S2),
  .Q(H2_Q)
);

x74189 H3(
  .clk(clk_sys),
  .din(G2_Y),
  .addr(G7_Y),
  .cs(G9_Y[0]),
  .wr(S2),
  .Q(H3_Q)
);

x74189 H4(
  .clk(clk_sys),
  .din(G2_Y),
  .addr(G7_Y),
  .cs(J7_10),
  .wr(S2),
  .Q(H4_Q)
);

reg [3:0] H5_P;
always @(posedge CLK) H5_P <= H3_Q | H4_Q;

x74161 H5(
  .cl(1'b1),
  .ep(1'b1),
  .et(1'b1),
  .clk(J9_11),
  .P(H5_P),
  .ld(S3),
  .Q(H5_Q),
  .co(H5_co)
);

reg [3:0] H6_P;
always @(posedge CLK) H6_P <= H1_Q | H2_Q;

x74161 H6(
  .cl(1'b1),
  .ep(H5_co),
  .et(H5_co),
  .clk(J9_11),
  .P(H6_P),
  .ld(S3),
  .Q(H6_Q),
  .co(H6_co)
);

x74157 H7(
  .A(H6_Q),
  .B(HH[7:4]),
  .s(VV[0]),
  .en(SHIFTED_HB),
  .Y(H7_Y)
);

x74157 H8(
  .A(HH[7:4]),
  .B(H6_Q),
  .s(VV[0]),
  .en(SHIFTED_HB),
  .Y(H8_Y)
);

x74157 H9(
  .A(H5_Q),
  .B(HH[3:0]),
  .s(VV[0]),
  .en(SHIFTED_HB),
  .Y(H9_Y)
);

x74157 H10(
  .A(HH[3:0]),
  .B(H5_Q),
  .s(VV[0]),
  .en(SHIFTED_HB),
  .Y(H10_Y)
);

wire H11_5 = ~((|G12_Y)|J12_13);
wire H11_6 = ~((|J10_Q)|(|J11_Q));

// fg/bg priority
x74298 H12(
  .clk(~CLK5),
  .A(J10_Q|J11_Q),
  .B(G12_Y),
  .s(J12_4), // 1 = bg, 0 = fg
  .Y(H12_Y)
);

// H13 removed because of dual port color RAM

// H14
wire H14_3 = ~(E17_8 & K15_6);
wire H14_6 = ~(~H[1] & H[2]);
wire H14_8 = ~(J7_2 & addr[0]);
wire H14_11 = ~(J7_2 & J7_6);

// H15
wire H15_8 = ~(&{ J17_Q, J16_Q });

// H16
wire H16_3  = J16_Q[2] ^ HORIZFLIP;
wire H16_6  = J16_Q[3] ^ HORIZFLIP;
wire H16_8  = J16_Q[0] ^ HORIZFLIP;
wire H16_11 = J16_Q[1] ^ HORIZFLIP;

// H17
wire H17_3  = J17_Q[2] ^ HORIZFLIP;
wire H17_6  = J17_Q[3] ^ HORIZFLIP;
wire H17_8  = J17_Q[0] ^ HORIZFLIP;
wire H17_11 = J17_Q[1] ^ HORIZFLIP;

x74189 J1(
  .clk(clk_sys),
  .din(G3_Y),
  .addr(G7_Y),
  .cs(G9_Y[0]),
  .wr(S2),
  .Q(J1_Q)
);

x74189 J2(
  .clk(clk_sys),
  .din(G3_Y),
  .addr(G7_Y),
  .cs(J7_10),
  .wr(S2),
  .Q(J2_Q)
);

x74189 J3(
  .clk(clk_sys),
  .din(G4_Y),
  .addr(G7_Y),
  .cs(J7_10),
  .wr(S2),
  .Q(J3_Q)
);

x74189 J4(
  .clk(clk_sys),
  .din(G4_Y),
  .addr(G7_Y),
  .cs(G9_Y[0]),
  .wr(S2),
  .Q(J4_Q)
);

x74189 J5(
  .clk(clk_sys),
  .din(G5_Y),
  .addr(G7_Y),
  .cs(G9_Y[0]),
  .wr(S2),
  .Q(J5_Q)
);

x74189 J6(
  .clk(clk_sys),
  .din(G5_Y),
  .addr(G7_Y),
  .cs(J7_10),
  .wr(S2),
  .Q(J6_Q)
);

// J7
wire J7_2 = ~F6_11;
wire J7_4 = ~LATCH_CLK;
wire J7_6 = ~addr[0];
wire J7_8 = ~G6_Q[3];
wire J7_10 = ~G9_Y[0];
wire J7_12 = ~E6_8;

// J8
wire J8_3 = CLK5 | E6_8;
wire J8_6 = J8_11 | nBRSEL;
wire J8_8 = SBBW | nBRSEL;
wire J8_11 = F16_Q[3] | E17_8;

// J9
wire J9_8 = K13_6 & J8_6;
wire J9_11 = ~CLK & G8_nQ2;

reg [7:0] J10_addr;
always @(posedge clk_sys) J10_addr <= { H8_Y, H10_Y };
ram #(.addr_width(8), .data_width(4)) J10(
  .clk(CLK),
  .din(K10_Y),
  .addr(J10_addr),
  .cs(1'b0),
  .oe(VV[0]),
  .wr(K9_Y[0]),
  .Q(J10_Q)
);

reg [7:0] J11_addr;
always @(posedge clk_sys) J11_addr <= { H7_Y, H9_Y };
ram #(.addr_width(8), .data_width(4)) J11(
  .clk(CLK),
  .din(K11_Y),
  .addr(J11_addr),
  .cs(1'b0),
  .oe(K15_10),
  .wr(K9_Y[2]),
  .Q(J11_Q)
);

wire J12_1 = ~(K17_Q[0] | K15_4);
wire J12_4 = ~(H11_5 | J12_10);
wire J12_10 = ~(H11_6 | FB_PRIORITY);
wire J12_13 = ~FB_PRIORITY;

x7474 J13(
  .clk1(J16_Q[1]),
  .pre1(1'b1),
  .clr1(K14_6),
  .D1(K15_6),
  .Q1(J13_Q1),
  .nQ1(J13_nQ1),
  .clk2(H[1]),
  .pre2(1'b1),
  .clr2(1'b1),
  .D2(HBLANK),
  .Q2(J13_Q2)
);

wire J15 = ~(&{ K17_Q[0], J17_Q[1:0], J16_Q[3:2], J16_Q[0] });

x74161 J16(
  .cl(1'b1),
  .ep(1'b1),
  .et(1'b1),
  .clk(CLK5),
  .P(4'd0),
  .ld(J15),
  .Q(J16_Q),
  .co(J16_co)
);

x74161 J17(
  .cl(1'b1),
  .ep(1'b1),
  .et(J16_co),
  .clk(CLK5),
  .P(4'd0),
  .ld(J15),
  .Q(J17_Q),
  .co(J17_co)
);

reg [3:0] K1_D;
always @(posedge CLK) K1_D <= J1_Q | J2_Q;

x74379 K1(
  .clk(J7_4),
  .D(K1_D),
  .Q(K1_Q),
  .G(1'b0)
);

reg [3:0] K2_D;
always @(posedge CLK) K2_D <= J3_Q | J4_Q;

x74379 K2(
  .clk(J7_4),
  .D(K2_D),
  .Q(K2_Q),
  .G(1'b0)
);

reg [3:0] K3_D;
always @(posedge CLK) K3_D <= J6_Q | J5_Q;

x74379 K3(
  .clk(J7_4),
  .D(K3_D),
  .Q(K3_Q),
  .G(1'b0)
);
//00000000 1100 0000 0000 0000
// K4,K5,K6,K7_8 addr_width(14), bit13 = BANK_SEL - fix me!
wire bit13 =  BANK_SEL;
reg [13:0] FGROM_addr;
always @(posedge clk_sys) FGROM_addr <= {bit13,RA};
dpram #(.addr_width(14),.data_width(8)) K4(
  .clk(clk_sys),
  .addr(FGROM_addr),
  .dout(K4_D),
  .ce(1'b0),
  .oe(1'b0),
  .we(rom_init && rom_init_address < 18'h10000),
  .waddr(rom_init_address),
  .wdata(rom_init_data)
);

dpram #(.addr_width(14),.data_width(8)) K5(
  .clk(clk_sys),
  .addr(FGROM_addr),
  .dout(K5_D),
  .ce(1'b0),
  .oe(1'b0),
  .we(rom_init && rom_init_address < 18'h14000),
  .waddr(rom_init_address),
  .wdata(rom_init_data)
);

dpram #(.addr_width(14),.data_width(8)) K6(
  .clk(clk_sys),
  .addr(FGROM_addr),
  .dout(K6_D),
  .ce(1'b0),
  .oe(1'b0),
  .we(rom_init && rom_init_address < 18'h18000),
  .waddr(rom_init_address),
  .wdata(rom_init_data)
);

dpram #(.addr_width(14),.data_width(8)) K7_8(
  .clk(clk_sys),
  .addr(FGROM_addr),
  .dout(K7_8_D),
  .ce(1'b0),
  .oe(1'b0),
  .we(rom_init & rom_init_address < 18'h1C000),
  .waddr(rom_init_address),
  .wdata(rom_init_data)
);

x74157 K9(
  .A({ 1'b0, K13_11, 1'b0, S5 }),
  .B({ 1'b0, S5, 1'b0, K13_11 }),
  .s(VV[0]),
  .en(1'b0),
  .Y(K9_Y)
);

x74157 K10(
  .A({ L7_8_Q, L6_7_Q, L5_6_Q, L4_5_Q }),
  .B(4'd0),
  .s(K15_10),
  .en(1'b0),
  .Y(K10_Y)
);

x74157 K11(
  .A({ L7_8_Q, L6_7_Q, L5_6_Q, L4_5_Q }),
  .B(4'd0),
  .s(VV[0]),
  .en(1'b0),
  .Y(K11_Y)
);

// K12
wire K12_6 = ~(L5_6_Q | L6_7_Q | L7_8_Q | L4_5_Q);

// K13
wire K13_3 = K15_4 | K15_6;
wire K13_6 = J13_Q1 | nFRSEL;
wire K13_8 = CLK5 | CLK;
wire K13_11 = K12_6 | CLK;

// K14
wire K14_3 = K17_Q[0] & E17_8;
wire K14_6 = H15_8 & K15_6;
wire K14_8 = K15_6 & K14_11;
wire K14_11 = K15_4 & F15_6;

// K15
wire K15_2 = ~J16_Q[1];
wire K15_4 = ~E17_8;
wire K15_6 = ~K17_Q[0];
wire K15_8 = ~SBBW;
wire K15_10 = ~E15_3;
wire K15_12 = ~J16_Q[2];

// K16
wire K16_8 = ~(J16_Q[0] & J16_Q[1] & K15_12 & ~CLK5);
wire K16_6 = ~(J16_Q[0] & K15_2 & K15_12 & ~CLK5);

x74161 K17(
  .cl(1'b1),
  .ep(1'b1),
  .et(J17_co),
  .clk(CLK5),
  .P(4'd0),
  .ld(J15),
  .Q(K17_Q)
);

x74166 L4_5(
  .clk(CLK),
  .LD(nSRLD),
  .D(K4_D),
  .Q(L4_5_Q)
);

x74166 L5_6(
  .clk(CLK),
  .LD(nSRLD),
  .D(K5_D),
  .Q(L5_6_Q)
);

x74166 L6_7(
  .clk(CLK),
  .LD(nSRLD),
  .D(K6_D),
  .Q(L6_7_Q)
);

x74166 L7_8(
  .clk(CLK),
  .LD(nSRLD),
  .D(K7_8_D),
  .Q(L7_8_Q)
);


x7474 L10(
  .clk1(G16_Q[1]),
  .clr1(1'b1),
  .pre1(1'b1),
  .D1(E10_11_Q[7]),
  .Q1(L10_Q1)
);

// L11
wire L11_6 = ~(L12_Q[1] & L12_Q[0] & ~L12_Q[2]);
// wire L11_8 = ~(L12_Q[2] & 1'b1);

x74161 L12(
  .cl(1'b1),
  .ep(1'b1),
  .et(1'b1),
  .clk(~CLK),
  .P(4'd0),
  .ld(LATCH_CLK),
  .Q(L12_Q)
);

endmodule