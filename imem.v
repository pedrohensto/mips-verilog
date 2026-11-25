`default_nettype none

// memoria de instrucoes (ROM), carregada a partir de memfile.dat
module imem (
    input  [ 5:0] a,
    output [31:0] rd
);
  reg [31:0] RAM[63:0];

  initial begin
    $readmemh("memfile.dat", RAM, 0, 17);  // 18 instrucoes
  end

  assign rd = RAM[a];  // enderecada por palavra
endmodule
