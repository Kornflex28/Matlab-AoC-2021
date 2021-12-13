function [t,solution1,solution2] = day08(verbose)
%DAY08  Solve day 8 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/13
% 
% --- Day 8: Seven Segment Search ---
% Problem URL : https://adventofcode.com/2021/day/8
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 8;
input_data_str = fetch_input(d);
tic;
[patterns, outputs] = format_data(input_data_str);
t_format = toc;


%% SOLVING
tic;

translate_digits(patterns)

% Solution 1
outputs_lengths = cellfun(@length,outputs);
solution1 = sum(outputs_lengths == 2 | outputs_lengths == 3 | ...
                outputs_lengths == 4 | outputs_lengths == 7 , 'all');

% Solution 2

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
function [patterns, output] = format_data(data_str)
    data = strtrim(split(splitlines(data_str),'|'));
    patterns = split(data(:,1));
    output   = split(data(:,2));
end

function translate_digits(patterns)
    patterns1 = flipud(patterns(cellfun(@length,patterns)==2));
    patterns7 = flipud(patterns(cellfun(@length,patterns)==3));
    patterns4 = flipud(patterns(cellfun(@length,patterns)==4));
    patterns8 = flipud(patterns(cellfun(@length,patterns)==7));
    
    segmentsa = cellfun(@setdiff,patterns7,patterns1);
    
end

end