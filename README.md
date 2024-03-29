# rv32i 5 Stage Pipeline Core
## by Rohan Gupta

##### rv32i unpriviledged
##### Data memory byte accesible
i.e for work access, memory in multiples of 4, for half word access, memory in multiples of 2

00000000 -- NOP

(fence coded as nop, 1 hart system)

ecall, ebreak not yet implemented

All instructions working (rv32i) (excluding environment)

Working on hazard resolution

## Architecture
![architecture](https://github.com/Rohan7Gupta/rv32_5_Stage_Pipeline/blob/main/RV32%205-stage%20pipeline%20data-path%20(14).png)

## References

The RISC-V Instruction Set Manual Volume I Unprivileged Architecture
 Editors: Andrew waterman, Krste Asanovic, SiFive, Inc., CS Division, EECS Department, University of California, Berkeley
 Version 20191214, Revised 20230723

RISC-V Lectures by John's basement on youtube

Harris & Harris 5 stage pipeline MIPS architecture

https://github.com/merldsu/RISCV_Pipeline_Core.git

https://github.com/Moo-osama/RISCV-verilog.git

swapforth/JI
