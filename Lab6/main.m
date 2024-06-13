% % 6-3
% g = semilogy([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], [1, 0.1, 0.01, 0.001, 0.0001, 0.00001, 0.000001, 0.000001, 0.000001, 0.000001], ':');
% set(g,'Visible','off');
% 
% % 6-4
% g = semilogy([0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5], [0.1, 0.01, 0.001, 0.0001, 0.00001, 0.000001, 0.0000001, 0.0000001, 0.0000001, 0.0000001, 0.0000001], ':');
% set(g,'Visible','off');

% ============================================================
% 6 - 1

% bin_seq = [0 0 0 1 1 1 0 0 1 0 1 1 0 1 1 0];
% M = 4; % PAM PSK: 2/4/8/16 QAM: 4/16/64
% d = 2*25^(1/2);
% name = 'QAM'; % 'PAM / PSK / QAM'
% sym_seq = symbol_mapper(bin_seq, M, d, name);
% reconstruct = MD_symbol_demapper(sym_seq, M, d, name);
% 
% error('stop here !')

% ============================================================
% 6 - 2

len = 10000;
bi = randi([0 1],1,len);
% bi

M = 4;
l = log2(M);
d = 1;
name = 'QAM';
ui = symbol_mapper(bi, M, d, name);

% ===================================
% ori_1 = [];
% ori_2 = [];
% for i = 1 : length(ui)/2
%     ori_1(end+1) = ui(2*i-1);
%     ori_2(end+1) = ui(2*i);
% end
%     
% h = histogram2(ori_1, ori_2, [15,15], 'FaceColor','flat');
% axis([-2, 2, -2, 2]);
% ===================================

% reconstruct = MD_symbol_demapper(ui, M, d, name);
% reconstruct

% histo = histogram2(ui(:, 1), ui(:, 2), 100);

Eb = d^2 / (4 * log2(M) * sin(pi/M)^2);
N0 = Eb/1; % 1, 10, 100
h1 = sqrt(N0/2) * randn(1, len/l);
h2 = sqrt(N0/2) * randn(1, len/l);
% histo = histogram2(h1, h2, 100);

sym_seq = [];
for i = 1 : len/l
%     sym_seq = [ sym_seq; [ ui(2*i-1)+h1(i), ui(2*i)+h2(i) ] ];
    sym_seq(end+1) = ui(2*i-1)+h1(i);
    sym_seq(end+1) = ui(2*i)+h2(i);
end
% histo = histogram2(sym_seq(:, 1), sym_seq(:, 2), 100);

h = histogram2(sym_seq(:, 1), sym_seq(:, 2), [15,15], 'FaceColor','flat');
axis([-2, 2, -2, 2]);

reconstruct = MD_symbol_demapper(sym_seq, M, d, name);
% reconstruct

BError = 0;
for i = 1 : len
    if bi(i) ~= reconstruct(i)
        BError = BError + 1;
    end
end
SError = 0;
for i = 1 : len/l
    for j = 1 : l
        if bi(i*l - l + j) ~= reconstruct(i*l - l + j)
            SError = SError + 1;
            break;
        end
    end
end

BER = BError/len
SER = SError/(len/l)

error('stop here !')

% ============================================================
% 6 - 3

name = 'PAM';
len = 300000;
bi = randi([0 1],1,len);
if name == 'QAM'
    M_List = [4 16 64];
else
    M_List = [2 4 8 16];
end
% l = log2(M);
d = 1;
% ui = symbol_mapper(bi, M, d, name);
% Eb = d^2 / (4 * log2(M) * sin(pi/M)^2);

% **********

for iter = 1 : length(M_List)
    iter
    
    M = M_List(iter);
    l = log2(M);
    a = 'start map'
    ui = symbol_mapper(bi, M, d, name);
    a = 'end map'
%     ====================================================================================================
    if name == 'PAM'
        Eb = d^2 * (M^2-1) / (12*log2(M));
    elseif name == 'PSK'
        Eb = d^2 / (4 * log2(M) * sin(pi/M)^2);
    else
        Eb = d^2 * (M-1) / (6*log2(M));
    end
