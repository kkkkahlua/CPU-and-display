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


module IO_keyboard(
    input clk,
    input rst,
    input ps2_clk,
    input ps2_data,
    input [9:0] sel,
    output reg [7:0] data,
    output reg [15:0]led=0,
    output reg [31:0]fib=0,
    output reg flag
    );
    
    reg [3:0]ledid;
   
    reg overflow;
    reg [1:0] ready=0;
    reg [3:0] count=0;  // count ps2_data bits              
    // internal signal, for test
    reg [9:0] buffer;        // ps2_data bits
    reg [7:0]linebuf [63:0];
    reg [7:0] fifo[1023:0];     // data fifo
    reg [9:0] w_ptr=0;   // fifo write and read pointers
    reg [5:0] l_ptr=0;
    // detect falling edge of ps2_clk
    reg [2:0] ps2_clk_sync=3'b000;
    
    always @(posedge clk) begin
        ps2_clk_sync <=  {ps2_clk_sync[1:0],ps2_clk};
    end

    wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];
    
    reg [7:0] ascii;
    
    reg [7:0] k2n [93:0];
    
    initial begin
        $readmemh("D://k2n.txt", k2n, 0, 93);
    end        
    
    reg check;
    
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
                                                     if (buffer[8:1] == 8'h5a) begin
                                                        w_ptr = ((w_ptr >> 6) + 1) << 6;
                                                       if (linebuf[0] == 8'h16 && linebuf[1] == 8'h0f && linebuf[2] == 8'h0e && linebuf[3] == 8'h00 && linebuf[4] == 8'h19 && linebuf[5] == 8'h18) begin
                                                            ledid = linebuf[7] - 1;
                                                            led[ledid] = 1;
                                                             flag = 1'b0;
                                                        end
                                                        else if (linebuf[0] == 8'h16 && linebuf[1] == 8'h0f && linebuf[2] == 8'h0e && linebuf[3] == 8'h00 && linebuf[4] == 8'h19 && linebuf[5] == 8'h10 && linebuf[6] == 8'h10) begin
                                                            ledid = linebuf[8] - 1;
                                                            led[ledid] = 0;
                                                             flag = 1'b0;
                                                        end
                                                        else if (linebuf[0] == 8'h10 && linebuf[1] == 8'h13 && linebuf[2] == 8'h0c) begin
                                                            if (l_ptr == 5) fib = linebuf[4] - 1;
                                                            else if (l_ptr == 6) fib = (linebuf[4] - 1) * 10 + linebuf[5] - 1;
                                                          flag =1'b1;  
                                                        end
                                                      else flag =1'b0;  
                                                    l_ptr = 0;                                                    
                                                end   
                                                else if (buffer[8:1] == 8'h66) begin
                                                    if (w_ptr > 0) begin l_ptr = l_ptr - 1; w_ptr = w_ptr - 1; end
                                                     flag = 1'b0;
                                                end   
                                                else if (buffer[8:1] == 8'h59) begin
                                                    fifo[w_ptr] = 8'h59;
                                                    linebuf[l_ptr] = fifo[w_ptr]; l_ptr = l_ptr + 1; w_ptr = w_ptr + 1;
                                                     flag = 1'b0;
                                                end
                                                else if (buffer[8:1] == 8'h49) begin
                                                    if (w_ptr > 0 && fifo[w_ptr-1] == 8'h59) begin fifo[w_ptr-1] = 8'h29; linebuf[l_ptr - 1] = 8'h29; end
                                                    else begin 
                                                        fifo[w_ptr] = 8'h28;
                                                        linebuf[l_ptr] = fifo[w_ptr]; l_ptr = l_ptr + 1; w_ptr = w_ptr + 3'b1;                                       
                                                    end
                                                     flag = 1'b0;
                                                end
                                                else if (buffer[8:1] == 8'h25) begin
                                                    if (w_ptr > 0 && fifo[w_ptr-1] == 8'h59) begin fifo[w_ptr-1] = 8'h2a; linebuf[l_ptr - 1] = 8'h2a; end
                                                    else begin 
                                                        fifo[w_ptr] = 8'h05;
                                                        linebuf[l_ptr] = fifo[w_ptr]; l_ptr = l_ptr + 1;   w_ptr = w_ptr + 3'b1;
                                                    end
                                                     flag = 1'b0;
                                                end
                                                else if (buffer[8:1] == 8'h3e) begin
                                                    if (w_ptr > 0 && fifo[w_ptr-1] == 8'h59) begin fifo[w_ptr-1] = 8'h2c; linebuf[l_ptr - 1] = 8'h2c; end
                                                    else begin 
                                                        fifo[w_ptr] = 8'h09; 
                                                        linebuf[l_ptr] = fifo[w_ptr]; l_ptr = l_ptr + 1;  w_ptr = w_ptr + 3'b1;
                                                    end
                                                     flag = 1'b0;
                                                end
                                                else begin
                                                    fifo[w_ptr] = k2n[buffer[8:1]];
                                                    linebuf[l_ptr] = fifo[w_ptr]; l_ptr = l_ptr + 1;   w_ptr = w_ptr + 3'b1;
                                                     flag = 1'b0;
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
