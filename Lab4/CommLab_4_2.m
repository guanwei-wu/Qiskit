function dict = huff
symbols = { 's0', 's1', 's2', 's3', 's4' };
    prob = [ 0.26, 0.25, 0.20, 0.15, 0.14 ];

    num = length(prob);
    nxt_row_index = num + 1;
    C = cell(num);

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
        index_u = find(array_prob==prob_u);
        index_v = find(array_prob==prob_v);

        new_name = strcat(char(C(index_v(1), 1)), char(C(index_u(1), 1)));
        new_prob = prob_u + prob_v;
        new_left = index_v(1);
        new_right = index_u(1);

        % delete used nodes / add new prob in and sort again
        sort_prob(1) = [];
        sort_prob(1) = [];
        sort_prob(end+1) = prob_u + prob_v;
        sort_prob = sort(sort_prob);

        C(nxt_row_index, :) = {new_name, new_prob, new_left, new_right, cell2mat(C(1, 5))};
        nxt_row_index = nxt_row_index + 1;
    end

    % handle bits part
    C2 = travel(C, '', nxt_row_index - 1);