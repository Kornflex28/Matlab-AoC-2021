function [t,solution1,solution2] = day22(verbose)
%DAY22  Solve day 22 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/22
% 
% --- Day 22: Reactor Reboot ---
% Problem URL : https://adventofcode.com/2021/day/22
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 22;
input_data_str = fetch_input(d);
tic;
[reboot_steps] = format_data(input_data_str);
t_format = toc;

%% SOLVING
tic;

% Solution 1
shift = 51;
nrows = 2*shift-1;
reactor_core = (zeros(nrows,nrows,nrows));
for kstep=1:size(reboot_steps,2)
    xmin = reboot_steps(kstep).xmin+shift;
    xmax = reboot_steps(kstep).xmax+shift;
    ymin = reboot_steps(kstep).ymin+shift;
    ymax = reboot_steps(kstep).ymax+shift;
    zmin = reboot_steps(kstep).zmin+shift;
    zmax = reboot_steps(kstep).zmax+shift;
    if any([xmin:xmax,ymin:ymax,zmin:zmax] < 1 | nrows < [xmin:xmax,ymin:ymax,zmin:zmax])
        continue;
    end
    reactor_core(xmin:xmax,ymin:ymax,zmin:zmax) = reboot_steps(kstep).action;
end
solution1 = sum(reactor_core,'all');

% Solution 2
cuboids = [];
for kstep = 1:size(reboot_steps,2)
  
  step_cuboid = reboot_steps(kstep);
  new_cuboids = [];
  old_cuboids = [];

  if step_cuboid.action
    new_cuboids = step_cuboid;
  end
  
  for kcuboid = 1:size(cuboids, 1)
    cuboid = cuboids(kcuboid);
    if is_overlapping(cuboid, step_cuboid)
      sub_cuboids = split_cuboids(cuboid,step_cuboid);

      new_cuboids = [new_cuboids; sub_cuboids];
      old_cuboids = [old_cuboids; kcuboid];
    end
  end
  cuboids(old_cuboids) = [];
  cuboids = [cuboids; new_cuboids];
end

solution2 = count_on_cubes(cuboids);

t_end = toc;
%% LOGS
if verbose
    print_solution(d,solution1,solution2);
    print_elapsed_time(t_format,t_end);
end

t = [t_format;t_end];

if nargout == 0
    clear solution1 solution2 t
end
%% HELPER FUNCTIONS
function [input_data] = format_data(data_str)
    data = splitlines(data_str);
    pattern_expr = '(?<action>\w+) x=(?<xmin>-?\d+)..(?<xmax>-?\d+),y=(?<ymin>-?\d+)..(?<ymax>-?\d+),z=(?<zmin>-?\d+)..(?<zmax>-?\d+)';
    input_data = regexp(data,pattern_expr,'names');
    input_data = [input_data{:}];
    for kline = 1:size(input_data,2)
        input_data(kline).action = strcmp(input_data(kline).action,'on');
        input_data(kline).xmin = str2double(input_data(kline).xmin);
        input_data(kline).xmax = str2double(input_data(kline).xmax);
        input_data(kline).ymin = str2double(input_data(kline).ymin);
        input_data(kline).ymax = str2double(input_data(kline).ymax);
        input_data(kline).zmin = str2double(input_data(kline).zmin);
        input_data(kline).zmax = str2double(input_data(kline).zmax);
    end
end

function [on_cubes] = count_on_cubes(cuboids)
  cuboids_dims = [cuboids.xmax; cuboids.ymax; cuboids.zmax] - [cuboids.xmin; cuboids.ymin; cuboids.zmin] + 1;
  cuboids_volumes = prod(cuboids_dims);
  on_cubes = sum(cuboids_volumes);
end

function [overlapping] = is_overlapping(cuboid1, cuboid2)
    overlapping = false;
    maxmin_dims = max([cuboid1.xmin cuboid1.ymin cuboid1.zmin; cuboid2.xmin cuboid2.ymin cuboid2.zmin]);
    minmax_dims = min([cuboid1.xmax cuboid1.ymax cuboid1.zmax; cuboid2.xmax cuboid2.ymax cuboid2.zmax]);
    if all(maxmin_dims <= minmax_dims, 'all')
        overlapping = true;
    end
end

function [splitcuboids] = split_cuboids(cuboid1,cuboid2)

    smallest_cuboid.action = cuboid2.action;
    smallest_cuboid.xmin = max([cuboid1.xmin cuboid2.xmin]);
    smallest_cuboid.xmax = min([cuboid1.xmax cuboid2.xmax]);
    smallest_cuboid.ymin = max([cuboid1.ymin cuboid2.ymin]);
    smallest_cuboid.ymax = min([cuboid1.ymax cuboid2.ymax]);
    smallest_cuboid.zmin = max([cuboid1.zmin cuboid2.zmin]);
    smallest_cuboid.zmax = min([cuboid1.zmax cuboid2.zmax]);
    
    subcuboid1 = cuboid1;
    subcuboid2 = cuboid1;
    subcuboid3 = cuboid1;
    subcuboid4 = cuboid1;
    subcuboid5 = smallest_cuboid;
    subcuboid6 = smallest_cuboid;

    subcuboid1.xmax = smallest_cuboid.xmin - 1;
    
    subcuboid2.xmin = smallest_cuboid.xmax + 1;
    
    subcuboid3.xmin = smallest_cuboid.xmin;
    subcuboid3.xmax = smallest_cuboid.xmax;
    subcuboid3.ymax = smallest_cuboid.ymin - 1;
    
    subcuboid4.xmin = smallest_cuboid.xmin;
    subcuboid4.xmax = smallest_cuboid.xmax;
    subcuboid4.ymin = smallest_cuboid.ymax + 1;

    subcuboid5.action = cuboid1.action; 
    subcuboid5.zmin = cuboid1.zmin;
    subcuboid5.zmax = smallest_cuboid.zmin - 1;

    subcuboid6.action = cuboid1.action;
    subcuboid6.zmax = cuboid1.zmax;
    subcuboid6.zmin = smallest_cuboid.zmax + 1;
    
    subcuboids = [subcuboid1; subcuboid2; subcuboid3; subcuboid4; subcuboid5; subcuboid6];
    splitcuboids = subcuboids([subcuboids.xmin] <= [subcuboids.xmax] & [subcuboids.ymin] <= [subcuboids.ymax] & [subcuboids.zmin] <= [subcuboids.zmax]);
end

end