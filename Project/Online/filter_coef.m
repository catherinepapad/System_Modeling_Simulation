function coefficients = filter_coef(filter_order) 
%filter polynomial coefficients P(s+i) for i=1,..,n

if filter_order == 1
    coefficients = 1;
elseif filter_order == 2 
    coefficients = [3 2];
elseif filter_order == 3
    coefficients = [6 11 6];
elseif filter_order == 4
    coefficients = [10 35 50 24];
elseif filter_order == 5
    coefficients = [15 85 225 274 120];
end

end