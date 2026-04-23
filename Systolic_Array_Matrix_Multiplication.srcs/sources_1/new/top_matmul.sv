`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.04.2026 22:40:52
// Design Name: 
// Module Name: top_matmul
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


module top_matmul #(
    parameter int DATA_W = 8,
    parameter int ACCUM_W = 32,
    parameter int N = 2
)(
    input  logic clk,
    input  logic rst,
    input  logic load,
    input  logic [N-1:0][N-1:0][DATA_W-1:0] a,
    input  logic [N-1:0][N-1:0][DATA_W-1:0] b,
    output logic [N-1:0][N-1:0][ACCUM_W-1:0] c,
    output logic done
);

    logic [N-1:0][DATA_W-1:0] a_row;
    logic [N-1:0][DATA_W-1:0] b_col;
    logic skew_valid;
    logic clear_acc_r;
    logic [$clog2(2*N):0] drain_cnt;
    logic skew_prev;

    always_ff @(posedge clk) begin
        if (rst)
            clear_acc_r <= 0;
        else
            clear_acc_r <= load;
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            done      <= 0;
            drain_cnt <= 0;
            skew_prev <= 0;
        end else begin
            skew_prev <= skew_valid;
            
            if (skew_prev && !skew_valid) begin
                drain_cnt <= 1;
            end else if (drain_cnt > 0) begin
                if (drain_cnt == N) begin 
                    done      <= 1;
                    drain_cnt <= 0;
                end else begin
                    drain_cnt <= drain_cnt + 1;
                end
            end else begin
                done <= 0;
            end
        end
    end

    input_skew #(
        .DATA_W(DATA_W),
        .N(N)
    ) u_skew (
        .clk(clk),
        .rst(rst),
        .load(load),
        .a(a),
        .b(b),
        .a_row(a_row),
        .b_col(b_col),
        .valid_out(skew_valid)
    );

    systolic_array_2x2 #(
        .DATA_W(DATA_W),
        .ACCUM_W(ACCUM_W)
    ) u_array (
        .clk(clk),
        .rst(rst),
        .clear_acc(clear_acc_r),
        .en(skew_valid || (drain_cnt > 0)),
        .a_row(a_row),
        .b_col(b_col),
        .c(c)
    );

endmodule

