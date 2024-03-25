module IMEM(rst,addr,readData);

  input rst;
  input [31:0]addr;
  output [31:0]readData;

  reg [31:0] mem [0:1023];
  
  assign readData = (rst) ? {32{1'b0}} : mem[addr[31:2]];

  initial begin
    $readmemh("memfile.hex",mem);
  end
endmodule
