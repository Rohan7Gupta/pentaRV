`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"
`include "writeback.v"

module processor(clk,rst);
input clk,rst;

//fetch
wire [31:0] instrD, PCD;

//decode
wire RegWriteE,MemWriteE,PCBranchE,MemtoRegE; 
wire [1:0] SrcASelE,SrcBSelE;
wire [3:0] ALUopE;
wire [2:0] strCtrlE;

//execute
wire [4:0] rdE;
wire [31:0] immE,PCE,r1E,r2E;

wire RegWriteM, MemWriteM, MemtoRegM, PCsrcE;
wire [2:0] strCtrlM;
wire [4:0] rdM;
wire [31:0] ALUoutM, PCplusImmM, r2M;

//memory
wire [31:0] ALUoutW, ReadDataW;
wire [4:0] rdW; 
wire MemtoRegW, RegWriteW;
wire [31:0] resultW;

//writeback
fetch fetch_unit(clk,rst,PCsrcE,PCplusImmM,PCD, instrD);

decode decode_unit(clk,rst, instrD, PCD, RegWriteW, rdW, resultW, strCtrlE, RegWriteE, 
MemWriteE, MemtoRegE, PCBranchE, ALUopE, SrcASelE, SrcBSelE, immE, PCE, r1E, r2E, rdE);

execute execute_unit(clk,rst,strCtrlE, RegWriteE, MemWriteE, MemtoRegE, PCBranchE, 
                ALUopE, SrcASelE, SrcBSelE, immE, PCE, r1E, r2E, rdE,
                strCtrlM, RegWriteM, MemWriteM, MemtoRegM,
                ALUoutM , PCplusImmM, rdM, r2M, PCsrcE);

memory memory_unit(clk, rst, strCtrlM, RegWriteM, MemWriteM, MemtoRegM,
                ALUoutM, PCplusImmM, rdM, r2M, ALUoutW, ReadDataW, rdW, 
                MemtoRegW, RegWriteW);

writeback writeback_unit( ALUoutW, ReadDataW, rdW, MemtoRegW, RegWriteW,resultW);
endmodule