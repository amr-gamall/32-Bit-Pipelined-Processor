
module hazardUnit(input eq, regWriteEH, regWriteDH, mem2RegEH, regWriteMH,
          input [5 : 0] opcode, 
          input  [4 : 0] rsDH, rtDH, rdEH, rdMH, 
          output flushD, enableE, enableD,
          output reg [1 : 0] fad, fbd
         );

    localparam beq   = 6'b000100;

    assign flushD = (opcode == beq) && eq;
    // stall if lw x, blabla; rtype f, x, x
    assign enableE = (mem2RegEH & regWriteEH) & ((rsDH == rdEH) | (rtDH == rdEH));
    assign enableD = (mem2RegEH & regWriteEH) & ((rsDH == rdEH) | (rtDH == rdEH)); 
    always @(*) begin
        if(regWriteEH && rsDH == rdEH && rdEH)
            fad = 1;
        else if(regWriteEH && rsDH == rdMH && rdMH)
            if(mem2RegEH) // I'm being smart and indicating if forwarding from the memory is needed without the regwriteM don't forget to remove it from the microarch design IDIOT!
                fad = 2;
            else
                fad = 3;
        else
            fad = 0;
    end
    always @(*) begin
        if(regWriteEH && rtDH == rdEH && rdEH)
            fbd = 1;
        else if(regWriteEH && rtDH == rdMH && rdMH)
            if(mem2RegEH) // I'm being smart and indicating if forwarding from the memory is needed without the regwriteM don't forget to remove it from the microarch design IDIOT!
                fbd = 2;
            else
                fbd = 3;
        else
            fbd = 0;
    end
endmodule