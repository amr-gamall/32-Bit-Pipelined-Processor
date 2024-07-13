
module hazardUnit(input eq, regWriteE, regWriteM, mem2RegEE,
          input [5 : 0] opcode, 
          input  [4 : 0] RSD, RTD, destinationE, destinationM, 
          output flush,
          output reg [1 : 0] fad, fbd
         );

    localparam beq   = 6'b000100;

    assign flush = (opcode == beq) && eq;
    always @(*) begin
        if(regWriteE && RSD == destinationE)
            fad = 1;
        else if(regWriteE && RSD == destinationM)
            if(mem2RegEE)
                fad = 2;
            else
                fad = 3;
        else
            fad = 0;
    end
    always @(*) begin
        if(regWriteE && RTD == destinationE)
            fbd = 1;
        else if(regWriteE && RTD == destinationM)
            if(mem2RegEE)
                fbd = 2;
            else
                fbd = 3;
        else
            fbd = 0;
    end
endmodule