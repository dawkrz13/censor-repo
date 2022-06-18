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
    bit [63:0] hash_array = 0;
    int hash_array_size = 64;
    int hash;
    
    // ITERATORS
    int i, j;
    
    function automatic int calculate_hash(const ref string tmp_string);

        int tmp_hash = 0;
        for(j = 0; j < tmp_string.len(); j = j + 1)
        begin
            // str.getc(j) returns the ASCII code of the j-th character in str
            tmp_hash = tmp_hash + tmp_string.getc(j);
            tmp_hash = tmp_hash % hash_array_size;
        end
        return tmp_hash;
 
    endfunction
    
    initial begin
        // CREATING LOOKUP TABLE START
        $display("Creating hash lookup table.");
        for(i = 0; i < array_size1; i = i + 1)
        begin
            tmp_string = forbidden_words[i];
            hash = calculate_hash(tmp_string);
            hash_array[hash] = 1;
            $display("%10s inserted, hash: %d", tmp_string, hash);
        end
        // CREATING LOOKUP TABLE END
        // CHECKING TEST WORDS START
        $display("Checking input stream.");
        for(i = 0; i < array_size2; i = i + 1)
        begin
            tmp_string = test_words_array[i];
            hash = calculate_hash(tmp_string);
            if (hash_array[hash])
            begin
                $display("[!]%7s is probably forbidden, hash: %d", tmp_string, hash);
            end
            else
            begin
                $display("%10s is not forbidden,      hash: %d", tmp_string, hash);
            end
        end
        // CHECKING TEST WORDS END
    end

endmodule
