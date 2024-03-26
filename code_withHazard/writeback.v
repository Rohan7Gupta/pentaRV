module writeback( ALUoutW, ReadDataW, MemtoRegW, resultW);

input MemtoRegW;
input [31:0] ALUoutW, ReadDataW;

output [31:0] resultW;

assign resultW = (MemtoRegW) ? ReadDataW : ALUoutW ;

endmodule