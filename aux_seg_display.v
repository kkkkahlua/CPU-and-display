`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/25 14:58:03
// Design Name: 
// Module Name: seg_display
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


module aux_seg_display(
    input clk,
    input [31:0] dout,
    output reg [7:0] sel_seg,
    output reg [6:0] seg7
    );
    reg [25:0] count_clk;
    reg [6:0] out_dis[7:0];

    always @ (posedge clk) begin
        if (count_clk == 5000000) count_clk = 0;
        else count_clk = count_clk + 1;
    end
    
    always @ (count_clk) begin
        case (count_clk[18:16])
            0:begin sel_seg = 8'b11111110; seg7 = out_dis[0]; end
            1:begin sel_seg = 8'b11111101; seg7 = out_dis[1]; end
            2:begin sel_seg = 8'b11111011; seg7 = out_dis[2]; end
            3:begin sel_seg = 8'b11110111; seg7 = out_dis[3]; end
            4:begin sel_seg = 8'b11101111; seg7 = out_dis[4]; end
            5:begin sel_seg = 8'b11011111; seg7 = out_dis[5]; end
            6:begin sel_seg = 8'b10111111; seg7 = out_dis[6]; end
            7:begin sel_seg = 8'b01111111; seg7 = out_dis[7]; end
            default:begin sel_seg = 8'b11111111; end
        endcase           
    end
    
    always @ (dout) begin
        case (dout[3:0]) 
        0: out_dis[0] = 7'b1000000;
        1: out_dis[0] = 7'b1111001;
        2: out_dis[0] = 7'b0100100;
        3: out_dis[0] = 7'b0110000;
        4: out_dis[0] = 7'b0011001;
        5: out_dis[0] = 7'b0010010;
        6: out_dis[0] = 7'b0000010;
        7: out_dis[0] = 7'b1111000;
        8: out_dis[0] = 7'b0000000;
        9: out_dis[0] = 7'b0010000;
        10: out_dis[0] = 7'b0001000;
        11: out_dis[0] = 7'b0000011;
        12: out_dis[0] = 7'b1000110;
        13: out_dis[0] = 7'b0100001;
        14: out_dis[0] = 7'b0000110;
        15: out_dis[0] = 7'b0001110;
        default: out_dis[0] = 7'b1111111;
    endcase    
        case (dout[7:4]) 
        0: out_dis[1] = 7'b1000000;
        1: out_dis[1] = 7'b1111001;
        2: out_dis[1] = 7'b0100100;
        3: out_dis[1] = 7'b0110000;
        4: out_dis[1] = 7'b0011001;
        5: out_dis[1] = 7'b0010010;
        6: out_dis[1] = 7'b0000010;
        7: out_dis[1] = 7'b1111000;
        8: out_dis[1] = 7'b0000000;
        9: out_dis[1] = 7'b0010000;
        10: out_dis[1] = 7'b0001000;
        11: out_dis[1] = 7'b0000011;
        12: out_dis[1] = 7'b1000110;
        13: out_dis[1] = 7'b0100001;
        14: out_dis[1] = 7'b0000110;
        15: out_dis[1] = 7'b0001110;
        default: out_dis[1] = 7'b1111111;
    endcase    
        case (dout[11:8]) 
        0: out_dis[2] = 7'b1000000;
        1: out_dis[2] = 7'b1111001;
        2: out_dis[2] = 7'b0100100;
        3: out_dis[2] = 7'b0110000;
        4: out_dis[2] = 7'b0011001;
        5: out_dis[2] = 7'b0010010;
        6: out_dis[2] = 7'b0000010;
        7: out_dis[2] = 7'b1111000;
        8: out_dis[2] = 7'b0000000;
        9: out_dis[2] = 7'b0010000;
        10: out_dis[2] = 7'b0001000;
        11: out_dis[2] = 7'b0000011;
        12: out_dis[2] = 7'b1000110;
        13: out_dis[2] = 7'b0100001;
        14: out_dis[2] = 7'b0000110;
        15: out_dis[2] = 7'b0001110;
        default: out_dis[2] = 7'b1111111;
    endcase    
        case (dout[15:12]) 
        0: out_dis[3] = 7'b1000000;
        1: out_dis[3] = 7'b1111001;
        2: out_dis[3] = 7'b0100100;
        3: out_dis[3] = 7'b0110000;
        4: out_dis[3] = 7'b0011001;
        5: out_dis[3] = 7'b0010010;
        6: out_dis[3] = 7'b0000010;
        7: out_dis[3] = 7'b1111000;
        8: out_dis[3] = 7'b0000000;
        9: out_dis[3] = 7'b0010000;
        10: out_dis[3] = 7'b0001000;
        11: out_dis[3] = 7'b0000011;
        12: out_dis[3] = 7'b1000110;
        13: out_dis[3] = 7'b0100001;
        14: out_dis[3] = 7'b0000110;
        15: out_dis[3] = 7'b0001110;
        default: out_dis[3] = 7'b1111111;
    endcase    
        case (dout[19:16]) 
        0: out_dis[4] = 7'b1000000;
        1: out_dis[4] = 7'b1111001;
        2: out_dis[4] = 7'b0100100;
        3: out_dis[4] = 7'b0110000;
        4: out_dis[4] = 7'b0011001;
        5: out_dis[4] = 7'b0010010;
        6: out_dis[4] = 7'b0000010;
        7: out_dis[4] = 7'b1111000;
        8: out_dis[4] = 7'b0000000;
        9: out_dis[4] = 7'b0010000;
        10: out_dis[4] = 7'b0001000;
        11: out_dis[4] = 7'b0000011;
        12: out_dis[4] = 7'b1000110;
        13: out_dis[4] = 7'b0100001;
        14: out_dis[4] = 7'b0000110;
        15: out_dis[4] = 7'b0001110;
        default: out_dis[4] = 7'b1111111;
    endcase    
        case (dout[23:20]) 
        0: out_dis[5] = 7'b1000000;
        1: out_dis[5] = 7'b1111001;
        2: out_dis[5] = 7'b0100100;
        3: out_dis[5] = 7'b0110000;
        4: out_dis[5] = 7'b0011001;
        5: out_dis[5] = 7'b0010010;
        6: out_dis[5] = 7'b0000010;
        7: out_dis[5] = 7'b1111000;
        8: out_dis[5] = 7'b0000000;
        9: out_dis[5] = 7'b0010000;
        10: out_dis[5] = 7'b0001000;
        11: out_dis[5] = 7'b0000011;
        12: out_dis[5] = 7'b1000110;
        13: out_dis[5] = 7'b0100001;
        14: out_dis[5] = 7'b0000110;
        15: out_dis[5] = 7'b0001110;
        default: out_dis[5] = 7'b1111111;
    endcase
        case (dout[27:24]) 
        0: out_dis[6] = 7'b1000000;
        1: out_dis[6] = 7'b1111001;
        2: out_dis[6] = 7'b0100100;
        3: out_dis[6] = 7'b0110000;
        4: out_dis[6] = 7'b0011001;
        5: out_dis[6] = 7'b0010010;
        6: out_dis[6] = 7'b0000010;
        7: out_dis[6] = 7'b1111000;
        8: out_dis[6] = 7'b0000000;
        9: out_dis[6] = 7'b0010000;
        10: out_dis[6] = 7'b0001000;
        11: out_dis[6] = 7'b0000011;
        12: out_dis[6] = 7'b1000110;
        13: out_dis[6] = 7'b0100001;
        14: out_dis[6] = 7'b0000110;
        15: out_dis[6] = 7'b0001110;
        default: out_dis[6] = 7'b1111111;
    endcase   
        case (dout[31:28]) 
        0: out_dis[7] = 7'b1000000;
        1: out_dis[7] = 7'b1111001;
        2: out_dis[7] = 7'b0100100;
        3: out_dis[7] = 7'b0110000;
        4: out_dis[7] = 7'b0011001;
        5: out_dis[7] = 7'b0010010;
        6: out_dis[7] = 7'b0000010;
        7: out_dis[7] = 7'b1111000;
        8: out_dis[7] = 7'b0000000;
        9: out_dis[7] = 7'b0010000;
        10: out_dis[7] = 7'b0001000;
        11: out_dis[7] = 7'b0000011;
        12: out_dis[7] = 7'b1000110;
        13: out_dis[7] = 7'b0100001;
        14: out_dis[7] = 7'b0000110;
        15: out_dis[7] = 7'b0001110;
        default: out_dis[7] = 7'b1111111;
    endcase       
    end    
endmodule
