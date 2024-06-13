binary_data = [1 0 1 1 0];
impulse_response = [1, 0, 0; 1, 0, 1; 1, 1, 1];
encoded_data = conv_enc(binary_data, impulse_response);

binary_data = [0 1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 1 1 0 0 0];
decoded_data = conv_dec(binary_data, impulse_response);

% encoded_data
% decoded_data

binary_data = [0 0 1 1 0 1 0 0 0 1 0 1 0 0];
impulse_response = [1, 0, 1; 1, 1, 1];
decoded_data = conv_dec(binary_data, impulse_response);
decoded_data

% ============================================================

r = randi([0 1],1,120000);
encoded_data = conv_enc(r, impulse_response);

p = randi([0 9],1,360000);

for i = 1 : 360000
    if p(i) <= 9
        if encoded_data(i) == 0
            encoded_data(i) = 1;
        else
            encoded_data(i) = 0;
        end
    end
end

decoded_data = conv_dec(encoded_data, impulse_response);

cnt = 0;
for i = 1 : 120000
    if r(i) ~= decoded_data(i)
        cnt = cnt + 1;
    end
end

cnt / 120000

% ============================================================

impulse_response = [1, 1, 0; 1, 0, 1];
r = randi([0 1],1,120000);
encoded_data = conv_enc(r, impulse_response);

p = randi([0 9],1,240000);

for i = 1 : 240000
    if p(i) <= 9
        if encoded_data(i) == 0
            encoded_data(i) = 1;
        else
            encoded_data(i) = 0;
        end
    end
end

decoded_data = conv_dec(encoded_data, impulse_response);

cnt = 0;
for i = 1 : 120000
    if r(i) ~= decoded_data(i)
        cnt = cnt + 1;
    end
end

cnt / 120000