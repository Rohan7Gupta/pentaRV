# rv32i 5 Stage Pipeline Core
## by Rohan Gupta

#### rv32i unpriviledged
##### Data memory byte accesible (8 byte word) (little endian) 
##### 512 KB memory (code 8 KB)
i.e for work access, memory in multiples of 4, for half word access, memory in multiples of 2

- 00000000 -- NOP
- (fence coded as nop, 1 hart system)
- ecall, ebreak not yet implemented
- All instructions working (rv32i) (excluding environment)
- Working on hazard resolution


All instructions working (rv32i) (excluding environment and fence) & resolved for hazards
Data forwarding implemented
Pipeline flush implemented (only decode)
branch resolved in execute stage


### References

The RISC-V Instruction Set Manual Volume I Unprivileged Architecture
=======
## Architecture
![architecture](https://github.com/Rohan7Gupta/nanoRV/blob/v2/RV32%205-stage%20pipeline%20data-path%20(6).jpg)



## References
- based on Harris & Harris 5 stage pipeline MIPS architecture
- The RISC-V Instruction Set Manual Volume I Unprivileged Architecture

 Editors: Andrew waterman, Krste Asanovic, SiFive, Inc., CS Division, EECS Department, University of California, Berkeley
 Version 20191214, Revised 20230723
- RISC-V Lectures by John's basement on youtube
- https://github.com/merldsu/RISCV_Pipeline_Core.git
- https://github.com/Moo-osama/RISCV-verilog.git
- swapforth/JI

#### Assembler used for testing
https://github.com/josh7670/Risc-V-Assembly-to-Hex