`default_nettype none

module datapath (
    input clk,
    reset,
    memtoreg,
    pcsrc,
    alusrc,
    regdst,
    regwrite,
    jump,
    input [2:0] alucontrol,
    input [31:0] instr,
    readdata,
    output zero,
    output [31:0] pc,
    aluout,
    writedata
);

  wire [4:0] writereg;
  wire [31:0] pcnext, pcnextbr, pcplus4, pcbranch, signimm, signimmsh, srca, srcb, result;

  // proxima instrucao
  flopr #(32) pcreg (
      clk,
      reset,
      pcnext,
      pc
  );
  // adder pcaddd1(pc, 32'b100, pcplus4);
  assign pcplus4 = pc + 4;
  // sl2 immsh(signimm, signimmsh);
  assign signimmsh = {signimm[29:0], 2'b00};
  // adder pcadd2(pcplus4, signimmsh, pcbranch);
  assign pcbranch = pcplus4 + signimmsh;
  // mux2#(32) pcbrmux(pcplus4, pcbranch, pcsrc, pcnextbr);
  // uma mux2x1 eh o mesmo que ? a : b 
  assign pcnextbr = pcsrc ? pcbranch : pcplus4;
  assign pcnext = jump ? {pcplus4[31:28], instr[25:0], 2'b00} : pcnextbr;

  // logica do registrador
  regfile rf (
      clk,
      regwrite,
      instr[25:21],
      instr[20:16],
      writereg,
      result,
      srca,
      writedata
  );
  assign writereg = regdst ? instr[15:11] : instr[20:16];
  assign result = memtoreg ? readdata : aluout;
  // signext se(instr[15:0], signimm);
  assign signimm = {{16{instr[15]}}, instr[15:0]};

  // alu 
  assign srcb = alusrc ? signimm : writedata;
  alu alu (
      srca,
      srcb,
      1'b0,
      alucontrol,
      aluout,
      , // cout sem conexão
      zero
  );
endmodule