%     ====================================================================================================
    
    dB_sample = 10;
    range = 10;
    dB_List = zeros(1, dB_sample);
    for i = 1 : dB_sample
        dB_List(i) = i/(dB_sample/range);
    end
    
    SER_List = zeros(1, dB_sample);
    
    b = 'start for'
    for idx = 1 : dB_sample
        N0 = Eb/( 10^( dB_List(idx)/10 ) );

        if name == 'PAM'
             h1 = sqrt(N0/2) * randn(1, len/l);
        else
            h1 = sqrt(N0/2) * randn(1, len/l);
        end
        h2 = sqrt(N0/2) * randn(1, len/l);
        sym_seq = [];
        
        if name == 'PAM'
            for i = 1 : len/l
                sym_seq(end+1) = ui(i)+h1(i);
            end
            
        else
            for i = 1 : len/l
                sym_seq(end+1) = ui(2*i-1)+h1(i);
                sym_seq(end+1) = ui(2*i)+h2(i);
            end
        end
        
        reconstruct = MD_symbol_demapper(sym_seq, M, d, name);
        
        % BError = 0;
        % for i = 1 : len
        %     if bi(i) ~= reconstruct(i)
        %         BError = BError + 1;
        %     end
        % end
        SError = 0;
        for i = 1 : len/l
            for j = 1 : l
                if bi(i*l - l + j) ~= reconstruct(i*l - l + j)
                    SError = SError + 1;
                    break;
                end
            end
        end
        
        SER_List(idx) = SError/(len/l);
    end
    b = 'end for'

    % PSK
    qx = dB_List;
    qin = zeros(1, dB_sample);
    for idx = 1 : dB_sample
%     ====================================================================================================
        if name == 'PAM'
            qin(idx) = sqrt( 6 * log2(M) * (1/(M^2-1)) * 10^(dB_List(idx)/10) );
        elseif name == 'PSK'
            qin(idx) = sqrt( 2 * log2(M) * sin(pi/M)^2 * 10^(dB_List(idx)/10) );
        else
            qin(idx) = sqrt( 3 * log2(M) * (1/(M-1)) * 10^(dB_List(idx)/10) );
        end
%     ====================================================================================================
    end
    qy = qfunc(qin);
    for idx = 1 : dB_sample
%     ====================================================================================================
        if name == 'PAM'
            qy(idx) = 2 * qy(idx); % * ( (M-1)/M );
        elseif name == 'PSK'
            qy(idx) = 2 * qy(idx);
        else
            qy(idx) = 4 * qy(idx);
        end
%     ====================================================================================================
    end

%     ====================================================================================================
    if name == 'PAM'
        hold on
        if M == 2
            graph = semilogy(qx, qy, '--x');
        else
            graph = semilogy(qx, qy);
        end
        set(graph, 'linewidth');
        graph = semilogy(dB_List, SER_List, 'o');
        set(graph, 'linewidth');

        title('SER for PAM');

        xlabel('Eb/N0 (dB)');
        ylabel('SER');
        
    elseif name == 'PSK'
        hold on
        if M == 2
            graph = semilogy(qx, qy, '--x');
        else
            graph = semilogy(qx, qy);
        end
        set(graph, 'linewidth');
        graph = semilogy(dB_List, SER_List, 'o');
        set(graph, 'linewidth');

        title('SER for PSK');

        xlabel('Eb/N0 (dB)');
        ylabel('SER');
        
    else

        hold on
        graph = semilogy(qx, qy);
        set(graph, 'linewidth');
        graph = semilogy(dB_List, SER_List, 'o');
        set(graph, 'linewidth');

        title('SER for QAM');

        xlabel('Eb/N0 (dB)');
        ylabel('SER');
        
    end
    
%     ====================================================================================================
    
end

%     ====================================================================================================
if name == 'PAM'
    legend( '.....', 'Theor-2', 'Simul-2', 'Theor-4', 'Simul-4', 'Theor-8', 'Simul-8', 'Theor-16', 'Simul-16' ); legend( 'location', 'southwest' );
