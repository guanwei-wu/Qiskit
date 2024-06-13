function [C2] = travel(C, text, here)

    C2 = C;

    l = cell2mat(C2(here, 3));
    C2(l, 5) = cellstr(strcat(text, '0'));
    
    if cell2mat(C2(here, 3)) > 0
        C2 = travel(C2, strcat(text, '0'), l);
    end
    
    r = cell2mat(C2(here, 4));
    C2(r, 5) = cellstr(strcat(text, '1'));
    
    if cell2mat(C2(here, 4)) > 0
        C2 = travel(C2, strcat(text, '1'), r);
    end
    
end