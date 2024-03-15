module DMEM(clk,rst,we,mem_wmask,wd,A,rd);

    input clk,rst,we;
    input [3:0] mem_wmask;
    input [31:0]A,wd;
    output [31:0]rd;

    reg [31:0] mem [1023:0];

    always @ (posedge clk)
    begin
        if(we)
        if(mem_wmask[0]) mem[A][ 7:0 ] <= wd[ 7:0 ];
        if(mem_wmask[1]) mem[A][15:8 ] <= wd[15:8 ];
        if(mem_wmask[2]) mem[A][23:16] <= wd[23:16];
        if(mem_wmask[3]) mem[A][31:24] <= wd[31:24];	
    end

    assign rd = (rst) ? 32'd0 : mem[A];

    initial begin
        mem[0] = 32'h00000000;
        //mem[40] = 32'h00000002;
    end


endmodule