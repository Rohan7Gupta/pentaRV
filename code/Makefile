# Makefile for Verilog test bench

# Compiler
IVERILOG = iverilog

# Simulator
VVP = vvp

# Dumpfile viewer
GTKWAVE = gtkwave

# Source files
SRC_FILES = top_tb.v

# Testbench
TB = top_tb

# Dumpfile
DUMPFILE = rv32i.vcd

# Default target
all: compile simulate view

# Compile Verilog source files
compile:
	$(IVERILOG) -o $(TB) $(SRC_FILES)

# Run simulation
simulate:
	$(VVP) $(TB)

# View dumpfile
view:
	$(GTKWAVE) $(DUMPFILE)

# Install iverilog and gtkwave if not installed
install:
	which iverilog || sudo apt-get install -y iverilog
	which gtkwave || sudo apt-get install -y gtkwave

# Clean up generated files
clean:
	rm -f $(TB) $(DUMPFILE)
