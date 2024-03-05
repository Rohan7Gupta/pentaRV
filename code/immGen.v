module IMEM(instrD,immSelD,immD);
input [31:0] instrD;
input [2:0] immSelD;
output [31:0] immD;

wire [31:0] Uimm,Iimm,Jimm, Bimm,Simm;

assign Uimm={    instrD[31],   instrD[30:12], {12{1'b0}}};//U type immediate
assign Iimm={{21{instrD[31]}}, instrD[30:20]};//I type immediate
assign Simm={{21{instrD[31]}}, instrD[30:25],instrD[11:7]};//Stype immediate
assign Bimm={{20{instrD[31]}}, instrD[7],instrD[30:25],instrD[11:8],1'b0};//B type immediate
assign Jimm={{12{instrD[31]}}, instrD[19:12],instrD[20],instrD[30:21],1'b0};//J type immediate

assign immD = (~immSelD[2]) ? ((~immSelD[1]) ? ((~immSelD[0]) ? Iimm : Bimm)
                                            : ((~immSelD[0]) ? Jimm : Simm))
                            : ((~immSelD[1]) ? ((~immSelD[0]) ? Uimm : 32'b0)
                                            : ((~immSelD[0]) ? 32'b0 : 32'b0));

endmodule