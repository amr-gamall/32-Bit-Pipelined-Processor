# 32-Bit-MIPS-Pipelined-Processor 

## Introduction

- An implementation to *h&h* 32 bit MIPS Pipelined processor with some nuances.
- The microarchitecture is quite different from *h&h*, I customized various aspects to it the main change was:
    - Changing the forward sink to the decode stage instead of the execute stage  
        - reasons : 
            1. Less wire cluttering.
            2. No needed stall anymore because `lw` instruction forwards directly to the decode stage.
            2. No need for forward logic of the branch instruction because the sink is already at the decode stage.
            3. Some downs is that the $T_c$ kind of increase by very small fraction which might be neglected (due to the increase of critical path, specifically $T_{mem} + {T_{mux}}$).

- The microarchitecture is synthesizeable.

## Dependencies 
- python
- GTKwave or any wave simulator (for simulation purposes)

## Usage

- Run `python simulate.py <file>.hex` with the appropriate hex file, you can view the outputs at `output.vcd` 
