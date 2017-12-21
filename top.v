`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/10 20:10:09
// Design Name: 
// Module Name: sccomp_dataflow
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



module top(clk,clock,resetn,sel_seg,seg7,temp,txd,ps2_clk,ps2_data,r,g,b,hs,vs,rst,sel_num);
    input txd;
    input rst;
    input [4:0]sel_num;
    wire [31:0]r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16;
    input clock,resetn;
    output  [15:0]temp;
    wire [31:0] pc;
    wire [31:0] inst;
    input clk;
    wire [31:0] dout;
    output  [7:0] sel_seg;
    output  [6:0] seg7;
    wire [31:0]aluout,memout;
    wire [31:0]data;
    wire wmem;
    wire [31:0]fib;
    wire flag;
    wire [31:0]out_num;
    input ps2_clk;
    input ps2_data;    
    output [3:0] r;
    output [3:0] g;
    output [3:0] b;
    output hs;
    output vs;
    wire btn;
    IO IO(
    .clk(clk), 
    .rst(rst), 
    .ps2_clk(ps2_clk), 
    .ps2_data(ps2_data), 
    .r(r), 
    .g(g), 
    .b(b), 
    .hs(hs), 
    .vs(vs),
    .pc(pc),
    .inst(inst),
    .r1(r1),
    .r2(r2),
    .r3(r3),
    .r4(r4),
    .r5(r5),
    .r6(r6),
    .r7(r7),
    .r8(r8),
    .r9(r9),
    .r10(r10),
    .r11(r11),
    .r12(r12),
    .r13(r13),
    .r14(r14),
    .r15(r15),
    .r16(r16),
    .led(temp),
    .fib(fib),
    .flag(flag)
    );

aux_btn_clk aux_btn_clk(
    .clk(clk),
    .key(clock),
    .ctrl(btn)
    );

cpu cpu(
    .clock(btn),
    .resetn(resetn),
    .inst(inst),
    .mem(memout),
    .pc(pc),
    .wmem(wmem),
    .alu(aluout),
    .data(data),
    .r1(r1),
    .r2(r2),
    .r3(r3),
    .r4(r4),
    .r5(r5),
    .r6(r6),
    .r7(r7),
    .r8(r8),
    .r9(r9),
    .r10(r10),
    .r11(r11),
    .r12(r12),
    .r13(r13),
    .r14(r14),
    .r15(r15),
    .r16(r16),
    .out_num(out_num),
    .sel_num(sel_num)    
   );
  

inst_rom inst_rom(
    .pc(pc),
    .inst(inst),
     .txd(txd),
     .clk(clk),
     .resetn(resetn)
    );
    

data_ram data_ram(
    .clk(clock),
    .dataout(memout),
    .datain(data),
    .addr(aluout),
    .we(wmem),
    .fib(fib),
    .flag(flag)
    );
    
aux_seg_display aux_seg_display(
    .clk(clk),
    .dout(out_num),
    .sel_seg(sel_seg),
    .seg7(seg7)
    );
endmodule


