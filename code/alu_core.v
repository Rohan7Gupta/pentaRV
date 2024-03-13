//This alu is used for execute, fetch,branch, jump, load & store 
`include "defines.v"
module alu_core(aluIn1,aluIn2,aluOP,aluOut,branch);
input [31:0] aluIn1,aluIn2;
input [3:0] aluOP;
output [31:0] aluOut;
output branch;

   wire [31:0] aluPlus = aluIn1 + aluIn2;
   // Using a single 33 bits subtract to do subtraction and all comparisons
   // (trick borrowed from swapforth/J1)

   wire [32:0] aluMinus = {1'b1, ~aluIn2} + {1'b0,aluIn1} + 33'b1;
   wire        LT  = (aluIn1[31] ^ aluIn2[31]) ? aluIn1[31] : aluMinus[32];
   wire        LTU = aluMinus[32];
   wire        EQ  = (aluMinus[31:0] == 0);

   // Flip a 32 bit word. Used by the shifter (optimization) 
   //(a single shifter for left and right shifts)
   function [31:0] flip32;
      input [31:0] x;
      flip32 = {x[ 0], x[ 1], x[ 2], x[ 3], x[ 4], x[ 5], x[ 6], x[ 7], 
		x[ 8], x[ 9], x[10], x[11], x[12], x[13], x[14], x[15], 
		x[16], x[17], x[18], x[19], x[20], x[21], x[22], x[23],
		x[24], x[25], x[26], x[27], x[28], x[29], x[30], x[31]};
   endfunction

   wire [31:0] shifter_in = (aluOP == 3'b001) ? flip32(aluIn1) : aluIn1;
   
   wire [31:0] shifter = $signed({aluOP[3] & aluIn1[31], shifter_in}) >>> aluIn2[4:0];

   wire [31:0] leftshift = flip32(shifter);
   

   
   // ADD/SUB/ADDI: 
   // funct7[5] is 1 for SUB and 0 for ADD. We need also to test instr[5]
   // to make the difference with ADDI
   //
   // SRLI/SRAI/SRL/SRA: 
   // funct7[5] is 1 for arithmetic shift (SRA/SRAI) and 
   // 0 for logical shift (SRL/SRLI)
   reg [31:0]  aluOut;
   always @(*) begin
   case(aluOP)
	`ADD: aluOut = aluPlus; //add/sub/addi
	`SLL: aluOut = leftshift;
	`SLT: aluOut = {31'b0, LT};
	`SLTU: aluOut = {31'b0, LTU};
	`XOR: aluOut = (aluIn1 ^ aluIn2);
	`SRL: aluOut = shifter;
   `SRA: aluOut = shifter;
	`OR: aluOut = (aluIn1 | aluIn2);
	`AND: aluOut = (aluIn1 & aluIn2);
   `SUB: aluOut = aluMinus;	
   endcase
   end

   // The predicate for branch instructions
   reg takeBranch;
   always @(*) begin
      case(aluOP)
	`BEQ: takeBranch = EQ;
	`BNE: takeBranch = !EQ;
	`BLT: takeBranch = LT;
	`BGE: takeBranch = !LT;
	`BLTU: takeBranch = LTU;
	`BGEU: takeBranch = !LTU;
	default: takeBranch = 1'b0;
      endcase
   end
endmodule