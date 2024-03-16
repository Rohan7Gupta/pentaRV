`include "fetch.v"
`timescale 1ns / 1ps
module fetch_tb();

reg clk,rst,PCsrcM;
reg [31:0] PCplusImmM;
wire [31:0] PCD, instrD;

fetch dut(clk,rst,PCsrcM,PCplusImmM,PCD, instrD);

initial begin 
    clk=0;
    forever #5 clk = ~clk;
end

initial begin
    rst =1 ;
    #8 rst=0; PCsrcM =0; PCplusImmM = 32'b0;
    #10000 rst=1; $finish;
end

initial begin
  $dumpfile("rv32i.vcd");
  $dumpvars;
end

endmodule