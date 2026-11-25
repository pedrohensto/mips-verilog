module tb_alu;
  reg [31:0] a, b;
  reg [2:0] alu_control;
  reg cin;
  wire [31:0] sum;
  wire cout;

  alu dut (
      .a(a),
      .b(b),
      .cin(cin),
      .alu_control(alu_control),
      .sum(sum),
      .cout(cout)
  );

  initial begin
    // teste 1 - soma
    a = 32'd10;
    b = 32'd25;
    cin = 0;
    alu_control = 3'b010;
    #10;
    $display("SOMA: %d + %d = %d", a, b, sum);
    // teste 2 - slt
    a = -32'd5;
    b = 32'd2;
    alu_control = 3'b111;
    #10;
    $display("SLT: %d < %d = %d", a, b, sum);
    $finish;
  end
endmodule

