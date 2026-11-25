`default_nettype none
`timescale 1ns / 1ps

// o programa em memfile.dat deve terminar escrevendo 7 no endereco 84
module tb_mips;
  reg clk, reset;
  wire [31:0] writedata, dataadr;
  wire memwrite;

  top dut (
      clk,
      reset,
      writedata,
      dataadr,
      memwrite
  );

  // reset no inicio
  initial begin
    $dumpfile("tb_mips.vcd");
    $dumpvars(0, tb_mips);
    // arrays nao entram no dump por padrao: registradores e posicoes de
    // memoria usados pelo programa de teste sao adicionados um a um
    $dumpvars(0, dut.mips.dp.rf.rf[2]);
    $dumpvars(0, dut.mips.dp.rf.rf[3]);
    $dumpvars(0, dut.mips.dp.rf.rf[4]);
    $dumpvars(0, dut.mips.dp.rf.rf[5]);
    $dumpvars(0, dut.mips.dp.rf.rf[7]);
    $dumpvars(0, dut.dmem.RAM[20]);  // endereco 80
    $dumpvars(0, dut.dmem.RAM[21]);  // endereco 84
    reset <= 1;
    #22;
    reset <= 0;
  end

  // clock com periodo de 10
  always begin
    clk <= 1;
    #5;
    clk <= 0;
    #5;
  end

  // confere o resultado na borda de descida
  always @(negedge clk) begin
    if (memwrite) begin
      if (dataadr === 84 & writedata === 7) begin
        $display("Simulation succeeded");
        $finish;
      end else if (dataadr !== 80) begin
        $display("Simulation failed");
        $finish;
      end
    end
  end

  // evita simulacao infinita se o programa nunca escrever na memoria
  initial begin
    #1000;
    $display("Simulation failed (timeout)");
    $finish;
  end
endmodule
