`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.04.2026 22:40:06
// Design Name: 
// Module Name: systolic_array_2x2
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


module systolic_array_2x2 #(
parameter int DATA_W  = 8,
parameter int ACCUM_W = 32
)(
input  logic clk,
input  logic rst,
input  logic clear_acc,
input  logic en,
input  logic [DATA_W-1:0] a_row [2],
input  logic [DATA_W-1:0] b_col [2],
output logic [ACCUM_W-1:0] c [2][2]
);


logic [DATA_W-1:0] a_wire [2][2];
logic [DATA_W-1:0] b_wire [2][2];

mac_pe #(.DATA_W(DATA_W), .ACCUM_W(ACCUM_W)) pe00 (
    .*,
    .a_in  (a_row[0]),
    .b_in  (b_col[0]),
    .a_out (a_wire[0][1]),
    .b_out (b_wire[1][0]),
    .acc   (c[0][0])
);

mac_pe #(.DATA_W(DATA_W), .ACCUM_W(ACCUM_W)) pe01 (
    .*,
    .a_in  (a_wire[0][1]),
    .b_in  (b_col[1]),
    .a_out (),
    .b_out (b_wire[1][1]),
    .acc   (c[0][1])
);

mac_pe #(.DATA_W(DATA_W), .ACCUM_W(ACCUM_W)) pe10 (
    .*,
    .a_in  (a_row[1]),
    .b_in  (b_wire[1][0]),
    .a_out (a_wire[1][1]),
    .b_out (),
    .acc   (c[1][0])
);

mac_pe #(.DATA_W(DATA_W), .ACCUM_W(ACCUM_W)) pe11 (
    .*,
    .a_in  (a_wire[1][1]),
    .b_in  (b_wire[1][1]),
    .a_out (),
    .b_out (),
    .acc   (c[1][1])
);


endmodule

