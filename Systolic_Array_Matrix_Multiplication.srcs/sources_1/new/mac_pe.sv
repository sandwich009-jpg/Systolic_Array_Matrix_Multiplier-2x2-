`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.04.2026 22:19:48
// Design Name: 
// Module Name: mac_pe
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


module mac_pe #(
parameter int DATA_W  = 8,
parameter int ACCUM_W = 32
)(
input  logic clk,
input  logic rst,
input  logic clear_acc,
input  logic en,
input  logic [DATA_W-1:0] a_in,
input  logic [DATA_W-1:0] b_in,
output logic [DATA_W-1:0] a_out,
output logic [DATA_W-1:0] b_out,
output logic [ACCUM_W-1:0] acc
);


always_ff @(posedge clk) begin
    if (rst) begin
        acc   <= '0;
        a_out <= '0;
        b_out <= '0;
    end else begin
        a_out <= a_in;
        b_out <= b_in;

        if (clear_acc)
            acc <= '0;
        else if (en)
            acc <= acc + (a_in * b_in);
    end
end


endmodule

