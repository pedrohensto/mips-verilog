`default_nettype none

// processador + memorias externas (instrucoes e dados)
module top (
    input clk,
    reset,
    output [31:0] writedata,
    dataadr,
    output memwrite
);

  wire [31:0] pc, instr, readdata;

  mips mips (
      clk,
      reset,
      instr,
      readdata,
      memwrite,
      pc,
      dataadr,
      writedata
  );

  imem imem (
      pc[7:2],
      instr
  );

  dmem dmem (
      clk,
      memwrite,
      dataadr,
      writedata,
      readdata
  );
endmodule
