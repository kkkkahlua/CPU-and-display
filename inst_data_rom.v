`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/10 20:54:32
// Design Name: 
// Module Name: scinstmem
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

module inst_rom(pc, inst,txd,clk,resetn);
	input clk;
	input [31:0] pc;
	output [31:0] inst;
	input resetn;
    input txd;
	reg [31:0] instram [31:0];
	reg [50:0]write;
    integer i;           
    reg clk_2;
    reg[30:0] count;
    reg [3:0]num;     
    reg [12:0]counter_2=2604;                     
    always@(posedge clk)
        if(counter_2==5208)
        begin counter_2<=0;
             clk_2=~clk_2;end
        else
             counter_2=counter_2+1;                                   
    always @(negedge txd or posedge resetn )
        if(resetn)
            count=0;
        else if(num==0)
            count=count+1;  
               
      reg [7:0] fifo [7:0];
      reg [10:0]buffer;
      reg [10:0]cinnum=0;
      reg [3:0]temp[7:0];
    always @ ( posedge resetn or posedge clk_2) 
    if(resetn)
    begin write=0;num=0;cinnum=0;end            
    else if(write!=count)//一位数字3
         begin buffer[num]=txd;
               num=num+1;
              if(num==11)             
              begin fifo[write-cinnum*8]=buffer[8:1];
               num<=0;write=write+1;end
                    if(write==(8+cinnum*8))//1-8
                begin
                    for(i=0;i<=7;i=i+1)
                    case(fifo[i])//i0-7 8个数字
                    8'h30: temp[i]=4'b0000;
                    8'h31: temp[i]=4'b0001;
                    8'h32: temp[i]=4'b0010;
                    8'h33: temp[i]=4'b0011;
                    8'h34: temp[i]=4'b0100;
                    8'h35: temp[i]=4'b0101;
                    8'h36: temp[i]=4'b0110;
                    8'h37: temp[i]=4'b0111;
                    8'h38: temp[i]=4'b1000;
                    8'h39: temp[i]=4'b1001;
                    8'h61: temp[i]=4'b1010;
                    8'h62: temp[i]=4'b1011;
                    8'h63: temp[i]=4'b1100;
                    8'h64: temp[i]=4'b1101;
                    8'h65: temp[i]=4'b1110;
                    8'h66: temp[i]=4'b1111;
                    endcase 
                        instram[cinnum][31:28]=temp[0];
                        instram[cinnum][27:24]=temp[1];
                        instram[cinnum][23:20]=temp[2];
                        instram[cinnum][19:16]=temp[3];
                        instram[cinnum][15:12]=temp[4];
                        instram[cinnum][11:8]=temp[5];
                        instram[cinnum][7:4]=temp[6];
                        instram[cinnum][3:0]=temp[7];
                        cinnum=cinnum+1;                    
                     end   
                  end		
   	assign inst = instram[pc/4];
endmodule

module data_ram(clk, dataout, datain, addr, we,flag,fib); 
    input flag;
    input [31:0]fib;
    input [31:0]addr;
    input we;
	input clk;
	output  [31:0] dataout;
	input [31:0] datain;
	reg [31:0] dataram[1023:0];
	initial begin
	dataram[8'h30]=32'hc;
	dataram[8'h4c]=32'h6;
	dataram[8'h50]=32'h1;
	dataram[8'h54]=32'h2;
	dataram[8'h58]=32'h3;
	dataram[8'h5c]=32'h4;
	dataram[8'h60]=32'h5;
	end 
	always @ (negedge clk or posedge flag) begin
	    if(flag)begin	      
	      dataram[8'h30]=fib; end	   
		else if (we) dataram[addr] = datain;		
	end
		assign dataout = dataram[addr];  
endmodule

