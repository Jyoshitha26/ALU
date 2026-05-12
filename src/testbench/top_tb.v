`include "alu.v"
`include "a_drv.v"
`include "a_mon_scb.v"
module test_bench_alu;
  wire                  CLK;
  wire                  RST;
  wire                  CE;
  wire  [1:0]           INP_VALID;
  wire                  MODE;
  wire  [3:0]           CMD;
  wire                  CIN;
  wire  [7:0]           OPA;
  wire  [7:0]           OPB;
 
  wire  [15:0]          RES;
  wire                  COUT;
  wire                  OFLOW;
  wire                  G;
  wire                  L;
  wire                  E;
  wire                  ERR;
  driver #(.WIDTH(8), .CMD_WIDTH(4)) drv (
    .CLK      (CLK),
    .RST      (RST),
    .CE       (CE),
    .INP_VALID(INP_VALID),
    .MODE     (MODE),
    .CMD      (CMD),
    .CIN      (CIN),
    .OPA      (OPA),
    .OPB      (OPB)
  );
  alu #(.WIDTH(8), .CMD_WIDTH(4)) DUT (
    .CLK      (CLK),
    .RST      (RST),
    .CE       (CE),
    .INP_VALID(INP_VALID),
    .MODE     (MODE),
    .CMD      (CMD),
    .CIN      (CIN),
    .OPA      (OPA),
    .OPB      (OPB),
    .RES      (RES),
    .COUT     (COUT),
    .OFLOW    (OFLOW),
    .G        (G),
    .L        (L),
    .E        (E),
    .ERR      (ERR)
  );
  monitor_scb #(.WIDTH(8), .CMD_WIDTH(4)) mc (
    .CLK      (CLK),
    .RST      (RST),
    .CE       (CE),
    .INP_VALID(INP_VALID),
    .MODE     (MODE),
    .CMD      (CMD),
    .CIN      (CIN),
    .OPA      (OPA),
    .OPB      (OPB),
    .RES      (RES),
    .COUT     (COUT),
    .OFLOW    (OFLOW),
    .G        (G),
    .L        (L),
    .E        (E),
    .ERR      (ERR)
  );
  initial begin
    $dumpfile("alu_tb.vcd");
    $dumpvars(0, test_bench_alu);
  end
 
endmodule
 
