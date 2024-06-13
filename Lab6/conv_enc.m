function encoded_data = conv_enc(binary_data, impulse_response)

    impulse_response_size = size(impulse_response);
    output_bit_len = impulse_response_size(1);
    K_size = impulse_response_size(2);
    
    state_num = 2^(K_size - 1);
    fsm_table_height = 2^K_size;
    fsm_table_width = 1 + 1 + output_bit_len + 1;
    fsm_table = zeros(fsm_table_height, fsm_table_width);
    
    for i = state_num + 1 : fsm_table_height
        fsm_table(i) = 1;
    end
    for i = 0 : state_num - 1
        fsm_table(i+1, 2) = i;
        fsm_table(i+1, 2+output_bit_len+1) = floor(i/2);
        fsm_table(i+1+state_num, 2) = i;
        fsm_table(i+1+state_num, 2+output_bit_len+1) = floor((i + 2^(K_size-1)) / 2);
    end
    
    for ALL_index = 1 : fsm_table_height
        for G_index = 1 : output_bit_len
            g = impulse_response(G_index, 1:K_size);

            state_arr = zeros(1, length(g));
            state_arr(1) = fsm_table(ALL_index, 1);

            state_str = dec2bin( fsm_table(ALL_index, 2), K_size-1 );
            for i = 1 : length(state_str)
                state_arr(i+1) = str2num( state_str(i) );
            end
            
            cnt = 0;
            for i = 1 : length(g)
                if g(i) == 1 && state_arr(i) == 1
                    cnt = cnt + 1;
                end
            end
            if mod(cnt, 2) == 1
                fsm_table(ALL_index, 2+G_index) = 1;
            end
        end
    end
    
    LEN = length(binary_data);
    STATE = 0;
    ROw = 0;
    encoded_data = zeros(1, output_bit_len * LEN);
    for i = 1 : LEN
        ROW = 1 + (fsm_table_height/2) * binary_data(i) + STATE;
        for j = 1 : output_bit_len
            encoded_data(output_bit_len * (i-1) + j) = fsm_table(ROW, 2+j);
        end
        STATE = fsm_table(ROW, 2 + output_bit_len + 1);
    end