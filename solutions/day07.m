function [t,solution1,solution2] = day07(verbose)
%DAY07  Solve day 7 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/13
% 
% --- Day 7: The Treachery of Whales ---
% Problem URL : https://adventofcode.com/2021/day/7
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 7;
input_data_str = fetch_input(d);
tic;
input_data = format_data(input_data_str);
t_format = toc;


%% SOLVING
tic;

% Solution 1
best_position1 = median(input_data);
solution1 = get_cost1(input_data,best_position1);

% Solution 2
best_position2 = round(fminsearch(@(x) get_cost2(input_data,x),mean(input_data)));
solution2 = get_cost2(input_data,best_position2);

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

function [cost] = get_cost1(positions,target)
   % Get simple fuel cost
   cost = sum(abs(positions-target)) ;
end

function [cost] = get_cost2(positions,target)
   % Get second fuel cost using sum(i,1,n) = .5*n*(n+1)
   cost = sum(.5*abs(positions-target).*(abs(positions-target)+1)) ;
end

end