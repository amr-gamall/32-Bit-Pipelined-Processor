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
            data[32]<= 2;
            data[33]<= 0;
            data[34]<= 64;
            data[35]<= 4;
        end
        else if(writeEnable)   
                data[address] <= dataWrite;
    end
    wire [31 : 0] dataTest; assign dataTest = data[36];
    assign dataOutput = data[address];
endmodule