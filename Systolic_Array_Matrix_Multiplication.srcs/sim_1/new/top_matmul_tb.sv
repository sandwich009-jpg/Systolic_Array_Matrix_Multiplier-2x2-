`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.04.2026 22:54:57
// Design Name: 
// Module Name: top_matmul_tb
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


module top_matmul_tb;

    localparam int DATA_W = 8;
    localparam int ACCUM_W = 32;
    localparam int N = 2;

    logic clk, rst, load;
    // Standardizing to packed dimensions for ports
    logic [N-1:0][N-1:0][DATA_W-1:0] a, b;
    logic [N-1:0][N-1:0][ACCUM_W-1:0] c;
    logic done;

    int pass=0, fail=0;

    top_matmul #(
        .DATA_W(DATA_W),
        .ACCUM_W(ACCUM_W),
        .N(N)
    ) dut (.*);

    always #5 clk = ~clk;

    // Task arguments must match the logic types exactly
    task automatic run_test(
        input logic [N-1:0][N-1:0][DATA_W-1:0] A,
        input logic [N-1:0][N-1:0][DATA_W-1:0] B,
        input logic [N-1:0][N-1:0][ACCUM_W-1:0] exp,
        string name
    );
        a <= A; 
        b <= B;
        load <= 1; 
        @(posedge clk); 
        load <= 0;

        // Wait for the hardware 'done' signal
        wait(done);
        @(posedge clk); // Small buffer to ensure outputs are stable
        #1;

        for (int i=0; i<N; i++) begin
            for (int j=0; j<N; j++) begin
                if (c[i][j] !== exp[i][j]) begin
                    $display("FAIL [%s] @ c[%0d][%0d]: got=%0d exp=%0d", name, i, j, c[i][j], exp[i][j]);
                    fail++;
                end else begin
                    pass++;
                end
            end
        end
    endtask

    initial begin
        clk = 0; rst = 1; load = 0;
        a = '0; b = '0;
        
        repeat(3) @(posedge clk);
        rst <= 0;

        run_test(
            '{ '{8'd1, 8'd0}, '{8'd0, 8'd1} }, // Identity A
            '{ '{8'd1, 8'd0}, '{8'd0, 8'd1} }, // Identity B
            '{ '{32'd1, 32'd0}, '{32'd0, 32'd1} }, // Expected
            "identity"
        );

        run_test(
            '{ '{8'd1, 8'd2}, '{8'd3, 8'd4} }, // Standard A
            '{ '{8'd5, 8'd6}, '{8'd7, 8'd8} }, // Standard B
            '{ '{32'd19, 32'd22}, '{32'd43, 32'd50} }, // Expected
            "standard"
        );

        $display("--------------------------");
        $display("FINAL RESULT: PASS=%0d FAIL=%0d", pass, fail);
        $display("--------------------------");
        $finish;
    end

endmodule
