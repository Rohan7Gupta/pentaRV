`include "alu.v"
`timescale 1ns / 1ps
module execute_tb();

reg clk,rst,RegWriteW;
reg [4:0] rdW;
reg [31:0] instrD,PCD,resultW;

//control
wire RegWriteE,MemWriteE,PCBranchE,MemtoRegE; 
wire [1:0] SrcASelE,SrcBSelE;
wire [3:0] ALUopE;
wire [2:0] strCtrlE;

//data path
wire [31:0] immE,PCE,r1E,r2E;
wire [4:0] rdE;

execute dut(clk,rst,strCtrlE, RegWriteE, MemWriteE, MemtoRegE, PCBranchE, 
                ALUopE, SrcASelE, SrcBSelE, immE, PCE, r1E, r2E, rdE,
                strCtrlM, RegWriteM, MemWriteM, MemtoRegM,
                ALUoutM,PCplusImmM,rdM,r2M, PCsrcE);
initial begin 
    clk=0;
    forever #10 clk = ~clk;
end

initial begin
    rst =1 ;
    #12 rst=0;
    instrD= 32'h00002403;
    PCD= 32'b0;
    RegWriteW=1;
    rdW=5'd5;
    resultW=32'd9;
    #10000 $finish;
end

initial begin
  $dumpfile("rv32i.vcd");
  $dumpvars;
end

endmodule