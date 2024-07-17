module controlUnit(input [5 : 0] funct, opcode, 
                   input eq,
                   output reg regWrite, regDst, memWrite, mem2Reg, aluSrcB, pcSrc,
                   output reg [2 : 0] aluControl
                  );


// opcodes
localparam rType = 6'b000000,
            lw    = 6'b100011,
            sw    = 6'b101011,
            beq   = 6'b000100;

// funct fields
localparam add = 6'b100000;
localparam sub = 6'b100010;

always @(*)begin
    case (opcode)
        lw:     {pcSrc, regWrite, regDst, memWrite, mem2Reg, aluSrcB, aluControl} = {1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 3'b010};
        sw:     {pcSrc, regWrite, regDst, memWrite, mem2Reg, aluSrcB, aluControl} = {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 3'b010};
        rType:  {pcSrc, regWrite, regDst, memWrite, mem2Reg, aluSrcB, aluControl} = {1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, (funct == add) ? 3'b010 : (funct == sub?3'b110 : 3'b011)};
        beq:    {pcSrc, regWrite, regDst, memWrite, mem2Reg, aluSrcB, aluControl} = {eq, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 3'b010};
        default:{pcSrc, regWrite, regDst, memWrite, mem2Reg, aluSrcB, aluControl} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 3'b010};
    endcase
end

endmodule


// TODO : update the static branch predictor to a 2 bit saturation dynamic one
// now it makes sense why in the ISA we choose distance is from the next instruction preceding the branch instruction, because
// the static branch predictor is used and the next instruction is already fetched and PC is pointing at it while beq is at decode.