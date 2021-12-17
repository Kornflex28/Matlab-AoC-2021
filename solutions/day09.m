function [t,solution1,solution2] = day09(verbose)
%DAY09  Solve day 9 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/14
% 
% --- Day 9: Smoke Basin ---
% Problem URL : https://adventofcode.com/2021/day/9
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 9;
input_data_str = fetch_input(d);
tic;
[input_data] = format_data(input_data_str);
t_format = toc;


%% SOLVING
tic;

lowpoints_ind = find(get_lowpoints(input_data));

% Solution 1
lowpoints = input_data(lowpoints_ind);
solution1 = sum(risk(lowpoints));

% Solution 2
bassins_size = arrayfun(@(x) numel(get_bassin(input_data,x)),lowpoints_ind);
k_largest = 3;
solution2 = prod(maxk(bassins_size,k_largest));

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
    data = split(splitlines(strtrim(data_str)),'');
    data = str2double(data(:,2:end-1));
end

function [padded_heightmap] = pad_heightmap(heightmap,pad_size,pad_value)
    % Pad both dimension of heightmap with pad_value
    padded_heightmap = pad_value*ones(size(heightmap)+2*pad_size);
    padded_heightmap(pad_size+1:end-pad_size,pad_size+1:end-pad_size) = heightmap;
end

function [islowpoint] = is_lowpoint(height,neighbours_height)
    % Check if height is lowpoint given its neighbour
    islowpoint = all(height<neighbours_height);
end

function [neighbours,neighbours_ind] = get_neighbours(heightmap,ind)
    % Get neighbours value in specific order UP, RIGHT, DOWN AND LEFT
    neighbours = zeros(4,1);

    if length(ind)>1
        row = ind(1);
        col = ind(2);
        
        ind_u = [row-1;col];
        ind_r = [row;col+1];
        ind_d = [row+1;col];
        ind_l = [row;col-1];

        neighbours(1) = heightmap(ind_u(1),ind_u(2));
        neighbours(2) = heightmap(ind_r(1),ind_r(2));
        neighbours(3) = heightmap(ind_d(1),ind_d(2));
        neighbours(4) = heightmap(ind_l(1),ind_l(2));
    else
        [nrow,~] = size(heightmap);
        
        ind_u = ind-1;
        ind_r = ind+nrow;
        ind_d = ind+1;
        ind_l = ind-nrow;

        neighbours(1) = heightmap(ind_u);
        neighbours(2) = heightmap(ind_r);
        neighbours(3) = heightmap(ind_d);
        neighbours(4) = heightmap(ind_l);
    end
    
    if nargout>1
        neighbours_ind = [ind_u ind_r ind_d ind_l];
    end
end

function [lowpoints] = get_lowpoints(heightmap)
    % Give position of lowpoints
    lowpoints = false(size(heightmap));
    pheightmap = pad_heightmap(heightmap,1,max(heightmap,[],'all'));
    [nrow,ncol] = size(heightmap);
    for krow=1:nrow
        for kcol=1:ncol
            pkrow = krow+1;
            pkcol = kcol+1;
            height = pheightmap(pkrow,pkcol);

            lowpoints(krow,kcol) = is_lowpoint(height,get_neighbours(pheightmap,[pkrow pkcol]));
        end
    end
end

function [risk_level] = risk(lowpoints)
    risk_level = lowpoints+1;
end

function [bassin] = get_bassin(heightmap,lowpoint_ind)
    % Get bassin in heightmap from given lowpoint
    height_max = max(heightmap,[],'all');
    pheightmap = pad_heightmap(heightmap,1,height_max);
    [lowpoint_indr,lowpoint_indc] = ind2sub(size(heightmap),lowpoint_ind);
    lowpoint_pind = sub2ind(size(pheightmap),lowpoint_indr+1,lowpoint_indc+1);
    
    to_check = lowpoint_pind;
    checked  = [];
    % bfs
    while ~isempty(to_check)
        check_ind = to_check(1);
        to_check  = to_check(2:end);
        
        [neighbours,neighbours_ind] = get_neighbours(pheightmap,check_ind);
        
        next_ind = setdiff(neighbours_ind(neighbours ~= height_max),[checked to_check]);
        
        to_check = [next_ind to_check];
        checked = [checked check_ind];
    end
    [lowpoint_pindr,lowpoint_pindc] = ind2sub(size(pheightmap),checked);
    bassin = sub2ind(size(heightmap),lowpoint_pindr-1,lowpoint_pindc-1);
end

end