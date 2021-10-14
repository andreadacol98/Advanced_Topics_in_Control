function [x_k_P , y_k_P ] = P_rand_stubborn(n , p , t_end , x_0_stubborn, n_selfish , n_stubborn, ref , A_sequence, topology_stubborn, complete, Kp);

%Function giving the following output of a P-controlled system with global or myopic
%visibility, using the random sequence of i.i.d. matrices
% - plot of opinion dynamics in the P-controlled system
% - opinion values evolution, subject to saturation at 1 and 0
% - stubborn agents (= malicious nodes)
% - network average evolution

y_k_P = zeros(n_selfish , t_end+1);

% Reference sequence (for plots)
ref_seq = mean(x_0_stubborn) * ones(t_end+1 , 1);

% State-Space Representation 
A_P_sequence = zeros(n+n_stubborn , n+n_stubborn , t_end);
B = [eye(n_selfish) ; zeros(n - n_selfish + n_stubborn , n_selfish)];
C= zeros(n_selfish , length(x_0_stubborn));

if complete
    C = (1/n)*[ones(n_selfish , n + n_stubborn)];
else
    sum_rows = diag(sum(topology_stubborn , 2));
    C = (inv(sum_rows) * topology_stubborn);
    C = C(1:n_selfish , :);
end

% Definition of variables for storage of the augmented state evolution and the Measurements
% evolution
x_k_P = zeros(n+n_stubborn , t_end+1);
y_k_P = zeros(n_selfish , t_end+1);
x_k_P(: , 1) = x_0_stubborn;
y_k_P(: , 1) = C * x_0_stubborn;

% Building the sequence of state matrices for PI-Controlled Closed Loop 
for k  = 1:t_end
    A_P_sequence(: , : , k) = A_sequence(: , : , k)-B*Kp*C ;
    x_k_P(: , k+1) = A_P_sequence(: , : , k) * x_k_P(: , k) + B*Kp*ref;
    y_k_P(: , k+1) = C * x_k_P(: , k+1);
end

%Plotting opinion Dynamics
figure(101) ;  hold on;
plot(0:1:t_end , x_k_P(1:n_selfish ,:) ,  'LineWidth' , 1.5); hold on;
% plot(0:1:t_end, x_k_P(n_selfish+1 ,:),  'LineWidth' , 1.5);
plot(0:1:t_end, x_k_P(n+1:end ,:),  'LineWidth' , 1.5);
plot(0:1:t_end , y_k_P(: ,:) , 'LineWidth' , 1.5);
plot(0:1:t_end , mean(x_k_P , 1) , 'LineWidth' , 1.5);
plot(0:1:t_end, ref_seq, 'k -.' , 'MarkerSize' , 1.1);
% title('No saturation, stubborn agent, Mean reference, P , random sequence');
legend( 'Coordinator 1' ,'Coordinator 2' , 'Malicious Agent' ,'Measurement 1', 'Measurement 2', 'Global Network Average' , 'Reference' , 'Location' , 'SouthEast');
pbaspect([1.5 1 1]);
xlabel('Time (k)');
ylabel('Opinion');
axis([-Inf Inf -Inf Inf]);
hold off;

end

