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


module read_from_file_tb;
    parameter BYTES_PER_WORD = 'h100;
    
    reg clock, murmur_clock, filter_clock;
    int fd, position;
    reg [8*32:1] current_word;   // max numeber of words = 32
    reg [8*32:1] previous_word;
    
    wire [31:0] hash;
    wire hash_ready;
    
    wire filter_ready;
    wire result;
    
    reg filter_enabled;
    reg first_word_processed;
    reg read_result;
    reg last_word;
    reg finished_reading;
    
    //Instantiation
    murmur_4_bytes murmur(murmur_clock, current_word, hash, hash_ready);
    censor_bloom bloom_filter(filter_clock, hash, filter_ready, result);

initial begin
    clock = 1'b0;
    murmur_clock = 1'b0;
    filter_clock = 1'b0;
    filter_enabled = 1'b1;
    first_word_processed = 1'b0;
    read_result = 1'b0;
    last_word = 1'b0;
    finished_reading = 1'b0;
end

always
    #1 if (first_word_processed && (fd != 0)) 
            murmur_clock <= ~murmur_clock;
            
always
    #1 if (filter_enabled) 
        filter_clock <= ~filter_clock;
        
// clock value changes every 8 time units
always
    #8 if (fd) 
        clock <= ~clock;

always@ (posedge finished_reading) begin
    #2 filter_enabled = 1'b0;
    if (result)
        $display("Word: %s ", previous_word[128:1]);
end

always@ (posedge hash_ready) begin
    if (first_word_processed)
        filter_enabled = 1'b1;
end

always@ (negedge hash_ready) begin
    if (first_word_processed)
        filter_enabled = 1'b0;
end

always@ (posedge filter_ready) begin
    filter_enabled = 1'b0;
    
    fd = $fopen("../../../../Text_files/sample_file_2.txt", "r");
    if (fd) $display("File was opened succesfully %0d", fd);
    else    $display("File could not be opened: %0d", fd);
end
    
always@(posedge clock) begin
    //file is open and (EOF not reached or last word being processed)
    if (!$feof(fd) || last_word) begin
        if (read_result)
            if (result)
                $display("Word: %s at position %d", previous_word[128:1], position);
        if (first_word_processed) begin
//            $display("%s ", current_word);
//            $display("(hash: %8h)\t", hash); //last generated hash
            read_result = 1'b1;
        end //(first_word_processed)
        else
            first_word_processed = 1'b1;
        
        previous_word = current_word;
        position = $ftell(fd);
        if (!last_word)    
            $fscanf(fd, "%s", current_word);//read a single word
    end //(!$feof(fd))
    //if EOF reached wait till last word is processed and then close the file
    if ($feof(fd)) begin
        if (last_word) begin
            $fclose(fd);
            fd = 0;
            finished_reading = 1'b1;
        end //(last_word)
        else
            last_word = 1'b1;
    end //($feof(fd))
end

endmodule