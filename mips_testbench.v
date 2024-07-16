`include "mips.v"
`timescale 1ns/1ps

module tb;


    reg clk, rst;
    always #10 clk ^= 1;

    mips m(.clk(clk), .rst(rst));

    initial begin
        $dumpfile("mips_testbench.vcd");
        $dumpvars(0, tb);

        clk = 0;
        rst = 1;
        #5;
        rst = 0;

        #10000;
        $finish;
    end


endmodule