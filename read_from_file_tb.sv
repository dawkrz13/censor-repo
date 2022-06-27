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

    reg clock, reset, enable;
    reg [31:0] chunk;
    reg [8*32:1] word;   // words max length is 32
    wire [31:0] hash;
    wire ready;
    wire is_present;
    
    int fd;
    bit in_progress;
    
    //Instantiation
    murmur_4_bytes murmur(clock, reset, enable, ready, word, hash, is_present);
    
initial begin

    in_progress = 0;
    
    fd = $fopen("../../../../Text_files/sample_file.txt", "r");
    if (fd) $display("File was opened succesfully %0d", fd);
    else    $display("File could not be opened: %0d", fd);
    
end

initial begin
    clock <= 1'b1;
end

always
    #5 if (fd) clock <= ~clock;

always@(posedge clock)
begin

    if (!in_progress) begin
        if (!$feof(fd)) begin
            $fscanf(fd, "%s", word);
            enable = 1;
            in_progress = 1;
        end
        else begin
            //$fclose(fd);
        end
    end
    else if (ready) begin
        $display("%s ", word[256:1]);
        $display("is_present: %d (hash: %d)\n", is_present, hash);
        in_progress = 0;
        enable = 0;
    end

end
endmodule