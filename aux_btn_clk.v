`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/25 14:36:19
// Design Name: 
// Module Name: btn_clk
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


module aux_btn_clk(
    input clk,
    input key,
    output ctrl
    );

    reg [19:0] cnt;					//	������
    always @ (posedge clk) begin
        cnt <= cnt + 1'b1;
    end
    
    reg low_sw;
    always @ (posedge clk) begin
        if (cnt == 20'hfffff) low_sw <= key;    //    ��20ms��������ֵ���浽�Ĵ���low_sw��
    end
    
    reg low_sw_r;                    //    ÿ��ʱ�ӵ������ؽ�low_sw�ź����浽low_sw_r��
    always @ (posedge clk) begin
        low_sw_r <= low_sw;
    end
    
    //    ���Ĵ���low_sw��1��Ϊ0ʱ��ctrl��Ϊ1��ά��һ��ʱ������
    assign ctrl = low_sw_r & (~low_sw);        
    
endmodule
