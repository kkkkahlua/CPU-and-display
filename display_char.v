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
     
     reg [7:0] d2n [15:0];
     initial begin
        $readmemh("F:/digital/system/system.srcs/d2n.txt", d2n, 0, 15);
    end

     always @ (pc,inst,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16) begin
        reginfo[0] = 8'h1a; reginfo[1] = 8'h0d; reginfo[2] = 8'h25;
        reginfo[8'h10] = 8'h13; reginfo[8'h11] = 8'h18; reginfo[8'h12] = 8'h1d; reginfo[8'h13] = 8'h1e; reginfo[8'h14] = 8'h25;
        reginfo[8'h40] = 8'h1c; reginfo[8'h41] = 8'h02; reginfo[8'h42] = 8'h25;
        reginfo[8'h50] = 8'h1c; reginfo[8'h51] = 8'h03; reginfo[8'h52] = 8'h25;
        reginfo[8'h60] = 8'h1c; reginfo[8'h61] = 8'h04; reginfo[8'h62] = 8'h25;
        reginfo[8'h70] = 8'h1c; reginfo[8'h71] = 8'h05; reginfo[8'h72] = 8'h25;
        reginfo[8'h80] = 8'h1c; reginfo[8'h81] = 8'h06; reginfo[8'h82] = 8'h25;
        reginfo[8'h90] = 8'h1c; reginfo[8'h91] = 8'h07; reginfo[8'h92] = 8'h25;
        reginfo[8'ha0] = 8'h1c; reginfo[8'ha1] = 8'h08; reginfo[8'ha2] = 8'h25;
        reginfo[8'hb0] = 8'h1c; reginfo[8'hb1] = 8'h09; reginfo[8'hb2] = 8'h25;
        reginfo[8'hc0] = 8'h1c; reginfo[8'hc1] = 8'h0a; reginfo[8'hc2] = 8'h25;
        reginfo[8'hd0] = 8'h1c; reginfo[8'hd1] = 8'h02; reginfo[8'hd2] = 8'h01; reginfo[8'hd3] = 8'h25;
        reginfo[8'he0] = 8'h1c; reginfo[8'he1] = 8'h02; reginfo[8'he2] = 8'h02; reginfo[8'he3] = 8'h25;
        reginfo[8'hf0] = 8'h1c; reginfo[8'hf1] = 8'h02; reginfo[8'hf2] = 8'h03; reginfo[8'hf3] = 8'h25;
        reginfo[12'h100] = 8'h1c; reginfo[12'h101] = 8'h02; reginfo[12'h102] = 8'h04; reginfo[12'h103] = 8'h25;
        reginfo[12'h110] = 8'h1c; reginfo[12'h111] = 8'h02; reginfo[12'h112] = 8'h05; reginfo[12'h113] = 8'h25;
        reginfo[12'h120] = 8'h1c; reginfo[12'h121] = 8'h02; reginfo[12'h122] = 8'h06; reginfo[12'h123] = 8'h25;
        reginfo[12'h130] = 8'h1c; reginfo[12'h131] = 8'h02; reginfo[12'h132] = 8'h07; reginfo[12'h133] = 8'h25;
        
         reginfo[3] = d2n[pc[31:28]]; reginfo[4] = d2n[pc[27:24]]; reginfo[5] = d2n[pc[23:20]]; reginfo[6] = d2n[pc[19:16]]; reginfo[7] = d2n[pc[15:12]]; reginfo[8] = d2n[pc[11:8]]; reginfo[9] = d2n[pc[7:4]]; reginfo[10] = d2n[pc[3:0]]; 
         reginfo[8'h15] = d2n[inst[31:28]]; reginfo[8'h16] = d2n[inst[27:24]]; reginfo[8'h17] = d2n[inst[23:20]]; reginfo[8'h18] = d2n[inst[19:16]]; reginfo[8'h19] = d2n[inst[15:12]]; reginfo[8'h1a] = d2n[inst[11:8]]; reginfo[8'h1b] = d2n[inst[7:4]]; reginfo[8'h1c] = d2n[inst[3:0]]; 
         reginfo[8'h43] = d2n[r1[31:28]]; reginfo[8'h44] = d2n[r1[27:24]]; reginfo[8'h45] = d2n[r1[23:20]]; reginfo[8'h46] = d2n[r1[19:16]]; reginfo[8'h47] = d2n[r1[15:12]]; reginfo[8'h48] = d2n[r1[11:8]]; reginfo[8'h49] = d2n[r1[7:4]]; reginfo[8'h4a] = d2n[r1[3:0]];
         reginfo[8'h53] = d2n[r2[31:28]]; reginfo[8'h54] = d2n[r2[27:24]]; reginfo[8'h55] = d2n[r2[23:20]]; reginfo[8'h56] = d2n[r2[19:16]]; reginfo[8'h57] = d2n[r2[15:12]]; reginfo[8'h58] = d2n[r2[11:8]]; reginfo[8'h59] = d2n[r2[7:4]]; reginfo[8'h5a] = d2n[r2[3:0]];
         reginfo[8'h63] = d2n[r3[31:28]]; reginfo[8'h64] = d2n[r3[27:24]]; reginfo[8'h65] = d2n[r3[23:20]]; reginfo[8'h66] = d2n[r3[19:16]]; reginfo[8'h67] = d2n[r3[15:12]]; reginfo[8'h68] = d2n[r3[11:8]]; reginfo[8'h69] = d2n[r3[7:4]]; reginfo[8'h6a] = d2n[r3[3:0]];
         reginfo[8'h73] = d2n[r4[31:28]]; reginfo[8'h74] = d2n[r4[27:24]]; reginfo[8'h75] = d2n[r4[23:20]]; reginfo[8'h76] = d2n[r4[19:16]]; reginfo[8'h77] = d2n[r4[15:12]]; reginfo[8'h78] = d2n[r4[11:8]]; reginfo[8'h79] = d2n[r4[7:4]]; reginfo[8'h7a] = d2n[r4[3:0]];
         reginfo[8'h83] = d2n[r5[31:28]]; reginfo[8'h84] = d2n[r5[27:24]]; reginfo[8'h85] = d2n[r5[23:20]]; reginfo[8'h86] = d2n[r5[19:16]]; reginfo[8'h87] = d2n[r5[15:12]]; reginfo[8'h88] = d2n[r5[11:8]]; reginfo[8'h89] = d2n[r5[7:4]]; reginfo[8'h8a] = d2n[r5[3:0]];
         reginfo[8'h93] = d2n[r6[31:28]]; reginfo[8'h94] = d2n[r6[27:24]]; reginfo[8'h95] = d2n[r6[23:20]]; reginfo[8'h96] = d2n[r6[19:16]]; reginfo[8'h97] = d2n[r6[15:12]]; reginfo[8'h98] = d2n[r6[11:8]]; reginfo[8'h99] = d2n[r6[7:4]]; reginfo[8'h9a] = d2n[r6[3:0]];
         reginfo[8'ha3] = d2n[r7[31:28]]; reginfo[8'ha4] = d2n[r7[27:24]]; reginfo[8'ha5] = d2n[r7[23:20]]; reginfo[8'ha6] = d2n[r7[19:16]]; reginfo[8'ha7] = d2n[r7[15:12]]; reginfo[8'ha8] = d2n[r7[11:8]]; reginfo[8'ha9] = d2n[r7[7:4]]; reginfo[8'haa] = d2n[r7[3:0]];
         reginfo[8'hb3] = d2n[r8[31:28]]; reginfo[8'hb4] = d2n[r8[27:24]]; reginfo[8'hb5] = d2n[r8[23:20]]; reginfo[8'hb6] = d2n[r8[19:16]]; reginfo[8'hb7] = d2n[r8[15:12]]; reginfo[8'hb8] = d2n[r8[11:8]]; reginfo[8'hb9] = d2n[r8[7:4]]; reginfo[8'hba] = d2n[r8[3:0]];
         reginfo[8'hc3] = d2n[r9[31:28]]; reginfo[8'hc4] = d2n[r9[27:24]]; reginfo[8'hc5] = d2n[r9[23:20]]; reginfo[8'hc6] = d2n[r9[19:16]]; reginfo[8'hc7] = d2n[r9[15:12]]; reginfo[8'hc8] = d2n[r9[11:8]]; reginfo[8'hc9] = d2n[r9[7:4]]; reginfo[8'hca] = d2n[r9[3:0]];
         reginfo[8'hd4] = d2n[r10[31:28]]; reginfo[8'hd5] = d2n[r10[27:24]]; reginfo[8'hd6] = d2n[r10[23:20]]; reginfo[8'hd7] = d2n[r10[19:16]]; reginfo[8'hd8] = d2n[r10[15:12]]; reginfo[8'hd9] = d2n[r10[11:8]]; reginfo[8'hda] = d2n[r10[7:4]]; reginfo[8'hdb] = d2n[r10[3:0]];
         reginfo[8'he4] = d2n[r11[31:28]]; reginfo[8'he5] = d2n[r11[27:24]]; reginfo[8'he6] = d2n[r11[23:20]]; reginfo[8'he7] = d2n[r11[19:16]]; reginfo[8'he8] = d2n[r11[15:12]]; reginfo[8'he9] = d2n[r11[11:8]]; reginfo[8'hea] = d2n[r11[7:4]]; reginfo[8'heb] = d2n[r11[3:0]];
         reginfo[8'hf4] = d2n[r12[31:28]]; reginfo[8'hf5] = d2n[r12[27:24]]; reginfo[8'hf6] = d2n[r12[23:20]]; reginfo[8'hf7] = d2n[r12[19:16]]; reginfo[8'hf8] = d2n[r12[15:12]]; reginfo[8'hf9] = d2n[r12[11:8]]; reginfo[8'hfa] = d2n[r12[7:4]]; reginfo[8'hfb] = d2n[r12[3:0]];
         reginfo[12'h104] = d2n[r13[31:28]]; reginfo[12'h105] = d2n[r13[27:24]]; reginfo[12'h106] = d2n[r13[23:20]]; reginfo[12'h107] = d2n[r13[19:16]]; reginfo[12'h108] = d2n[r13[15:12]]; reginfo[12'h109] = d2n[r13[11:8]]; reginfo[12'h10a] = d2n[r13[7:4]]; reginfo[12'h10b] = d2n[r13[3:0]];
         reginfo[12'h114] = d2n[r14[31:28]]; reginfo[12'h115] = d2n[r14[27:24]]; reginfo[12'h116] = d2n[r14[23:20]]; reginfo[12'h117] = d2n[r14[19:16]]; reginfo[12'h118] = d2n[r14[15:12]]; reginfo[12'h119] = d2n[r14[11:8]]; reginfo[12'h11a] = d2n[r14[7:4]]; reginfo[12'h11b] = d2n[r14[3:0]];
         reginfo[12'h124] = d2n[r15[31:28]]; reginfo[12'h125] = d2n[r15[27:24]]; reginfo[12'h126] = d2n[r15[23:20]]; reginfo[12'h127] = d2n[r15[19:16]]; reginfo[12'h128] = d2n[r15[15:12]]; reginfo[12'h129] = d2n[r15[11:8]]; reginfo[12'h12a] = d2n[r15[7:4]]; reginfo[12'h12b] = d2n[r15[3:0]];
         reginfo[12'h134] = d2n[r16[31:28]]; reginfo[12'h135] = d2n[r16[27:24]]; reginfo[12'h136] = d2n[r16[23:20]]; reginfo[12'h137] = d2n[r16[19:16]]; reginfo[12'h138] = d2n[r16[15:12]]; reginfo[12'h139] = d2n[r16[11:8]]; reginfo[12'h13a] = d2n[r16[7:4]]; reginfo[12'h13b] = d2n[r16[3:0]];        
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
                else if (vcount >= up_pos2 && vcount < down_pos2) begin
//                    r = 4'b1111; g = 4'b1111; b = 4'b1111;
                    dh = hcount - left_pos; nh = dh / 8; ph = dh % 8;
                    dv = vcount - up_pos2; nv = dv / 16; pv = dv % 16;
                    p_data = reginfo[nv * 64 + nh];
                    
                    pos = pv * 8 + ph;
                    if (ram[p_data][pos]) begin r = 4'b1111; g = 4'b1111; b = 4'b1111; end
                    else begin r = 4'b0000; g = 4'b0000; b = 4'b0000; end                
                end
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