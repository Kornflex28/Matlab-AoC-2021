function [t,solution1,solution2] = day12(verbose)
%DAY12  Solve day 12 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/17
% 
% --- Day 12: Passage Pathing ---
% Problem URL : https://adventofcode.com/2021/day/12
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 12;
input_data_str = fetch_input(d);
tic;
[input_data] = format_data(input_data_str);
t_format = toc;


%% SOLVING
tic;
[caves_matrix,caves_name,is_big_caves] = get_caves_matrix(input_data);
start_ind = caves_name('start');
end_ind   = caves_name('end');

% Solution 1
all_paths1 = explore1(caves_matrix,start_ind,[],is_big_caves,start_ind,end_ind);
solution1 = sum(all_paths1 == start_ind);

% Solution 2
all_paths2 = explore2(caves_matrix,start_ind,[],is_big_caves,start_ind,end_ind);
solution2 = sum(all_paths2 == start_ind);


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
    data = split(splitlines(strtrim(data_str)),'-');
end

function [caves_matrix,caves_name,is_big_caves] = get_caves_matrix(caves)
    % Generate graph matrix and indices of big caves
    caves_name = unique(caves);
    nrow = length(caves_name);
    caves_name = containers.Map(caves_name,1:nrow);
    is_big_caves = strcmp(upper(caves_name.keys),caves_name.keys);
    caves_matrix = false(nrow);
    nedge = size(caves,1);
    for kedge=1:nedge
        caves_matrix(caves_name(caves{kedge,1}),caves_name(caves{kedge,2})) = true;
        caves_matrix(caves_name(caves{kedge,2}),caves_name(caves{kedge,1})) = true;
    end
end

function [new_visited] = explore1(caves_matrix,to_visit_ind,visited_ind,is_big_caves,start_ind,end_ind)
    % Performs a DFS to find paths from start_ind to end_end visiting small
    % caves only one time
    paths = [];
    new_visited = [visited_ind to_visit_ind];
    if to_visit_ind == end_ind
        return
    else
        for next_ind=find(caves_matrix(to_visit_ind,:))
            if next_ind ~=start_ind
                if ~ismember(next_ind,visited_ind) || is_big_caves(next_ind)
                    temp_path = explore1(caves_matrix,next_ind,new_visited,is_big_caves,start_ind,end_ind);
                    paths = [paths temp_path];
                end
            end
        end
        new_visited = paths;
    end
end

function [new_visited] = explore2(caves_matrix,to_visit_ind,visited_ind,is_big_caves,start_ind,end_ind)
    % Performs a DFS to find paths from start_ind to end_end visiting small
    % caves only one time (or one twice)
    paths = [];
    new_visited = [visited_ind to_visit_ind];
    if to_visit_ind == end_ind
        return
    else
        for next_ind=find(caves_matrix(to_visit_ind,:))
            if next_ind ~=start_ind
                if is_big_caves(next_ind)
                    temp_path = explore2(caves_matrix,next_ind,new_visited,is_big_caves,start_ind,end_ind);
                    paths = [paths temp_path];
                else
                    visited_small_caves = new_visited(ismember(new_visited,find(~is_big_caves)));
                    small_cave_visited_twice = any(sum(visited_small_caves==visited_small_caves')>1);
                    if ( small_cave_visited_twice && (sum(new_visited == next_ind) < 1)) ||...
                       (~small_cave_visited_twice && (sum(new_visited == next_ind) < 2))
                        temp_path = explore2(caves_matrix,next_ind,new_visited,is_big_caves,start_ind,end_ind);
                        paths = [paths temp_path];
                    end
                end
            end
        end
    end
    new_visited = paths;
end

end