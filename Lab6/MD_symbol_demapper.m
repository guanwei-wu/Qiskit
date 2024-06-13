function bin_seq = MD_symbol_demapper(sym_seq, M, d, name)
    if name == 'PAM'
        l = log2(M);
        bin_seq = zeros(1, length(sym_seq)*l);
        
        x = (0:M-1);
        [y,mapy] = bin2gray(x,'pam',M);
        
        y = flip(y);
        
        A = zeros(1, M);
        for i = 1 : M
            A(i) = d/2 * ( 2 * (i-M/2) - 1 );
        end
        
        for i = 1 : length(sym_seq)
            min_idx = -1;
            min_val = 100000;
            for j = 1 : length(A)
                if abs(A(j) - sym_seq(i)) < min_val
                    min_val = abs(A(j) - sym_seq(i));
                    min_idx = j;
                end
            end
            for k = 1 : l
                bin = dec2bin( y(min_idx), l );
                bin_seq(i*l - l + k) = str2num( bin(k) );
            end
        end
    end
    
    if name == 'PSK'
        l = log2(M);
        bin_seq = [];
        
        x = (0:M-1);
        [y,mapy] = bin2gray(x,'psk',M);
        
%         y = flip(y);
        
%         A = [];
%         B = [];
%         for i = 1 : M
%             A(end+1) = d/(2*sin(pi/M)) * cos((2*pi/M) * (i-1));
%             B(end+1) = d/(2*sin(pi/M)) * sin((2*pi/M) * (i-1));
%         end
        
        for i = 1 : length(sym_seq)/2
%             min_idx = -1;
%             min_val = 100000;
%             for j = 1 : length(A)
%                 val = (A(j) - sym_seq(2*i-1))^2 + (B(j) - sym_seq(2*i))^2;
%                 if val < min_val
%                     min_val = val;
%                     min_idx = j;
%                 end
%             end
%             for k = 1 : l
%                 bin = dec2bin( y(min_idx), l );
%                 bin_seq(end+1) = str2num( bin(k) );
%             end
            Cos = sym_seq(2*i-1);
            Sin = sym_seq(2*i);
            Tan = Sin/Cos;
            ATan = atan(Tan);
            if ATan < 0
                ATan = ATan + pi;
            end
            if Sin * ( (2*sin(pi/M))/d ) < 0
                ATan = ATan + pi;
            end
            Pred = ATan*( M/(2*pi) ) + 1;
            Round = round(Pred, 0);
            if Round == M + 1
                Round = 1;
            end
            bin = dec2bin( y(Round), l );
            for k = 1 : l
%                 y(Round)
                bin_seq(end+1) = str2num( bin(k) );
            end
            
        end
        
    end
    
    if name == 'QAM'
        l = log2(M);
        bin_seq = [];
        
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
        
        for i = 1 : length(sym_seq)/2
            min_idx = -1;
            min_val = 100000;
            for j = 1 : length(A)
                if (A(j) - sym_seq(2*i-1))^2 + (B(j) - sym_seq(2*i))^2 < min_val
                    min_val = (A(j) - sym_seq(2*i-1))^2 + (B(j) - sym_seq(2*i))^2;
                    min_idx = j;
                end
            end
            bin = dec2bin( y(min_idx), l );
            for k = 1 : l
%                 bin = dec2bin( y(min_idx), l );
                bin_seq(end+1) = str2num( bin(k) );
            end
        end
    end