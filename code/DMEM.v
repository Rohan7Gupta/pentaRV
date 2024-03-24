module DMEM (
    input clk, rst, we, dump,
    input [3:0] mem_wmask,
    input [31:2] A, 
    input [31:0]wd,
    output [31:0] rd
);

reg [31:0] mem [1023:0];

integer i;
integer dump_file;

always @ (posedge clk) begin
    if (we) begin
        if (mem_wmask[0]) mem[A][ 7:0 ] <= wd[ 7:0 ];
        if (mem_wmask[1]) mem[A][15:8 ] <= wd[15:8 ];
        if (mem_wmask[2]) mem[A][23:16] <= wd[23:16];
        if (mem_wmask[3]) mem[A][31:24] <= wd[31:24];  
    end
end

assign rd = (rst) ? 32'd0 : mem[A];

// Memory dump logic
initial begin
    dump_file = $fopen("memory_dump.txt", "w");
    if (dump_file == 0) begin
        $display("Error: Unable to open file for writing.");
        $finish;
    end

    // Initialize memory with some values (optional)
    mem[0] = 32'h00000000;
end

always @(posedge clk) begin
    if (dump) begin
        for (i = 0; i < 1024; i = i + 1) begin
            $fwrite(dump_file, "mem[%3d] = %h\n", i, mem[i]);
        end
        $fflush(dump_file);
        $display("Memory dumped to memory_dump.txt");
    end
end

endmodule
