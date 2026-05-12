module monitor_scb #(
  parameter WIDTH     = 8,
  parameter CMD_WIDTH = 4
)(
  input wire                  CLK,
  input wire                  RST,
  input wire                  CE,
  input wire  [1:0]           INP_VALID,
  input wire                  MODE,
  input wire  [CMD_WIDTH-1:0] CMD,
  input wire                  CIN,
  input wire  [WIDTH-1:0]     OPA,
  input wire  [WIDTH-1:0]     OPB,
  input wire  [2*WIDTH-1:0]   RES,
  input wire                  COUT,
  input wire                  OFLOW,
  input wire                  G,
  input wire                  L,
  input wire                  E,
  input wire                  ERR
);
  reg [2*WIDTH-1:0]   exp_res;
  reg                 exp_cout;
  reg                 exp_oflow;
  reg                 exp_g, exp_l, exp_e;
  reg                 exp_err;
  reg [1:0]           v_d;
  reg                 mode_d;
  reg [CMD_WIDTH-1:0] cmd_d;
  reg [WIDTH-1:0]     a_d, b_d;
  reg [2*WIDTH-1:0]   A_d, B_d;
  reg                 cin_d;
  reg [2*WIDTH-1:0]   mul_res_d;
  reg                 mul_err_d;
  wire [2:0]       sh       = b_d[2:0];
  wire             rot_err  = |b_d[WIDTH-1:3];
 
  integer pass_cnt = 0;
  integer fail_cnt = 0;
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      v_d <= 0; mode_d <= 0; cmd_d <= 0;
      a_d <= 0; b_d <= 0; A_d <= 0; B_d <= 0; cin_d <= 0;
    end else if (CE) begin
      v_d    <= INP_VALID;
      mode_d <= MODE;
      cmd_d  <= CMD;
      cin_d  <= CIN;
      a_d    <= OPA;
      b_d    <= OPB;
      A_d    <= OPA;
      B_d    <= OPB;
    end
  end
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      exp_res   <= 0; exp_cout  <= 0; exp_oflow <= 0;
      exp_g     <= 0; exp_l     <= 0; exp_e     <= 0;
      exp_err   <= 0;
      mul_res_d <= 0; mul_err_d <= 0;
    end else if (CE) begin
      exp_res   <= 0; exp_cout  <= 0; exp_oflow <= 0;
      exp_g     <= 0; exp_l     <= 0; exp_e     <= 0;
      exp_err   <= 0;
 
      if (mode_d) begin
        case (cmd_d)
          4'd0: begin 
            exp_err <= (v_d == 2'b11) ? 0 : 1;
            exp_res <= (v_d == 2'b11) ? (A_d + B_d) : 0;
            exp_cout  <= (v_d == 2'b11) ? (A_d + B_d) >> WIDTH : 0;
            exp_oflow <= (v_d == 2'b11) ? (A_d + B_d) >> WIDTH : 0;
          end
          4'd1: begin 
            exp_err <= (v_d == 2'b11) ? 0 : 1;
            exp_res <= (v_d == 2'b11) ? (A_d - B_d) : 0;
            exp_cout  <= (v_d == 2'b11) ? (A_d - B_d) >> WIDTH : 0;
            exp_oflow <= (v_d == 2'b11) ? (A_d - B_d) >> WIDTH : 0;
          end
          4'd2: begin 
            exp_err <= (v_d == 2'b11) ? 0 : 1;
            exp_res <= (v_d == 2'b11) ? (A_d + B_d + cin_d) : 0;
            exp_cout  <= (v_d == 2'b11) ? (A_d + B_d + cin_d) >> WIDTH : 0;
            exp_oflow <= (v_d == 2'b11) ? (A_d + B_d + cin_d) >> WIDTH : 0;
          end
          4'd3: begin 
            exp_err <= (v_d == 2'b11) ? 0 : 1;
            exp_res <= (v_d == 2'b11) ? (A_d - B_d - cin_d) : 0;
            exp_cout  <= (v_d == 2'b11) ? (A_d - B_d - cin_d) >> WIDTH : 0;
            exp_oflow <= (v_d == 2'b11) ? (A_d - B_d - cin_d) >> WIDTH : 0;
          end
          4'd4: begin 
            exp_err <= (v_d == 2'b01) ? 0 : 1;
            exp_res <= (v_d == 2'b01) ? (A_d + 1) : 0;
            exp_cout  <= (v_d == 2'b01) ? (A_d + 1) >> WIDTH : 0;
            exp_oflow <= (v_d == 2'b01) ? (A_d + 1) >> WIDTH : 0;
          end
          4'd5: begin 
            exp_err <= (v_d == 2'b01) ? 0 : 1;
            exp_res <= (v_d == 2'b01) ? (A_d - 1) : 0;
            exp_cout  <= (v_d == 2'b01) ? (A_d - 1) >> WIDTH : 0;
            exp_oflow <= (v_d == 2'b01) ? (A_d - 1) >> WIDTH : 0;
          end
          4'd6: begin 
            exp_err <= (v_d == 2'b10) ? 0 : 1;
            exp_res <= (v_d == 2'b10) ? (B_d + 1) : 0;
            exp_cout  <= (v_d == 2'b10) ? (B_d + 1) >> WIDTH : 0;
            exp_oflow <= (v_d == 2'b10) ? (B_d + 1) >> WIDTH : 0;
          end
          4'd7: begin 
            exp_err <= (v_d == 2'b10) ? 0 : 1;
            exp_res <= (v_d == 2'b10) ? (B_d - 1) : 0;
            exp_cout  <= (v_d == 2'b10) ? (B_d - 1) >> WIDTH : 0;
            exp_oflow <= (v_d == 2'b10) ? (B_d - 1) >> WIDTH : 0;
          end
          4'd8: begin 
            exp_res  <= 0;
            exp_cout <= 0; exp_oflow <= 0;
            if (v_d == 2'b11) begin
              exp_err <= 0;
              exp_g   <= (A_d > B_d);
              exp_l   <= (A_d < B_d);
              exp_e   <= (A_d == B_d);
            end else begin
              exp_err <= 1;
            end
          end
          4'd9: begin 
            mul_err_d <= (v_d == 2'b11) ? 0 : 1;
            mul_res_d <= (v_d == 2'b11) ? ((A_d + 1) * (B_d + 1)) : 0;
            exp_res   <= mul_res_d;
            exp_err   <= mul_err_d;
            exp_cout  <= 0; exp_oflow <= 0;
          end
          4'd10: begin
            mul_err_d <= (v_d == 2'b11) ? 0 : 1;
            mul_res_d <= (v_d == 2'b11) ? ((A_d << 1) * B_d) : 0;
            exp_res   <= mul_res_d;
            exp_err   <= mul_err_d;
            exp_cout  <= 0; exp_oflow <= 0;
          end
           4'd11: begin 
    exp_err <= (v_d == 2'b11) ? 0 : 1;
    if (v_d == 2'b11) begin
      begin : signed_add_blk
        reg [2*WIDTH-1:0] tmp_sum;
        tmp_sum   = A_d + B_d;
        exp_res   <= tmp_sum;
        exp_cout  <= tmp_sum[WIDTH];
        exp_oflow <= (a_d[WIDTH-1] == b_d[WIDTH-1]) &&
                     (a_d[WIDTH-1] != tmp_sum[WIDTH-1]);
        exp_g <= ($signed(a_d) > $signed(b_d));
        exp_l <= ($signed(a_d) < $signed(b_d));
        exp_e <= ($signed(a_d) == $signed(b_d));
      end
    end else begin
      exp_res <= 0;
    end
    end
         4'd12: begin 
    exp_err <= (v_d == 2'b11) ? 0 : 1;
    if (v_d == 2'b11) begin
      begin : signed_sub_blk
        reg [2*WIDTH-1:0] tmp_sub;
        tmp_sub   = $signed({{WIDTH{a_d[WIDTH-1]}}, a_d}) - 
                    $signed({{WIDTH{b_d[WIDTH-1]}}, b_d});
        exp_res   <= tmp_sub;
        exp_cout  <= tmp_sub[WIDTH];
        exp_oflow <= (a_d[WIDTH-1] != b_d[WIDTH-1]) &&
                     (a_d[WIDTH-1] != tmp_sub[WIDTH-1]); 
        exp_g <= ($signed(a_d) > $signed(b_d));
        exp_l <= ($signed(a_d) < $signed(b_d));
        exp_e <= ($signed(a_d) == $signed(b_d));
      end
    end else begin
      exp_res <= 0;
    end
   end
          default: begin
            exp_err <= 1; exp_res <= 0;
          end
        endcase
 
      end else begin
        exp_cout <= 0; exp_oflow <= 0;
        case (cmd_d)
          4'd0:  begin exp_err <= (v_d==2'b11)?0:1; exp_res <= (v_d==2'b11)? {8'd0, (a_d & b_d)}  :0; end
          4'd1:  begin exp_err <= (v_d==2'b11)?0:1; exp_res <= (v_d==2'b11)? {8'd0,~(a_d & b_d)}  :0; end
          4'd2:  begin exp_err <= (v_d==2'b11)?0:1; exp_res <= (v_d==2'b11)? {8'd0, (a_d | b_d)}  :0; end
          4'd3:  begin exp_err <= (v_d==2'b11)?0:1; exp_res <= (v_d==2'b11)? {8'd0,~(a_d | b_d)}  :0; end
          4'd4:  begin exp_err <= (v_d==2'b11)?0:1; exp_res <= (v_d==2'b11)? {8'd0, (a_d ^ b_d)}  :0; end
          4'd5:  begin exp_err <= (v_d==2'b11)?0:1; exp_res <= (v_d==2'b11)? {8'd0,~(a_d ^ b_d)}  :0; end
          4'd6:  begin exp_err <= (v_d==2'b01)?0:1; exp_res <= (v_d==2'b01)? {8'd0, ~a_d}         :0; end
          4'd7:  begin exp_err <= (v_d==2'b10)?0:1; exp_res <= (v_d==2'b10)? {8'd0, ~b_d}         :0; end
          4'd8:  begin exp_err <= (v_d==2'b01)?0:1; exp_res <= (v_d==2'b01)? {8'd0, (a_d >> 1)}   :0; end
          4'd9:  begin exp_err <= (v_d==2'b01)?0:1; exp_res <= (v_d==2'b01)? {8'd0, (a_d << 1)}   :0; end
          4'd10: begin exp_err <= (v_d==2'b10)?0:1; exp_res <= (v_d==2'b10)? {8'd0, (b_d >> 1)}   :0; end
          4'd11: begin exp_err <= (v_d==2'b10)?0:1; exp_res <= (v_d==2'b10)? {8'd0, (b_d << 1)}   :0; end
          4'd12: begin 
            exp_err <= (v_d==2'b11) ? rot_err : 1'b1;
            exp_res <= (v_d==2'b11 && !rot_err) ?
                       {8'd0, (a_d << sh) | (a_d >> (WIDTH - sh))} : 0;
          end
          4'd13: begin
            exp_err <= (v_d==2'b11) ? rot_err : 1'b1;
            exp_res <= (v_d==2'b11 && !rot_err) ?
                       {8'd0, (a_d >> sh) | (a_d << (WIDTH - sh))} : 0;
          end
          default: begin exp_err <= 1; exp_res <= 0; end
        endcase
      end
    end
  end
  always @(posedge CLK) begin
    if (!RST && CE) begin
      @(posedge CLK); #1;
 
      $display("----------------------------------------------------");
      $display("MODE=%0b CMD=%0d OPA=0x%02h OPB=0x%02h VALID=%02b CIN=%0b",
               mode_d, cmd_d, a_d, b_d, v_d, cin_d);
      $display("  DUT : RES=%04h COUT=%b OFLOW=%b G=%b L=%b E=%b ERR=%b",
               RES, COUT, OFLOW, G, L, E, ERR);
      $display("  EXP : RES=%04h COUT=%b OFLOW=%b G=%b L=%b E=%b ERR=%b",
               exp_res, exp_cout, exp_oflow, exp_g, exp_l, exp_e, exp_err);
 
      if (RES   !== exp_res   ||
          ERR   !== exp_err   ||
          G     !== exp_g     ||
          L     !== exp_l     ||
          E     !== exp_e) begin
        $display("  RESULT: ** FAIL **");
        fail_cnt = fail_cnt + 1;
      end else begin
        $display("  RESULT: PASS");
        pass_cnt = pass_cnt + 1;
      end
    end
  end
endmodule
 
