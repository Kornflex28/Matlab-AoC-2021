function [t,solution1,solution2] = day11(verbose)
%DAY11  Solve day 11 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/16
% 
% --- Day 11: Dumbo Octopus ---
% Problem URL : https://adventofcode.com/2021/day/11
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 11;
input_data_str = fetch_input(d);
tic;
[input_data] = format_data(input_data_str);
t_format = toc;


%% SOLVING
tic;
energy_levels = pad_grid(input_data,1,nan);

% Solution 1 & 2
solution1 = 0;
sum_flashes = 0;
kstep = 0;
maxflashes = numel(input_data);
while sum_flashes~=maxflashes 
    [energy_levels,flashes] = process_step(energy_levels);
    sum_flashes = sum(flashes,'all');
    if kstep < 100
        solution1 = solution1+sum_flashes;
    end
    kstep = kstep+1;
end

solution2 = kstep;

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

function [padded_grid] = pad_grid(grid,pad_size,pad_value)
    % Pad both dimension of grid with pad_value
    padded_grid = pad_value*ones(size(grid)+2*pad_size);
    padded_grid(pad_size+1:end-pad_size,pad_size+1:end-pad_size) = grid;
end

function [energy_levels, flashes] = process_step(energy_levels)
    [nrow,ncol] = size(energy_levels);
    max_energy = 9;

    energy_levels = energy_levels+1;

    flashes = energy_levels > max_energy;
    flashed = zeros(size(flashes));
    to_flash = find(flashes);
    while ~isempty(to_flash)
        flashing_ind = to_flash(1);
        to_flash = to_flash(2:end);

        [~,neighbours_ind] = get_neighbours(energy_levels,flashing_ind);
        energy_levels(neighbours_ind) = energy_levels(neighbours_ind)+1;

        next_to_flash = find(energy_levels > max_energy);
        flashed(flashing_ind) = 1;
        next_to_flash = setdiff(next_to_flash,[find(flashed) ;to_flash]);
        to_flash = [to_flash ;next_to_flash];
    end
    flashes = energy_levels > max_energy;
    energy_levels(flashes) = 0;
end


function [neighbours,neighbours_ind] = get_neighbours(grid,ind)
    % Get neighbours value in specific order UP, UPRIGHT, RIGHT, DOWNRIGHT,
    % DOWN, DOWNLEFT, LEFT and UPLEFT
    neighbours = zeros(8,1);

    if length(ind)>1
        row = ind(1);
        col = ind(2);
        
        ind_u  = [row-1;col];
        ind_ur = [row-1;col+1];
        ind_r  = [row;col+1];
        ind_dr = [row+1;col+1];
        ind_d  = [row+1;col];
        ind_dl = [row+1;col-1];
        ind_l  = [row;col-1];
        ind_ul = [row-1:col-1];

        neighbours(1) = grid(ind_u(1),ind_u(2));
        neighbours(2) = grid(ind_ur(1),ind_ur(2));
        neighbours(3) = grid(ind_r(1),ind_r(2));
        neighbours(4) = grid(ind_dr(1),ind_dr(2));
        neighbours(5) = grid(ind_d(1),ind_d(2));
        neighbours(6) = grid(ind_dl(1),ind_dl(2));
        neighbours(7) = grid(ind_l(1),ind_l(2));
        neighbours(8) = grid(ind_ul(1),ind_ul(2));
    else
        [nrow,~] = size(grid);
        
        ind_u = ind-1;
        ind_ur = ind-1+nrow;
        ind_r = ind+nrow;
        ind_dr = ind+1+nrow;
        ind_d = ind+1;
        ind_dl = ind+1-nrow;
        ind_l = ind-nrow;
        ind_ul = ind-1-nrow;

        neighbours(1) = grid(ind_u);
        neighbours(2) = grid(ind_ur);
        neighbours(3) = grid(ind_r);
        neighbours(4) = grid(ind_dr);
        neighbours(5) = grid(ind_d);
        neighbours(6) = grid(ind_dl);
        neighbours(7) = grid(ind_l);
        neighbours(8) = grid(ind_ul);
    end
    
    if nargout>1
        neighbours_ind = [ind_u ind_ur ind_r ind_dr ind_d ind_dl ind_l ind_ul];
    end
end

end