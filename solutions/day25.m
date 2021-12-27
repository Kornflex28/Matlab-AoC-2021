function [t,solution1,solution2] = day25(verbose)
%DAY22  Solve day 25 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/27
% 
% --- Day 25: Sea Cucumber ---
% Problem URL : https://adventofcode.com/2021/day/25
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 25;
input_data_str = fetch_input(d);
tic;
[map] = format_data(input_data_str);
t_format = toc;

%% SOLVING
tic;

% Solution 1
[nrow,~] = size(map);
is_stable = false;
solution1 = 0;
while ~is_stable
    previous_map = map;

    % East herds
    map(:,end+1) = map(:,1);
    east_herds = find(map=='>');
    map(:,end+1) = map(:,2);
    east_herds_moving = east_herds(map(east_herds+nrow)=='.');

    map(east_herds_moving+nrow) = '>';
    map(east_herds_moving) = '.';
    map(:,1) = map(:,end-1);
    map(:,end-1:end) = [];

    % South herds
    map(end+1,:) = map(1,:);
    [south_herds_rows,south_herds_cols] = find(map=='v');
    map(end+1,:) = map(2,:);
    south_herds = sub2ind(size(map),south_herds_rows,south_herds_cols);
    south_herds_moving = south_herds(map(south_herds+1) == '.');

    map(south_herds_moving++1) = 'v';
    map(south_herds_moving) = '.';
    map(1,:) = map(end-1,:);
    map(end-1:end,:) = [];
    
    solution1 = solution1+1;
    is_stable = isequal(previous_map,map);
end

% Solution 2
solution2 = 'No part 2 for this day !';

t_end = toc;
%% LOGS
if verbose
    print_solution(d,solution1,solution2);
    print_elapsed_time(t_format,t_end);
end

t = [t_format;t_end];

if nargout == 0
    clear solution1 solution2 t
end
%% HELPER FUNCTIONS
function [input_data] = format_data(data_str)
    input_data = char(split(data_str));
end

end