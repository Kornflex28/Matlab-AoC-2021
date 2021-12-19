function [t,solution1,solution2] = day18(verbose)
%DAY18  Solve day 18 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/19
% 
% --- Day 18: Snailfish ---
% Problem URL : https://adventofcode.com/2021/day/18
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 18;
input_data_str = fetch_input(d);
tic;
[snailfishes] = format_data(input_data_str);
t_format = toc;

%% SOLVING
tic;
nsnailfishes = length(snailfishes);

% Solution 1
snailfish = snailfishes(1);
for ksf = 2:nsnailfishes
    snailfish = add_snailfish(snailfish,snailfishes(ksf));
    snailfish = reduce_snailfish(snailfish);
end
solution1 = snailfish_magnitude(snailfish);

% Solution 2
solution2 = -inf;
for isf = 1:nsnailfishes
    for jsf = 1:nsnailfishes
        snailfish = add_snailfish(snailfishes(isf),snailfishes(jsf));
        solution2 = max(solution2,snailfish_magnitude(reduce_snailfish(snailfish)));
    end
end

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
function [snailfishes] = format_data(data_str)
    data = splitlines(data_str);
    nsnailfish = size(data,1);
    snailfishes = struct;
    for ksnailfish=nsnailfish:-1:1
        [snailfishes(ksnailfish).value, snailfishes(ksnailfish).depth] = parse_snailfish(data{ksnailfish,:});
    end
end

function [values, depths] = parse_snailfish(snailfish_str)
    depth = -1;
    depths = [];
    values = [];
    for k=1:numel(snailfish_str)
        kchar = snailfish_str(k);
        switch kchar
            case '['
                depth = depth+1;
            case ']'
                depth = depth-1;
            case ','
            otherwise
                value = str2double(kchar);
                depths = [depths depth];
                values = [values value];
        end
    end
end

function [snailfish] = add_snailfish(snailfish1,snailfish2)
    snailfish.value = [snailfish1.value snailfish2.value];
    snailfish.depth = [snailfish1.depth snailfish2.depth]+1;
end


function [snailfish] = reduce_snailfish(snailfish)
    exploded = true;
    split = true;
    while exploded || split
      [snailfish, exploded] = explode_snailfish(snailfish);
      if exploded
        continue
      end
      [snailfish, split] = split_snailfish(snailfish);
    end
end

function [snailfish,exploded] = explode_snailfish(snailfish)
    ind_to_explode = find(snailfish.depth > 3 & [diff(snailfish.depth) == 0 0], 1);
    if isempty(ind_to_explode)
        exploded = false;
    else
        left_value  = snailfish.value(ind_to_explode);
        right_value = snailfish.value(ind_to_explode+1);
        ind_left  = ind_to_explode-1;
        ind_right = ind_to_explode+2;
        if ind_left>0
            snailfish.value(ind_left) = snailfish.value(ind_left) + left_value;
        end
        if ind_right<length(snailfish.value)+1
            snailfish.value(ind_right) = snailfish.value(ind_right) + right_value;
        end
        snailfish.value = [snailfish.value(1:ind_to_explode-1) 0 snailfish.value(ind_to_explode+2:end)];
        snailfish.depth = [snailfish.depth(1:ind_to_explode-1) snailfish.depth(ind_to_explode)-1 snailfish.depth(ind_to_explode+2:end)];
        exploded = true;
    end
end

function [snailfish,split] = split_snailfish(snailfish)
    ind_to_split = find(snailfish.value > 9, 1);
    if isempty(ind_to_split)
        split = false;
    else
        value = .5*snailfish.value(ind_to_split);
        depth = snailfish.depth(ind_to_split);
        left_value  = floor(value);
        right_value = ceil(value);
        snailfish.value = [snailfish.value(1:ind_to_split-1) [left_value right_value] snailfish.value(ind_to_split+1:end)];
        snailfish.depth = [snailfish.depth(1:ind_to_split-1) [depth+1 depth+1] snailfish.depth(ind_to_split+1:end)];
        split = true;
    end
end


function [magnitude] = snailfish_magnitude(snailfish)
    if length(snailfish.value)<2
        magnitude = snailfish.value(1);
    else
        [max_depth,imax] = max([snailfish.depth]);
        mag = 3*snailfish.value(imax)+2*snailfish.value(imax+1);
        new_snailfish.value = [snailfish.value(1:imax-1) mag snailfish.value(imax+2:end)];
        new_snailfish.depth = [snailfish.depth(1:imax-1) max_depth-1 snailfish.depth(imax+2:end)];
        magnitude = snailfish_magnitude(new_snailfish);
    end
end

end