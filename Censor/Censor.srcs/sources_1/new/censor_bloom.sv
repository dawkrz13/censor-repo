`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2022 20:19:27
// Design Name: 
// Module Name: censor_bloom
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



module censor_bloom(clock, hash_in, filter_ready, result);
    
    parameter BYTES_PER_WORD = 'h100;
    parameter WORD_CNT = 9;
    parameter FILTER_SIZE = 896;
    
    input reg clock;
    input [31:0] hash_in;
    output reg filter_ready;
    output reg result;
    
    reg murmur_clock;
    reg [3:0] i;
    reg [2:0] clock_cntr;
    
    wire [31:0] hash;
    reg [31:0] seed;
    reg [BYTES_PER_WORD:1] word;
    
    reg [BYTES_PER_WORD:1] dictionary[WORD_CNT:1] = { "system", "SoC", "hardware", "FPGA", "processor",
                                                        "book", "Chapter", "design", "Zynq"};                                  
    reg [FILTER_SIZE:1] filter;
    
    murmur_4_bytes murmur(murmur_clock, word, hash);
    
    initial begin
        filter[FILTER_SIZE:1] = 0;
        filter_ready = 1'b0;    
        i = 4'b0001;
        murmur_clock = 1'b0;
        clock_cntr = 3'b000;
    end

    always@(posedge clock) begin
    
        if (filter_ready) begin
            if (filter & (1'b1 << (hash_in%FILTER_SIZE)))
                result = 1'b1;
            else
                result = 1'b0;
        end //(filter_ready)
        
        if (!filter_ready && !clock_cntr) begin 
            //first word processed and hash generated
            if (i > 1) begin    
                filter = filter | (1'b1 << (hash%FILTER_SIZE));
                $display("filter: %2h, hash: %2h\n", filter, hash);
            end
            
            if (i <= WORD_CNT) begin
                word = dictionary[i];
                i = i + 1;
            end //(i < WORD_CNT)
            else begin
               filter_ready = 1'b1;
               deassign murmur_clock;
            end
        end //((!clock_cntr))
        
        if (!filter_ready) begin
            assign murmur_clock = clock;
            clock_cntr = clock_cntr + 1;
        end //(!filter_ready)
        
    end //always@(posedge clock )

endmodule
