`default_nettype none
module alu (
    input [31:0] a,
    input [31:0] b,
    input cin,
    input [2:0] alu_control,
    output reg [31:0] sum,
    output reg cout,
    output reg zero
);

  // usar case para cada tipo de operacao, selecionado pelo alu_control
  // bloco combinacional
  always @(*) begin

    case (alu_control)
      // add 010
      3'b010: begin
        {cout, sum} = a + b + cin;
      end
      // sub 110
      3'b110: begin
        {cout, sum} = a + (~b) + 1;
        if (~sum) begin
          zero = 0;
        end
      end
      // and 000
      3'b000: begin
        sum  = a & b;
        cout = 0;
      end
      // or 001
      3'b001: begin
        sum  = a | b;
        cout = 0;
      end
      // slt 111
      3'b111: begin
        sum  = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
        cout = 0;
        if (~sum[0]) begin
          zero = 1;
        end
      end
      // default para evitar latches
      default: begin
        sum  = 0;
        cout = 0;
        zero = 0;
      end
    endcase

  end
endmodule



