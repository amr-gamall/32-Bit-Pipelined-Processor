`include "Instruction-Memory/instruction_memory.v"
`include "Data-Memory/data_memory.v"
`include "ALU/alu.v"
`include "Register-File/register_file.v"
`include "Program-Counter/program_counter.v"

module dataPath(
    input              rst, clk,

    // control inputs
    input              regWrite, regDst, memWrite, mem2Reg, aluSrcB, pcSrc,
    input  [2 : 0]     aluControl,
    // for control/hazard
    output [5 : 0] reg opcode, funct,
    output         reg eq,

    // hazard inputs
    input [1 : 0]      fad, fbd,
    input              flush
);

    // fetch stage
    wire addToPC;    assign  addToPC = pcSrc ? immShifted : 4;
    reg [31 : 0] PC; always@(posedge clk, posedge rst)if(rst)PC <= 0; else PC <= PC + addToPC;

    wire instr[31 : 0];
    instructionMemory IM (.clk(clk), .rst(rst), .instr(instr), .address(PC));

    // decode flop
    wire [31 : 0] dFlop;
    always @(posedge clk, posedge flush)if(flush & clk)dFlop <= 0; else dFlop <= instr;

    // decode stage
    wire [4 : 0] rs, rt; assign rs = instr[25 : 21]; assign rt = instr[20 : 16];
    wire [31 : 0] rsD, rtD; 
    registerFile(.rst(rst), .clk(clk), .writeEnable(regWriteWB), .dataWrite(regDstWB), .addressA(rs), .addressB(rt)
                 .dataA(rsD), .dataB(rtD));
    wire [31 : 0] immD = {instr[15]?16'hffff : 16'h0000 , instr[15 : 0]};
    wire [31 : 0] immShifted = immD << 2;

    // forward muxes


endmodule
