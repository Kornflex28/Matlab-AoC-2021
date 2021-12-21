function [t,solution1,solution2] = day19(verbose)
%DAY19  Solve day 19 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/21
% 
% --- Day 19: Beacon Scanner ---
% Problem URL : https://adventofcode.com/2021/day/19
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 19;
input_data_str = fetch_input(d);
tic;
[scanner_reports] = format_data(input_data_str);
t_format = toc;

%% SOLVING
tic;
rotation_mats = rotation_mats_3D();
nrotation_mats = length(rotation_mats);
nscanner = size(scanner_reports,1);

scanner_positions = [0 0 0];
fixed_beacon_positions = scanner_reports{1};
not_processed_scanners = 2:nscanner;
kscanner = 1;
while ~isempty(not_processed_scanners)
    kscanner = wrap_to_n(kscanner,length(not_processed_scanners));

    beacon_positions_to_process = scanner_reports{not_processed_scanners(kscanner)};
    
    for krot = 1:nrotation_mats
        rotation_mat = rotation_mats{krot};
        rotated_beacon_positions_to_process = beacon_positions_to_process * rotation_mat;
        pairwise_distances = euclidean_dist(fixed_beacon_positions, rotated_beacon_positions_to_process);
        most_common_pairwise_dist = mode(pairwise_distances,'all');
        [common_row_ind,common_col_ind] = find(pairwise_distances == most_common_pairwise_dist,12);
        if length(common_row_ind) == 12

            kscanner_position = fixed_beacon_positions(common_row_ind(1),:) - rotated_beacon_positions_to_process(common_col_ind(1),:);
            
            fixed_beacon_positions = [fixed_beacon_positions; rotated_beacon_positions_to_process + kscanner_position];
            fixed_beacon_positions = unique(fixed_beacon_positions,'rows');
            
            scanner_positions = [scanner_positions; kscanner_position];
            not_processed_scanners(kscanner) = [];
            kscanner = kscanner-1;
            break
        end    
    end  
    kscanner = kscanner+1;
end

% Solution 1
solution1 = length(fixed_beacon_positions);

% Solution 2
solution2 = max(manhatta_dist(scanner_positions,scanner_positions),[],'all');

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
function [scanner_reports] = format_data(data_str)
    data = splitlines(data_str);
    data = data(~cellfun(@isempty,data));
    reports_start = find(cellfun(@(x) contains(x,'scanner'),data))+1;

    nreport = length(reports_start);
    scanner_reports = cell(nreport,1);
    for kreport = 1:nreport
        if kreport == nreport
            report = data(reports_start(kreport):end);
        else
            report = data(reports_start(kreport):reports_start(kreport+1)-2);
        end
        scanner_reports{kreport} = str2double(split(report,','));
    end
end

function [wrap_n] = wrap_to_n(x,n)
    % Keep x in range [1:n]
    wrap_n = (1 + mod(x-1, n));
end

function [dist] = euclidean_dist(x, y)
   % ||x-y||^2 = ||x||^2 + ||y||^2 - 2*x.y
   dist = bsxfun(@plus,sum(x.^2,2),sum(y.^2,2)') - 2*(x*y');
end

function [dist] = manhatta_dist(x, y)
   dist = sum(abs(bsxfun(@minus,permute(x,[1 3 2]),permute(y,[3 1 2]))),3);
end

function M = rotation_mats_3D()
    Mx = [1 0 0;0 1 0;0 0 1;1 0 0;0 0 -1;0 1 0;1 0 0;0 -1 0;0 0 -1;1 0 0;0 0 1;0 -1 0;0 -1 0;1 0 0;0 0 1;0 0 1;1 0 0;0 1 0;0 1 0;1 0 0;0 0 -1;0 0 -1;1 0 0;0 -1 0;-1 0 0;0 -1 0;0 0 1;-1 0 0;0 0 -1;0 -1 0;-1 0 0;0 1 0;0 0 -1;-1 0 0;0 0 1;0 1 0;0 1 0;-1 0 0;0 0 1;0 0 1;-1 0 0;0 -1 0;0 -1 0;-1 0 0;0 0 -1;0 0 -1;-1 0 0;0 1 0;0 0 -1;0 1 0;1 0 0;0 1 0;0 0 1;1 0 0;0 0 1;0 -1 0;1 0 0;0 -1 0;0 0 -1;1 0 0;0 0 -1;0 -1 0;-1 0 0;0 -1 0;0 0 1;-1 0 0;0 0 1;0 1 0;-1 0 0;0 1 0;0 0 -1;-1 0 0];
    nrotation = size(Mx,1);
    M = cell(1,nrotation/3);
    for krotation = 1:nrotation/3
        M{krotation} = Mx(3*(krotation-1)+ 1 : 3*krotation,:);
    end
end

end
