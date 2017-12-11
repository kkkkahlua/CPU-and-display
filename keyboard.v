`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/10 08:49:32
// Design Name: 
// Module Name: keyboard
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


module keyboard(
    input clk,
    input rst,
    input ps2_clk,
    input ps2_data,
    input [9:0] sel,
    output reg [7:0] data
    );
    
    
    reg overflow;
    reg [1:0] ready=0;
    reg [3:0] count=0;  // count ps2_data bits              
    // internal signal, for test
    reg [9:0] buffer;        // ps2_data bits
    reg [7:0] fifo[1023:0];     // data fifo
    reg [9:0] w_ptr=0;   // fifo write and read pointers
    // detect falling edge of ps2_clk
    reg [2:0] ps2_clk_sync=3'b000;
    
    always @(posedge clk) begin
        ps2_clk_sync <=  {ps2_clk_sync[1:0],ps2_clk};
    end

    wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];
    
    reg [7:0] ascii;
    
    reg [7:0] k2n [93:0];
    
    initial begin
        $readmemh("F:/digital/system/system.srcs/k2n.txt", k2n, 0, 93);
    end        
    
    integer i;
    always @(posedge clk) begin
        if (rst) begin // reset 
            count = 0; w_ptr = 1; overflow = 0; ready = 0;buffer = 0;
        end
        else if (sampling) begin
            if (count == 4'd10) begin
                if (ready==0) begin
                    if ((buffer[0] == 0) &&  // start bit
                        (ps2_data)       &&  // stop bit
                        (^buffer[9:1])) begin      // odd  parity
//                                                if (w_ptr / 64 * 64 == w_ptr) begin
//                                                    fifo[w_ptr] = 8'h29;
//                                                    w_ptr = w_ptr + 1;
//                                                end
                                                if (buffer[8:1] == 8'h5a) begin
                                                    w_ptr = (w_ptr / 64 + 1) * 64;
                                                end   
                                                else if (buffer[8:1] == 8'h66) begin
                                                    if (w_ptr > 0) w_ptr = w_ptr - 1;
                                                end   
                                                else if (buffer[8:1] == 8'h59) begin
                                                    fifo[w_ptr] = 8'h59;
                                                    w_ptr = w_ptr + 1;
                                                end
                                                else if (buffer[8:1] == 8'h49) begin
                                                    if (w_ptr > 0 && fifo[w_ptr-1] == 8'h59) fifo[w_ptr-1] = 8'h29;
                                                    else begin fifo[w_ptr] = 8'h28; w_ptr = w_ptr + 3'b1; end
                                                end
                                                else if (buffer[8:1] == 8'h25) begin
                                                    if (w_ptr > 0 && fifo[w_ptr-1] == 8'h59) fifo[w_ptr-1] = 8'h2a;
                                                    else begin fifo[w_ptr] = 8'h05; w_ptr = w_ptr + 3'b1; end
                                                end
                                                else if (buffer[8:1] == 8'h3e) begin
                                                    if (w_ptr > 0 && fifo[w_ptr-1] == 8'h59) fifo[w_ptr-1] = 8'h2c;
                                                    else begin fifo[w_ptr] = 8'h09; w_ptr = w_ptr + 3'b1; end
                                                end
                                                else begin
                                                    fifo[w_ptr] = k2n[buffer[8:1]];
                                                    w_ptr = w_ptr + 3'b1;
                                                end                                                   
                    end
                end
                ready = ready + 1;
                if (ready == 3) ready <= 0;
                count = 0;     // for next
            end else begin
                buffer[count] = ps2_data;  // store ps2_data 
                count = count + 3'b1;
            end      
        end
    end 
    
    always @ (*) begin
        if (sel >= w_ptr) data = 8'h00;
        else data = fifo[sel];
    end    
    
endmodule
