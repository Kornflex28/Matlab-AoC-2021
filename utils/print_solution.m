function [] = print_solution(d,sol1,sol2)
%PRINT_SOLUTION Print problem solutions.
    switch class(sol1)
        case 'double'
            switch class(sol2)
                case 'double'
                    fprintf('Day %d\nSolution 1 : %d\nSolution 2 : %d\n',d,sol1,sol2);
                case 'char'
                    fprintf('Day %d\nSolution 1 : %d\nSolution 2 : %s\n',d,sol1,sol2);
            end
        case 'char'
            switch class(sol2)
                case 'double'
                    fprintf('Day %d\nSolution 1 : %s\nSolution 2 : %d\n',d,sol1,sol2);
                case 'char'
                    fprintf('Day %d\nSolution 1 : %s\nSolution 2 : %s\n',d,sol1,sol2);
            end
    end
end

