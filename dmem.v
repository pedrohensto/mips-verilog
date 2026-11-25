`default_nettype none

// memoria de dados: escrita na borda de subida, leitura na borda de descida
//
// no livro a leitura eh combinacional, mas a ice40 so tem ram em bloco com
// leitura sincrona (com leitura combinacional a memoria vira ~2000 flip-flops
// e nao cabe na icesugar nano). lendo na borda de descida o dado do lw fica
// pronto na segunda metade do mesmo ciclo, entao o processador continua
// executando uma instrucao por ciclo
module dmem (
    input clk,
    we,
    input [31:0] a,
    wd,
    output reg [31:0] rd
);
  reg [31:0] RAM[63:0];

  always @(negedge clk) begin
    rd <= RAM[a[7:2]];  // alinhada por palavra
  end

  always @(posedge clk) begin
    if (we) RAM[a[7:2]] <= wd;
  end
endmodule
