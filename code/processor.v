`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"
`include "writeback.v"

module processor(clk,rst);
input clk,rst;

//fetch
wire clk, rst;
wire PCsrcM;
wire [31:0] PCbranchE;

wire [31:0] instrD, PCD;

//decode
wire clk,rst,RegWriteW;
wire [4:0] rdW;
wire [31:0] instrD,PCD,PCplus4D,resultW;

wire RegWriteE,MemWriteE,PCBranchE,MemtoRegE,SrcBSelE; 
wire [1:0] SrcASelE;
wire [3:0] ALUopE;
wire [2:0] strCtrlE;

//execute
wire clk,rst,RegWriteE, MemWriteE, MemtoRegE, PCBranchE, SrcBSelE;
wire [1:0] SrcASelE;
wire [2:0] strCtrlE, immE;
wire [3:0] ALUopE;
wire [4:0] rdE;
wire [31:0] PCE,r1E,r2E;

wire RegWriteM, MemWriteM, MemtoRegM, PCBranchM, branchM;
wire [2:0] strCtrlM;
wire [4:0] rdM;
wire [31:0] ALUoutM, PCplusImmM, r2M;

//memory
wire clk, rst, RegWriteM, MemWriteM, MemtoRegM, PCBranchM, branchM;
wire [2:0] strCtrlM;
wire [31:0] ALUoutM, PCplusImmM, r2M;
wire [4:0] rdM;

wire [31:0] ALUoutW, ReadDataW;
wire [4:0] rdW; 
wire MemtoRegW, RegWriteW;

//writeback
wire RegWriteW, MemtoRegW;
wire [31:0] ALUoutW, ReadDataW;
wire [4:0] rdW;

fetch fetch_unit(clk,rst,PCsrcM,PCbranchE,PCD, instrD);

decode decode_gupta(clk,rst, instrD, PCD, PCplus4D, RegWriteW, rdW, resultW, strCtrlE, RegWriteE, 
MemWriteE, MemtoRegE, PCBranchE, ALUopE, SrcASelE, SrcBSelE, immE, PCE, r1E, r2E, rdE);

execute execute_unit(clk,rst,strCtrlE, RegWriteE, MemWriteE, MemtoRegE, PCBranchE, 
                ALUopE, SrcASelE, SrcBSelE, immE, PCE, r1E, r2E, rdE,
                strCtrlM, RegWriteM, MemWriteM, MemtoRegM, PCBranchM,
                ALUoutM,branchM,PCplusImmM,rdM,r2M);

memory memory_unit(clk, rst, strCtrlM, RegWriteM, MemWriteM, MemtoRegM, PCBranchM,
                ALUoutM, branchM, PCplusImmM, rdM, r2M, ALUoutW, ReadDataW, rdW, 
                MemtoRegW, RegWriteW);

writeback writeback_unit( ALUoutW, ReadDataW, rdW, MemtoRegW, RegWriteW);
endmodule