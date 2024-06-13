function decoded_data = conv_dec(binary_data, impulse_response)
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
    
    table_height = state_num;
    table_width = length(binary_data) / output_bit_len + 1;
    
    %cost_table = zeros(table_height, table_width);
    %pre_table = zeros(table_height, table_width);
    %pre_table = pre_table - 1;
    %pre_table(1, 1) = 1; % state_00 = 1 ; state_01 = 2 ; ...
    
    V_table = zeros(table_height, table_width);
    V_table = V_table + 999999;
    V_table(1, 1) = 0;
    s_table = zeros(table_height, table_width);
    s_table = s_table - 1;
    
    zero_pad = K_size - 1;
    
    for W = 1 : table_width - 1 - zero_pad
        for H = 1 : table_height
            if V_table(H, W) ~= 999999
                
                STATE = H;
                
                % '0' path
                ROW = STATE;
                out_arr = zeros(1, output_bit_len);
                for i = 1 : output_bit_len
                    out_arr(i) = fsm_table(ROW, 2+i);
                end
                
                TMPA = fsm_table(ROW, 2+output_bit_len+1) + 1;
                
                % ++++++++++++++++++++++++++++++++++++++++++++++++++
                d = 0;
                for i = 1 : output_bit_len
                    if out_arr(i) == 0
                        change = 0.5;
                    else
                        change = -0.5;
                    end
                    d = d + abs ( binary_data( (W-1)*output_bit_len + i ) - change );
                end
                % ++++++++++++++++++++++++++++++++++++++++++++++++++
                
                if V_table(ROW, W) + d < V_table(TMPA, W+1)
                    V_table(TMPA, W+1) = V_table(ROW, W) + d;
                    s_table(TMPA, W+1) = ROW;
                end
                
                % ==========
                
                % '1' path
                ROW = 2^(K_size-1) + STATE;
                out_arr = zeros(1, output_bit_len);
                for i = 1 : output_bit_len
                    out_arr(i) = fsm_table(ROW, 2+i);
                end
                
                TMPB = fsm_table(ROW, 2+output_bit_len+1) + 1;
                
                % ++++++++++++++++++++++++++++++++++++++++++++++++++
                d = 0;
                for i = 1 : output_bit_len
                    if out_arr(i) == 0
                        change = 0.5;
                    else
                        change = -0.5;
                    end
                    d = d + abs ( binary_data( (W-1)*output_bit_len + i ) - change );
                end
                % ++++++++++++++++++++++++++++++++++++++++++++++++++
                
                if V_table(ROW - 2^(K_size-1), W) + d < V_table(TMPB, W+1)
                    V_table(TMPB, W+1) = V_table(ROW - 2^(K_size-1), W) + d;
                    s_table(TMPB, W+1) = ROW - 2^(K_size-1);
                end
                
            end
        end
    end
    
    
    % zero padding
    for W = table_width - zero_pad : table_width-1
        for H = 1 : table_height
            if V_table(H, W) ~= 999999
                
                STATE = H;
                
                % '0' path
                ROW = STATE;
                out_arr = zeros(1, output_bit_len);
                for i = 1 : output_bit_len
                    out_arr(i) = fsm_table(ROW, 2+i);
                end
                
                TMPA = fsm_table(ROW, 2+output_bit_len+1) + 1;
                
                d = 0;
                for i = 1 : output_bit_len
                    if out_arr(i) ~= binary_data( (W-1)*output_bit_len + i )
                        d = d + 1;
                    end
                end
                
                if V_table(ROW, W) + d < V_table(TMPA, W+1)
                    V_table(TMPA, W+1) = V_table(ROW, W) + d;
                    s_table(TMPA, W+1) = ROW;
                end     
            end
        end
    end
    
%     fsm_table
%     V_table
%     s_table
    
    c_decoded_data = zeros(1, length(binary_data));
    decoded_data = zeros( 1, length(binary_data)/output_bit_len );
    
    DLEN = length(c_decoded_data);
    curr_state = 1;
    last_state = s_table(1, table_width);
    
    index = DLEN;
    idx = length(decoded_data);
    
    while index > 0
        for i = 0 : 1
            if fsm_table(last_state + i*2^(K_size - 1), fsm_table_width) + 1 == curr_state
                for j = 1 : output_bit_len
                    c_decoded_data(index) = fsm_table(last_state + i*2^(K_size - 1), 2+(output_bit_len-j+1));
                    index = index - 1;
                end
                decoded_data(idx) = i;
                idx = idx - 1;
            end
        end
        curr_state = last_state;
        last_state = s_table(last_state, index/output_bit_len + 1);
    end
    
    % c_decoded_data
    
    % decoded_data
    
%     match = 1;
%     
%     for i = 1 : length(decoded_data)
%         for j = 1 : fsm_table_height / 2
%             match = 1;
%             for k = 1 : output_bit_len
%                 if fsm_table(j, 2+k) ~= c_decoded_data((i-1)*output_bit_len + k)
%                     match = 0;
%                     break;
%                 end
%             end
%             if match == 1
%                 break;
%             end
%         end
%         if match == 1
%             decoded_data(i) = 0;
%         else
%             decoded_data(i) = 1;
%         end
%     end