function [t,solution1,solution2] = day15(verbose)
%DAY15  Solve day 15 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/18
% 
% --- Day 15: Chiton ---
% Problem URL : https://adventofcode.com/2021/day/15
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 15;
input_data_str = fetch_input(d);
tic;
[input_data] = format_data(input_data_str);
t_format = toc;


%% SOLVING
tic;

% Solution 1

[~, solution1] = get_lowest_risk_path(input_data);

% Solution 2
[~, solution2] = get_lowest_risk_path(create_full_map(input_data, 5));

t_end = toc;
%% LOGS
if verbose
    print_solution(d,double(solution1),double(solution2));
    print_elapsed_time(t_format,t_end);
end

t = [t_format;t_end];

if nargout == 0
    clear solution1 solution2 t
end
%% HELPER FUNCTIONS
function [data] = format_data(data_str)
    data = split(splitlines(strtrim(data_str)),'');
    data = str2double(data(:,2:end-1));
end

function [lowest_path, lowest_risk] = get_lowest_risk_path(data)
    [nrow,ncol] = size(data);
    [start_nodes_str, end_nodes_str, weights] = create_nodes(data);
    G = digraph(start_nodes_str, end_nodes_str, weights);
    [lowest_path, lowest_risk] = shortestpath(G, '1,1', [num2str(ncol) ',' num2str(nrow)]);
end

function [start_nodes_str, end_nodes_str, weights] = create_nodes(data)

    [nrow,ncol] = size(data);
    start_nodes_str = string.empty; 
    end_nodes_str   = string.empty; 
    weights         = single.empty;

    for krow = 1:nrow
        for kcol = 1:ncol
            if krow > 1
                start_nodes_str(end+1) = krow + "," + kcol;
                end_nodes_str(end+1) = (krow-1) + "," + kcol;
                weights(end+1) = data(krow-1, kcol);
            end
            if kcol < ncol
                start_nodes_str(end+1) = krow + "," + kcol;
                end_nodes_str(end+1) = krow + "," + (kcol+1);
                weights(end+1) = data(krow, kcol+1);
            end
            if krow < nrow
                start_nodes_str(end+1) = krow + "," + kcol;
                end_nodes_str(end+1) = (krow+1) + "," + kcol;
                weights(end+1) = data(krow+1, kcol);
            end
            if kcol > 1
                start_nodes_str(end+1) = krow + "," + kcol;
                end_nodes_str(end+1) = krow + "," + (kcol-1);
                weights(end+1) = data(krow, kcol-1);
            end
        end
    end
end

function [full_map] = create_full_map(map, n)
    [nrow,ncol] = size(map);
    full_map = repmat(map, n);
    for i = 1:(n*nrow)
        for j = 1:(n*ncol)
            full_map(i,j) = full_map(i,j) + floor((i-1)/nrow) + floor((j-1)/ncol);
            if full_map(i,j) > 9
                full_map(i,j) = max(1, rem(full_map(i,j), 9));
            end
        end
    end
end

end