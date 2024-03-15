module writeback( ALUoutW, ReadDataW, rdW, MemtoRegW, RegWriteW,resultW);

input RegWriteW, MemtoRegW;
input [31:0] ALUoutW, ReadDataW;
input [4:0] rdW;

output [31:0] resultW;

assign resultW = (MemtoRegW) ? ReadDataW : ALUoutW ;

endmodule