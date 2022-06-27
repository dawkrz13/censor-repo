`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.06.2022 19:37:50
// Design Name: 
// Module Name: murmur_hash_3_32
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


module murmur_4_bytes(clock, reset, enable, ready, word, hash, is_present);
    
    input clock, reset, enable;
    input reg [8*32:1] word;
    output reg [31:0] hash;
    output reg ready;
    output reg is_present;
    
    // Bloom filter look-up table
    static reg [255:0] bloom_array = 0;
    reg [31:0] seed;
    reg [31:0] chunk;
    reg [31:0] tmp_hash;
    static reg [3:0] i;

    initial begin
        is_present = 0;
        ready = 0;
        i = 0;
    end

    always @ (posedge clock)
    begin
        
        if(enable) begin
            if (i == 0) begin
                seed[31:0]  = 'hF00DBAAD;
                chunk[31:0] = 'h00000000;
            end
            else begin
                seed[31:0] = tmp_hash[31:0];
            end
            
            if (i < (256/32)) begin
                case (i)
                    0: chunk[31:0] = word[32:1];
                    1: chunk[31:0] = word[64:33];
                    2: chunk[31:0] = word[96:65];
                    3: chunk[31:0] = word[128:97];
                    4: chunk[31:0] = word[160:129];
                    5: chunk[31:0] = word[192:161];
                    6: chunk[31:0] = word[224:193];
                    7: chunk[31:0] = word[256:225];
                endcase
                assign tmp_hash = murmurblock(seed, chunk);
                i = i + 1;
                ready = 0;
            end
            else begin
                hash = tmp_hash & 255; //modulo 256
                if (bloom_array[hash]) begin
                    is_present = 1;
                end
                else begin
                    bloom_array[hash] = 1;
                    is_present = 0;
                end
                i = 0;
                ready = 1;
            end
        end
        
        
    
    end
    
    function [31:0] murmurblock;
        input [31:0] seed, chunk;
        reg [31:0] k, h;
        localparam [31:0] c1 = 'hcc9e2d51; 
        localparam [31:0] c2 = 'h1b873593;
        localparam [31:0] m = 5;
        localparam [31:0] n = 'he6546b64;
        
        begin
            k = chunk;
            
            k = k * c1;
            k[31:0] = {k[16:0], k[31:17]};
            k = k * c2;
            
            h = seed;
            h = h ^ k;
            h = {h[18:0], h[31:19]};
            h = h * m;
            murmurblock = h + n;
        end
        
    endfunction
    
endmodule
