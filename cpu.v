`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/10 19:41:41
// Design Name: 
// Module Name: sccpu_dataflow
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


module cpu (clock,resetn,inst,mem,pc,wmem,alu,data,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,out_num,sel_num);
    output [31:0]r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16;
    input [4:0]sel_num;
    output [31:0]out_num;
    input [31:0] inst,mem;
    input clock,resetn;
    output reg [31:0] pc=0;
    output [31:0]alu,data;
    output wmem;
    wire [31:0] p4, bpc,npc,adr,ra,alua,alub,res,alu_mem;
    wire [3:0] aluc;
    wire [4:0] reg_dest,wn;
    wire [1:0] pcsource;
    wire zero,wmem,wreg,regrt,m2reg,shift,aluimm,jal,sext;
    wire [31:0] sa = {27'b0,inst[10:6]};
    wire e = sext & inst[15];
    wire [15:0]imm = {16{e}};
    wire [31:0] offset= {imm[13:0],inst[15:0],2'b00};    
    cpu_control cpu_control (inst[31:26],inst [5:0] ,zero,wmem,wreg,regrt,m2reg,aluc,shift,aluimm,pcsource,jal,sext);    
    wire [31:0]immediate= {imm,inst [15:0] };    
     always @(posedge clock or posedge resetn)
           begin if(resetn==1)
                pc<=0;
           else
               pc=npc; 
           end
    add pc_4 (pc,32'h4,1'b0,p4) ;
    add addr(p4,offset,1'b0,adr);    
    wire [31:0] jpc= {p4[31:28],inst[25:0],2'b00};
    
    mux2 alu_b (data,immediate,aluimm,alub) ;
    mux2 alu_a (ra,sa,shift,alua) ;
    mux2 result (alu,mem,m2reg,alu_mem) ;
    mux2 link (alu_mem,p4,jal,res) ;
    mux2_5 reg_wn (inst[15:11] ,inst [20:16] ,regrt ,reg_dest);
    
    assign wn= reg_dest| {5{jal}}; // jal: r31<- -p4;
    
    mux4 pc_next (p4,adr,ra,jpc,pcsource,npc) ;
    
    regfile regfile (inst[25:21],inst [20: 16],res,wn,wreg,clock,resetn,ra,data,
    r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,out_num,sel_num) ;
    alu alu_out (alua,alub,aluc,alu,zero) ;
endmodule

