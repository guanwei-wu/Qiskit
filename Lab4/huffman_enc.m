function bin_seq = huffman_enc(seq, d)
    bin_seq = '';

    sym_seq = seq;
    dict = d;
    len = length(sym_seq);
    for i = 1:len
        for j = 1:length(dict)
            if string(dict(j, 1)) == sym_seq(i)
                bin_seq = strcat(bin_seq, string(dict(j, 5)));
            end
        end
    end