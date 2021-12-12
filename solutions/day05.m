function [t,solution1,solution2] = day05(verbose)
%DAY05  Solve day 5 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/12
% 
% --- Day 5: Hydrothermal Venture ---
% Problem URL : https://adventofcode.com/2021/day/5
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 5;
input_data_str = fetch_input(d);
tic;
input_data = format_data(input_data_str);
t_format = toc;


%% SOLVING
tic;
% Solution 1
[horzvert_diagram] = generate_horzvert_diagram(input_data);
solution1 = sum(horzvert_diagram>1,'all');

% Solution 2
[diagram] = generate_diagram(input_data);
solution2 = sum(diagram>1,'all');

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
    data = splitlines(data_str);
    data = str2double(split(data,{',','->'}));
end

function [diagram] = generate_horzvert_diagram(lines_data)
    % Generate diagram with number of passing horizontal and vertical
    % lines on grid points
    lines_coord = lines_data+1;
    nrow = max(lines_coord,[],'all');
    diagram = zeros(nrow,nrow);

    horzvert_lines_coord = lines_coord(lines_coord(:,1)==lines_coord(:,3) | lines_coord(:,2)==lines_coord(:,4),:);
    [xs] = horzvert_lines_coord(:,[1 3]);
    [ys] = horzvert_lines_coord(:,[2 4]);
    for kline=1:size(horzvert_lines_coord,1)
        x1 = xs(kline,1);
        x2 = xs(kline,2);
        y1 = ys(kline,1);
        y2 = ys(kline,2);

        x = linspace(x1,x2,abs(x1-x2)+1);
        y = linspace(y1,y2,abs(y1-y2)+1);

        x = repmat(x,1,max(length(x),length(y))-length(x)+1);
        y = repmat(y,1,max(length(x),length(y))-length(y)+1);
        line_coord = sub2ind(size(diagram),x,y);
        
        diagram(line_coord) = diagram(line_coord)+1;
    end
end

function [diagram] = generate_diagram(lines_data)
    % Generate diagram with number of all passing lines on grid points
    lines_coord = lines_data+1;
    nrow = max(lines_coord,[],'all');
    diagram = zeros(nrow,nrow);

    [xs] = lines_coord(:,[1 3]);
    [ys] = lines_coord(:,[2 4]);
    for kline=1:size(lines_coord,1)
        x1 = xs(kline,1);
        x2 = xs(kline,2);
        y1 = ys(kline,1);
        y2 = ys(kline,2);

        x = linspace(x1,x2,abs(x1-x2)+1);
        y = linspace(y1,y2,abs(y1-y2)+1);

        x = repmat(x,1,max(length(x),length(y))-length(x)+1);
        y = repmat(y,1,max(length(x),length(y))-length(y)+1);
        line_coord = sub2ind(size(diagram),x,y);

        diagram(line_coord) = diagram(line_coord)+1;
    end
end

end