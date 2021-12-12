function [t,solution1,solution2] = day01(verbose)
%DAY01  Solve day 1 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/11
% 
% --- Day 1: Sonar Sweep ---
% Problem URL : https://adventofcode.com/2021/day/1
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 1;
input_data_str = fetch_input(d);
tic;
input_data = format_data(input_data_str);
t_format = toc;

%% SOLVING
tic;
% Solution 1
solution1 = sum(diff(input_data)>0);

% Solution 2
movsum3 = movsum(input_data,3,'Endpoints','discard');
solution2 = sum(diff(movsum3)>0);

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
function data = format_data(data_str)
    data = str2double(splitlines(data_str));
end
end