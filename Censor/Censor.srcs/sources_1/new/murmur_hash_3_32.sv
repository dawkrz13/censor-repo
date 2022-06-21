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


module murmur_4_bytes(seed, chunk, hash);
    
    input [31:0] seed;
    input [31:0] chunk;
    output [31:0] hash;
    
    assign hash = murmurblock(seed, chunk);
    
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