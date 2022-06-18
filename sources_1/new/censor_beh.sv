`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.06.2022 12:57:56
// Design Name: 
// Module Name: censor_beh
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


module censor_beh();

    // STRINGS
    string forbidden_words[6] = '{"one", "two", "three", "four", "five", "six"};
    int array_size1 = 6;
    string test_words_array[6] = '{"seven", "two", "three", "eight", "six", "nine"};
    int array_size2 = 6;
    string tmp_string;
    
    // HASH
    bit [31:0] hash_array = 0;
    int hash_array_size = 32;
    int hash;
    
    // ITERATORS
    int i, j;
    
    initial begin
        // CREATING LOOKUP TABLE START
        for(i = 0; i < array_size1; i = i + 1)
        begin
            tmp_string = forbidden_words[i];
            // CALCULATE HASH START
            hash = 0;
            for(j = 0; j < tmp_string.len(); j = j + 1)
            begin
                // str.getc(j) returns the ASCII code of the j-th character in str
                hash = hash + tmp_string.getc(j);
                hash = hash % hash_array_size;
            end
            // CALCULATE HASH END
            hash_array[hash] = 1;
            $display("%s inserted", tmp_string);
        end
        // CREATING LOOKUP TABLE END
        // CHECKING TEST WORDS START
        for(i = 0; i < array_size2; i = i + 1)
        begin
            tmp_string = test_words_array[i];
            // CALCULATE HASH START
            hash = 0;
            for(j = 0; j < tmp_string.len(); j = j + 1)
            begin
                // str.getc(j) returns the ASCII code of the j-th character in str
                hash = hash + tmp_string.getc(j);
                hash = hash % hash_array_size;
            end
            // CALCULATE HASH END
            if (hash_array[hash])
            begin
                $display("%s is probably forbidden", tmp_string);
            end
            else
            begin
                $display("%s is not forbidden", tmp_string);
            end
        end
        // CHECKING TEST WORDS END
    end

endmodule
