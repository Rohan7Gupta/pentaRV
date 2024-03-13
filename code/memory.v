wire mem_byteAccess     = funct3[1:0] == 2'b00;
wire mem_halfwordAccess = funct3[1:0] == 2'b01;

mem_wmask = mem_byteAccess ?
	(writeBack[1] ?
	(writeBack[0] ? 4'b1000 : 4'b0100) :
	(writeBack[0] ? 4'b0010 : 4'b0001)
) :
	mem_halfwordAccess ?
	(writeBack[1] ? 4'b1100 : 4'b0011) :
    4'b1111;

wire [15:0] LOAD_halfword = writeBack[1] ? mem_rdata[31:16] : mem_rdata[15:0];

wire  [7:0] LOAD_byte = writeBack[0] ? LOAD_halfword[15:8] : LOAD_halfword[7:0];

   // LOAD, in addition to funct3[1:0], LOAD depends on:
   // - funct3[2] (instr[14]): 0->do sign expansion   1->no sign expansion
wire LOAD_sign = !funct3[2] & (mem_byteAccess ? LOAD_byte[7] : LOAD_halfword[15]);

wire [31:0] LOAD_data = mem_byteAccess ? {{24{LOAD_sign}},     LOAD_byte} :
                        mem_halfwordAccess ? {{16{LOAD_sign}}, LOAD_halfword} :
                        mem_rdata ;