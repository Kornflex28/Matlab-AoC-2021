function [solution1,solution2] = day2()
%DAY2  Solve day 2 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/11
% 
% --- Day 2: Dive! ---
% Problem URL : https://adventofcode.com/2021/day/2
%

%% GET INPUT
tic
d = 2;
input_data_str = fetch_input(d);
input_data = format_data(input_data_str);

%% SOLVING

% Solution 1
commands1 = parse_commands(input_data,1);
final_position1 = sum(commands1);
solution1 = final_position1(1)*final_position1(2);

% Solution 2
commands2 = parse_commands(input_data,2);
final_position2 = sum(commands2);
solution2 = final_position2(1)*final_position2(2);

%% LOGS
print_solution(d,solution1,solution2);

if nargout < 2
    clear solution1 solution2
end
toc
%% HELPER FUNCTIONS
function data = format_data(data_str)
    data = split(splitlines(data_str));
end

function  [commands] = parse_commands(command_lines,parser)
    commands = zeros(size(command_lines,1),3);
    for kCommand=1:size(commands,1)
        commands(kCommand,:) = parse_command(command_lines(kCommand,:),parser);
        if kCommand > 1 && parser == 2
            commands(kCommand,2) = commands(kCommand,1)*commands(kCommand-1,3);
            commands(kCommand,3) = commands(kCommand,3)+commands(kCommand-1,3);
        end
    end
end

function [command] = parse_command(command_line,parser)

    if parser == 1
        switch command_line{1}
            case 'forward'
                a = 1;
                b = 0;
            case 'up'
                a = 0;
                b = -1;
            otherwise
                a = 0;
                b = 1;
        end
        aim = 0;
    else
        switch command_line{1}
            case 'forward'
                a = 1;
                b = 0;
                aim = 0;
            case 'up'
                a = 0;
                b = 0;
                aim = -1;
            otherwise
                a = 0;
                b = 0;
                aim = 1;
        end
    end
    magnitude = str2double(command_line{2});
    command = [a*magnitude b*magnitude aim*magnitude];
end

end