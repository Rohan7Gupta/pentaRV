`define     ADD          3'b000  // add/sub/addi
`define     SLL          3'b001  //slli    
`define     SLT          3'b010  //slti    
`define     SLTU         3'b011  //sltui    
`define     XOR          3'b100  //xori    
`define     SRL          3'b101  //srl/sra/srli,srai    
`define     OR           3'b110   //ori   
`define     AND          3'b111  //andi

`define     LSB          3'b000
`define     LSH          3'b001
`define     LSW          3'b010
`define     LSBU         3'b100
`define     LSHU         3'b101

`define     BEQ          3'b000
`define     BNE          3'b001
`define     BLT          3'b100
`define     BGE          3'b101
`define     BLTU         3'b110
`define     BGEU         3'b111

`define     SB           3'b000
`define     SH           3'b001
`define     SW           3'b010

`define     ALUreg     7'b0110011  // rd <- rs1 OP rs2   
`define     ALUimm     7'b0010011  // rd <- rs1 OP Iimm
`define     Branch     7'b1100011  // if(rs1 OP rs2) PC<-PC+Bimm
`define     JALR       7'b1100111  // rd <- PC+4; PC<-rs1+Iimm
`define     JAL        7'b1101111  // rd <- PC+4; PC<-PC+Jimm
`define     AUIPC      7'b0010111  // rd <- PC + Uimm
`define     LUI        7'b0110111  // rd <- Uimm   
`define     Load       7'b0000011  // rd <- mem[rs1+Iimm]
`define     Store      7'b0100011  // mem[rs1+Simm] <- rs2
`define     SYSTEM     7'b1110011  // system operation  