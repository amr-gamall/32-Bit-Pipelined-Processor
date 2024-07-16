`include "data_path.v"
`include "control_unit.v"
`include "hazard_unit.v"
module mips(input clk, rst);

    wire [5 : 0] funct, opcode;
    wire         eq, regWrite, regWriteEH, regWriteMH, regWriteDH,
                 regDst, memWrite, mem2RegEH, aluSrcB, pcSrc, flush,
                 mem2RegEE, enableE, enableD, flushD;
    wire [2 : 0] aluControl;
    wire [1 : 0] fad, fbd;
    wire [4 : 0] rsDH, rtDH, rdEH, rdMH;

    controlUnit cu(.eq(eq), .regWrite(regWrite), .regDst(regDst),
                   .memWrite(memWrite), .mem2Reg(mem2Reg), .aluSrcB(aluSrcB), 
                   .pcSrc(pcSrc), .aluControl(aluControl), .opcode(opcode),
                   .funct(funct));

    hazardUnit hu(.eq(eq), .regWriteEH(regWriteEH), .regWriteDH(regWriteDH), 
                  .mem2RegEH(mem2RegEH), .regWriteMH(regWriteMH), .opcode(opcode), 
                  .rsDH(rsDH), .rtDH(rtDH), .rdEH(rdEH), .rdMH(rdMH), .flushD(flushD), 
                  .enableE(enableE), .fad(fad), .fbd(fbd), .enableD(enableD));

    dataPath    dp(.rst(rst), .clk(clk), .regWrite(regWrite), .regDst(regDst),
                   .memWrite(memWrite), .mem2Reg(mem2Reg), .aluSrcB(aluSrcB), 
                   .pcSrc(pcSrc), .aluControl(aluControl), .fad(fad), .fbd(fbd),
                   .enableE(enableE), .rsDH(rsDH), .rtDH(rtDH), .rdEH(rdEH), .rdMH(rdMH),
                   .opcode(opcode), .funct(funct), .eq(eq), .mem2RegEH(mem2RegEH), 
                   .regWriteMH(regWriteMH), .regWriteEH(regWriteEH),.regWriteDH(regWriteDH),
                   .flushD(flushD), .enableD(enableD));

    
endmodule