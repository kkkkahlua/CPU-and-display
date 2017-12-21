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

    reg [19:0] cnt;					//	计数器
    always @ (posedge clk) begin
        cnt <= cnt + 1'b1;
    end
    
    reg low_sw;
    always @ (posedge clk) begin
        if (cnt == 20'hfffff) low_sw <= key;    //    满20ms，将按键值锁存到寄存器low_sw中
    end
    
    reg low_sw_r;                    //    每个时钟的上升沿将low_sw信号锁存到low_sw_r中
    always @ (posedge clk) begin
        low_sw_r <= low_sw;
    end
    
    //    当寄存器low_sw由1变为0时，ctrl变为1，维持一个时钟周期
    assign ctrl = low_sw_r & (~low_sw);        
    
endmodule
