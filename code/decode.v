`include "Control.v"
`include "immGen.v"
`include "RegFile.v"

module decode(clk,rst,flush, instrD, PCD, RegWriteW, rdW, resultW, strCtrlE,
RegWriteE,MemWriteE, MemtoRegE, PCBranchE, ALUopE, SrcASelE, SrcBSelE,
immE, PCE, r1E, r2E, rdE, JALRctrlE,rs1E,rs2E, exception, cause, mtval);

//data path
input clk,rst,RegWriteW,flush;
input [4:0] rdW;
input [31:0] instrD,PCD,resultW;

//control
output RegWriteE,MemWriteE,PCBranchE,MemtoRegE, JALRctrlE; 
output [1:0] SrcASelE,SrcBSelE;
output [3:0] ALUopE;
output [2:0] strCtrlE;

//data path
output [31:0] immE,PCE,r1E,r2E;
output [4:0] rdE,rs1E,rs2E;

//exception
output reg exception;
output reg [4:0] cause;
output reg [31:0] mtval;

//internal wire control
wire [2:0]immSelD,strCtrlD;
wire RegWriteD,MemWriteD,PCBranchD,MemtoRegD, JALRctrlD;
wire [3:0] ALUopD;
wire [1:0] SrcASelD,SrcBSelD;

wire [6:0] opcode = instrD[6:0];
wire [2:0] funct3 = instrD[14:12];
wire [6:0] funct7 = instrD[31:25];

//internal wire data path
wire [31:0] immD,r1D,r2D;
wire [4:0] rs1D, rs2D;
assign rs1D = instrD[19:15];
assign rs2D = instrD[24:20];

//pipeline registers
reg reg_RegWriteD,reg_MemWriteD,reg_MemtoRegD,reg_PCBranchD, reg_JALRctrlD;
reg [3:0] reg_ALUopD;
reg [31:0] reg_r1D,reg_r2D,reg_immD,reg_PCD;
reg [4:0] reg_rdD,reg_rs1D,reg_rs2D;
reg [1:0] reg_SrcASelD,reg_SrcBSelD;
reg [2:0] reg_strCtrlD;

//ecall / ebreak => end program
always @(*) begin
    if(instrD === 32'h73) begin
        $finish;
    end
end

RegFile regs(
    .clk(clk),
    .rst(rst),
    .rs1(rs1D),
    .rs2(rs2D),
    .rd(rdW),
    .we(RegWriteW),
    .wd(resultW),
    .r1(r1D),
    .r2(r2D)
);

immGen immG(
    .instrD(instrD[31:7]),
    .immSelD(immSelD),
    .immD(immD)
);

Control control(
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7[6]),
    .strCtrlD(strCtrlD),
    .RegWriteD(RegWriteD),
    .MemWriteD(MemWriteD),
    .PCBranchD(PCBranchD),
    .SrcASelD(SrcASelD),
    .SrcBSelD(SrcBSelD),
    .MemtoRegD(MemtoRegD),
    .ALUopD(ALUopD),
    .immSelD(immSelD),
    .JALRctrlD(JALRctrlD)
);

//exception
always @ * begin
if(!rst) begin
    if((opcode != `ALUreg) && (opcode != `ALUimm) && (opcode != `Branch) && (opcode != `JALR) && 
    (opcode != `JAL) && (opcode != `AUIPC) && (opcode != `LUI) && (opcode != `Load) && 
    (opcode != `Store) && (opcode != `SYSTEM)) 
    begin
        exception = 1;
        cause = 2; //illegal code
        mtval = {25'b0,opcode};
    end
    if( (opcode == `Branch) && ((funct3 == 3'b010) || (funct3 == 3'b011) )) begin
        exception = 1;
        cause = 2;
        mtval = {opcode,20'b0,funct3};
    end
    else if( (opcode == `Load) && ((funct3 == 3'b011) || (funct3 == 3'b110) || (funct3 == 3'b111) )) begin
        exception = 1;
        cause = 2;
        mtval = {opcode,20'b0,funct3};
    end
    else if( (opcode == `Store) && ((funct3 != 3'b000) || (funct3 != 3'b001) || (funct3 != 3'b010) )) begin
        exception = 1;
        cause = 2;
        mtval = {opcode,20'b0,funct3};
    end
    else if ((opcode == `ALUreg) && ((funct3 == 3'b000) || (funct3 == 3'b101)) && ((funct7 == 7'b0100000 )|| (funct7 == 7'b0)) ) begin
        exception = 1;
        cause = 2;
        mtval = {opcode,5'b0, funct3,8'b0, funct7};
    end
    else if ( (opcode == `ALUimm) && ((funct3 == 3'b001) ) && (funct7 != 7'b0) ) begin
        exception = 1;
        cause = 2;
        mtval = {opcode,5'b0, funct3,8'b0, funct7};
    end
    else if ( (opcode == `ALUimm) && (funct3 == 3'b101) && ((funct7 != 7'b0000000)||(funct7 != 7'b0100000)) ) begin
        exception = 1;
        cause = 2;
        mtval = {opcode,5'b0, funct3,8'b0, funct7};
    end
    else begin
        exception = 0;
    end
end
end

//pipeline registers
    always @(posedge clk or posedge rst) begin
        if(rst | flush) begin
            reg_RegWriteD <= 1'b0;
            reg_SrcASelD <= 2'b01;
            reg_SrcBSelD <= 2'b11;
            reg_MemWriteD <= 1'b0;
            reg_MemtoRegD <= 1'b0;
            reg_PCBranchD <= 1'b0;
            reg_ALUopD <= 4'b0000;
            reg_strCtrlD <= 3'b000;
            reg_r1D <= 32'h00000000; 
            reg_r2D <= 32'h00000000; 
            reg_immD <= 32'h00000000;
            reg_rdD <= 5'h00;
            reg_PCD <= 32'h00000000; 
            reg_JALRctrlD <= 1'b1;
            reg_rs1D <= 5'b0;
            reg_rs2D <= 5'b0;

        end
        else begin
            reg_RegWriteD <= RegWriteD;
            reg_SrcASelD <= SrcASelD;
            reg_SrcBSelD <= SrcBSelD;
            reg_MemWriteD <= MemWriteD;
            reg_MemtoRegD <= MemtoRegD;
            reg_PCBranchD <= PCBranchD;
            reg_ALUopD <= ALUopD;
            reg_strCtrlD <= strCtrlD;
            reg_r1D <= r1D; 
            reg_r2D <= r2D; 
            reg_immD <= immD;
            reg_rdD <= instrD[11:7];
            reg_PCD <= PCD;
            reg_JALRctrlD <= JALRctrlD;
            reg_rs1D <= rs1D;
            reg_rs2D <= rs2D;
        end
    end


assign strCtrlE = reg_strCtrlD;
assign RegWriteE = reg_RegWriteD;
assign MemWriteE = reg_MemWriteD;
assign PCBranchE = reg_PCBranchD;
assign SrcASelE = reg_SrcASelD;
assign SrcBSelE = reg_SrcBSelD;
assign MemtoRegE = reg_MemtoRegD;
assign ALUopE = reg_ALUopD;
assign immE = reg_immD;
assign PCE = reg_PCD;
assign r1E = reg_r1D;
assign r2E = reg_r2D;
assign rdE = reg_rdD;
assign JALRctrlE = reg_JALRctrlD;
assign rs1E = reg_rs1D;
assign rs2E = reg_rs2D;

endmodule