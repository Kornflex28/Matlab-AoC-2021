% day1.m

input_data_str = fetchInput(1);
input_data = format_data(input_data_str);

%% HELPER FUNCTIONS

function data = format_data(data_str)
    data = str2double(splitlines(data_str));
end