`include "PC_module.v"
`include "IMEM.v"
module fetch(clk,rst,PCsrcE,PCplusImmM,PCD, instrD);
input clk, rst;
input PCsrcE;
input [31:0] PCplusImmM;
output [31:0] instrD, PCD;

wire [31:0] PCF, PCplus4F,instrF, nextPCF, four;
reg [31:0] reg_instrF, reg_PCF;

PC_Module pc(
    .clk(clk),
    .rst(rst),
    .PC(PCF),
    .nextPC(nextPCF)
    );

IMEM imem(
    .rst(rst),
    .addr(PCF),
    .readData(instrF)
    );

assign nextPCF = (PCsrcE)? PCplusImmM:PCplus4F;
assign four = 32'd4;
assign PCplus4F = PCF + four;

//pipeline registers
always @ (posedge clk or posedge rst) begin //rst used to implement stall
    if(rst) begin
        reg_instrF <= 32'b0;
        reg_PCF <= 32'b0;
    end
    else begin
        reg_instrF <= instrF;
        reg_PCF <= PCF;
    end
end

//signals to Decoder
assign instrD = (rst) ? 32'b0 : reg_instrF;
assign PCD = rst ? 32'b0 : reg_PCF;

endmodule

