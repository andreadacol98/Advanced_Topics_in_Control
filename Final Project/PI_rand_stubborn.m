% PI random stubborn

function [x_k_PI , y_k_PI] = PI_rand_stubborn(n , p , t_end , x_0_stubborn , n_selfish , n_stubborn, ref , A_sequence_stubborn , topology_stubborn , complete , Kp , Ki)

% We are checking if the controller works when using the random sequence of
% i.i.d. matrices intead of their expected value

%Function giving the following output of a PI-controlled system with
%global/myopic visibility:
% - plot of opinion dynamics in the PI-controlled system
% - opinion values evolution
% - stubborn agents (= malicious nodes)
% - network average evolution

% Reference sequence (for plots)
ref_seq = mean(x_0_stubborn) * ones(t_end+1 , 1);

% State-Space Representation 
A_PI_sequence = zeros(n+n_selfish+n_stubborn , n+n_selfish+n_stubborn , t_end);
B = [eye(n_selfish) ; zeros(n + n_stubborn - n_selfish , n_selfish)];

if complete
    C = (1/n)*ones(n_selfish , n + n_stubborn);
else
    sum_rows = diag(sum(topology_stubborn , 2));
    C = sum_rows \ topology_stubborn;
    C = C(1:n_selfish , :);
end

% Definition of variables for storage of the augmented state evolution and the Measurements
% evolution
x_0_aug=[x_0_stubborn; zeros(n_selfish,1)];
x_k_PI = zeros(n + n_selfish + n_stubborn, t_end+1);
y_k_PI = zeros(n_selfish , t_end+1);
x_k_PI(: , 1) = x_0_aug;
y_k_PI(: , 1) = C*x_0_stubborn;

% Building the sequence of state matrices for PI-Controlled Closed Loop 
for k  = 1:t_end
    A_PI_sequence(: , : , k) = [A_sequence_stubborn(: , : , k)-B*Kp*C , B*Ki ; -C , eye(n_selfish)];
    x_k_PI(: , k+1) = A_PI_sequence(: , : , k) * x_k_PI(: , k) + [B*Kp ; eye(n_selfish)]*ref;
    y_k_PI(: , k+1) = C * x_k_PI(1:n+n_stubborn , k+1);
end

%Plotting opinion Dynamics
figure(201) ;  hold on;
plot(0:1:t_end , x_k_PI(1:n_selfish ,:) ,  'LineWidth' , 1.5); hold on;
% plot(0:1:t_end, x_k_PI(n_selfish+1 ,:),  'LineWidth' , 1.5);
plot(0:1:t_end, x_k_PI(n+1 ,:),  'LineWidth' , 1.5);
% plot(0:1:t_end, x_k_PI(n + n_stubborn + 1 ,:),  'LineWidth' , 1.5);
plot(0:1:t_end , y_k_PI , 'LineWidth' , 1.5);
plot(0:1:t_end , mean(x_k_PI(1:n+n_stubborn,:) , 1) , 'LineWidth' , 1.5);
plot(0:1:t_end, ref_seq, 'k -.' , 'MarkerSize' , 1.1);
legend( 'Coordinator' , 'Malicious Agent' ,  'Measurement' , 'Global Network average' , 'Reference', 'Location' , 'SouthEast');
%title('NO saturation, stubborn agent, Mean reference, PI , random sequence');
pbaspect([1.5 1 1]);
xlabel('Time (k)');
ylabel('Opinion');
axis([-Inf Inf -Inf Inf]);
hold off;

end