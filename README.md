# rv32i 5 Stage Pipeline Core
## by Rohan Gupta
#### rv32i unpriviledged 

Unified memory byte accesible (little endian)
i.e for word access, memory in multiples of 4, for half word access, memory in multiples of 2

256kB memory
16kB code memory
remaining data memory

### run make (debian) or mingw32-make (windows) in code directory
- (fence coded as nop, 1 hart system)
- ecall, ebreak not yet implemented
- csr to be implemented
- Data forwarding implemented
- Pipeline flush implemented (only decode)
- branch resolved in execute stage

## Architecture
![architecture](https://github.com/Rohan7Gupta/nanoRV/blob/v2/RV32%205-stage%20pipeline%20data-path%20(6).jpg)



## References
- based on Harris & Harris 5 stage pipeline MIPS architecture
- The RISC-V Instruction Set Manual Volume I Unprivileged Architecture
-- Editors: Andrew waterman, Krste Asanovic, SiFive, Inc., CS Division, EECS Department, University of California, Berkeley
 Version 20191214, Revised 20230723
- RISC-V Lectures by John's basement on youtube
- https://github.com/merldsu/RISCV_Pipeline_Core.git
- https://github.com/Moo-osama/RISCV-verilog.git
- swapforth/JI

#### Assembler used for testing
https://github.com/josh7670/Risc-V-Assembly-to-Hex
