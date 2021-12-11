function [solution1,solution2] = day1()
%DAY1  Solve day 1 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/11
% 
% --- Day 1: Sonar Sweep ---
% Problem URL : https://adventofcode.com/2021/day/1
%

%% GET INPUT
tic
d = 1;
input_data_str = fetch_input(d);
input_data = format_data(input_data_str);

%% SOLVING

% Solution 1
solution1 = sum(diff(input_data)>0);

% Solution 2
movsum3 = movsum(input_data,3,'Endpoints','discard');
solution2 = sum(diff(movsum3)>0);

%% LOGS
print_solution(d,solution1,solution2);

if nargout < 2 
    clear solution1 solution2
end
toc
%% HELPER FUNCTIONS
function data = format_data(data_str)
    data = str2double(splitlines(data_str));
end
end