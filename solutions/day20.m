function [t,solution1,solution2] = day20(verbose)
%DAY20  Solve day 20 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/20
% 
% --- Day 20: Trench Map ---
% Problem URL : https://adventofcode.com/2021/day/20
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 20;
input_data_str = fetch_input(d);
tic;
[img,algorithm] = format_data(input_data_str);
t_format = toc;

%% SOLVING
tic;

% Solution 1
nstep1 = 2;
for istep = 1:nstep1
  img = apply_enhancement(img, algorithm, istep);
end
solution1 = sum(img, 'all');

% Solution 2
nstep2 = 50;
for istep = nstep1+1:nstep2
  img = apply_enhancement(img, algorithm, istep);
end
solution2 = sum(img, 'all');

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
function [img,algorithm] = format_data(data_str)
    data = split(data_str);
    algorithm = data{1} == '#';
    img = char(data(2:end)) == '#';
end

function [padded_grid] = pad_grid(grid,pad_size,pad_value)
    % Pad both dimension of grid with pad_value
    padded_grid = pad_value*ones(size(grid)+2*pad_size);
    padded_grid(pad_size+1:end-pad_size,pad_size+1:end-pad_size) = grid;
end


function [next_img] = apply_enhancement(img, algorithm, kstep)
  binary_mask = permute(2.^(8:-1:0), [1,3,2]);
  if mod(kstep,2) == 1
    img = pad_grid(img, 2, 0);
  else
    img = pad_grid(img, 2, algorithm(1));
  end

  nrow = size(img,1) - 2;
  img_mask = zeros([nrow,nrow,9]);
  for irow = 1:3
    for jrow = 1:3
      img_mask(:,:,(irow-1)*3+jrow) = img(irow:end+irow-3, jrow:end+jrow-3);
    end
  end

  img_mask = img_mask .* binary_mask;
  img_mask = sum(img_mask, 3);
  next_img = algorithm(img_mask + 1);
end

end