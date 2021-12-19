function [t,solution1,solution2] = day17(verbose)
%DAY17  Solve day 17 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/19
% 
% --- Day 17: Trick Shot ---
% Problem URL : https://adventofcode.com/2021/day/17
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 17;
input_data_str = fetch_input(d);
tic;
[target_area] = format_data(input_data_str);
t_format = toc;

%% SOLVING
tic;

%%% BRUTE FORCE SOLUTION
% vxs = 0:target_area.xmax;
% vys = -max(abs([target_area.ymin target_area.ymax])):max(abs([target_area.ymin target_area.ymax]));
% nvxs = length(vxs);
% nvys = length(vys);
% max_heights = -inf(nvys,nvxs);
% 
% 
% for kvx = 1:nvxs
%     for kvy = 1:nvys
%         traj = get_trajectory([vxs(kvx) vys(kvy)],target_area);
%         if traj(end).is_in_target
%             max_heights(kvy,kvx) = get_max_height(traj);
%         end
%     end
% end
% 
% % Solution 1
% solution1 = max(max_heights,[],'all');
% 
% % Solution 2
% solution2 = sum(max_heights~=-inf,'all');
%%%

% Solution 1
% Solving equations with pen and paper we found :
solution1 = .5*abs(target_area.ymin)*(abs(target_area.ymin)-1);

% Solution 2
valid_steps_x = get_valid_steps_x(0,target_area);
valid_steps_y = get_valid_steps_y(0,target_area);
solution2 = count_valid_initial(valid_steps_x,valid_steps_y);


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
function [target_area] = format_data(data_str)
    pattern_expr = 'x=(?<xmin>-?\d+)..(?<xmax>-?\d+), y=(?<ymin>-?\d+)..(?<ymax>-?\d+)';
    target_area = regexp(data_str,pattern_expr,'names');
    target_area = structfun(@str2double,target_area,'UniformOutput',false);
end

function [next_pos] = get_next_posvel(current_pos)
    next_pos.x  = current_pos.x + current_pos.vx;
    next_pos.y  = current_pos.y + current_pos.vy;
    next_pos.vx = current_pos.vx - sign(current_pos.vx);
    next_pos.vy = current_pos.vy - 1;
end

function [trajectory] = get_trajectory(start_vel,target_area)
    % Get trajectory iteratively
    start_pos = struct('x',0,'y',0,'vx',start_vel(1),'vy',start_vel(2),'is_in_target',false,'is_past_target',false);
    trajectory(1) = start_pos;
    istep = 2;
    while true
        kpos = get_next_posvel(trajectory(istep-1));
        kpos.is_in_target = target_area.xmin <= kpos.x & kpos.x <= target_area.xmax & ...
                            target_area.ymin <= kpos.y & kpos.y <= target_area.ymax;
        kpos.is_past_target = target_area.xmax < kpos.x |  kpos.y < target_area.ymin;
        trajectory(istep) = kpos;

        if kpos.is_in_target || kpos.is_past_target
            break
        end
        istep = istep+1;
    end
end

function [max_height] = get_max_height(trajectory)
    max_height = max([trajectory.y]);
end

function [xt] = x(t,x0,v0x)
    xt = x0 + sign(v0x).*(abs(max(0, abs(v0x)-(t-1))) .* t + min(sum_int_0_to_n(t-1), sum_int_0_to_n(v0x)));
end

function [yt] = y(t,y0,v0y)
    yt = y0+t*v0y - sum_int_0_to_n(t-1);
end

function [valid_steps_x] = get_valid_steps_x(x0,target_area)
    valid_steps_x = {};
    v0x_min = floor(.5*(sqrt(8*target_area.xmin+1)-1));
    for v0x = v0x_min:target_area.xmax+1
        kstep = 0;
        xt = x0;
        valid_steps = [];
        while kstep<2*abs(target_area.ymin)+2 && xt<=target_area.xmax
            xt = x(kstep,x0,v0x);
            if target_area.xmin <= xt && xt <= target_area.xmax
                valid_steps = [valid_steps kstep];
            end
            kstep = kstep + 1;
        end
        valid_steps_x = [valid_steps_x valid_steps];
    end
end

function [valid_steps_y] = get_valid_steps_y(y0,target_area)
    valid_steps_y = {};
    v0y_min = -max(abs([target_area.ymin target_area.ymax]));
    for v0y = v0y_min:-v0y_min
        kstep = 0;
        valid_steps = [];
        yt=y0;
        while yt>= v0y_min
            yt  = y(kstep,y0,v0y);
            if target_area.ymin <= yt && yt <= target_area.ymax
                valid_steps = [valid_steps kstep];
            end
            kstep = kstep + 1;
        end
        valid_steps_y = [valid_steps_y valid_steps];
    end
end

function [count] = count_valid_initial(valid_steps_x,valid_steps_y)
    count = 0;
    for kx=1:numel(valid_steps_x)
        for ky=1:numel(valid_steps_y)
            count = count + ~isempty(intersect(valid_steps_x{kx},valid_steps_y{ky}));
        end
    end
end


function [tot] = sum_int_0_to_n(n)
    tot = .5*n.*(n+1);
end

end