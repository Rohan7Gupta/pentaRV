`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"
`include "writeback.v"
`include "hazard.v"

module processor(clk,rst,dump);
input clk,rst,dump;

//fetch
wire [31:0] instrD, PCD;

//decode
wire RegWriteE,MemWriteE,PCBranchE,MemtoRegE, JALRctrlE; 
wire [1:0] SrcASelE,SrcBSelE;
wire [3:0] ALUopE;
wire [2:0] strCtrlE;

//execute
wire [4:0] rdE,rs1E,rs2E;
wire [31:0] immE,PCE,r1E,r2E;

wire RegWriteM, MemWriteM, MemtoRegM, PCsrcE;
wire [2:0] strCtrlM;
wire [4:0] rdM;
wire [31:0] ALUoutM, PCplusImmE, r2M;

//memory
wire [31:0] ALUoutW, ReadDataW;
wire [4:0] rdW; 
wire MemtoRegW, RegWriteW;
wire [31:0] resultW;

//hazard 
wire [1:0] ForwardAE,ForwardBE;

//writeback
fetch fetch_unit(clk,rst,PCsrcE,PCplusImmE,PCD, instrD);

decode decode_unit(clk,rst, instrD, PCD, RegWriteW, rdW, resultW, 
                strCtrlE, RegWriteE,MemWriteE, MemtoRegE, PCBranchE, 
                ALUopE, SrcASelE, SrcBSelE, immE, PCE, r1E, r2E, rdE, 
                JALRctrlE, rs1E, rs2E);

execute execute_unit(clk,rst,resultW, ForwardAE, ForwardBE, JALRctrlE,
                strCtrlE, RegWriteE, MemWriteE, MemtoRegE, PCBranchE, 
                ALUopE, SrcASelE, SrcBSelE, immE, PCE, r1E, r2E, rdE,
                strCtrlM, RegWriteM, MemWriteM, MemtoRegM,
                ALUoutM , PCplusImmE, rdM, r2M, PCsrcE);

memory memory_unit(clk, rst,dump, strCtrlM, RegWriteM, MemWriteM, MemtoRegM,
                ALUoutM, rdM, r2M, ALUoutW, ReadDataW, rdW, 
                MemtoRegW, RegWriteW);

writeback writeback_unit( ALUoutW, ReadDataW, MemtoRegW,resultW);

hazard hazard_unit(rst, RegWriteM, RegWriteW, rdM, rdW, rs1E, rs2E, 
                    ForwardAE, ForwardBE);

endmodule