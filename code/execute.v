`include "alu.v"

module execute(clk,rst,JALRctrlE,strCtrlE, RegWriteE, MemWriteE, MemtoRegE, PCBranchE, 
                ALUopE, SrcASelE, SrcBSelE, immE, PCE, r1E, r2E, rdE,
                strCtrlM, RegWriteM, MemWriteM, MemtoRegM,
                ALUoutM,PCplusImmE,rdM,r2M, PCsrcE);

input clk,rst,JALRctrlE,RegWriteE, MemWriteE, MemtoRegE, PCBranchE;
input [1:0] SrcASelE,SrcBSelE;
input [2:0] strCtrlE;
input [3:0] ALUopE;
input [4:0] rdE;
input [31:0] immE,PCE,r1E,r2E;

output RegWriteM, MemWriteM, MemtoRegM, PCsrcE;
output [2:0] strCtrlM;
output [4:0] rdM;
output [31:0] ALUoutM, PCplusImmE, r2M;

wire [31:0] srcA,srcB, ALUoutE, Imm;
wire branchE;

assign Imm = (JALRctrlE) ? immE : r1E;
assign PCplusImmE  = PCE + Imm;
assign srcA = (SrcASelE[1]) ? ((SrcASelE[0]) ? r1E : 32'bz) : ((SrcASelE[0]) ? 32'b0 : PCE) ;
assign srcB = (SrcBSelE[1]) ? ((SrcBSelE[0]) ? 32'd0 : 32'd4) : ((SrcBSelE[0]) ? immE : r2E) ;

alu core(
    .aluIn1(srcA),
    .aluIn2(srcB),
    .aluOP(ALUopE),
    .aluOut(ALUoutE),
    .branch(branchE)
);

//pipeline register
reg reg_RegWriteE,reg_MemWriteE,reg_MemtoRegE;
reg [2:0]reg_strCtrlE;
reg [4:0]reg_rdE;
reg [31:0]reg_ALUoutE,reg_r2E; 

always @(posedge clk or posedge rst) begin
        if(rst) begin
            reg_RegWriteE <= 1'b0;
            reg_MemWriteE <= 1'b0;
            reg_MemtoRegE <= 1'b0;
            reg_strCtrlE <= 3'b000;
            reg_rdE <= 5'h00;
            reg_r2E <= 32'h00000000;
            reg_ALUoutE <= 32'h00000000;

        end
        else begin
            reg_RegWriteE <= RegWriteE;
            reg_MemWriteE <= MemWriteE;
            reg_MemtoRegE <= MemtoRegE;
            reg_strCtrlE <= strCtrlE;
            reg_rdE <= rdE;
            reg_r2E <= r2E;
            reg_ALUoutE <= ALUoutE;
        end
    end

assign PCsrcE = branchE & PCBranchE;

assign strCtrlM = reg_strCtrlE;
assign RegWriteM = reg_RegWriteE;
assign MemWriteM = reg_MemWriteE;
assign MemtoRegM = reg_MemtoRegE;
assign r2M = reg_r2E;
assign rdM = reg_rdE;
assign ALUoutM = reg_ALUoutE;


endmodule
