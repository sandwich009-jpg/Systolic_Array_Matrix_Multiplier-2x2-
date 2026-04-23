`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.04.2026 22:42:50
// Design Name: 
// Module Name: mac_pe_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mac_pe_tb;

localparam int DATA_W  = 8;
localparam int ACCUM_W = 32;
localparam int CLK_PERIOD = 10;

logic clk, rst, clear_acc, en;
logic [DATA_W-1:0] a_in, b_in;
logic [DATA_W-1:0] a_out, b_out;
logic [ACCUM_W-1:0] acc;

int pass = 0, fail = 0;

mac_pe #(.DATA_W(DATA_W), .ACCUM_W(ACCUM_W)) dut (.*);

always #(CLK_PERIOD/2) clk = ~clk;

task automatic check(input logic [ACCUM_W-1:0] exp, string name);
    #1; 
    if (acc !== exp) begin
        $display("FAIL [%s]: got=%0d exp=%0d", name, acc, exp);
        fail++;
    end else begin
        $display("PASS [%s]: %0d", name, acc);
        pass++;
    end
endtask

initial begin
    clk = 0; rst = 1; clear_acc = 0; en = 0;
    a_in = 0; b_in = 0;

    repeat(2) @(posedge clk);
    rst <= 0;

    @(posedge clk); 
    check(0, "reset");

    en <= 1; a_in <= 3; b_in <= 4;
    @(posedge clk); 
    check(12, "3x4");

    a_in <= 5; b_in <= 6;
    @(posedge clk); 
    check(42, "accumulate");

    en <= 0;
    @(posedge clk); 
    check(42, "hold");

    clear_acc <= 1; en <= 1;
    @(posedge clk); 
    check(0, "clear");
    clear_acc <= 0;

    a_in <= 7; b_in <= 8;
    @(posedge clk); 
    check(56, "post_clear");

    $display("--- FINAL RESULT ---");
    $display("PASS=%0d FAIL=%0d", pass, fail);
    $finish;
end
endmodule

