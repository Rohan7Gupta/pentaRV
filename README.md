# rv32i 5 Stage Pipeline Core
## by Rohan Gupta
#### rv32i unpriviledged 

### memory
####Unified memory byte accesible (little endian)
i.e for word access, memory in multiples of 4, for half word access, memory in multiples of 2

256kB memory
0-8 kB code memory
8 - 16 kB vector table + reserve 
16kB+ data memory

### run make (debian) or mingw32-make (windows) in code directory
- no fence as 1 hart system
- 5 stage pipeline with hazard handling implemented
--- (note : need 1 nop if load immediately followed by R/I accessing same register)
- ecall, ebreak end execution
- csr implemented for exception and interrupt
--- csr manipulation instruction to be implemnted
- exception handling implemented for cause 0 - 7 (defined in priviledged manual)
- interrupt handling to be implmented
- exception leads to IVT which contains ebreak and ends execution immediately (can be modified later)
- mret to be implemented
- plans to implement memory mapped IO


## Architecture
![architecture](https://github.com/Rohan7Gupta/pentaRV/blob/main/RV32%205-stage%20pipeline%20data-path%20(7).jpg)



## References
- based on Harris & Harris 5 stage pipeline MIPS architecture
- The RISC-V Instruction Set Manual Volume I Unprivileged Architecture. Volume I: User-Level ISA Document Version 2.2
-- Editors: Andrew waterman, Krste Asanovic
- The RISC-V Instruction Set Manual Volume II: Privileged Architecture Privileged Architecture Version 1.10 Document Version 1.10
--  Editors: Andrew Waterman, Krste Asanovic 
- RISC-V Lectures by John's basement on youtube
- LMARV-1 reboot by Robert Baruch
- https://github.com/merldsu/RISCV_Pipeline_Core.git
- https://github.com/Moo-osama/RISCV-verilog.git
- swapforth/JI
- https://luplab.gitlab.io/rvcodecjs/#q=xor+x10,+x10,+x11&abi=false&isa=RV32I
- https://github.com/Fahad-Habib/RISC-V-Pipelined-Processor-with-CSR

