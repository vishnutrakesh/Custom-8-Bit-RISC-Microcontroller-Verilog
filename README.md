# Custom 8-bit RISC Microcontroller in Verilog

A custom-designed 8-bit RISC microcontroller implemented in Verilog HDL.  
The processor includes a custom instruction set, ALU, register file, program counter, control unit, instruction memory, data memory, GPIO interface, timer peripheral, and bus decoder.

The design was simulated and verified using a Verilog testbench.

## Features

- 8-bit datapath
- 16-bit instruction format
- 8 general-purpose registers
- Hardwired R0 register
- FSM-based control unit
- ALU operations: ADD, SUB, AND, OR, NOT, XOR
- ADDI instruction support
- LOAD and STORE instructions
- JMP and JZ control flow instructions
- Memory-mapped GPIO peripheral
- Timer peripheral
- Bus decoder for peripheral selection
- Testbench-based simulation verification

## Architecture

The processor follows a multi-cycle RISC architecture.

Main modules:

- Program Counter
- Instruction Memory
- Instruction Register
- Control Unit
- Register File
- ALU
- Data Memory
- GPIO Peripheral
- Timer Peripheral
- Bus Decoder

## Instruction Format

```text
[15:12] opcode
[11:9]  rd
[8:6]   rs1
[5:3]   rs2
[2:0]   immediate / unused
