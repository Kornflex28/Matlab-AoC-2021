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
[cave_risk_map] = format_data(input_data_str);
t_format = toc;


%% SOLVING
tic;

% Solution 1
solution1 = get_lowest_risk(cave_risk_map,1,numel(cave_risk_map));

% Solution 2
full_cave_map = create_full_map(cave_risk_map,5);
solution2 = get_lowest_risk(full_cave_map,1,numel(full_cave_map));

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
function [data] = format_data(data_str)
    data = split(splitlines(strtrim(data_str)),'');
    data = str2double(data(:,2:end-1));
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

function [lowest_risk] = get_lowest_risk(cave_risk_map,start_node,end_node)
  [nrow, ncol] = size(cave_risk_map);

  [neighbour_rows, neighbour_cols] = meshgrid(1:nrow, 1:ncol);
  neighbour_rows = neighbour_rows(:) + [0, 0, -1, 1];
  neighbour_cols = neighbour_cols(:) + [-1, 1, 0, 0];
  
  valid_nodes = neighbour_cols >= 1 & ...
                neighbour_cols <= nrow & ...
                neighbour_rows >= 1 & ...
                neighbour_rows <= ncol;

  nodes_1 = (neighbour_rows(:) - 1) * nrow + neighbour_cols(:);
  nodes_2 = repmat((1:nrow*ncol)', 4, 1);
  risks = repmat(cave_risk_map(:), 4, 1);
  
  sparsed_cave_risk_map = sparse(nodes_1(valid_nodes), nodes_2(valid_nodes), risks(valid_nodes));
  lowest_risk = sum(cave_risk_map(shortestpath(digraph(sparsed_cave_risk_map), start_node, end_node))) - cave_risk_map(1,1);
end


end