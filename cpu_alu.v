`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/10 15:27:47
// Design Name: 
// Module Name: alu
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


module alu(a,b,aluc,r,z);
    input [31:0]a,b;
    input [3:0]aluc;
    output  [31:0]r;
    output  z;
    wire [31:0] d_and = a & b;
    wire [31:0] d_or = a | b;
    wire [31:0] d_xor = a ^ b;
    wire [31:0] d_lui={b[15:0],16'h0};
    wire [31:0] d_and_or=aluc[2]?d_or:d_and;
    wire [31:0] d_xor_lui=aluc[2]?d_lui:d_xor;
    wire [31:0] d_as,s_sh;
    addsub addsub(a,b,aluc[2],d_as);
    shift shift (b,a[4:0],aluc[2],aluc[3],d_sh);
    mux4 mux4 (d_as,d_and_or,d_xor_lui,d_sh,aluc[1:0],r);
    assign z=~|r;
endmodule

module mux4(a0,a1,a2,a3,s,y);
    input [31:0]a0,a1,a2,a3;
    input [1:0]s;
    output [31:0]y;
    function [31:0] select;
    input[31:0]a0,a1,a2,a3;
    input[1:0]s;
    case(s)
        0:select=a0;
        1:select=a1;
        2:select=a2;
        3:select=a3;
    endcase
    endfunction
    assign y = select(a0,a1,a2,a3,s);
endmodule
       
module addsub(a,b,sub,s);
    input [31:0] a,b;
    input sub;
    output [31:0]s;
    add add(a,b^{32{sub}},sub,s);
endmodule

module shift(d,sa,right,arith,sh);
    input[31:0]d;
    input[4:0]sa;
    input right,arith;
    output [31:0]sh;
    reg [31:0]sh;
    always @(*)
        begin if(!right)begin
            sh=d<<sa;
        end else if(!arith)begin
            sh=d>>sa;
        end else begin
            sh=$signed(d)>>>sa;
        end end
endmodule

module mux2 (a0,a1,s,y);
    input [31:0]a0,a1;
    input s;
    output [31:0]y;
    assign y=s?a1:a0;
endmodule

module mux2_5 (a0,a1,s,y);
    input [4:0]a0,a1;
    input s;
    output [4:0]y;
    assign y=s?a1:a0;
endmodule

module add(a, b, ci, s);
	input [31:0] a, b;
	input ci;
	output [31:0] s;
	assign s=a+b+ci;
endmodule
  