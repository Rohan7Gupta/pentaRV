module writeback( ALUoutW, ReadDataW, rdW, MemtoRegW, RegWriteW);

input RegWriteW, MemtoRegW;
input [31:0] ALUoutW, ReadDataW;
input [4:0] rdW;

wire [31:0] resultW;

assign resultW = (MemtoRegW) ? ReadDataW : ALUoutW ;

endmodule