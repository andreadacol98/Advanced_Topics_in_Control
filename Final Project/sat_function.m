function y = sat_function(x)

y = zeros(length(x) , 1);

for i = 1:length(x)
    if x(i)>1
        y(i) = 1;
    elseif x(i)<0
        y(i) = 1;
    else
        y(i) = x(i);
    end
end

%y = min(max(x, 0), 1);
    
end


