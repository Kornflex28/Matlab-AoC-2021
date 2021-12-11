function [solution1,solution2] = day3()
%DAY3  Solve day 3 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/11
% 
% --- Day 3: Binary Diagnostic ---
% Problem URL : https://adventofcode.com/2021/day/3
%

%% GET INPUT
tic
d = 3;
input_data_str = fetch_input(d);
input_data = format_data(input_data_str);

%% SOLVING

% Solution 1
gamma_rate_bin   = mode(input_data,1);
espilon_rate_bin = invert_string(gamma_rate_bin);
solution1 = bin2dec(gamma_rate_bin)*bin2dec(espilon_rate_bin);

% Solution 2
oxygen_generator_rating_bin = process_report(input_data,1,'most');
co2_scrubber_rating_bin     = process_report(input_data,1,'least');
solution2 = bin2dec(oxygen_generator_rating_bin)*bin2dec(co2_scrubber_rating_bin);

%% LOGS
print_solution(d,solution1,solution2);

if nargout < 2
    clear solution1 solution2
end
toc
%% HELPER FUNCTIONS
function data = format_data(data_str)
    data = splitlines(data_str);
    data = vertcat(data{:});
end

function [inverted] = invert_string(str)
    inverted = char(zeros(size(str)));
    for kchar=1:numel(inverted)
        inverted(kchar) = num2str(1-str2double(str(kchar)));
    end
end

function [processed] = process_report(report,kbit,criteria)
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