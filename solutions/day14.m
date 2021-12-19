function [t,solution1,solution2] = day14(verbose)
%DAY14  Solve day 14 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/18
% 
% --- Day 14: Extended Polymerization ---
% Problem URL : https://adventofcode.com/2021/day/14
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 14;
input_data_str = fetch_input(d);
tic;
[polymer_template, insertion_pairs, insertions] = format_data(input_data_str);
t_format = toc;


%% SOLVING
tic;
[pairs_count] = get_pairs_count(polymer_template,insertion_pairs, insertions);
nstep1 = 10;
nstep2 = 40;

% Solution 1
for kstep=1:nstep1
    pairs_count = process_step(pairs_count, insertion_pairs, insertions);
end
occurences = nonzeros(unique(sum(pairs_count,1)));
solution1 = max(occurences)-min(occurences);

% Solution 2
for kstep=nstep1+1:nstep2
    pairs_count = process_step(pairs_count, insertion_pairs, insertions);
end
occurences = nonzeros(unique(sum(pairs_count,1)));
solution2 = max(occurences)-min(occurences);

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
function [polymer_template, insertion_pairs, insertions] = format_data(data_str)
    data = splitlines(strtrim(data_str));
    polymer_template = double(data{1,:});
    insertion_rules = strtrim(split(data(3:end,:),'->'));
    insertion_pairs = cell2mat(cellfun(@double,insertion_rules(:,1),'UniformOutput',false));
    insertions = cellfun(@double,insertion_rules(:,2));
end

    function [new_pairs_count] = process_step(pairs_count, insertion_pairs, insertions)
    [pairs_row,pairs_col] = ind2sub(size(pairs_count),find(pairs_count));
    pairs = [pairs_row pairs_col];
    npairs = size(pairs,1);
    new_pairs_count = pairs_count;
    for kpair=1:npairs
        pair = pairs(kpair,:);
        pair_match_ind = find(all(pair == insertion_pairs,2), 1);
        if ~isempty(pair_match_ind)
            element_to_add = insertions(pair_match_ind);
            n = pairs_count(pair(1),pair(2));
            new_pairs_count(pair(1),element_to_add) = new_pairs_count(pair(1),element_to_add)+n;
            new_pairs_count(element_to_add,pair(2)) = new_pairs_count(element_to_add,pair(2))+n;
            new_pairs_count(pair(1),pair(2)) = new_pairs_count(pair(1),pair(2)) - n;
        end
    end
end

function [pairs_count] = get_pairs_count(polymer_template,insertion_pairs, insertions)
    % Generate 2D matrix that represents elements pair and their count
    nrow = max([insertion_pairs insertions],[],'all');
    pairs_count = zeros(nrow,nrow);
    nelement = length(polymer_template);
    for k=1:nelement-1
        pairs_count(polymer_template(k),polymer_template(k+1)) = pairs_count(polymer_template(k),polymer_template(k+1))+1;
    end
end

end