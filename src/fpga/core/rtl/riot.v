
module riot(
  input PHI2,
  input RES_N,
  input CS1,
  input CS2_N,
  input RS_N,
  input R_W,
  input [6:0] A,
  input [7:0] D_I,
  output reg [7:0] D_O,
  input [7:0] PA_I,
  output reg [7:0] PA_O,
  output reg [7:0] DDRA_O,
  input [7:0] PB_I,
  output reg [7:0] PB_O,
  output reg [7:0] DDRB_O,
  output IRQ_N
);

parameter
  TIM1T = 2'd0,
  TIM8T = 2'd1,
  TIM64T = 2'd2,
  TIM1024T = 2'd3;

reg [7:0] RAM[127:0];
reg [1:0] PERIOD;
reg [7:0] DDRA, DDRB, ORA, ORB;
reg PA7FLAG;
reg TIMERFLAG;
reg PA7FLAGENABLE;
reg TIMERFLAGENABLE;
reg EDGEDETECT;
reg PA7CLEARNEED;
reg PA7CLEARDONE;
reg TIMERCLEARNEED;
reg TIMERCLEARDONE;
reg [18:0] COUNTER;
reg PA7;

integer i;

assign IRQ_N = ~((TIMERFLAG & TIMERFLAGENABLE) | (PA7FLAG & PA7FLAGENABLE));

always @(negedge PHI2) begin

  if (RES_N & CS1 & ~CS2_N) begin
    if (R_W) begin
      if (~RS_N)
        D_O <= RAM[A];
      else begin
        if (~A[2]) begin
          case (A[1:0])
            2'b00: D_O <= PA_I;
            2'b01: D_O <= DDRA;
            2'b10: D_O <= PB_I;
            2'b11: D_O <= DDRB;
          endcase
        end
        else begin
          if (~A[0]) begin
            TIMERCLEARNEED <= ~TIMERCLEARNEED;
            if (COUNTER[18])
              D_O <= COUNTER[7:0];
            else begin
              case (PERIOD)
                TIM1T: D_O <= COUNTER[7:0];
                TIM8T: D_O <= COUNTER[10:3];
                TIM64T: D_O <= COUNTER[13:6];
                TIM1024T: D_O <= COUNTER[17:10];
              endcase
            end
          end
          else begin
            D_O <= { TIMERFLAG, PA7FLAG, 6'd0 };
            PA7CLEARNEED <= ~PA7CLEARNEED;
          end
        end
      end
    end
    else begin
      D_O <= 0;
    end
  end
  else begin
    D_O <= 0;
  end

  // the following was negedge PHI2 in original file

  if (EDGEDETECT == PA_I[7] && PA7 != PA_I[7]) PA7FLAG <= 1'b1;

  if (COUNTER[18]) begin
    PERIOD <= TIM1T;
    TIMERFLAG <= 1'b1;
  end

  COUNTER <= COUNTER - 19'd1;

  if (PA7CLEARNEED != PA7CLEARDONE) begin
    PA7CLEARDONE <= PA7CLEARNEED;
    PA7FLAG <= 0;
  end

  if (TIMERCLEARNEED != TIMERCLEARDONE) begin
    TIMERCLEARDONE <= TIMERCLEARNEED;
    TIMERFLAG <= 0;
  end

  if (RES_N & CS1 & ~CS2_N) begin
    if (~R_W) begin
      if (~RS_N) begin
        RAM[A] <= D_I;
      end
      else begin
        if (~A[2]) begin
          case (A[1:0])
            2'b00: ORA <= D_I;
            2'b01: DDRA <= D_I;
            2'b10: ORB <= D_I;
            2'b11: DDRB <= D_I;
          endcase
        end
        else begin
          if (A[4]) begin
            case (A[1:0])
              2'b00: begin
                PERIOD <= TIM1T;
                COUNTER <= { 11'b0, D_I };
                TIMERFLAG <= 1'b0;
              end
              2'b01: begin
                PERIOD <= TIM8T;
                COUNTER <= { 8'd0, D_I, 3'd0 };
                TIMERFLAG <= 1'b0;
              end
              2'b10: begin
                PERIOD <= TIM64T;
                COUNTER <= { 5'd0, D_I, 6'd0 };
                TIMERFLAG <= 1'b0;
              end
              2'b11: begin
                PERIOD <= TIM1024T;
                COUNTER <= { 1'd0, D_I, 10'd0 };
                TIMERFLAG <= 1'b0;
              end
            endcase
            TIMERFLAGENABLE <= A[3];
          end
          else begin
            if (A[2]) begin
              PA7FLAGENABLE <= A[1];
              EDGEDETECT <= A[0];
            end
          end

        end
      end
    end
    else if (A[2] & ~A[0]) begin
      TIMERFLAGENABLE <= A[3];
    end
  end
  else begin
    if (~RES_N) begin
      ORA <= 8'd0;
      ORB <= 8'd0;
      DDRA <= 8'd0;
      DDRB <= 8'd0;
      PA7FLAG <= 1'b0;
      TIMERFLAG <= 1'b0;
      PA7FLAGENABLE <= 1'b0;
      TIMERFLAGENABLE <= 1'b0;
      EDGEDETECT <= 1'b0;
      PERIOD <= TIM1T;
      COUNTER <= 19'd0;
    end
  end

  for (i = 0; i < 8; i = i + 1) begin
    PA_O[i] = DDRA[i] ? ORA[i] : 1'b0;
    PB_O[i] = DDRB[i] ? ORB[i] : 1'b0;
  end

  DDRA_O <= DDRA;
  DDRB_O <= DDRB;
  PA7 <= PA_I[7];

end

endmodule
