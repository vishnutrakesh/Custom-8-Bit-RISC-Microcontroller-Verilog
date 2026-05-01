`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:59:02 04/29/2026
// Design Name:   cpu
// Module Name:   C:/Users/Vishnu/Documents/RISC8Bit/RISC_8Bit/soc_tb.v
// Project Name:  RISC_8Bit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cpu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module soc_tb;

    reg clk, reset;
    reg  [7:0] switches;
    wire [7:0] led;
    wire timer_flag;

    cpu uut(
        .clk(clk),
        .reset(reset),
        .switches(switches),
        .led(led),
        .timer_flag(timer_flag)
    );

    wire [2:0]cu_state=uut.cu_state;
    wire [7:0]pc_out=uut.PC.pc_out;
    wire [15:0]ir_out=uut.ir_out;
    wire [7:0]alu_res=uut.alu_result;
    wire [7:0]mem_addr=uut.mem_addr;
    wire mem_write=uut.mem_write;
    wire mem_read=uut.mem_read;
    wire gpio_cs=uut.gpio_cs;
    wire timer_cs=uut.timer_cs;

    wire [7:0]r0=uut.RF.registers[0];
    wire [7:0]r1=uut.RF.registers[1];
    wire [7:0]r2=uut.RF.registers[2];
    wire [7:0]r3=uut.RF.registers[3];
    wire [7:0]r4=uut.RF.registers[4];
    wire [7:0]r5=uut.RF.registers[5];
    wire [7:0]r6=uut.RF.registers[6];
    wire [7:0]r7=uut.RF.registers[7];

    wire [7:0]gpio_led=uut.GPIO.led;
    wire [7:0]timer_cmp=uut.TIMER.compare;
    wire [7:0]timer_cnt=uut.TIMER.counter;

    always #5 clk = ~clk;

    integer pass, fail;

    task check;
        input [63:0]got;
        input [63:0]expected;
        input [127:0]name;
        begin
            if (got===expected) begin
                $display("  PASS | %s = %0d (0x%02X)", name, got, got);
                pass=pass+1;
            end else begin
                $display("  FAIL | %s = %0d (0x%02X), expected %0d (0x%02X)",
                    name, got, got, expected, expected);
                fail=fail+1;
            end
        end
    endtask

    localparam CYCLES_SETUP=90;
    localparam CYCLES_LOOP=50;

    initial begin
        $dumpfile("soc_test.vcd");
        $dumpvars(0, soc_tb);

        clk=0;
        reset=1;
        switches=8'b00000000;
        pass=0;
        fail=0;

        #15 reset=0;

        #(CYCLES_SETUP*10);

        $display("");
        $display("======== PART 1: ALU CHECK ========");
        check(r4, 8'd5, "R4 final value before loop");

        $display("");
        $display("======== PART 2: ADDRESS LOAD CHECK ========");
        check(r1, 8'd7, "R1 GPIO_OUT addr");
        check(r2, 8'd6, "R2 GPIO_IN addr");
        check(r3, 8'd5, "R3 TIMER addr");

        $display("");
        $display("======== PART 3: GPIO OUTPUT CHECK ========");
        check(gpio_led, 8'd5, "LED initial pattern");

        $display("");
        $display("======== PART 4: TIMER CHECK ========");
        check(timer_cmp, 8'd3, "TIMER compare");

        $display("");
        $display("======== PART 5: SWITCH MIRROR CHECK ========");
        switches = 8'b10110011;
        #(CYCLES_LOOP * 10);
        check(led, 8'b10110011, "LED mirrors switches");

        switches = 8'b01010101;
        #(CYCLES_LOOP * 10);
        check(led, 8'b01010101, "LED mirrors switches");

        $display("");
        $display("======== PART 6: TIMER FLAG CHECK ========");
        if (timer_flag===1'bx)
            $display("  WARN | timer_flag is X");
        else
            $display("  INFO | timer_flag = %b, timer compare = %0d", timer_flag, timer_cmp);

        $display("");
        $display("==================================");
        $display("  PASSED: %0d", pass);
        $display("  FAILED: %0d", fail);
        $display("==================================");
        $display("");

        $finish;
    end

    always @(posedge clk) begin
        if (mem_write) begin
            $display("WRITE t=%0t | PC=%0d | IR=%b | addr=%0d | gpio_cs=%b | timer_cs=%b | R2(data path)=%0d | LED=%b",
                $time, pc_out, ir_out, mem_addr, gpio_cs, timer_cs, uut.reg_data2, led);
        end

        if (cu_state==3'b100) begin
            $display("WB t=%0t | PC=%0d | IR=%b | LED=%b | SW=%b | TMR_CNT=%0d | R1=%0d R2=%0d R3=%0d R4=%0d R5=%0d",
                $time, pc_out, ir_out, led, switches, timer_cnt, r1, r2, r3, r4, r5);
        end
    end

endmodule
