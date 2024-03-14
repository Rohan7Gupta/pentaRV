`include "alu.v"

module execute(clk,rst,strCtrlE, RegWriteE, MemWriteE, MemtoRegE, PCBranchE, 
                ALUopE, SrcASelE, SrcBSelE, immE, PCE, r1E, r2E, rdE,
                strCtrlM, RegWriteM, MemWriteM, MemtoRegM, PCBranchM,
                ALUoutM,branchM,PCplusImmM,rdM,r2M);

input clk,rst,RegWriteE, MemWriteE, MemtoRegE, PCBranchE, SrcBSelE;
input [1:0] SrcASelE;
input [2:0] strCtrlE, immE;
input [3:0] ALUopE;
input [4:0] rdE;
input [31:0] PCE,r1E,r2E;

output RegWriteM, MemWriteM, MemtoRegM, PCBranchM, branchM;
output [2:0] strCtrlM;
output [4:0] rdM;
output [31:0] ALUoutM, PCplusImmM, r2M;

wire [31:0] srcA,srcB, ALUoutE, PCplusImmE;
wire branchE;

//pipeline register
reg reg_RegWriteM,reg_MemWriteM,reg_MemtoRegM,reg_PCBranchM,reg_branchM;
reg [2:0]reg_strCtrlM;
reg [4:0]reg_rdM;
reg [31:0]reg_ALUoutM,reg_PCplusImmM,reg_r2M; 

endmodule
