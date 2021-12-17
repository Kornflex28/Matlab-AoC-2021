function [t,solution1,solution2] = day13(verbose)
%DAY13  Solve day 13 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/17
% 
% --- Day 13: Transparent Origami ---
% Problem URL : https://adventofcode.com/2021/day/13
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 13;
input_data_str = fetch_input(d);
tic;
[dots,fold_instructions] = format_data(input_data_str);
t_format = toc;


%% SOLVING
tic;
[dots_matrix] = generate_dots_matrix(dots);
n_instructions = size(fold_instructions,1);
% Solution 1 & 2
for k_instruction = 1:n_instructions
    dots_matrix = fold_grid(dots_matrix,fold_instructions(k_instruction,2),fold_instructions(k_instruction,1));
    if k_instruction == 1 
        solution1 = sum(dots_matrix > 0,'all');
    end
end

dots_matrix(dots_matrix>0) = 1;
solution2 = 'see image';


t_end = toc;
%% LOGS
if verbose
    print_solution(d,solution1,solution2);
    print_elapsed_time(t_format,t_end);
    figure('Name',sprintf('Day %d - solution 2',d),'NumberTitle','off');
    imshow(dots_matrix,'InitialMagnification','fit');
end

t = [t_format;t_end];

if nargout == 0
    clear solution1 solution2 t
end
%% HELPER FUNCTIONS
function [dots,fold_instructions] = format_data(data_str)
    data = splitlines(strtrim(data_str));
    separation_line = find(cellfun(@isempty,data));
    dots = str2double(split(data(1:separation_line-1,end,:),','));
    match_pattern = '(?<dim>[xy])=(?<value>\d+)';
    fold_instructions_str = regexp(data(separation_line+1:end,end,:),match_pattern,'names');
    ninstructions = size(fold_instructions_str,1);
    fold_instructions = zeros(ninstructions,2);
    for kinstruction=1:ninstructions
        switch fold_instructions_str{kinstruction}.dim
            case 'x'
                fold_instructions(kinstruction,1)=2;
            case 'y'
                fold_instructions(kinstruction,1)=1;
        end
        fold_instructions(kinstruction,2) = str2double(fold_instructions_str{kinstruction}.value);
    end
    dots = dots+1;
    fold_instructions(:,2) = fold_instructions(:,2)+1;
end

function [folded] = fold_grid(grid,line_ind,dim)    
    
    if dim==1
        folded = grid(1:line_ind-1,:) + flipud(grid(line_ind+1:end,:));
    elseif dim == 2
        folded = grid(:,1:line_ind-1) + fliplr(grid(:,line_ind+1:end));
    end
end

function [dots_matrix] = generate_dots_matrix(dots)
    dims = max(dots,[],1);
    dots_matrix = zeros(fliplr(dims));
    for kdot = 1:length(dots)
        dots_matrix(dots(kdot,2),dots(kdot,1))=1;
    end
end

end