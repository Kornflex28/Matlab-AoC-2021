function [t,solution1,solution2] = day08(verbose)
%DAY08  Solve day 8 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/13
% 
% --- Day 8: Seven Segment Search ---
% Problem URL : https://adventofcode.com/2021/day/8
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 8;
input_data_str = fetch_input(d);
tic;
[patterns, outputs] = format_data(input_data_str);
t_format = toc;


%% SOLVING
tic;

% Solution 1
outputs_lengths = cellfun(@length,outputs);
solution1 = sum(outputs_lengths == 2 | outputs_lengths == 3 | ...
                outputs_lengths == 4 | outputs_lengths == 7 , 'all');

% Solution 2
segments_score = get_segments_score(patterns);
outputs_score  = get_digits_score(outputs,segments_score);
outputs_digits = convert_score_to_digits(outputs_score);
solution2 = sum(str2num(outputs_digits));

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
function [patterns, output] = format_data(data_str)
    data = strtrim(split(splitlines(data_str),'|'));
    patterns = split(data(:,1));
    output   = split(data(:,2));
end

function [scores] = get_segments_score(patterns)
    % Score each segments (abcdefg) given its frequency
    patterns_char = double(char(strrep(join(string(patterns)),' ','')));
    segments = double('abcdefg');
    scores = zeros(size(patterns,1),size(segments,2));
    for krow=1:size(patterns,1)
        for kchar=1:size(segments,2)
            scores(krow,kchar) = sum(patterns_char(krow,:)==segments(kchar));
        end
    end
end

function [scores] = get_digits_score(patterns,segments_score)
    % Get score of digits which is the sum of its segments scores (which
    % gives 10 unique scores for digits 0 to 9.
    scores = zeros(size(patterns));
    for krow=1:size(patterns,1)
        scores(krow,:) = cellfun(@(x) get_letter_score(x,segments_score(krow,:)),patterns(krow,:));
    end
end

function [score] = get_letter_score(letters,segments_score)
    % Get score of one digit
    letters_d = double(letters);
    segments = double('abcdefg');
    score = 0;
    for kchar=1:size(segments,2)
        score = score + sum(letters_d==segments(kchar))*segments_score(kchar);
    end
end

function [dig] = convert_score_to_digits(scores)
    % Converts scores to their digit representation
    nominal_digits = '0123456789';
    nominal_segments = {'abcefg' 'cf' 'acdeg' 'acdfg' 'bcdf' 'abdfg' 'abdefg' 'acf' 'abcdefg' 'abcdfg'};
    nominal_score  = get_digits_score(nominal_segments,get_segments_score(nominal_segments));
    
    for krow=1:size(scores,1)
        for kcol = 1:size(scores,2)
            dig(krow,kcol) = nominal_digits(nominal_score==scores(krow,kcol));
        end
    end    
end
end