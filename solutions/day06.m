function [t,solution1,solution2] = day06(verbose)
%DAY06  Solve day 6 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/12
% 
% --- Day 6: Lanternfish ---
% Problem URL : https://adventofcode.com/2021/day/6
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 6;
input_data_str = fetch_input(d);
tic;
input_data = format_data(input_data_str);
t_format = toc;


%% SOLVING
tic;

% The trick here is only to keep track of the population by their internal
% timers and not trying to represent each individuals in an array (memory
% problem)

% Solution 1
% Identify initial population by internal timers
population = sum(input_data == (0:8)); 
for k=1:80
    population = pass_day(population);
end
solution1 = sum(population);

% Solution 2
for k=81:256
    population = pass_day(population);
end
solution2 = sum(population);

t_end = toc;
%% LOGS
if verbose
    print_solution(d,solution1,solution2);
    print_elapsed_time(t_format,t_end)
end

t = [t_format;t_end];

if nargout == 0
    clear solution1 solution2 t
end
%% HELPER FUNCTIONS
function [data] = format_data(data_str)
    data = str2double(split(data_str,','));
end

function [population] = pass_day(population)
    % Pass one day given a population identified by their internal timer
    pop0 = population(1); % population of internal timer 0
    population = circshift(population,-1);
    population(7) = population(7)+pop0; % reset internal timer to 6
end

end