function dict = huffman_dict(s, p)
    tol = 0.00001;

    symbols = s;
    prob = p;
    used = {'store_used'};
    i_u = 1;
    i_v = 1;

    num = length(prob);
    nxt_row_index = num + 1;
    C = cell(num);
    C = C(:, 1:5);

    for i = 1:num
        C(i, 1) = symbols(i);
        C(i, 2) = {prob(i)};
    end

    array_prob = cell2mat(C(:, 2));
    sort_prob = sort(array_prob);

    while length(sort_prob) > 1
        array_prob = cell2mat(C(:, 2));

        % add u+v node in the list
        prob_u = sort_prob(1);
        prob_v = sort_prob(2);
        index_u = find(abs(array_prob-prob_u) < tol);
        index_v = find(abs(array_prob-prob_v) < tol);
        
        u_find = 0;
        for i = 1:length(index_u)
            for j = 1:length(used)
                if strcmp(char(C(index_u(i), 1)), char(used(j)))
                    i_u = 1;
                    break;
                elseif j == length(used)
                    i_u = index_u(i);
                    used = [used, char(C(i_u, 1))];
                    u_find = 1;
                end
            end
            if u_find == 1
                break;
            end
        end
        
        v_find = 0;
        for i = 1:length(index_v)
            for j = 1:length(used)
                if strcmp(char(C(index_v(i), 1)), char(used(j)))
                    i_v = 1;
                    break;
                elseif j == length(used)
                    i_v = index_v(i);
                    used = [used, char(C(i_v, 1))];
                    v_find = 1;
                end
            end
            if v_find ==1
                break;
            end
        end

        new_name = strcat(char(C(i_v, 1)), char(C(i_u, 1)));
        
        new_prob = double(prob_u + prob_v);
        new_left = i_v;
        new_right = i_u;

        % delete used nodes / add new prob in and sort again
        sort_prob(1) = [];
        sort_prob(1) = [];
        sort_prob(end+1) = double(prob_u + prob_v);
        sort_prob = sort(sort_prob);
        
        C(nxt_row_index, :) = {new_name, new_prob, new_left, new_right, cell2mat(C(1, 5))};
        nxt_row_index = nxt_row_index + 1;
    end

    % handle bits part
    C2 = travel(C, '', nxt_row_index - 1);
    
    dict = C2;