function [t,solution1,solution2] = day03(verbose)
%DAY03  Solve day 3 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/11
% 
% --- Day 3: Binary Diagnostic ---
% Problem URL : https://adventofcode.com/2021/day/3
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 3;
input_data_str = fetch_input(d);
tic;
input_data = format_data(input_data_str);
t_format = toc;

%% SOLVING
tic;
% Solution 1
gamma_rate_bin   = mode(input_data,1); % most common bit
espilon_rate_bin = invert_string(gamma_rate_bin); % least common bit
solution1 = bin2dec(gamma_rate_bin)*bin2dec(espilon_rate_bin);

% Solution 2
oxygen_generator_rating_bin = process_report(input_data,1,'most');
co2_scrubber_rating_bin     = process_report(input_data,1,'least');
solution2 = bin2dec(oxygen_generator_rating_bin)*bin2dec(co2_scrubber_rating_bin);

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
function data = format_data(data_str)
    data = splitlines(data_str);
    data = vertcat(data{:});
end

function [inverted] = invert_string(str)
    % Get the inverted binary string
    inverted = char(zeros(size(str)));
    for kchar=1:numel(inverted)
        inverted(kchar) = num2str(1-str2double(str(kchar)));
    end
end

function [processed] = process_report(report,kbit,criteria)
    % Process report for oxygen generator rating (criteria = 'most') and 
    % the CO2 scrubber rating (criteria = 'least')

    n0 = sum(report(:,kbit)=='0');
    n1 = sum(report(:,kbit)=='1');
    switch criteria
        case 'most'
            [~,max_ind] = max([n1 n0]);
            choices = '10';
            filt = choices(max_ind);
        case 'least'
            [~,min_ind] = min([n0 n1]);
            choices = '01';
            filt = choices(min_ind);
    end

    next_report = report(report(:,kbit)==filt,:);
    if size(next_report,1) == 1
        processed = next_report;
    else
        processed = process_report(next_report,kbit+1,criteria);
    end
end
end