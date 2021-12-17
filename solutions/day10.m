function [t,solution1,solution2] = day10(verbose)
%DAY10  Solve day 10 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/15
% 
% --- Day 10: Syntax Scoring ---
% Problem URL : https://adventofcode.com/2021/day/10
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 10;
input_data_str = fetch_input(d);
tic;
[input_data] = format_data(input_data_str);
t_format = toc;


%% SOLVING
tic;
subsystem = translate(input_data);
nline = size(subsystem,1);

% Solution 1
solution1 = 0;
corrections_score = nan(1,nline);
for kline=1:nline
    [linepoint, opened] = check_line(subsystem(kline,:));
    if ~isnan(linepoint)
        solution1 = solution1+linepoint;
    else
        corrected = -fliplr(opened);
        corrections_score(kline) = get_correction_score(corrected);
    end
end

% Solution 2
solution2 = median(corrections_score,'omitnan');

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
    data = char(splitlines(strtrim(data_str)));
end
    
function [translated] = translate(chars)
    translated = zeros(size(chars));
    for kchar=1:numel(chars)
        switch chars(kchar)
            case '('
                tchar = -3;
            case ')'
                tchar = 3;
            case '['
                tchar = -57;
            case ']'
                tchar = 57;
            case '{'
                tchar = -1197;
            case '}'
                tchar = 1197;
            case '<'
                tchar = -25137;
            case '>'
                tchar = 25137;
            otherwise
                tchar = nan;
        end
        translated(kchar) = tchar;
    end
end

function [tchar, opened] = check_line(li)
    opened = [];
    nchar = length(li);
    for kchar=1:nchar
        tchar = li(kchar);
        if isnan(tchar)
            return
        elseif tchar < 0
            opened = [opened tchar];
        else
            if opened(end) == -tchar
                opened = opened(1:end-1);
            else
                return
            end
        end
    end
    tchar = nan;
end

function [score] = get_correction_score(correction)
    nchar = length(correction);
    score = 0;
    mult = 5;
    for kchar=1:nchar
        tchar = correction(kchar);
        switch tchar
            case 3
                score = score*mult + 1;
            case 57
                score = score*mult + 2;
            case 1197
                score = score*mult + 3;
            case 25137
                score = score*mult + 4;
        end
    end
end

end