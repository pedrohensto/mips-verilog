`default_nettype none

module mips (
    input clk,
    reset,
    input [31:0] instr,
    readdata,
    output memwrite,
    output [31:0] pc,
    aluout,
    writedata
);

  wire memtoreg, alusrc, regdst, regwrite, jump, pcsrc, zero;
  wire [2:0] alucontrol;

  controller c (
      instr[31:26],
      instr[5:0],
      zero,
      memtoreg,
      memwrite,
      pcsrc,
      alusrc,
      regdst,
      regwrite,
      jump,
      alucontrol
  );

  datapath dp (
      clk,
      reset,
      memtoreg,
      pcsrc,
      alusrc,
      regdst,
      regwrite,
      jump,
      alucontrol,
      instr,
      readdata,
      zero,
      pc,
      aluout,
      writedata
  );

endmodule
