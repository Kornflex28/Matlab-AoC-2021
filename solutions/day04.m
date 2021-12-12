function [t,solution1,solution2] = day04(verbose)
%DAY04  Solve day 4 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/11
% 
% --- Day 4: Giant Squid ---
% Problem URL : https://adventofcode.com/2021/day/4
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 4;
input_data_str = fetch_input(d);
tic;
[drawn_numbers,boards] = format_data(input_data_str);
t_format = toc;

%% SOLVING
tic;
% Solution 1 and 2
boards_state = zeros(size(boards));
boards_won_turn = zeros(1,size(boards,1));
first_winner = false;

% Draw numbers one after another and play bingo
for drawn_number=drawn_numbers

    % Draw number and update game state
    [boards_won,boards_state] = draw_number(drawn_number,boards,boards_state);

    % Check for first winner
    winner_kboard = find(boards_won, 1);
    if ~isempty(winner_kboard) && ~first_winner
            solution1 = score_board(drawn_number,winner_kboard,boards,boards_state);
            first_winner = ~first_winner;
    end
    
    % Update winners number of turns (minimum value will be last winner)
    boards_won_turn = boards_won_turn+boards_won;
    
    % Stop playing if all boards won
    if all(boards_won)
        break
    end
end

% Get last winner board
[~,last_winner_kboard] = min(boards_won_turn);
solution2 = score_board(drawn_number,last_winner_kboard,boards,boards_state);

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
function [drawn_numbers,boards] = format_data(data_str)
    data = splitlines(data_str);
    drawn_numbers = str2double(split(data{1,:},','))';

    nboard = (size(data,1)-1)/6;
    board_nrow = 5;
    boards = zeros(nboard,board_nrow,board_nrow);
    for kboard = 1:nboard
        cell_board = data(3+(kboard-1)*(board_nrow+1):7+(kboard-1)*(board_nrow+1),:);
        boards(kboard,:,:) = str2double(split(strtrim(cell_board)));
    end
end

function [boards_state] = update_boards(drawn_number,boards,boards_state)
    % Update board state for the drawn number
    boards_state = boards_state + (boards == drawn_number);
end

function [won]=board_won(board_state)
    % Check if the board fulfils win condition
    won = any(all(board_state,2)) || any(all(board_state,3));
end

function [boards_won,boards_state] = draw_number(drawn_number,boards,boards_state)
    % Update all boards state for the drawn number
    % Update all boards win state after that
    nboard = size(boards,1);
    [boards_state] = update_boards(drawn_number,boards,boards_state);
    boards_won = zeros(1,nboard);
    for kboard = 1:nboard
        board_state = boards_state(kboard,:,:);
        boards_won(kboard) = board_won(board_state);
    end
end

function [score] = score_board(drawn_number,kboard,boards,boards_state)
   % Get score of a winning board
   score = drawn_number * sum(boards(kboard,~boards_state(kboard,:,:)));
end

end