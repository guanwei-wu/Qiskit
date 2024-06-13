symbols = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' };
prob = [ 0.2, 0.05, 0.005, 0.2, 0.3, 0.05, 0.045, 0.15 ];
% symbols = { 's0', 's1', 's2', 's3', 's4' };
% prob = [ 0.26, 0.25, 0.20, 0.15, 0.14 ];
dict = huffman_dict( symbols, prob );

dict
avg_len = (2+5+5+2+2+5+5+3) / 8;

sym_seq = { 'g', 'a', 'c', 'a', 'b' };
% sym_seq = { 's0', 's1', 's2', 's3', 's4' };
bin_seq = huffman_enc( sym_seq, dict );

% bin_seq

bin_seq = '0001011000111100001';
% bin_seq = '011011000001';
sym_seq = huffman_dec( bin_seq, dict );

% sym_seq

% ===== p3 =====
% R = 200;
R = [ 10, 20, 50, 100, 200, 500, 1000 ];
p = [ 0.2, 0.05, 0.005, 0.2, 0.3, 0.05, 0.045, 0.15 ];
n = 10;
y_10 = zeros(1, 7);
y_50 = zeros(1, 7);
y_100 = zeros(1, 7);
Ln = {};
LnR = 0;
LnR_b = 0;

for idx = 1:length(R)
    for k = 1:R(idx)
        r = randi([0 199],1,n);
        ten_rand = {};

        for i = 1:n
            if mod(r(i), 200) < 40
                r(i) = 'a';
            elseif mod(r(i), 200) < 50
                r(i) = 'b';
            elseif mod(r(i), 200) < 51
                r(i) = 'c';
            elseif mod(r(i), 200) < 91
                r(i) = 'd';
            elseif mod(r(i), 200) < 151
                r(i) = 'e';
            elseif mod(r(i), 200) < 161
                r(i) = 'f';
            elseif mod(r(i), 200) < 170
                r(i) = 'g';
            elseif mod(r(i), 200) < 200
                r(i) = 'h';
            end

            ten_rand = [ten_rand, char(r(i))];
        end

        % ten_rand
        % ten_rand(1)

        ten_bin = huffman_enc( ten_rand, dict );
        % ten_bin

        ten_sym = huffman_dec( char(ten_bin), dict );
        % ten_sym

        LEN = length(char(ten_bin));
        % LEN

        Ln = [Ln, LEN];
        LnR = LnR + LEN;
    end
    
    % Ln
    LnR = LnR / R(idx);
    LnR_b = LnR / n;
    % hist = histogram(cell2mat(Ln)), title(LnR);
    % LnR
    % LnR_b
    y_10(idx) = LnR_b;
end

n = 50;

for idx = 1:length(R)
    for k = 1:R(idx)
        r = randi([0 199],1,n);
        ten_rand = {};

        for i = 1:n
            if mod(r(i), 200) < 40
                r(i) = 'a';
            elseif mod(r(i), 200) < 50
                r(i) = 'b';
            elseif mod(r(i), 200) < 51
                r(i) = 'c';
            elseif mod(r(i), 200) < 91
                r(i) = 'd';
            elseif mod(r(i), 200) < 151
                r(i) = 'e';
            elseif mod(r(i), 200) < 161
                r(i) = 'f';
            elseif mod(r(i), 200) < 170
                r(i) = 'g';
            elseif mod(r(i), 200) < 200
                r(i) = 'h';
            end

            ten_rand = [ten_rand, char(r(i))];
        end

        % ten_rand
        % ten_rand(1)

        ten_bin = huffman_enc( ten_rand, dict );
        % ten_bin

        ten_sym = huffman_dec( char(ten_bin), dict );
        % ten_sym

        LEN = length(char(ten_bin));
        % LEN

        Ln = [Ln, LEN];
        LnR = LnR + LEN;
    end
    
    % Ln
    LnR = LnR / R(idx);
    LnR_b = LnR / n;
    % hist = histogram(cell2mat(Ln)), title(LnR);
    % LnR
    % LnR_b
    y_50(idx) = LnR_b;
end

n = 100;

for idx = 1:length(R)
    for k = 1:R(idx)
        r = randi([0 199],1,n);
        ten_rand = {};

        for i = 1:n
            if mod(r(i), 200) < 40
                r(i) = 'a';
            elseif mod(r(i), 200) < 50
                r(i) = 'b';
            elseif mod(r(i), 200) < 51
                r(i) = 'c';
            elseif mod(r(i), 200) < 91
                r(i) = 'd';
            elseif mod(r(i), 200) < 151
                r(i) = 'e';
            elseif mod(r(i), 200) < 161
                r(i) = 'f';
            elseif mod(r(i), 200) < 170
                r(i) = 'g';
            elseif mod(r(i), 200) < 200
                r(i) = 'h';
            end

            ten_rand = [ten_rand, char(r(i))];
        end

        % ten_rand
        % ten_rand(1)

        ten_bin = huffman_enc( ten_rand, dict );
        % ten_bin

        ten_sym = huffman_dec( char(ten_bin), dict );
        % ten_sym

        LEN = length(char(ten_bin));
        % LEN

        Ln = [Ln, LEN];
        LnR = LnR + LEN;
    end
    
    % Ln
    LnR = LnR / R(idx);
    LnR_b = LnR / n;
    % hist = histogram(cell2mat(Ln)), title(LnR);
    % LnR
    % LnR_b
    y_100(idx) = LnR_b;
end

% for m = 1:length(R)
%     R(m) = log(R(m));
% end

x = R;

H = 0;
for n = 1:length(p)
    H = H + p(n) * log2(p(n)) * (-1);
end

a = avg_len;

% H
% a

figure
graph = semilogx(x, y_10, x, y_50, x, y_100, x, [H, H, H, H, H, H, H], x, [a, a, a, a, a, a, a]);
title('Monte–Carlo');
xlabel('runs with R (Log Scale)');
ylabel('AVG codeword length');
legend('n=10', 'n=50', 'n=100', 'H[X]', 'L-bar');
set(graph, 'linewidth', 3);