function [M] = mask_samples(n, p)

% Defining the Time Varing Random Matrix {A(k)} sequence
% The Mask M(k) says if a node j has been sampled by node i
M = zeros(n);

% The nodes on the diagonal are always sampled, thus we will sample only
% the remaining nodes (p nodes will be sampled out of a gruop of n-1)

vec = 1:1:n;
for i=1:n
    row = zeros(1,n);
    if(i == 1)
        vec(vec==i) = [];
    else
        vec(vec==i) = i-1;
    end
    idx = randperm(n-1); %random permutation of integers up to n-1
    index = idx(1:p); %selecting first p integers
    row(vec(index)) = 1; %setting corresponding indeces to 1
    M(i,:) = row;
end
M = M + eye(n);


end

