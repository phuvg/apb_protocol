# Guide :
#	"make compile" : compiles RTL code.
#	"make sim" : run simulation.
#	"make view" : invoke waveform.

#-----------------------------------------------------------------------------
#Source code directory
RTL_DIR = ../../rtl
TB_DIR = ../../tb
TEST = tb_apb_protocol_read_without_wait_states.v
#-----------------------------------------------------------------------------
#RTL code
RTL_SRC = $(RTL_DIR)/*.v
#-----------------------------------------------------------------------------
#TB code
TB_SRC = $(TB_DIR)/$(TEST)
#-----------------------------------------------------------------------------
#Tools
COMPILER = vlog
SIMULATOR = vsim
#-----------------------------------------------------------------------------
#Tool options, compile and simulate flags
COFLAGS = -f
SFLAGS = -c\
	 -l report.log\
	 -voptargs="+acc"\
	 -do "run -all" work.tb_apb_protocol_read_without_wait_states
#-t ns\
#-----------------------------------------------------------------------------
#Tool output


#-----------------------------------------------------------------------------
#PHONY
.PHONY : compile sim view clean
#-----------------------------------------------------------------------------
#MAKE DIRECTIVES
compile: $(TB_SRC) $(RTL_SRC)
	vlib work
	vmap work work
	$(COMPILER) $(TB_SRC) $(RTL_SRC)

sim:
	$(SIMULATOR) $(SFLAGS)
	vcd2wlf wf_apb_protocol_read_without_wait_states.vcd wf_apb_protocol_read_without_wait_states.wlf	
view :
	vsim -i -view wf_apb_protocol_read_without_wait_states.wlf &
clean : 
	rm -rf wf_apb_protocol_read_without_wait_states.vcd \
	wf_apb_protocol_read_without_wait_states.wlf \
	report.log \
	work
