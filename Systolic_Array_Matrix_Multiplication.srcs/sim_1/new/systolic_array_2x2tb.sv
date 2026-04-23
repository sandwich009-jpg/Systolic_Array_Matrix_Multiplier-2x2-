`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.04.2026 22:52:25
// Design Name: 
// Module Name: systolic_array_2x2tb
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


module systolic_array_2x2tb;


localparam int DATA_W = 8;
localparam int ACCUM_W = 32;

logic clk, rst, clear_acc, en;
logic [DATA_W-1:0] a_row [2];
logic [DATA_W-1:0] b_col [2];
logic [ACCUM_W-1:0] c [2][2];

int pass=0, fail=0;

systolic_array_2x2 dut (.*);

always #5 clk = ~clk;

task automatic check(input logic [31:0] got, exp, string name);
    if (got !== exp) begin
        $display("FAIL %s", name);
        fail++;
    end else pass++;
endtask

initial begin
    clk=0; rst=1; en=0; clear_acc=0;
    repeat(2) @(posedge clk);
    rst=0;

    clear_acc=1; @(posedge clk); clear_acc=0;
    en=1;

    // cycle 0
    a_row='{1,0}; b_col='{5,0}; @(posedge clk);
    // cycle 1
    a_row='{2,3}; b_col='{7,6}; @(posedge clk);
    // cycle 2
    a_row='{0,4}; b_col='{0,8}; @(posedge clk);

    en=0;
    repeat(2) @(posedge clk);

    check(c[0][0],19,"c00");
    check(c[0][1],22,"c01");
    check(c[1][0],43,"c10");
    check(c[1][1],50,"c11");

    $display("PASS=%0d FAIL=%0d", pass, fail);
    $finish;
end


endmodule
