`include "defines.v"

module Control(opcode,funct3,funct7,strCtrlD,RegWriteD,MemWriteD,
PCBranchD,SrcASelD,SrcBSelD,MemtoRegD,ALUopD,immSelD);

input [6:0] opcode,funct7;
input [2:0] funct3;

output RegWriteD,MemWriteD,PCBranchD,
        SrcBSelD,MemtoRegD;
output [3:0] ALUopD;
output [2:0] immSelD,strCtrlD;
output [1:0] SrcASelD; //implement 00 -> jal,jalr,auipc, 01 ->lui, 11->rs1 

assign RegWriteD = (opcode == `Load | opcode == `ALUreg | opcode == `ALUimm ) ? 1'b1 : 1'b0 ;
assign SrcBSelD = (opcode == `Load | opcode == `Store | opcode == `ALUimm) ? 1'b1 : 1'b0 ;
assign SrcASelD = (opcode == `JAL | opcode == `JALR | opcode == `AUIPC) ? 2'b00 : 
                                        ((opcode == `LUI) ? 2'b01 :  2'b10);  
assign MemWriteD = (opcode == `Store) ? 1'b1 : 1'b0 ;
assign MemtoRegD = (opcode == `Load) ? 1'b1 : 1'b0 ;
assign PCBranchD = (opcode == `Branch | opcode == `JAL | opcode == `JALR) ? 1'b1 : 1'b0 ;

assign strCtrlD = funct3;

assign ALUopD = (opcode == `ALUimm | opcode == `Branch ) ? {1'b0,funct3} : 
                                ((opcode == `ALUreg ) ? {funct7[5],funct3} : 4'b0000);

endmodule