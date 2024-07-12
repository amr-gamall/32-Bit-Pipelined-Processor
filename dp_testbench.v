`include "data_path.v"
`timescale 1ns/1ps

module tb;


    reg clk, rst, regWrite, regDst, memWrite, mem2Reg, aluSrcB, pcSrc, flush;
    reg [2 : 0] aluControl;
    reg [1 : 0]  fad, fbd;

    always #10 clk ^= 1;

    dataPath dp(.rst(rst), .clk(clk),.regWrite(regWrite), .regDst(regDst), .memWrite(memWrite),
                .mem2Reg(mem2Reg), .aluSrcB(aluSrcB), .pcSrc(pcSrc), .aluControl(aluControl), 
                .fad(fad), .fbd(fbd), .flush(flush));

    initial begin
        $dumpfile("dp_testbench.vcd");
        $dumpvars(0, tb);
        flush = 0;

        aluControl = 2;
        clk = 0;
        // resetting pc
        pcSrc = 0;

        @(negedge clk);
        rst = 1;
        #5;
        rst = 0;

        @(negedge clk);
        regWrite = 1;
        memWrite = 0;
        fad = 0; 
        fbd = 0;
        aluSrcB = 1;
        regDst = 0;
        mem2Reg = 1;

        #400;
        $finish;
    end


endmodule