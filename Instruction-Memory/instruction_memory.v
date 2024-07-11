// 1kb data memory for MIPS microarch

module dataMemory (
    input               clk, rst,
    input      [31 : 0] address,
    output [31 : 0] dataOutput
);
    reg [31 : 0] data [1023 : 0];
    integer  i;
    always @(posedge clk, posedge rst) begin
        if(rst)begin
            for(i = 0;i < 1024;i++)
                data[i] <= 0;
        end
    end

    assign dataOutput = data[address];
endmodule