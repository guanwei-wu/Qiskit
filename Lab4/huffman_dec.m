function sym_seq = huffman_dec(seq, d)
    sym_seq = {};
    
    bin_seq = seq;
    dict = d;
    z = 0;
    
    for i = 1:length(dict)
        if cell2mat(dict(i, 3)) > 0
            z = i;
            break;
        end
    end
    
    z = z-1;
    bit = 1;
    
    while length(bin_seq) > 0
        len = length(bin_seq);
        for j = 1:z
            split = bin_seq(1:bit);
            left = bin_seq(bit+1:end);
            if string(dict(j, 5)) == split
                sym_seq = [sym_seq, char(dict(j, 1))];
                bin_seq = left;
                bit = 1;
                break;
            end
            if j == z
                bit = bit + 1;
            end
        end
    end