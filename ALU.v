
ne

module ALU_Ver(
  input  wire [7:0] OPA, OPB,
  input  wire       CIN,
  input  wire       CLK, RST,
  input  wire       CE,
  input  wire [1:0] INP_VALID,
  input  wire       MODE,
  input  wire [3:0] CMD,
  output reg  [8:0] RES,
  output reg        COUT,
  output reg        OFLOW,
  output reg        G, E, L, ERR
);
  localparam W  = 8;
  localparam RW = $clog2(W);
  reg [7:0] OPA_reg, OPB_reg, Am, Bm;
  reg MODE_reg, CIN_reg;
  reg [3:0] CMD_reg;
  reg [1:0] IV_reg;
  reg [8:0] RES_2;
  reg COUT_2, OFLOW_2, G_2, E_2, L_2, ERR_2;
  reg signed [7:0] sOPA, sOPB;
  reg signed [8:0] sRES;
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      OPA_reg  <= 8'b0;
      OPB_reg  <= 8'b0;
      Am       <= 8'b0;
      Bm       <= 8'b0;
      CIN_reg  <= 1'b0;
      MODE_reg <= 1'b0;
      CMD_reg  <= 4'b0;
      IV_reg   <= 2'b0;
    end
    else begin
      OPA_reg  <= OPA;
      OPB_reg  <= OPB;
      Am       <= (CMD_reg == 9 || CMD_reg == 10) ? OPA_reg : 8'b0;
      Bm       <= (CMD_reg == 9 || CMD_reg == 10) ? OPB_reg : 8'b0;
      CIN_reg  <= CIN;
      MODE_reg <= MODE;
      CMD_reg  <= CMD;
      IV_reg   <= INP_VALID;
    end
  end
  always @(*) begin
    RES_2   = 9'b0;
    COUT_2  = 1'b0;
    OFLOW_2 = 1'b0;
    G_2     = 1'b0;
    E_2     = 1'b0;
    L_2     = 1'b0;
    ERR_2   = 1'b0;
    sOPA = OPA_reg;
    sOPB = OPB_reg;
    if (MODE_reg) begin
      case (CMD_reg)
        4'd0: begin
          if (IV_reg == 2'b11) begin
            RES_2  = OPA_reg + OPB_reg;
            COUT_2 = RES_2[8];
          end else begin
            ERR_2 = 1'b1;
          end
        end
        4'd1: begin
          if (IV_reg == 2'b11) begin
            RES_2  = OPA_reg - OPB_reg;
            COUT_2 = RES_2[8];
          end else begin
            ERR_2 = 1'b1;
          end
        end
        4'd2: begin
          if (IV_reg == 2'b11) begin
            RES_2  = OPA_reg + OPB_reg + CIN_reg;
            COUT_2 = RES_2[8];
          end else begin
            ERR_2 = 1'b1;
          end
        end
        4'd3: begin
          if (IV_reg == 2'b11) begin
            RES_2  = OPA_reg - OPB_reg - CIN_reg;
            COUT_2 = RES_2[8];
          end else begin
            ERR_2 = 1'b1;
          end
        end
        4'd4: begin
          if (IV_reg[0]) begin
            RES_2  = OPA_reg + 1;
            COUT_2 = RES_2[8];
          end else begin
            ERR_2 = 1'b1;
          end
        end
        4'd5: begin
          if (IV_reg[0]) begin
            RES_2  = OPA_reg - 1;
            COUT_2 = RES_2[8];
          end else begin
            ERR_2 = 1'b1;
          end
        end
        4'd6: begin
          if (IV_reg[1]) begin
            RES_2  = OPB_reg + 1;
            COUT_2 = RES_2[8];
          end else begin
            ERR_2 = 1'b1;
          end
        end
        4'd7: begin
          if (IV_reg[1]) begin
            RES_2  = OPB_reg - 1;
            COUT_2 = RES_2[8];
          end else begin
            ERR_2 = 1'b1;
          end
        end
        4'd8: begin
          if (IV_reg == 2'b11) begin
            G_2 = (OPA_reg > OPB_reg);
            L_2 = (OPA_reg < OPB_reg);
            E_2 = (OPA_reg == OPB_reg);
          end else begin
            ERR_2 = 1'b1;
          end
        end
        4'd9: begin
          if (IV_reg == 2'b11) begin
            RES_2  = (Am + 1) * (Bm + 1);
            COUT_2 = RES_2[8];
          end else begin
            ERR_2 = 1'b1;
          end
        end
        4'd10: begin
          if (IV_reg == 2'b11) begin
            RES_2  = (Am << 1) * Bm;
            COUT_2 = RES_2[8];
          end else begin
            ERR_2 = 1'b1;
          end
        end
        4'd11: begin
          if (IV_reg == 2'b11) begin
            sRES  = sOPA + sOPB;
            RES_2 = sRES;
            COUT_2 = RES_2[8];

            G_2 = (sOPA > sOPB);
            L_2 = (sOPA < sOPB);
            E_2 = (sOPA == sOPB);
            OFLOW_2 = (~sOPA[7] & ~sOPB[7] & sRES[7]) |
                      ( sOPA[7] &  sOPB[7] & ~sRES[7]);
          end else begin
            ERR_2 = 1'b1;
          end
        end
        4'd12: begin
          if (IV_reg == 2'b11) begin
            sRES  = sOPA - sOPB;
            RES_2 = sRES;
            COUT_2 = RES_2[8];
            G_2 = (sOPA > sOPB);
            L_2 = (sOPA < sOPB);
            E_2 = (sOPA == sOPB);

            OFLOW_2 = (sOPA[7] ^ sOPB[7]) & (sRES[7] ^ sOPA[7]);
          end else begin
            ERR_2 = 1'b1;
          end
        end
        default: begin
          RES_2 = 9'b0;
        end
      endcase
    end
    else begin
      case (CMD_reg)
        4'd0: begin
          if (IV_reg == 2'b11) RES_2 = {1'b0, (OPA_reg & OPB_reg)};
          else ERR_2 = 1'b1;
        end
        4'd1: begin
          if (IV_reg == 2'b11) RES_2 = {1'b0, ~(OPA_reg & OPB_reg)};
          else ERR_2 = 1'b1;
        end
        4'd2: begin
          if (IV_reg == 2'b11) RES_2 = {1'b0, (OPA_reg | OPB_reg)};
          else ERR_2 = 1'b1;
        end
        4'd3: begin
          if (IV_reg == 2'b11) RES_2 = {1'b0, ~(OPA_reg | OPB_reg)};
          else ERR_2 = 1'b1;
        end
        4'd4: begin
          if (IV_reg == 2'b11) RES_2 = {1'b0, (OPA_reg ^ OPB_reg)};
          else ERR_2 = 1'b1;
        end
        4'd5: begin
          if (IV_reg == 2'b11) RES_2 = {1'b0, ~(OPA_reg ^ OPB_reg)};
          else ERR_2 = 1'b1;
        end
        4'd6: begin
          if (IV_reg[0]) RES_2 = {1'b0, ~OPA_reg};
          else ERR_2 = 1'b1;
        end
        4'd7: begin
          if (IV_reg[1]) RES_2 = {1'b0, ~OPB_reg};
          else ERR_2 = 1'b1;
       end
        4'd8: begin
          if (IV_reg[0]) RES_2 = {1'b0, (OPA_reg >> 1)};
          else ERR_2 = 1'b1;
        end
        4'd9: begin
          if (IV_reg[0]) RES_2 = {1'b0, (OPA_reg << 1)};
          else ERR_2 = 1'b1;
        end
        4'd10: begin
          if (IV_reg[1]) RES_2 = {1'b0, (OPB_reg >> 1)};
          else ERR_2 = 1'b1;
        end
        4'd11: begin
          if (IV_reg[1]) RES_2 = {1'b0, (OPB_reg << 1)};
          else ERR_2 = 1'b1;
        end
        4'd12: begin
          if (IV_reg == 2'b11 && ~|OPB_reg[W-1:RW]) begin
            RES_2 = (OPA_reg << OPB_reg[RW-1:0]) |
                    (OPA_reg >> (W - OPB_reg[RW-1:0]));
          end else begin
            ERR_2 = 1'b1;
          end
        end
        4'd13: begin
          if (IV_reg == 2'b11 && ~|OPB_reg[W-1:RW]) begin
            RES_2 = (OPA_reg >> OPB_reg[RW-1:0]) |
                    (OPA_reg << (W - OPB_reg[RW-1:0]));
          end else begin
            ERR_2 = 1'b1;
          end
        end
        default: begin
          RES_2 = 9'b0;
        end
      endcase
    end
  end
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      RES   <= 9'b0;
      COUT  <= 1'b0;
      OFLOW <= 1'b0;
      G     <= 1'b0;
      E     <= 1'b0;
      L     <= 1'b0;
      ERR   <= 1'b0;
    end
    else if (CE) begin
      RES   <= RES_2;
      COUT  <= COUT_2;
      OFLOW <= OFLOW_2;
      G     <= G_2;
      E     <= E_2;
      L     <= L_2;
      ERR   <= ERR_2;
    end
  end

endmodule
