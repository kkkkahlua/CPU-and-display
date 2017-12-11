// vga_char_display.v  
`timescale 1ns / 1ps  
  
module display_char (  
    input clk,  
    input rst,  
    output reg [3:0] r,  
    output reg [3:0] g,  
    output reg [3:0] b,  
    output hs,  
    output vs,
    output reg [9:0] sel,
    input [7:0] data,
    input [31:0] pc,
    input [31:0] inst,
    input [31:0] r1,
    input [31:0] r2,
    input [31:0] r3,
    input [31:0] r4,
    input [31:0] r5, 
    input [31:0] r6,
    input [31:0] r7,
    input [31:0] r8,
    input [31:0] r9, 
    input [31:0] r10,
    input [31:0] r11,
    input [31:0] r12,
    input [31:0] r13,
    input [31:0] r14,
    input [31:0] r15,
    input [31:0] r16
    );  
    
    // 显示器可显示区域  
    parameter UP_BOUND = 31;  
    parameter DOWN_BOUND = 510;  
    parameter LEFT_BOUND = 144;  
    parameter RIGHT_BOUND = 783;  
  
    parameter up_pos1 = 64;  
    parameter down_pos1 = 320;  
    parameter left_pos = 160;  
    parameter right_pos = 672;  
    parameter dash = 360;
    parameter up_pos2 = 384;
    parameter down_pos2 = 464;
    
    wire pclk;  
    reg [1:0] count=0;  
    reg [9:0] hcount=0, vcount=0;  
      
    // 获得像素时钟25MHz  
    assign pclk = count[0]==0&&count[1]==0;  
    always @ (posedge clk or posedge rst)  
    begin  
        if (rst)  
            count <= 0;  
        else  
            count <= count+1;  
    end  
      
    // 列计数与行同步  
    assign hs = (hcount < 96) ? 0 : 1;  
    always @ (posedge pclk or posedge rst)  
    begin  
        if (rst)  
            hcount <= 0;  
        else if (hcount == 799)  
            hcount <= 0;  
        else  
            hcount <= hcount+1;  
    end  
      
    // 行计数与场同步  
    assign vs = (vcount < 2) ? 0 : 1;  
    always @ (posedge pclk or posedge rst)  
    begin  
        if (rst)  
            vcount <= 0;  
        else if (hcount == 799) begin  
            if (vcount == 520)  
                vcount <= 0;  
            else  
                vcount <= vcount+1;  
        end  
        else  
            vcount <= vcount;  
    end  

    reg [127:0] ram [44:0];
  
    initial begin
        $readmemh("F:/digital/system/system.srcs/mem.txt", ram, 0, 44);
    end
    
   reg [7:0] reginfo [319:0];  
     initial begin
         $readmemh("F:/digital/system/system.srcs/reginfo2.txt", reginfo, 0, 319);
     end    
     
     always @ (pc,inst,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16) begin
         reginfo[3] = pc[31:28]; reginfo[4] = pc[27:24]; reginfo[5] = pc[23:20]; reginfo[6] = pc[19:16]; reginfo[7] = pc[15:12]; reginfo[8] = pc[11:8]; reginfo[9] = pc[7:4]; reginfo[10] = pc[3:0]; 
         reginfo[8'h15] = inst[31:28]; reginfo[8'h16] = inst[27:24]; reginfo[8'h17] = inst[23:20]; reginfo[8'h18] = inst[19:16]; reginfo[8'h19] = inst[15:12]; reginfo[8'h1a] = inst[11:8]; reginfo[8'h1b] = inst[7:4]; reginfo[8'h1c] = inst[3:0]; 
         reginfo[8'h43] = r1[31:28]; reginfo[8'h44] = r1[27:24]; reginfo[8'h45] = r1[23:20]; reginfo[8'h46] = r1[19:16]; reginfo[8'h47] = r1[15:12]; reginfo[8'h48] = r1[11:8]; reginfo[8'h49] = r1[7:4]; reginfo[8'h4a] = r1[3:0];
         reginfo[8'h53] = r2[31:28]; reginfo[8'h54] = r2[27:24]; reginfo[8'h55] = r2[23:20]; reginfo[8'h56] = r2[19:16]; reginfo[8'h57] = r2[15:12]; reginfo[8'h58] = r2[11:8]; reginfo[8'h59] = r2[7:4]; reginfo[8'h5a] = r2[3:0];
         reginfo[8'h63] = r3[31:28]; reginfo[8'h64] = r3[27:24]; reginfo[8'h65] = r3[23:20]; reginfo[8'h66] = r3[19:16]; reginfo[8'h67] = r3[15:12]; reginfo[8'h68] = r3[11:8]; reginfo[8'h69] = r3[7:4]; reginfo[8'h6a] = r3[3:0];
         reginfo[8'h73] = r4[31:28]; reginfo[8'h74] = r4[27:24]; reginfo[8'h75] = r4[23:20]; reginfo[8'h76] = r4[19:16]; reginfo[8'h77] = r4[15:12]; reginfo[8'h78] = r4[11:8]; reginfo[8'h79] = r4[7:4]; reginfo[8'h7a] = r4[3:0];
         reginfo[8'h83] = r5[31:28]; reginfo[8'h84] = r5[27:24]; reginfo[8'h85] = r5[23:20]; reginfo[8'h86] = r5[19:16]; reginfo[8'h87] = r5[15:12]; reginfo[8'h88] = r5[11:8]; reginfo[8'h89] = r5[7:4]; reginfo[8'h8a] = r5[3:0];
         reginfo[8'h93] = r6[31:28]; reginfo[8'h94] = r6[27:24]; reginfo[8'h95] = r6[23:20]; reginfo[8'h96] = r6[19:16]; reginfo[8'h97] = r6[15:12]; reginfo[8'h98] = r6[11:8]; reginfo[8'h99] = r6[7:4]; reginfo[8'h9a] = r6[3:0];
         reginfo[8'ha3] = r7[31:28]; reginfo[8'ha4] = r7[27:24]; reginfo[8'ha5] = r7[23:20]; reginfo[8'ha6] = r7[19:16]; reginfo[8'ha7] = r7[15:12]; reginfo[8'ha8] = r7[11:8]; reginfo[8'ha9] = r7[7:4]; reginfo[8'haa] = r7[3:0];
         reginfo[8'hb3] = r8[31:28]; reginfo[8'hb4] = r8[27:24]; reginfo[8'hb5] = r8[23:20]; reginfo[8'hb6] = r8[19:16]; reginfo[8'hb7] = r8[15:12]; reginfo[8'hb8] = r8[11:8]; reginfo[8'hb9] = r8[7:4]; reginfo[8'hba] = r8[3:0];
         reginfo[8'hc3] = r9[31:28]; reginfo[8'hc4] = r9[27:24]; reginfo[8'hc5] = r9[23:20]; reginfo[8'hc6] = r9[19:16]; reginfo[8'hc7] = r9[15:12]; reginfo[8'hc8] = r9[11:8]; reginfo[8'hc9] = r9[7:4]; reginfo[8'hca] = r9[3:0];
         reginfo[8'hd3] = r10[31:28]; reginfo[8'hd4] = r10[27:24]; reginfo[8'hd5] = r10[23:20]; reginfo[8'hd6] = r10[19:16]; reginfo[8'hd7] = r10[15:12]; reginfo[8'hd8] = r10[11:8]; reginfo[8'hd9] = r10[7:4]; reginfo[8'hda] = r10[3:0];
         reginfo[8'he3] = r11[31:28]; reginfo[8'he4] = r11[27:24]; reginfo[8'he5] = r11[23:20]; reginfo[8'he6] = r11[19:16]; reginfo[8'he7] = r11[15:12]; reginfo[8'he8] = r11[11:8]; reginfo[8'he9] = r11[7:4]; reginfo[8'hea] = r11[3:0];
         reginfo[8'hf3] = r12[31:28]; reginfo[8'hf4] = r12[27:24]; reginfo[8'hf5] = r12[23:20]; reginfo[8'hf6] = r12[19:16]; reginfo[8'hf7] = r12[15:12]; reginfo[8'hf8] = r12[11:8]; reginfo[8'hf9] = r12[7:4]; reginfo[8'hfa] = r12[3:0];
         reginfo[12'h103] = r13[31:28]; reginfo[12'h104] = r13[27:24]; reginfo[12'h105] = r13[23:20]; reginfo[12'h106] = r13[19:16]; reginfo[12'h107] = r13[15:12]; reginfo[12'h108] = r13[11:8]; reginfo[12'h109] = r13[7:4]; reginfo[12'h10a] = r13[3:0];
         reginfo[12'h113] = r14[31:28]; reginfo[12'h114] = r14[27:24]; reginfo[12'h115] = r14[23:20]; reginfo[12'h116] = r14[19:16]; reginfo[12'h117] = r14[15:12]; reginfo[12'h118] = r14[11:8]; reginfo[12'h119] = r14[7:4]; reginfo[12'h11a] = r14[3:0];
         reginfo[12'h123] = r15[31:28]; reginfo[12'h124] = r15[27:24]; reginfo[12'h125] = r15[23:20]; reginfo[12'h126] = r15[19:16]; reginfo[12'h127] = r15[15:12]; reginfo[12'h128] = r15[11:8]; reginfo[12'h129] = r15[7:4]; reginfo[12'h12a] = r15[3:0];
         reginfo[12'h133] = r16[31:28]; reginfo[12'h134] = r16[27:24]; reginfo[12'h135] = r16[23:20]; reginfo[12'h136] = r16[19:16]; reginfo[12'h137] = r16[15:12]; reginfo[12'h138] = r16[11:8]; reginfo[12'h139] = r16[7:4]; reginfo[12'h13a] = r16[3:0];        
     end    
    
//    reg [7:0] data [1023:0];
//    initial begin
//        $readmemh("F:/digital/system/system.srcs/data.txt", data, 0, 1023);
//    end        
     
  
    reg [7:0] p_data;
    
    integer dh, dv, nh, nv, ph, pv, num, s, t, pos, i;
    // 设置显示信号值  
    always @ (posedge pclk or posedge rst)  
    begin  
        if (rst) begin  r = 0; g = 0; b = 0;  end  
        else if (vcount>=UP_BOUND && vcount<=DOWN_BOUND  
                && hcount>=LEFT_BOUND && hcount<=RIGHT_BOUND
                && hcount >= left_pos && hcount < right_pos) begin
                if (vcount>=up_pos1 && vcount < down_pos1) begin
                    dh = hcount - left_pos; nh = dh / 8; ph = dh % 8;
                    dv = vcount - up_pos1; nv = dv / 16; pv = dv % 16;
                    sel = nv * 64 + nh;
                    p_data = data;
                    
                    if (p_data == 8'h59) p_data = 0;
                    pos = pv * 8 + ph;
                    if (ram[p_data][pos]) begin r = 4'b1111; g = 4'b1111; b = 4'b1111; end
                    else begin r = 4'b0000; g = 4'b0000; b = 4'b0000; end
                end
                else if (vcount == dash) begin r = 4'b1111; g = 4'b1111; b = 4'b1111; end
                else begin
                    r = 4'b0000; g = 4'b0000; b = 4'b0000;
                end
        end  
        else begin  
            r <= 4'b0000;  
            g <= 4'b0000;  
            b <= 4'b0000;  
        end  
    end  
  
endmodule  