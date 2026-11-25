filename = mips
pcf_file = io.pcf
top      = fpga_top

# fontes do processador (sem os testbenches)
sources = fpga_top.v top.v imem.v dmem.v mips.v controller.v maindec.v \
          aludec.v datapath.v regfile.v flopr.v alu.v

ICELINK_DIR=$(shell df | grep iCELink | awk '{print $$NF}')
${warning iCELink path: $(ICELINK_DIR)}

build:
	yosys -p "synth_ice40 -top $(top) -json $(filename).json -blif $(filename).blif" $(sources)
	nextpnr-ice40 --lp1k --package cm36 --json $(filename).json --pcf $(pcf_file) --asc $(filename).asc --freq 12
	icepack $(filename).asc $(filename).bin

prog_flash:
	@if [ -d '$(ICELINK_DIR)' ]; \
        then \
            cp $(filename).bin $(ICELINK_DIR); \
        else \
            echo "iCELink not found"; \
            exit 1; \
    fi

# roda o testbench do livro (gera tb_mips.vcd)
sim:
	iverilog -s tb_mips -o tb_mips tb_mips.v $(filter-out fpga_top.v,$(sources))
	vvp tb_mips

# abre as formas de onda com o layout salvo
wave: sim
	gtkwave tb_mips.gtkw

clean:
	rm -rf $(filename).blif $(filename).json $(filename).asc $(filename).bin tb_mips tb_mips.vcd
