// 1kb data memory for MIPS microarch

module instructionMemory (
    input           clk, rst,
    input  [31 : 0] address,
    output [31 : 0] instruction
);
    reg [31 : 0] data [1023 : 0];
    integer  i;
    always @(posedge clk, posedge rst) begin
        if(rst)begin
            for(i = 0;i < 1024;i++)
                data[i] <= 0;
        end
    end

    assign instruction = data[address];
endmodule