
ne

module alu_param_tb;

 
  reg  [7:0] OPA, OPB;
  reg        CIN, CLK, RST, CE, MODE;
  reg  [1:0] INP_VALID;
  reg  [3:0] CMD;


  wire [8:0] RES;
  wire       ERR, OFLOW, COUT, G, L, E;

  
  ALU_Ver dut (
      .OPA(OPA),
      .OPB(OPB),
      .CIN(CIN),
      .CLK(CLK),
      .RST(RST),
      .CE(CE),
      .INP_VALID(INP_VALID),
      .MODE(MODE),
      .CMD(CMD),
      .RES(RES),
      .COUT(COUT),
      .OFLOW(OFLOW),
      .G(G),
      .E(E),
      .L(L),
      .ERR(ERR)
  );

  
  initial CLK = 0;
  always #5 CLK = ~CLK;


  task apply_op;
      input [7:0] a, b;
      input cin;
      input mode;
      input [1:0] valid;
      input [3:0] cmd;
      input [127:0] desc;
      begin
          @(negedge CLK);
          OPA = a;
          OPB = b;
          CIN = cin;
          MODE = mode;
          INP_VALID = valid;
          CMD = cmd;
          CE = 1;

          @(posedge CLK);
          @(posedge CLK);
          @(posedge CLK);
          #1;

          $display("[%0t] %s | OPA=%0d OPB=%0d CIN=%b MODE=%b CMD=%0d | RES=%0d COUT=%b OFLOW=%b G=%b L=%b E=%b ERR=%b",
                   $time, desc, a, b, cin, mode, cmd, RES, COUT, OFLOW, G, L, E, ERR);

          CE = 0;
      end
  endtask


  initial begin
      
      OPA=0; OPB=0; CIN=0; CE=0;
      MODE=0; INP_VALID=2'b00; CMD=0;
      RST=1;

      repeat(2) @(posedge CLK);

      
      @(negedge CLK);
      RST = 0;

      $display("\n========== ALU TESTBENCH START ==========\n");

      
      $display("--- ARITHMETIC MODE (MODE=1) ---");

      apply_op(8'd50,  8'd30,  0, 1, 2'b11, 4'd0, "ADD normal");
      apply_op(8'd200, 8'd100, 0, 1, 2'b11, 4'd0, "ADD overflow");
      apply_op(8'd10,  8'd0,   0, 1, 2'b01, 4'd0, "ADD ERR test");

      apply_op(8'd50,  8'd30,  0, 1, 2'b11, 4'd1, "SUB normal");
      apply_op(8'd10,  8'd20,  0, 1, 2'b11, 4'd1, "SUB underflow");

      apply_op(8'd100, 8'd100, 1, 1, 2'b11, 4'd2, "ADDC cin=1");
      apply_op(8'd255, 8'd255, 1, 1, 2'b11, 4'd2, "ADDC overflow");

      apply_op(8'd50,  8'd20,  1, 1, 2'b11, 4'd3, "SUBB cin=1");

      apply_op(8'd10,  8'd0,   0, 1, 2'b01, 4'd4, "INC OPA=10");
      apply_op(8'd255, 8'd0,   0, 1, 2'b01, 4'd4, "INC OPA=255");

      apply_op(8'd10,  8'd0,   0, 1, 2'b01, 4'd5, "DEC OPA=10");
      apply_op(8'd0,   8'd0,   0, 1, 2'b01, 4'd5, "DEC OPA=0");

      apply_op(8'd0,   8'd20,  0, 1, 2'b10, 4'd6, "INC OPB=20");
      apply_op(8'd0,   8'd0,   0, 1, 2'b10, 4'd7, "DEC OPB=0");

      apply_op(8'd50,  8'd30,  0, 1, 2'b11, 4'd8, "CMP OPA>OPB");
      apply_op(8'd30,  8'd50,  0, 1, 2'b11, 4'd8, "CMP OPA<OPB");
      apply_op(8'd50,  8'd50,  0, 1, 2'b11, 4'd8, "CMP OPA==OPB");

      apply_op(8'd5,  8'd9,  0, 1, 2'b11, 4'd9, "MUL");
      apply_op(8'd2,  8'd5,  0, 1, 2'b11, 4'd10, "MUL2");
      
      apply_op(8'h7F,  8'h01,  0, 1, 2'b11, 4'd11, "SADD overflow");
      apply_op(8'h80,  8'h01,  0, 1, 2'b11, 4'd12, "SSUB overflow");

      $display("\n--- LOGIC MODE (MODE=0) ---");

      apply_op(8'hAA, 8'hF0, 0, 0, 2'b11, 4'd0, "AND");
      apply_op(8'hAA, 8'hF0, 0, 0, 2'b11, 4'd1, "NAND");
      apply_op(8'hAA, 8'h55, 0, 0, 2'b11, 4'd2, "OR");
      apply_op(8'hAA, 8'h55, 0, 0, 2'b11, 4'd3, "NOR");
      apply_op(8'hAA, 8'h55, 0, 0, 2'b11, 4'd4, "XOR");
      apply_op(8'hAA, 8'h55, 0, 0, 2'b11, 4'd5, "XNOR");

      apply_op(8'hAA, 8'h00, 0, 0, 2'b01, 4'd6, "NOT OPA");
      apply_op(8'h00, 8'h55, 0, 0, 2'b10, 4'd7, "NOT OPB");

      apply_op(8'hAA, 8'h00, 0, 0, 2'b01, 4'd8, "LSR OPA");
      apply_op(8'h55, 8'h00, 0, 0, 2'b01, 4'd9, "LSL OPA");

      apply_op(8'h00, 8'hCC, 0, 0, 2'b10, 4'd10, "LSR OPB");
      apply_op(8'h00, 8'h33, 0, 0, 2'b10, 4'd11, "LSL OPB");

      apply_op(8'hA5, 8'd2,  0, 0, 2'b11, 4'd12, "ROL by 2");
      apply_op(8'hA5, 8'd2,  0, 0, 2'b11, 4'd13, "ROR by 2");

   
      $display("\n--- RESET TEST ---");
      @(negedge CLK);
      OPA=8'hFF; OPB=8'hFF; MODE=1; INP_VALID=2'b11; CMD=4'd0; CE=1;
      @(posedge CLK); #1;
      $display("Before RST: RES=%0d", RES);

      RST=1;
      @(posedge CLK); #1;
      $display("After RST:  RES=%0d ERR=%b OFLOW=%b", RES, ERR, OFLOW);

      RST=0; CE=0;

    
      $display("\n--- CE DISABLED TEST ---");
      @(negedge CLK);
      OPA=8'd99; OPB=8'd1; MODE=1; INP_VALID=2'b11; CMD=4'd0;
      CE=0;
      @(posedge CLK); #1;
      $display("CE=0: RES=%0d (should remain unchanged)", RES);

      $display("\n========== TESTBENCH COMPLETE ==========\n");
      $finish;
  end


  initial begin
      #50000;
      $display("TIMEOUT: simulation exceeded limit.");
      $finish;
  end

endmodule
