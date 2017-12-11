`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/08 16:00:33
// Design Name: 
// Module Name: top
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


module top(
    input clk,
    input rst,
    input ps2_clk,
    input ps2_data,    
    output [3:0] r,
    output [3:0] g,
    output [3:0] b,
    output hs,
    output vs,
    output [7:0] data
    );
    
    wire [9:0] sel;
//    wire [7:0] data;
    display_char M1(.clk(clk), .rst(rst), .r(r), .g(g), .b(b), .hs(hs), .vs(vs), .sel(sel), .data(data));
    keyboard M2(.clk(clk), .rst(rst), .ps2_clk(ps2_clk) ,.ps2_data(ps2_data), .sel(sel), .data(data));
    
endmodule
