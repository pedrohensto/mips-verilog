`default_nettype none

// memoria de dados: leitura combinacional, escrita na borda de subida
module dmem (
    input clk,
    we,
    input [31:0] a,
    wd,
    output [31:0] rd
);
  reg [31:0] RAM[63:0];

  assign rd = RAM[a[7:2]];  // alinhada por palavra

  always @(posedge clk) begin
    if (we) RAM[a[7:2]] <= wd;
  end
endmodule
