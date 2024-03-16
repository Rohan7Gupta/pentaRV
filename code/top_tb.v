`include "processor.v"
`timescale 1ns / 1ps
module top_tb();

reg clk,rst;

processor dut(clk,rst);;

initial begin 
    clk=0;
    forever #10 clk = ~clk;
end

initial begin
    rst =1 ;
    #11 rst=0;
    #10000 rst=1; $finish;
end

initial begin
  $dumpfile("rv32i.vcd");
  $dumpvars;
end

endmodule