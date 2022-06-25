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

module murmur_4_bytes(clock, word, hash_out, hash_ready);
    
    parameter SEED_DEF_VAL = 'hF00DBAAD;
    parameter BYTES_PER_WORD = 'h100;
    
    input reg clock;
    input [BYTES_PER_WORD:1] word;
    output reg [31:0] hash_out;
    output reg hash_ready;
    
    reg [31:0] hash;    
    reg [31:0] chunk;
    reg [31:0] seed;
    
    reg [2:0] i;
    reg [31:0] k, h;
    reg default_seed;
    
    localparam [31:0] c1 = 'hcc9e2d51; 
    localparam [31:0] c2 = 'h1b873593;
    localparam [31:0] m = 5;
    localparam [31:0] n = 'he6546b64;  
    
initial begin
    assign hash_out = hash;
    default_seed = 1'b1;
    i = 3'b000;
end

always@(posedge clock) begin
    if (default_seed) begin
        seed = SEED_DEF_VAL;
        default_seed = 1'b0;
        hash_ready = 1'b0;
    end //(default_seed)
    else 
        seed = hash;
        
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

    k = chunk;
    
    k = k * c1;
    k[31:0] = {k[16:0], k[31:17]};
    k = k * c2;
    
    h = seed;
    h = h ^ k;
    h = {h[18:0], h[31:19]};
    h = h * m;
    hash = h + n;
    
//    //finalization
    if (i == 7) begin
        hash = hash ^ BYTES_PER_WORD;
        hash = hash ^ (hash >> 16); //SHIFTR16
        hash = hash * 'h85ebca6b;
        hash = hash ^ (hash >> 13); //SHIFTR13
        hash = hash * 'hc2b2ae35;
        hash = hash ^ (hash >> 16); //SHIFTR16

        hash_ready = 1'b1;
        i = 0;
        default_seed = 1'b1;
    end //(i == 7)
    else
        i = i + 1;
        
end //always@(posedge clock)
            
endmodule