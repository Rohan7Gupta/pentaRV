module MEM (clk,rst,we,dump,mem_wmask,addrData,addrInstr,wd,rd,readInstr);

input clk, rst, we, dump;
input [3:0] mem_wmask;
input [31:2] addrData,addrInstr; 
input [31:0]wd;
output [31:0] rd, readInstr;


reg [31:0] mem [65536:0];

integer i;
integer dump_file;

always @ (negedge clk) begin
    if (we) begin
        if (mem_wmask[0]) mem[addrData][ 7:0 ] <= wd[ 7:0 ];
        if (mem_wmask[1]) mem[addrData][15:8 ] <= wd[15:8 ];
        if (mem_wmask[2]) mem[addrData][23:16] <= wd[23:16];
        if (mem_wmask[3]) mem[addrData][31:24] <= wd[31:24];  
    end
end

assign rd = (rst) ? 32'd0 : mem[addrData];
assign readInstr = (rst) ? 32'd0 : mem[addrInstr];


initial begin
// Initialize all memory cells to zero by default
        for (i = 0; i < 65536; i = i + 1) begin
            mem[i] = 32'd0;
        end

    $readmemh("memfile.hex",mem);
    mem[4096] = 32'h00000000;
    mem[4097] = 32'h08000000;
    mem[5000]= 32'h84755779;

    //dump file for testing
    dump_file = $fopen("memory_dump.txt", "w");
    if (dump_file == 0) begin
        $display("Error: Unable to open file for writing.");
        $finish;
    end
end


always @(posedge clk) begin
    if (dump) begin
        for (i = 0; i < 65536; i = i + 1) begin
            $fwrite(dump_file, "mem[%3d] = %h\n", i, mem[i]);
        end
        $fflush(dump_file);
        $display("Memory dumped to memory_dump.txt");
    end
end

endmodule
