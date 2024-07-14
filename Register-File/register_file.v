module registerFile (
    input rst, clk, writeEnable,
    input [31 : 0] dataWrite, 
    input [4 : 0] addressWrite, addressA, addressB,
    output reg [31 : 0] dataA, dataB
);
    integer  i;
    reg [31 : 0] registerFileData [31 : 0];


    always @(negedge clk, posedge rst) begin // don't forget the negedge instead of forwarding overhead.
        if(rst) begin
            for(i = 0; i < 10; i++)
                registerFileData[i] <= 0;
            registerFileData[10] = 5;
            registerFileData[20] = 5;
        end
        else if(writeEnable)
            registerFileData[addressWrite] = dataWrite;
    end



    always@(*)begin
        dataA = registerFileData[addressA];
        dataB = registerFileData[addressB];
    end
    wire [31 : 0] testRegister; assign testRegister = registerFileData[10];
endmodule