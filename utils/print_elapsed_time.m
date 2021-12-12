function [] = print_elapsed_time(elapsed1,elapsed2)
%PRINT_ELAPSED_TIME Print elapsed time in seconds.
fprintf('Elapsed time:\n\t%.6f seconds for formating input\n\t%.6f seconds for solving problem\nTotal elapsed time is %.6f seconds\n',elapsed1,elapsed2,elapsed1+elapsed2);
end

