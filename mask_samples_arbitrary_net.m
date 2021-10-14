function [M , average_mask] = mask_samples_arbitrary_net(topology , n , p)
%node i will always sample itself
%node i also randomly samples p nodes from the neighbours

%Find the indexes of neighbouring nodes
neigh = [];
sum_row = zeros(n,1);
sampled_neigh = zeros(n,p);
M = zeros(n);
average_mask = zeros(n);


%defining a matrix of the neighbours of i, excluding the node i itself
for i = 1:n
    neigh = find(topology(i,:));
    len = length(neigh);
    if i==1
        neigh_no_i = [neigh(1, 2:end)];
        sum_row(1 , 1) = length(neigh_no_i);
        for count = 1:length(neigh_no_i)
           average_mask(1 , neigh_no_i(1, count)) = p/sum_row(1 , 1);
        end
        sampled_neigh(1,:) = neigh_no_i( randperm(length(neigh_no_i) , p));
        sampled_neigh_sort(1,:) = sort(sampled_neigh(1,:));
        for counter = 1:p
                M(1 , sampled_neigh_sort(1 , counter)) = 1;
        end
        
    elseif (i>1 & i<n)
        checkpoint = find(neigh==i);
        if checkpoint==1
            neigh_no_i = [neigh(1, 2:end)];
        elseif (checkpoint>1 & checkpoint<length(neigh))
            neigh_no_i = [neigh(1, 1:checkpoint-1) , neigh(1,checkpoint+1 : end)];
        else
            neigh_no_i = [neigh(1, 1:end-1)];
        end
        
        sum_row(i , 1) = length(neigh_no_i);
        for count = 1:length(neigh_no_i)
           average_mask(i , neigh_no_i(1, count)) = p/(sum_row(i,1));
        end
        
        sampled_neigh(i,:) = neigh_no_i( randperm(length(neigh_no_i) , p));
        sampled_neigh_sort(i,:) = sort(sampled_neigh(i,:));
        for counter = 1:p
                M(i , sampled_neigh_sort(i , counter)) = 1;
        end
        
    else
        neigh_no_i = [neigh(1, 1:end-1)];
        sum_row(n , 1) = length(neigh_no_i);
        for count = 1:length(neigh_no_i)
           average_mask(n , neigh_no_i(1, count)) = p/(sum_row(n,1));
        end
        sampled_neigh(n,:) = neigh_no_i( randperm(length(neigh_no_i) , p));
        sampled_neigh_sort(n,:) = sort(sampled_neigh(n,:));
        for counter = 1:p
                M(n , sampled_neigh_sort(n , counter)) = 1;
        end
        
    end
end
M = M+eye(n);
average_mask = average_mask + eye(n);


end

