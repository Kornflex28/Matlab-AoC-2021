function [t,solution1,solution2] = day21(verbose)
%DAY21  Solve day 21 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/21
% 
% --- Day 21: Dirac Dice ---
% Problem URL : https://adventofcode.com/2021/day/21
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 21;
input_data_str = fetch_input(d);
tic;
[positions] = format_data(input_data_str);
t_format = toc;

%% SOLVING
tic;
nside = 100;
deterministic_dice = 1:nside;
kstep = 0;
scores = [0 0];
win_score = 1000;
positions1 = positions;

% Solution 1
while all(scores<win_score)
    kstep = kstep+1;
    player = wrap_to_n(kstep,2);
    positions1(player) = wrap_to_n(positions1(player) + sum(deterministic_dice(wrap_to_n((kstep-1)*3+1:(kstep)*3,nside))),10);
    scores(player) = scores(player)+positions1(player);
end
solution1 = 3*kstep*min(scores);

% Solution 2
universe = zeros([10,10,21,21]);
universe(positions(1),positions(2),1,1) = 1;

dice_rolls_possibilites = (1:3) + (1:3)' + permute(1:3,[1,3,2]);
[dice_rolls, ~, ic] = unique(dice_rolls_possibilites);
p = accumarray(ic, 1);
nwon = [0, 0];
kstep = 0;

while any(universe ~= 0, 'all')
  kstep = kstep+1;
  player = wrap_to_n(kstep,2);

  next_universe = zeros(size(universe));
  for j = 1:numel(p)
    next_universe = next_universe + p(j) * circshift(universe, dice_rolls(j), player);
  end

  if player == 2
    next_universe = permute(next_universe, [2,1,4,3]);
  end

  for j = 1:10
    nwon(player) = nwon(player) + sum(next_universe(j,:,end-j+1:end,:), 'all');
    next_universe(j,:,1+j:end,:) = next_universe(j,:,1:end-j,:);
    next_universe(j,:,1:j,:) = 0;
  end

  if player == 2
    next_universe = permute(next_universe, [2,1,4,3]);
  end

  universe = next_universe;
end
solution2 = max(nwon);

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
function [input_data] = format_data(data_str)
    data = split(data_str);
    input_data = str2double(data([5 10]));
end

function [wrap_n] = wrap_to_n(x,n)
    % Keep x in range [1:n]
    wrap_n = (1 + mod(x-1, n));
end

end