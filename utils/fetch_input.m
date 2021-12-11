function [inputData] = fetch_input(d)
%FETCH_INPUT Fetch problem input for the given day.

arguments
    d (1,1) {mustBeInteger, mustBeInRange(d,1,31)}
end
dbs = dbstack('-completenames');
path_parts = strsplit(dbs(end).file, filesep);
home_path = strjoin(path_parts(1:end-2), filesep);
input_path = sprintf('%s/inputs/day%d.txt',home_path,d);

if isfile(input_path)
    inputData = strtrim(fileread(input_path));
else
    error('Input file not found for day %d at %s',d,input_path)
end
end

