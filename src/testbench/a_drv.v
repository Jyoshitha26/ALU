module driver #(
  parameter WIDTH     = 8,
  parameter CMD_WIDTH = 4
)(
  output reg                  CLK,
  output reg                  RST,
  output reg                  CE,
  output reg  [1:0]           INP_VALID,
  output reg                  MODE,
  output reg  [CMD_WIDTH-1:0] CMD,
  output reg                  CIN,
  output reg  [WIDTH-1:0]     OPA,
  output reg  [WIDTH-1:0]     OPB
);
  initial CLK = 0;
  always #5 CLK = ~CLK; 
  task drv_inp;
    input [1:0]           inp_valid;
    input                 mode;
    input [CMD_WIDTH-1:0] cmd;
    input                 cin;
    input [WIDTH-1:0]     opa;
    input [WIDTH-1:0]     opb;
    begin
      @(posedge CLK);
      #1;
      CE        = 1;
      INP_VALID = inp_valid;
      MODE      = mode;
      CMD       = cmd;
      CIN       = cin;
      OPA       = opa;
      OPB       = opb;
      @(posedge CLK);
      #1;
      CE = 0;
    end
  endtask
 
  initial begin
    RST = 1; CE = 0; INP_VALID = 0; MODE = 0;
    CMD = 0; CIN = 0; OPA = 0; OPB = 0;
    repeat(3) @(posedge CLK);
    #1; RST = 0;
    repeat(2) @(posedge CLK);
    $display("\n--- LOGICAL OPERATIONS ---");
    drv_inp(2'b11, 1'b0, 4'd0,  1'b0, 8'hAA, 8'hF0);
    drv_inp(2'b10, 1'b0, 4'd0,  1'b0, 8'hAA, 8'hF0);
     drv_inp(2'b01, 1'b0, 4'd0,  1'b0, 8'hAA, 8'hF0);
    drv_inp(2'b11, 1'b0, 4'd1,  1'b0, 8'hAA, 8'hF0);
     drv_inp(2'b10, 1'b0, 4'd1,  1'b0, 8'hAA, 8'hF0);
      drv_inp(2'b01, 1'b0, 4'd1,  1'b0, 8'hAA, 8'hF0);
    drv_inp(2'b11, 1'b0, 4'd2,  1'b0, 8'hAA, 8'h0F);
     drv_inp(2'b10, 1'b0, 4'd2,  1'b0, 8'hAA, 8'h0F);
      drv_inp(2'b01, 1'b0, 4'd2,  1'b0, 8'hAA, 8'h0F);
    drv_inp(2'b11, 1'b0, 4'd3,  1'b0, 8'hAA, 8'h0F);
    drv_inp(2'b10, 1'b0, 4'd3,  1'b0, 8'hAA, 8'h0F);
    drv_inp(2'b01, 1'b0, 4'd3,  1'b0, 8'hAA, 8'h0F);
    drv_inp(2'b11, 1'b0, 4'd4,  1'b0, 8'hFF, 8'h0F);
     drv_inp(2'b10, 1'b0, 4'd4,  1'b0, 8'hFF, 8'h0F);
      drv_inp(2'b01, 1'b0, 4'd4,  1'b0, 8'hFF, 8'h0F);
    drv_inp(2'b11, 1'b0, 4'd5,  1'b0, 8'hFF, 8'h0F);
    drv_inp(2'b10, 1'b0, 4'd5,  1'b0, 8'hFF, 8'h0F);
    drv_inp(2'b01, 1'b0, 4'd5,  1'b0, 8'hFF, 8'h0F);
    drv_inp(2'b01, 1'b0, 4'd6,  1'b0, 8'hAA, 8'h00);
    drv_inp(2'b10, 1'b0, 4'd6,  1'b0, 8'hAA, 8'h00);
    drv_inp(2'b11, 1'b0, 4'd6,  1'b0, 8'hAA, 8'h00);
    drv_inp(2'b10, 1'b0, 4'd7,  1'b0, 8'h00, 8'h55);
     drv_inp(2'b01, 1'b0, 4'd7,  1'b0, 8'h00, 8'h55);
      drv_inp(2'b11, 1'b0, 4'd7,  1'b0, 8'h00, 8'h55);
    drv_inp(2'b01, 1'b0, 4'd8,  1'b0, 8'hF0, 8'h00);
    drv_inp(2'b10, 1'b0, 4'd8,  1'b0, 8'hF0, 8'h00);
    drv_inp(2'b11, 1'b0, 4'd8,  1'b0, 8'hF0, 8'h00);
    drv_inp(2'b01, 1'b0, 4'd9,  1'b0, 8'h0F, 8'h00);
      drv_inp(2'b10, 1'b0, 4'd9,  1'b0, 8'h0F, 8'h00);
        drv_inp(2'b11, 1'b0, 4'd9,  1'b0, 8'h0F, 8'h00);
    drv_inp(2'b10, 1'b0, 4'd10, 1'b0, 8'h00, 8'hF0);
     drv_inp(2'b01, 1'b0, 4'd10, 1'b0, 8'h00, 8'hF0);
      drv_inp(2'b11, 1'b0, 4'd10, 1'b0, 8'h00, 8'hF0);
    drv_inp(2'b10, 1'b0, 4'd11, 1'b0, 8'h00, 8'h0F);
    drv_inp(2'b01, 1'b0, 4'd11, 1'b0, 8'h00, 8'h0F);
    drv_inp(2'b11, 1'b0, 4'd11, 1'b0, 8'h00, 8'h0F);
    drv_inp(2'b11, 1'b0, 4'd12, 1'b0, 8'hB7, 8'h03);
     drv_inp(2'b10, 1'b0, 4'd12, 1'b0, 8'hB7, 8'h03);
      drv_inp(2'b01, 1'b0, 4'd12, 1'b0, 8'hB7, 8'h03);
      drv_inp(2'b11, 1'b0, 4'd13, 1'b0, 8'hB7, 8'h02);
    drv_inp(2'b10, 1'b0, 4'd13, 1'b0, 8'hB7, 8'hFF);
    
    $display("\n--- ARITHMETIC OPERATIONS ---");
    drv_inp(2'b11, 1'b1, 4'd0,  1'b0, 8'd96, 8'd55);
      drv_inp(2'b10, 1'b1, 4'd0,  1'b0, 8'd100, 8'd55);
        drv_inp(2'b01, 1'b1, 4'd0,  1'b0, 8'd100, 8'd66);
    drv_inp(2'b11, 1'b1, 4'd1,1'b0, 8'd200, 8'd50);
     drv_inp(2'b10, 1'b1, 4'd1,  1'b0, 8'd106, 8'd50);
      drv_inp(2'b01, 1'b1, 4'd1,  1'b0, 8'd200, 8'd50);
    drv_inp(2'b11, 1'b1, 4'd2,  1'b1, 8'd100, 8'd100);
    drv_inp(2'b10, 1'b1, 4'd2,  1'b1, 8'd100, 8'd200);
    drv_inp(2'b01, 1'b1, 4'd2,  1'b1, 8'd92, 8'd100);
    drv_inp(2'b11, 1'b1, 4'd3,  1'b1, 8'd200, 8'd50);
     drv_inp(2'b10, 1'b1, 4'd3,  1'b1, 8'd200, 8'd78);
      drv_inp(2'b01, 1'b1, 4'd3,  1'b1, 8'd126, 8'd50);
    drv_inp(2'b01, 1'b1, 4'd4,  1'b0, 8'd126, 8'd0);
     drv_inp(2'b10, 1'b1, 4'd4,  1'b0, 8'd127, 8'd0);
      drv_inp(2'b11, 1'b1, 4'd4,  1'b0, 8'd132, 8'd0);
    drv_inp(2'b01, 1'b1, 4'd5,  1'b0, 8'd154, 8'd0);
    drv_inp(2'b10, 1'b1, 4'd5,  1'b0, 8'd128, 8'd0);
    drv_inp(2'b11, 1'b1, 4'd5,  1'b0, 8'd126, 8'd0);
    drv_inp(2'b10, 1'b1, 4'd6,  1'b0, 8'd0,   8'd155);
     drv_inp(2'b01, 1'b1, 4'd6,  1'b0, 8'd0,   8'd215);
      drv_inp(2'b11, 1'b1, 4'd6,  1'b0, 8'd0,   8'd255);
    drv_inp(2'b10, 1'b1, 4'd7,  1'b0, 8'd0,   8'd1);
    drv_inp(2'b01, 1'b1, 4'd7,  1'b0, 8'd0,   8'd1);
    drv_inp(2'b11, 1'b1, 4'd7,  1'b0, 8'd0,   8'd1);
    drv_inp(2'b11, 1'b1, 4'd8,  1'b0, 8'd100, 8'd200);
    drv_inp(2'b11, 1'b1, 4'd8,  1'b0, 8'd200, 8'd100);
    drv_inp(2'b11, 1'b1, 4'd8,  1'b0, 8'd100, 8'd100);
    drv_inp(2'b11, 1'b1, 4'd9,  1'b0, 8'd10,  8'd10);
    drv_inp(2'b10, 1'b1, 4'd9,  1'b0, 8'd10,  8'd10);
    drv_inp(2'b01, 1'b1, 4'd9,  1'b0, 8'd10,  8'd10);
    drv_inp(2'b11, 1'b1, 4'd10, 1'b0, 8'd66, 8'd12);
    drv_inp(2'b10, 1'b1, 4'd10, 1'b0, 8'd66, 8'd12);
    drv_inp(2'b01, 1'b1, 4'd10, 1'b0, 8'd66, 8'd12);
    drv_inp(2'b11, 1'b1, 4'd11, 1'b0, 8'hFE,  8'h02);
    drv_inp(2'b10, 1'b1, 4'd11, 1'b0, 8'hEE,  8'h02);
    drv_inp(2'b11, 1'b1, 4'd12, 1'b0, 8'hFE,  8'h02); 
      drv_inp(2'b01, 1'b1, 4'd12, 1'b0, 8'hFE,  8'h02); 
    $display("\n--- ERROR (invalid INP_VALID) ---");
    drv_inp(2'b00, 1'b1, 4'd0,  1'b0, 8'd10, 8'd20); 
    drv_inp(2'b01, 1'b1, 4'd6,  1'b0, 8'd6, 8'd11); 
    $display("\n--- DEFAULT CMD (ERR expected) ---");
    drv_inp(2'b11, 1'b1, 4'd15, 1'b0, 8'd10, 8'd20);
    drv_inp(2'b11, 1'b0, 4'd15, 1'b0, 8'd10, 8'd20);
    repeat(5) @(posedge CLK);
    $stop;
  end
 
endmodule
