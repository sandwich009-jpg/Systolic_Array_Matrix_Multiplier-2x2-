`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.04.2026 22:45:37
// Design Name: 
// Module Name: input_skew_tb
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


module input_skew_tb;

localparam int DATA_W = 8;
localparam int N = 2;

logic clk, rst, load;
// Fixed: Using packed dimensions [N-1:0]
logic [N-1:0][N-1:0][DATA_W-1:0] a, b;
logic [N-1:0][DATA_W-1:0] a_row;
logic [N-1:0][DATA_W-1:0] b_col;
logic valid_out;

int pass = 0, fail = 0;

input_skew #(.DATA_W(DATA_W), .N(N)) dut (.*);

always #5 clk = ~clk;

task automatic check(input logic [DATA_W-1:0] got, exp, string name);
    if (got !== exp) begin
        $display("FAIL [%s]: got=%0d exp=%0d", name, got, exp);
        fail++;
    end else begin
        pass++;
    end
endtask

initial begin
    clk = 0; rst = 1; load = 0;
    a = '0; b = '0;

    // Use standard packed array indexing
    // A = [[1,2],[3,4]] -> a[0][0]=1, a[0][1]=2...
    a[0][0] = 8'd1; a[0][1] = 8'd2;
    a[1][0] = 8'd3; a[1][1] = 8'd4;

    b[0][0] = 8'd5; b[0][1] = 8'd6;
    b[1][0] = 8'd7; b[1][1] = 8'd8;

    repeat(2) @(posedge clk);
    rst <= 0;

    load <= 1; @(posedge clk); 
    load <= 0;

    // Cycle 1: col_cnt=0
    @(posedge clk);
    #1; // Allow NBA to settle
    check(a_row[0], 1, "a00");
    check(b_col[0], 5, "b00");

    // Cycle 2: col_cnt=1
    @(posedge clk);
    #1;
    check(a_row[0], 2, "a01");
    check(a_row[1], 3, "a10");
    check(b_col[0], 7, "b10");
    check(b_col[1], 6, "b01");

    // Cycle 3: col_cnt=2
    @(posedge clk);
    #1;
    check(a_row[1], 4, "a11");
    check(b_col[1], 8, "b11");

    $display("--- FINAL RESULT ---");
    $display("PASS=%0d FAIL=%0d", pass, fail);
    $finish;
end
endmodule
