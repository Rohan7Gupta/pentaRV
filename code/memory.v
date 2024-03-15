`include "DMEM.v"

module execute(clk, rst, strCtrlM, RegWriteM, MemWriteM, MemtoRegM, PCBranchM,
                ALUoutM, branchM, PCplusImmM, rdM, r2M, ALUoutW, ReadDataW, rdW, 
                MemtoRegW, RegWriteW);

input clk, rst, RegWriteM, MemWriteM, MemtoRegM, PCBranchM, branchM;
input [2:0] strCtrlM;
input [31:0] ALUoutM, PCplusImmM, r2M;
input [4:0] rdM;

output [31:0] ALUoutW, ReadDataW;
output [4:0] rdW; 
output MemtoRegW, RegWriteW;

wire PCsrcM;
wire [31:0] ReadDataM;
wire [3:0] mem_wmask;

wire mem_byteAccess, mem_halfwordAccess, LOAD_sign;
wire [15:0] LOAD_halfword;
wire  [7:0] LOAD_byte;
wire [31:0] LOAD_data, mem_rdata;

assign PCsrcM = branchM & PCBranchM ;

//store control
assign mem_byteAccess     = strCtrlM[1:0] == 2'b00;
assign mem_halfwordAccess = strCtrlM[1:0] == 2'b01;


assign mem_wmask = mem_byteAccess ?
	(ALUoutM[1] ?
	(ALUoutM[0] ? 4'b1000 : 4'b0100) :
	(ALUoutM[0] ? 4'b0010 : 4'b0001)
) :
	mem_halfwordAccess ?
	(ALUoutM[1] ? 4'b1100 : 4'b0011) :
    4'b1111;


DMEM dmem(
    .clk(clk),
    .rst(rst),
    .we(MemWriteM),
    .mem_wmask(mem_wmask),
    .wd(r2M),
    .A(ALUoutM),
    .rd(mem_rdata)
);

//load control
assign LOAD_halfword = ALUoutM[1] ? mem_rdata[31:16] : mem_rdata[15:0];
assign LOAD_byte = ALUoutM[0] ? LOAD_halfword[15:8] : LOAD_halfword[7:0];

   // LOAD, in addition to strCtrlM[1:0], LOAD depends on:
   // - strCtrlM[2] (instr[14]): 0->do sign expansion   1->no sign expansion
assign LOAD_sign = !strCtrlM[2] & (mem_byteAccess ? LOAD_byte[7] : LOAD_halfword[15]);

assign LOAD_data = mem_byteAccess ? {{24{LOAD_sign}},     LOAD_byte} :
                        mem_halfwordAccess ? {{16{LOAD_sign}}, LOAD_halfword} :
                        mem_rdata ;

assign ReadDataM = LOAD_data;

//pipeline register
reg [31:0] reg_ALUoutM, reg_ReadDataM;
reg [4:0] reg_rdM; 
reg reg_MemtoRegM, reg_RegWriteM;

always @(posedge clk or posedge rst) begin
        if(rst) begin
            reg_RegWriteM <= 1'b0;
            reg_MemtoRegM <= 1'b0;
            reg_rdM <= 5'h00;
            reg_ReadDataM <= 32'h00000000;
            reg_ALUoutM <= 32'h00000000;

        end
        else begin
            reg_RegWriteM <= RegWriteM;
            reg_MemtoRegM <= MemtoRegM;
            reg_rdM <= rdM;
            reg_ReadDataM <= ReadDataM;
            reg_ALUoutM <= ALUoutM;
        end
    end

assign RegWriteW = reg_RegWriteM;
assign MemtoRegW = reg_MemtoRegM;
assign rdW = reg_rdM;
assign ALUoutW = reg_ALUoutM;
assign ReadDataW = reg_ReadDataM;

endmodule