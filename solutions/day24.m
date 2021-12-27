function [t,solution1,solution2] = day24(verbose)
%DAY24  Solve day 24 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/27
% 
% --- Day 24: Arithmetic Logic Unit ---
% Problem URL : https://adventofcode.com/2021/day/24
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 24;
input_data_str = fetch_input(d);
tic;
[divisor,addend_1,addend_2] = format_data(input_data_str);
t_format = toc;

%% SOLVING
tic;

% Solution 1
solution1 = polyval(monad_check((9:-1:1)', divisor, addend_1, addend_2), 10);

% Solution 2
solution2 = polyval(monad_check((1:9)', divisor, addend_1, addend_2), 10);

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
function [divisor,addend_1,addend_2] = format_data(data_str)
    data = char(splitlines(data_str));
    data = data(1:end-1,:);
    divisor = str2double(string(data((0:13)*18 + 5, 7:end)));
    addend_1 = str2double(string(data((0:13)*18 + 6, 7:end)));
    addend_2 = str2double(string(data((0:13)*18 + 16, 7:end)));
end

function [best_digits] = monad_check(input, divisor, addend_1, addend_2)
  best_digits = zeros(1,14);
  hist_z{1} = 0;
  for kdigit = 1:14
    z0 = hist_z{kdigit};
    for guess = input'
      z = z0;
      x = rem(z,26) + addend_1(kdigit) ~= guess;
      z = unique(floor(z/divisor(kdigit)).*(25*x + 1) + (guess + addend_2(kdigit)).*x)';
      hist_z{kdigit+1} = z;
      for i = kdigit+1:14
        x = rem(z,26) + addend_1(i) ~= input;
        z = unique(floor(z/divisor(i)).*(25*x + 1) + (input + addend_2(i)).*x)';
      end
      if any(z == 0, 'all')
        best_digits(kdigit) = guess;
        break
      end
    end
  end
end


end