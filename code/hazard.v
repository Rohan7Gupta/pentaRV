module hazard(rst, RegWriteM, RegWriteW, rdM, rdW, rs1E, rs2E, ForwardAE, ForwardBE);

    // Declaration of I/Os
    input rst, RegWriteM, RegWriteW;
    input [4:0] rdM, rdW, rs1E, rs2E;
    output [1:0] ForwardAE, ForwardBE;
    
    assign ForwardAE = (rst) ? 2'b00 : 
                       ((RegWriteM == 1'b1) & (rdM != 5'h00) & (rdM == rs1E)) ? 2'b10 :
                       ((RegWriteW == 1'b1) & (rdW != 5'h00) & (rdW == rs1E)) ? 2'b01 : 2'b00;
                       
    assign ForwardBE = (rst) ? 2'b00 : 
                       ((RegWriteM == 1'b1) & (rdM != 5'h00) & (rdM == rs2E)) ? 2'b10 :
                       ((RegWriteW == 1'b1) & (rdW != 5'h00) & (rdW == rs2E)) ? 2'b01 : 2'b00;

endmodule