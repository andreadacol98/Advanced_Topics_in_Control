function [topology , sum_row , Irreducibility] = gen_graph2(n,p)
%Generate underlying topology like:
% - self loops
% - at least p+1 out neighbours, including himself
% - symmetric
% - connected
topology = zeros(n);
for i = 1 : n
    row = zeros(1,n);
    neighbors = randi([p+1 n/4]);
    indexes = randperm(n,neighbors);
    row(indexes) = 1;
    topology(i,:) = row;   
end

topology = topology - tril(topology,-1) + triu(topology,1)'; % Building a binary simmetric matrix

% Introducing self loops
for i=1:n
    if topology(i,i) == 0
        topology(i,i) =1;
    end
end
   
end

