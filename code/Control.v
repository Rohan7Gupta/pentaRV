`include "defines.v"

module Control(opcode,funct3,funct7,strCtrlD,RegWriteD,MemWriteD,
PCBranchD,SrcASelD,SrcBSelD,MemtoRegD,ALUopD,immSelD);

input [6:0] opcode,funct7;
input [2:0] funct3;

output RegWriteD,MemWriteD,PCBranchD,MemtoRegD;
output [3:0] ALUopD;
output [2:0] immSelD,strCtrlD;
output [1:0] SrcASelD, SrcBSelD; //implement 00 -> jal,jalr,auipc, 01 ->lui, 11->rs1 

assign RegWriteD = (opcode == `Load || opcode == `ALUreg || opcode == `ALUimm ) ? 1'b1 : 1'b0 ;
assign SrcBSelD = (opcode == `Load || opcode == `Store || opcode == `ALUimm || 
                opcode == `LUI || opcode == `AUIPC || opcode == `JAL) ? 2'd1 : 
                                (opcode == `JAL) ? 2'd2 : 2'b0 ;
assign SrcASelD = (opcode == `JAL || opcode == `JALR || opcode == `AUIPC) ? 2'b00 : 
                                        ((opcode == `LUI) ? 2'b01 :  2'b11);  
assign MemWriteD = (opcode == `Store) ? 1'b1 : 1'b0 ;
assign MemtoRegD = (opcode == `Load) ? 1'b1 : 1'b0 ;
assign PCBranchD = (opcode == `Branch || opcode == `JAL || opcode == `JALR) ? 1'b1 : 1'b0 ;

assign strCtrlD = funct3;

assign ALUopD = (opcode == `ALUimm || opcode == `Branch ) ? {1'b0,funct3} : 
                                ((opcode == `ALUreg ) ? {funct7[5],funct3} : 
                                ((opcode == `JAL) ? 4'b1000 : 4'b0000));
                                // 1111 chosen for JAL to avaoid  confusion with R type
reg [2:0]immSel;
always @(*) begin
    case(opcode)
    `ALUimm : immSel <= 3'o0;
    `LUI,`AUIPC : immSel <= 3'o1;
    `Store : immSel <= 3'o2;
    `Branch : immSel <= 3'o3;
    `JAL : immSel <= 3'o4;
    `Load : immSel <= 3'o5;
    default : immSel <= 3'o6;
    endcase
end
assign immSelD = immSel;

endmodule