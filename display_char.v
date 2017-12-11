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
    input [7:0] data
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
    
    parameter l1 = 160, l2 = 288, l3 = 416, l4 = 544;
    parameter l1_1 = 168, l1_2 = 176, l1_3 = 184, l1_r = 248;
    parameter l2_1 = 296, l2_2 = 304, l2_3 = 312, l2_4 = 320, l2_r2 = 376, l2_r1 = 384;
    parameter l3_1 = 424, l3_2 = 432, l3_3 = 440, l3_r = 504;
    parameter l4_1 = 552, l4_2 = 560, l4_3 = 568, l4_r = 572;
    parameter u1 = 384, u2 = 416, u3 = 448;
    parameter d1 = 400, d2 = 432, d3 = 464;
    
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