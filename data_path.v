`include "Instruction-Memory/instruction_memory.v"
`include "Data-Memory/data_memory.v"
`include "ALU/alu.v"
`include "Register-File/register_file.v"
`include "Program-Counter/program_counter.v"

module dataPath(
    input              rst, clk,
    input              regWrite, regDst, memWrite, mem2Reg, aluSrcB, pcSrc,
    input      [2 : 0] aluControl,

    input      [1 : 0] fad, fbd,
    input              flush,
    output     [4 : 0] RSD, RTD, destinationE, destinationM, 
    output     [5 : 0] opcode, funct, opcodeD,
    output             eq, mem2RegEE
);
    // fetch stage
    reg [31 : 0] PC; always@(posedge clk, posedge rst)if(rst)PC <= 0; else PC <= PC + (pcSrc ? immShiftedD : 1);
    wire [31 : 0] instr;
    instructionMemory IM(.clk(clk), .rst(rst), .instruction(instr), .address(PC));

    // decode stage
    reg [31 : 0] instrD;
    always @(posedge clk, posedge rst)if((flush & clk) | rst)instrD <= 0; else instrD <= instr;
    assign opcodeD = instrD[31 : 26];

    wire [4 : 0] rsD, rtD, rdD; assign rsD = instrD[25 : 21]; assign rtD = instrD[20 : 16]; assign rdD = instrD[15 : 11];
    wire [31 : 0] rsDataD, rtDataD;
    reg  [31 : 0] rsDataFD, rtDataFD;

    registerFile RF(.rst(rst), .clk(clk), .writeEnable(regWriteWB), .addressWrite(writeRegWB),
                .dataWrite(writeRegData), .addressA(rsD), .addressB(rtD), .dataA(rsDataD),
                .dataB(rtDataD));
    wire [31 : 0] immD; assign immD = {instrD[15]?16'hffff : 16'h0000 , instrD[15 : 0]};
    wire [31 : 0] immShiftedD = immD;
    assign eq = &(~(rsDataFD ^ rtDataFD));

    assign funct = instrD[5 : 0];
    assign opcode = instrD[31 : 26];
    // forward muxes
    always @(*) begin
        case (fad)
            0 : rsDataFD = rsDataD;     
            1 : rsDataFD = aluOutE; 
            2 : rsDataFD = memDataM;
            3 : rsDataFD = aluOutM;
            default: rsDataFD = 0;
        endcase
        case (fbd)
            0 : rtDataFD = rtDataD;     
            1 : rtDataFD = aluOutE; 
            2 : rtDataFD = memDataM;
            3 : rtDataFD = aluOutM;
            default: rtDataFD = 0;
        endcase
    end
    assign RSD = rsD; 
    assign RTD = rtD;

    // execute stage
    reg [31 : 0] rsDataE, rtDataE, immE;
    reg [5 : 0] rsE, rtE, rdE;
    reg regDstE, aluSrcBE, regWriteE, mem2RegE, memWriteE;
    reg [2 : 0] aluControlE;
    always @(posedge clk, posedge rst)begin
        if(rst)begin
            memWriteE   <= 0;
            regWriteE   <= 0;
        end else begin
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
    end
    wire [31 : 0] operand2; assign operand2 = aluSrcBE?immE : rtDataE;
    wire [31 : 0] aluOutE;
    ALU a(.SrcA(rsDataE), .SrcB(operand2), .ALUControl(aluControlE), .ALUResult(aluOutE));
    wire [4 : 0] writeRegE; assign writeRegE = regDstE?rdE:rtE;

    assign destinationE = writeRegE;
    assign mem2RegEE = mem2RegE;

    // memory read stage
    reg [31 : 0] aluOutM, rtDataM;
    reg regWriteM, mem2RegM, memWriteM;
    reg [4 : 0] writeRegM;
    always @(posedge clk, posedge rst)begin
        if(rst)begin
            memWriteE   <= 0;
            regWriteE   <= 0;
        end else begin
            aluOutM <= aluOutE;
            rtDataM  <= rtDataE;
            writeRegM<= writeRegE;
            regWriteM<= regWriteE;
            mem2RegM  <= mem2RegE;
            memWriteM<= memWriteE;
        end
    end

    wire [31 : 0] memDataM;    
    dataMemory DM(.clk(clk), .rst(rst), .writeEnable(memWriteM), .address(aluOutM), .dataWrite(rtDataM),
                  .dataOutput(memDataM));

    assign destinationM = writeRegM;

    // writeback stage
    reg [31 : 0] memDataWB, aluOutWB;
    reg [4 : 0] writeRegWB;
    reg regWriteWB, mem2RegWB;
    always @(posedge clk, posedge rst)begin
        if(rst)begin
            memWriteE   <= 0;
            regWriteE   <= 0;
        end else begin
            regWriteWB <= regWriteM;
            memDataWB  <= memDataM;
            aluOutWB   <= aluOutM;
            writeRegWB <= writeRegM;
            mem2RegWB  <= mem2RegM;
        end
    end
    wire [31 : 0] writeRegData; assign writeRegData = mem2RegWB? memDataWB : aluOutWB;
endmodule
// Register file nomenclature
    // writeReg       => address of reg to write
    // writeRegData => data to be written
    // regWrite       => control signal to write