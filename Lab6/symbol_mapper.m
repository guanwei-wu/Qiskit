function sym_seq = symbol_mapper(bin_seq, M, d, name)

    if name == 'PAM'
        l = log2(M);
        sym_seq = zeros(1, length(bin_seq)/l);
        
        x = (0:M-1);
        [y,mapy] = bin2gray(x,'pam',M);
        
        y = flip(y);
        
        A = zeros(1, M);
        for i = 1 : M
            A(i) = d/2 * ( 2 * (i-M/2) - 1 );
        end
        
        for i = 0 : length(bin_seq)/l - 1
            tmp = '';
            for j = 1 : l
                tmp = append( tmp, int2str( bin_seq(i*l+j) ) );
            end
            for k = 1 : length(y)
                if bin2dec(tmp) == y(k)
                    sym_seq(i+1) = A(k);
                    break;
                end
            end
        end
    end
    
    if name == 'PSK'
        l = log2(M);
        sym_seq = [];
        
        x = (0:M-1);
        [y,mapy] = bin2gray(x,'psk',M);
        
%         y = flip(y);
        
        A = [];
        B = [];
        for i = 1 : M
            A(end+1) = d/(2*sin(pi/M)) * cos((2*pi/M) * (i-1));
            B(end+1) = d/(2*sin(pi/M)) * sin((2*pi/M) * (i-1));
        end
        
        for i = 0 : length(bin_seq)/l - 1
            tmp = '';
            for j = 1 : l
                tmp = append( tmp, int2str( bin_seq(i*l+j) ) );
            end
            tmp = bin2dec(tmp);
            for k = 1 : length(y)
                if tmp == y(k)
%                     sym_seq = [sym_seq; [A(k), B(k)]];
                    sym_seq(end+1) = A(k);
                    sym_seq(end+1) = B(k);
                    break;
                end
            end
        end
    end
    
    if name == 'QAM'
        l = log2(M);
        sym_seq = [];
        
        x = (0:M-1);
        [y,mapy] = bin2gray(x,'qam',M);
        
        A = zeros(1, M);
        B = zeros(1, M);
        if M == 4
            Ami = [-1 -1 1 1];
            Amq = [-1 1 -1 1];
        end
        if M == 16
            Ami = [-3 -3 -3 -3 -1 -1 -1 -1 1 1 1 1 3 3 3 3];
            Amq = [-3 -1 1 3 -3 -1 1 3 -3 -1 1 3 -3 -1 1 3];
        end
        if M == 64
            Ami = zeros(1, 64);
            Amq = zeros(1, 64);
            for i = 1 : 8
                for j = 1 : 8
                    Ami(8*i - 8 + j) = -9 + 2*i;
                    Amq(8*j - 8 + i) = -9 + 2*i;
                end
            end
        end
        
        for i = 1 : M
            A(i) = d/2 * Ami(i);
            B(i) = d/2 * Amq(i);
        end
        
        for i = 0 : length(bin_seq)/l - 1
            tmp = '';
            for j = 1 : l
                tmp = append( tmp, int2str( bin_seq(i*l+j) ) );
            end
            for k = 1 : length(y)
                if bin2dec(tmp) == y(k)
%                     sym_seq = [sym_seq; [A(k), B(k)]];
                    sym_seq(end+1) = A(k);
                    sym_seq(end+1) = B(k);
                    break;
                end
            end
        end
    end