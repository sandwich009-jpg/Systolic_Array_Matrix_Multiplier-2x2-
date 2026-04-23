`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.04.2026 22:37:18
// Design Name: 
// Module Name: input_skew
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


module input_skew #(
    parameter int DATA_W = 8,
    parameter int N = 2
)(
    input  logic clk,
    input  logic rst,
    input  logic load,
    input  logic [N-1:0][N-1:0][DATA_W-1:0] a,
    input  logic [N-1:0][N-1:0][DATA_W-1:0] b,
    output logic [N-1:0][DATA_W-1:0] a_row,
    output logic [N-1:0][DATA_W-1:0] b_col,
    output logic valid_out
);

    logic [$clog2(2*N):0] col_cnt;
    logic running;

    always_ff @(posedge clk) begin
        if (rst) begin
            col_cnt   <= 0;
            running   <= 0;
            valid_out <= 0;
            a_row     <= '0;
            b_col     <= '0;
        end else begin
            if (load) begin
                col_cnt   <= 0;
                running   <= 1;
                valid_out <= 1;
            end

            if (running) begin
                a_row[0] <= (col_cnt < N) ? a[0][col_cnt] : '0;
                a_row[1] <= (col_cnt >= 1 && col_cnt < N+1) ? a[1][col_cnt-1] : '0;

                b_col[0] <= (col_cnt < N) ? b[col_cnt][0] : '0;
                b_col[1] <= (col_cnt >= 1 && col_cnt < N+1) ? b[col_cnt-1][1] : '0;

                if (col_cnt == (2*N - 2)) begin
                    running   <= 0;
                    valid_out <= 0;
                end else begin
                    col_cnt <= col_cnt + 1;
                end
            end
        end
    end
endmodule