elseif name == 'PSK'
    legend( '.....', 'Theor-2', 'Simul-2', 'Theor-4', 'Simul-4', 'Theor-8', 'Simul-8', 'Theor-16', 'Simul-16' ); legend( 'location', 'southwest' );
else
    legend( '.....', 'Theor-4', 'Simul-4', 'Theor-16', 'Simul-16', 'Theor-64', 'Simul-64' ); legend( 'location', 'southwest' );
end
%     ====================================================================================================

% **********

% BER = BError/len
% SER = SError/(len/l)

error('stop here !')



% ============================================================
%  6 - 4

impulse_response = [1, 0, 1; 1, 1, 1];

name = 'PSK';
M = 2;
l = log2(M);
d = 1;
len = 300000;

dB_List = [];
hard_List = [];

dB_List(end+1) = 0;
for i = 1 : 10
    dB_List(end+1) = i/2;
end

for i = 1 : 11
    
    bi = randi([0 1],1,len); % len
    
    encoded_data = conv_enc(bi, impulse_response); % 2 * len
    
    ui = symbol_mapper(encoded_data, M, d, name); % 4 * len
    
    Eb = d^2 / (4 * log2(M) * sin(pi/M)^2);
    N0 = Eb/( 10^( dB_List(i)/10 ) );
    h1 = sqrt(N0/2) * randn(1, 2*len/l);
    h2 = sqrt(N0/2) * randn(1, 2*len/l);
    sym_seq = [];

    for i = 1 : 2*len/l
        sym_seq(end+1) = ui(2*i-1)+h1(i);
        sym_seq(end+1) = ui(2*i)+h2(i);
    end
    
    ci = MD_symbol_demapper(sym_seq, M, d, name); % 2 * len
    decoded_data = conv_dec(ci, impulse_response); % len
    
    cnt = 0;
    for j = 1 : length(decoded_data)
        if decoded_data(j) ~= bi(j)
            cnt = cnt + 1;
        end
    end
    hard_List(end+1) = cnt/length(decoded_data);

end

hold on
graph = semilogy(dB_List, hard_List, '-');
set(graph, 'linewidth', 2);
title('BER vs. Eb/N0 (BPSK)');
xlabel('Eb/N0 (dB)');
ylabel('BER');
legend( '.....', 'Hard Decoding', 'Soft Decoding'); legend( 'location', 'southwest' );

% ============================================================

impulse_response = [1, 0, 1; 1, 1, 1];

name = 'PAM';
M = 2;
l = log2(M);
d = 1;
len = 300000;

dB_List = [];
soft_List = [];

dB_List(end+1) = 0;
for i = 1 : 10
    dB_List(end+1) = i/2;
end

for i = 1 : 11
    
    bi = randi([0 1],1,len); % len
%     bi
    
    encoded_data = conv_enc(bi, impulse_response); % 2 * len
%     encoded_data
    
    ui = symbol_mapper(encoded_data, M, d, name); % 2 * len
%     ui
    
    Eb = d^2 * (M^2-1) / (12*log2(M));
    N0 = Eb/( 10^( dB_List(i)/10 ) );
    h1 = sqrt(N0/2) * randn(1, 2*len/l);
    sym_seq = [];

    for i = 1 : 2*len/l
        sym_seq(end+1) = ui(i)+h1(i);
    end
    
%     sym_seq
    
    decoded_data = conv_dec_Eu(sym_seq, impulse_response); % len
%     decoded_data
    
%     error('stop')
    
    cnt = 0;
    for j = 1 : length(decoded_data)
        if decoded_data(j) ~= bi(j)
            cnt = cnt + 1;
        end
    end
    soft_List(end+1) = cnt/length(decoded_data);

end

hold on
graph = semilogy(dB_List, soft_List, '-');
set(graph, 'linewidth', 2);
title('BER vs. Eb/N0 (BPSK)');
xlabel('Eb/N0 (dB)');
ylabel('BER');
legend( '.....', 'Hard Decoding', 'Soft Decoding'); legend( 'location', 'southwest' );
