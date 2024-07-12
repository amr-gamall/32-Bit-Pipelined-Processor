`include "Instruction-Memory/instruction_memory.v"
`include "Data-Memory/data_memory.v"
`include "ALU/alu.v"
`include "Register-File/register_file.v"
`include "Program-Counter/program_counter.v"

module dataPath(
    input              rst, clk,
    // cu
    input              regWrite, regDst, memWrite, mem2Reg, aluSrcB, pcSrc,
    input      [2 : 0] aluControl,
    // for control/hazard
    output reg [5 : 0] opcode, funct,
    output             eq,

    // hazard inputs
    input      [1 : 0] fad, fbd,
    input              flush
);

    // fetch stage
    wire addToPC;    assign  addToPC = pcSrc ? immShiftedD : 4;
    reg [31 : 0] PC; always@(posedge clk, posedge rst)if(rst)PC <= 0; else PC <= PC + addToPC;

    wire instr[31 : 0];
    instructionMemory IM(.clk(clk), .rst(rst), .instr(instr), .address(PC));




    // decode stage
    // decode flop
    reg [31 : 0] instrD;
    always @(posedge clk, posedge flush)if(flush & clk)instrD <= 0; else instrD <= instr;

    wire [4 : 0] rsD, rtD, rdD; assign rsD = instrD[25 : 21]; assign rtD = instrD[20 : 16]; assign rdD = instrD[15 : 11];
    wire [31 : 0] rsDataD, rtDataD, rsDataFD, rtDataFD;

    registerFile RF(.rst(rst), .clk(clk), .writeEnable(regWriteWB), .addressWrite(writeRegWB),
                .dataWrite(regDataWriteWB), .addressA(rsD), .addressB(rtD), .dataA(rsDataD),
                .dataB(rtDataD));
    wire [31 : 0] immD; assign immD = {instrD[15]?16'hffff : 16'h0000 , instrD[15 : 0]};
    wire [31 : 0] immShiftedD = immD << 2;
    assign eq = &(~(rsDataFD ^ rtDataFD));
    // forward muxes
    always @(*) begin
        case (fad)
            0 : rsDataFD = rsD;     
            1 : rsDataFD = aluOutE; 
            2 : rsDataFD = memDataM;
            3 : rsDataFD = aluOutM;
            default: rsDataFD = 0;
        endcase
        case (fbd)
            0 : rtDataFD = rst;     
            1 : rtDataFD = aluOutE; 
            2 : rtDataFD = memDataM;
            3 : rtDataFD = aluOutM;
            default: rtDataFD = 0;
        endcase
    end




    // execute flop
    reg [31 : 0] rsDataE, rtDataE, immE;
    reg [5 : 0] rsE, rtE;
    reg regDstE, aluSrcBE, regWriteE, mem2RegE, memWriteE;
    reg [2 : 0] aluControlE;
    always @(posedge clk)begin
        rsDataE     <= rsDataFD;
        rtDataE     <= rtDataFD;
        immE        <= immD;
        rsE         <= rsD;
        rtE         <= rtD;
        rdE         <= rdD;

        memWriteE   <= memWrite;
        mem2RegE    <= mem2Reg;
        regDstE     <= regDst;
        aluSrcBE    <= aluSrcB;
        aluControlE <= aluControl;
        regWriteE   <= regWrite;
    end
    // execute stage
    wire [31 : 0] operand2; assign operand2 = aluSrcBE?rtDataE : immE;
    wire [31 : 0] aluOutE;
    ALU a(.SrcA(rsDataE), .SrcB(operand2), .ALUControl(aluControlE), .ALUResult(aluOutE));
    wire [4 : 0] writeRegE; assign writeRegE = regDst?rtE:rdE;




    // memory read
    reg [31 : 0] alutOutM, rtDataM;
    reg regWriteM, mem2RegM, memWriteM;
    always @(posedge clk)begin
        alutOutM <= aluOutE;
        rtDataM  <= rtDataE;
        writeRegM<= writeRegE;
        regWriteM<= regWriteE;
        mem2Reg  <= mem2RegE;
        memWriteM<= memWriteE;
    end

    wire [31 : 0] memDataM;    
    dataMemory DM(.clk(clk), .rst(rst), .writeEnable(memWriteM), .address(aluOutM), .dataWrite(rtDataM),
                  .dataOutput(memDataM));





    // writeback flop
    reg [31 : 0] memDataWB, aluOutWB;
    reg [4 : 0] writeRegWB;
    reg regWriteWB, mem2RegWB;
    always @(posedge clk)begin
        regWriteWB <= regWriteM;
        memDataWB  <= memDataM;
        aluOutWB   <= alutOutM;
        writeRegWB <= writeRegM;
        mem2RegWB  <= mem2RegM;
    end

    wire [31 : 0] regDataWriteWB; assign regDataWriteWB = mem2RegWB? aluOutWB : memDataWB;
endmodule

// Register file nomenclature
    // writeReg       => address of reg to write
    // regWrite       => control signal to write
    // regDataWriteWB => data to be written