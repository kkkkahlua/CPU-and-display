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
//    input [31:0] pc,
//    input [31:0] inst,
//    input [31:0] r1,
//    input [31:0] r2,
//    input [31:0] r3,
//    input [31:0] r4,
//    input [31:0] r5, 
//    input [31:0] r6,
//    input [31:0] r7,
//    input [31:0] r8,
//    input [31:0] r9, 
//    input [31:0] r10,
//    input [31:0] r11,
//    input [31:0] r12,
//    input [31:0] r13,
//    input [31:0] r14,
//    input [31:0] r15,
//    input [31:0] r16
    );
    
    wire [9:0] sel;
//    wire [7:0] data;
    wire [31:0] pc, inst, r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16;
    assign pc = 32'h3c011001, inst = 32'hff83ed2c,
        r1 = 32'h03492fec, r2 = 32'h8110dabc,
        r3 = 32'h03492fec, r4 = 32'h8110dabc,
        r5 = 32'h03492fec, r6 = 32'h8110dabc,
        r7 = 32'h03492fec, r8 = 32'h8110dabc,
        r9 = 32'h03492fec, r10 = 32'h8110dabc,
        r11 = 32'h03492fec, r12 = 32'h8110dabc,
        r13 = 32'h03492fec, r14 = 32'h8110dabc,
        r15 = 32'h03492fec, r16 = 32'h8110dabc;
    
    display_char M1(.clk(clk), .rst(rst), .r(r), .g(g), .b(b), .hs(hs), .vs(vs), .sel(sel), .data(data),
        .pc(pc),.inst(inst),.r1(r1),.r2(r2),.r3(r3),.r4(r4),.r5(r5),.r6(r6),.r7(r7),.r8(r8),.r9(r9),.r10(r10),.r11(r11),.r12(r12),.r13(r13),.r14(r14),.r15(r15),.r16(r16));
    keyboard M2(.clk(clk), .rst(rst), .ps2_clk(ps2_clk) ,.ps2_data(ps2_data), .sel(sel), .data(data));
    
endmodule
