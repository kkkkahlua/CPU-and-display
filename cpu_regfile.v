`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/10 16:26:50
// Design Name: 
// Module Name: regfile
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


module regfile(rna,rnb,d,wn,we,clk,clrn,qa,qb,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,out_num,sel_num);
    input [4:0]rna,rnb,wn;
    input [4:0]sel_num;
    input [31:0]d;
    input we,clk,clrn;
    output[31:0]qa,qb;
    output [31:0]out_num; 
    reg [31:0]register[1:31]; 
    assign out_num=register[sel_num];//31x32-bit regs
    output [31:0]r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16;
    assign r1=register[1];
    assign r2=register[2];
    assign r3=register[3];
    assign r4=register[4];
    assign r5=register[5];
    assign r6=register[6];
    assign r7=register[7];
    assign r8=register[8];
    assign r9=register[9];
    assign r10=register[10];
    assign r11=register[11];
    assign r12=register[12];
    assign r13=register[13];
    assign r14=register[14];
    assign r15=register[15];
    assign r16=register[16];      
          
    //2 read ports
    assign qa=(rna==0)?0:register[rna];
    assign qb=(rnb==0)?0:register[rnb];
    integer i;
    //1 write port
    always @(posedge clk or posedge clrn)
        if(clrn==1)begin           
            for(i=1;i<32;i=i+1)
                register[i]<=0;
       
        end else if((wn!=0)&&we)
            register[wn]<=d;
endmodule
