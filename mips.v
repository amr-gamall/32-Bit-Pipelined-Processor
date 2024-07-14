`include "data_path.v"
`include "control_unit.v"
`include "hazard_unit.v"
module mips(input clk, rst);

    wire [5 : 0] funct, opcode;
    wire         eq, regWrite, regDst, memWrite, mem2Reg, aluSrcB, pcSrc, flush, mem2RegEE;
    wire [2 : 0] aluControl;
    wire [1 : 0] fad, fbd;
    wire [4 : 0] RSD, RTD, destinationE, destinationM;

    controlUnit cu(.eq(eq), .regWrite(regWrite), .regDst(regDst),
                   .memWrite(memWrite), .mem2Reg(mem2Reg), .aluSrcB(aluSrcB), 
                   .pcSrc(pcSrc), .aluControl(aluControl), .opcode(opcode),
                   .funct(funct));

    hazardUnit hu(.eq(eq), .regWriteE(regWriteE), .regWriteM(regWriteM), .opcode(opcode),
                  .RSD(RSD), .RTD(RTD), .destinationE(destinationE), .destinationM(destinationM),
                  .flush(flush), .fad(fad), .fbd(fbd), .mem2RegEE(mem2RegEE));

    dataPath    dp(.rst(rst), .clk(clk), .regWrite(regWrite), .regDst(regDst), 
                   .memWrite(memWrite), .mem2Reg(mem2Reg), .aluSrcB(aluSrcB), 
                   .pcSrc(pcSrc), .aluControl(aluControl), .opcode(opcode), 
                   .funct(funct), .eq(eq), .fad(fad), .fbd(fbd), .flush(flush),
                   .RSD(RSD), .RTD(RTD), .destinationE(destinationE), .destinationM(destinationM), 
                   .mem2RegEE(mem2RegEE));


    
endmodule