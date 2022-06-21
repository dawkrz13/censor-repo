`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.06.2022 13:53:41
// Design Name: 
// Module Name: read_from_file_tb
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


module read_from_file_tb();

    reg clock;
    int fd;
    reg [8*32:1] word_reg;   // words max length is 32
    
    reg [31:0] seed;
    reg [31:0] chunk;
    wire [31:0] hash;
    
    int i;
    
    //Instantiation
    murmur_4_bytes murmur(seed, chunk, hash);
    
initial begin

    seed = 'hF00DBAAD;
    chunk = 'h00000000;
    i = 0;
    
    fd = $fopen("../../../../Text_files/sample_file.txt", "r");
    if (fd) $display("File was opened succesfully %0d", fd);
    else    $display("File could not be opened: %0d", fd);
    
end

initial begin
    clock <= 1'b1;
end

always
    #5 if (fd) clock <= ~clock;

always@(posedge clock) begin
    if (!$feof(fd)) begin
        if (i == 0) begin
            //read a single word and display it
            $fscanf(fd, "%s", word_reg);
            $display("%s ", word_reg[256:1]);
        end
        
        if (chunk[31:0] != 'h00000000) begin
            seed[31:0] = hash[31:0];
        end
        
        if (i < (256/32)) begin
            case (i)
                0: chunk[31:0] = word_reg[32:1];
                1: chunk[31:0] = word_reg[64:33];
                2: chunk[31:0] = word_reg[96:65];
                3: chunk[31:0] = word_reg[128:97];
                4: chunk[31:0] = word_reg[160:129];
                5: chunk[31:0] = word_reg[192:161];
                6: chunk[31:0] = word_reg[224:193];
                7: chunk[31:0] = word_reg[256:225];
            endcase
            i = i + 1;
        end
        else begin
            i = 0;
        end
        
        $display("(hash: %0h)\n", hash[31:0]);  
    end
    else begin
        $fclose(fd);
    end
end
endmodule
