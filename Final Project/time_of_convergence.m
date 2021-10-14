function min_time_step = time_of_convergence(reference, tolerance,mean_sequence,t_end)

min_time_step = t_end+1;
first = true;

for i=1:t_end+1
    if ((abs(mean_sequence(i) - reference) < tolerance) & first)
        min_time_step = i;
        first = false;
    end
    if abs(mean_sequence(i) - reference) > tolerance
        min_time_step = t_end+1;
        first = true;
    end

end

end