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
            data[0] <= 32'b100011_00000_01010_0000000000100000;
            data[1] <= 32'b100011_00000_01011_0000000000100001;
            data[2] <= 32'b100011_00000_01100_0000000000100010;
            data[3] <= 32'b100011_00000_01101_0000000000100011;
            data[4] <= 32'b000100_00000_01101_0000000000000011;
            data[5] <= 32'b000000_01010_01011_01011_00000_100000;
            data[6] <= 32'b000000_01100_01011_01101_00000_100110;
            data[7] <= 32'b000100_00000_00000_1111111111111100;
            for(i = 8;i < 1024;i++)
                data[i] <= 0;
        end
    end
    assign instruction = data[address];


endmodule





// data[0] <= 32'b000000_10100_01010_01010_00000_100000; // add $t1, $t1, $some other register
// data[1] <= 32'b000100_01010_01010_0000000000000011;   // beq $t1, $t1, add(5)
// data[5] <= 32'b000000_10100_01010_01010_00000_100000; // add $t1, $t1, $some other register
// data[0] <= 32'h8C0A0020;                              // lw $t1, 32($0), t1 = 5
// data[1] <= 32'h8C0A0021;                              // lw $t1, 33($0), t1 = 6
// data[1] <= 32'b000100_01010_01010_0000000000000011;   // beq $t1, $t1, add(5)
