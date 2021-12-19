function [t,solution1,solution2] = day16(verbose)
%DAY16  Solve day 16 problem of AoC 2021
% Author : L. Chauvet (inspiration from https://github.com/j-a-martins)
% Date   : 2021/12/19
% 
% --- Day 16: Packet Decoder ---
% Problem URL : https://adventofcode.com/2021/day/16
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 16;
input_data_str = fetch_input(d);
tic;
[input_data] = format_data(input_data_str);
t_format = toc;

%% SOLVING
tic;

% Solution 1 & 2
[dec_packet, ~, solution1] = process_packet(input_data{end}, Inf, 0);
solution2 = dec_packet.value;

t_end = toc;
%% LOGS
if verbose
    print_solution(d,double(solution1),double(solution2));
    print_elapsed_time(t_format,t_end);
end

t = [t_format;t_end];

if nargout == 0
    clear solution1 solution2 t
end
%% HELPER FUNCTIONS
function [data] = format_data(data_str)
    data = {};
    for ielem = numel(data_str):-1:1
        tmp = dec2bin(hex2dec(data_str(ielem)), 4).';
        data(ielem) = {tmp(:).'};
    end
    data = join(data,'');
end

function [operator_fun] = get_opertor_fun(operator_type)
    switch operator_type
        case 0
            operator_fun = @sum;
        case 1
            operator_fun = @prod;
        case 2
            operator_fun = @min;
        case 3
            operator_fun = @max;
        case 5
            operator_fun = @(x) cast(x(1) > x(2), 'like', x(1));
        case 6
            operator_fun = @(x) cast(x(1) < x(2), 'like', x(1));
        case 7
            operator_fun = @(x) cast(x(1) == x(2), 'like', x(1));
    end
end

function [bin_val, next_pos] = read_field_bin(bin_data, pos, fsize)
    end_pos = pos + fsize - 1;
    bin_val = bin_data(pos:end_pos);
    next_pos = end_pos + 1;
end

function [dec_val, next_pos] = read_field_dec(bin_data, pos, fsize)
    [val, next_pos] = read_field_bin(bin_data, pos, fsize);
    dec_val = bin2dec(val);
end

function [dec_val, pos] = get_literal_value_dec(bin_data, pos, s)
    literal_value_bin = '';
    while true
        [next, pos] = read_field_dec(bin_data, pos, s.next);
        [literal_value_bin(:, end+1), pos] = read_field_bin(bin_data, pos, s.length);
        if ~next
            break
        end
    end
    dec_val = bin2dec(literal_value_bin(:).');
end


function [decoded_packet, ibit, tot_packet_version] = process_packet(encoded_packet, packet_count_lim, tot_packet_version)
    ibit = 1;
    packet_count = 1;
    packet_format = struct(...
        'version_length', 3,...
        'type_id_length', 3,...
        'type_operator', struct('length_type_id', 1,...
                          'length_type_0', struct('total_length', 15),...
                          'length_type_1', struct('nsubpacket', 11)...
                          ),...
        'type_literal_value', struct('next', 1, 'length', 4));

    
    while true
        if packet_count > packet_count_lim
            break
        end
        if ibit - 1 > numel(encoded_packet) - 11
            break
        end
        [decoded_packet(packet_count).version, ibit] = read_field_dec(encoded_packet, ibit, packet_format.version_length);
        tot_packet_version = tot_packet_version + decoded_packet(packet_count).version;
        [decoded_packet(packet_count).type_id, ibit] = read_field_dec(encoded_packet, ibit, packet_format.type_id_length);
        switch decoded_packet(packet_count).type_id
            case 4
                [decoded_packet(packet_count).value, ibit] = get_literal_value_dec(encoded_packet, ibit, packet_format.type_literal_value);
            otherwise
                [length_type_id, ibit] = read_field_dec(encoded_packet, ibit, packet_format.type_operator.length_type_id);
                switch length_type_id
                    case 0
                        [total_length, ibit] = read_field_dec(encoded_packet, ibit, packet_format.type_operator.length_type_0.total_length);
                        [dec_subpackets, jbit, tot_packet_version] = process_packet(encoded_packet(ibit:ibit+total_length-1), Inf, tot_packet_version);
                    case 1
                        [c_subpackets, ibit] = read_field_dec(encoded_packet, ibit, packet_format.type_operator.length_type_1.nsubpacket);
                        [dec_subpackets, jbit, tot_packet_version] = process_packet(encoded_packet(ibit:end), c_subpackets, tot_packet_version);
                end
                ibit = ibit + jbit - 1;
                op_fun = get_opertor_fun(decoded_packet(packet_count).type_id);
                decoded_packet(packet_count).value = op_fun(arrayfun(@(x) dec_subpackets(x).value, 1:numel(dec_subpackets)));
        end
        packet_count = packet_count + 1;
    end
end

end