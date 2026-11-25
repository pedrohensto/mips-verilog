`default_nettype none

// topo para a icesugar nano: faz na placa o mesmo que o testbench faz na
// simulacao. o programa de memfile.dat roda sozinho e, se ele escrever 7 no
// endereco 84, o led comeca a piscar. se o processador estiver errado o led
// nunca pisca (fica parado)
module fpga_top (
    input  CLK,  // clock de 12 MHz do icelink
    output LED
);

  // contador livre: divide o clock e gera a piscada do led
  reg [23:0] counter = 0;
  always @(posedge CLK) begin
    counter <= counter + 1;
  end

  // clock do processador: 12 MHz / 16 = 750 kHz, com folga para o caminho
  // critico do ciclo unico (pc -> instrucao -> registradores -> alu -> memoria)
  wire clk = counter[3];

  // reset automatico ao ligar: fica em 1 nos primeiros ciclos
  reg [3:0] resetcnt = 0;
  wire reset = ~resetcnt[3];
  always @(posedge clk) begin
    if (reset) resetcnt <= resetcnt + 1;
  end

  wire [31:0] writedata, dataadr;
  wire memwrite;

  top top (
      clk,
      reset,
      writedata,
      dataadr,
      memwrite
  );

  // mesma checagem do testbench, na borda de descida
  reg ok = 0;
  always @(negedge clk) begin
    if (reset) ok <= 0;
    else if (memwrite & dataadr == 84 & writedata == 7) ok <= 1;
  end

  assign LED = ok & counter[23];  // pisca a ~0,7 Hz depois do sucesso
endmodule
