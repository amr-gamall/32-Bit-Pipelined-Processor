// 1kb data memory for MIPS microarch

module dataMemory (
    input               clk, rst, writeEnable,
    input      [31 : 0] address, dataWrite,
    output [31 : 0] dataOutput
);
    
    reg [31 : 0] data [1023 : 0];
    integer  i;
    always @(posedge clk, posedge rst) begin
        if(rst)begin
            for(i = 1;i < 1024&&i!=32;i++)
                data[i] <= 0;
            data[32]<= 32'h00000005;                              // $t1 = 0x05;
            data[33]<= 32'h00000006;
        end
        else if(writeEnable)   
                data[address] <= dataWrite;
    end

    assign dataOutput = data[address];
endmodule