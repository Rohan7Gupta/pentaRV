module RegFile(clk,rst,rs1,rs2,rd,we,wd,r1,r2);

    input clk,rst,we;
    input [4:0]rs1,rs2,rd;
    input [31:0]wd;
    output [31:0]r1,r2;

    reg [31:0] Register [31:0];

    always @ (negedge clk)
    begin
        if(we & (rd != 5'h00))
            Register[rd] <= wd;
    end
    
    assign r1 = (rst) ? 32'd0 : Register[rs1];
    assign r2 = (rst) ? 32'd0 : Register[rs2];

    initial begin
        Register[0] = 32'h00000000;
    end

endmodule