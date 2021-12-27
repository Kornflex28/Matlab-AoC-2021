function [t,solution1,solution2] = day23(verbose)
%DAY23  Solve day 23 problem of AoC 2021
% Author : L. Chauvet
% Date   : 2021/12/27
% 
% --- Day 23: Amphipod ---
% Problem URL : https://adventofcode.com/2021/day/23
%
arguments
    verbose (1,1) double = 1
end
%% GET INPUT
d = 23;
input_data_str = fetch_input(d);
tic;
[hall_1,rooms_1,hall_2,rooms_2] = format_data(input_data_str);
t_format = toc;

%% SOLVING
tic;

% Solution 1
solution1 = find_shortest_path(hall_1, rooms_1);

% Solution 2
solution2 = find_shortest_path(hall_2, rooms_2);

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
function [hall_1,rooms_1,hall_2,rooms_2] = format_data(data_str)
    data = char(splitlines(data_str));
    hall_1 = zeros(1,size(data,2)-2);
    hall_2 = hall_1;
    rooms_1 = data(3:4,4:2:10) - 64;
    data = [data(1:3,:); '  #D#C#B#A#  '; '  #D#B#A#C#  '; data(4:end,:)];
    rooms_2 = data(3:6,4:2:10) - 64;
end

function [cost] = find_shortest_path(hall, room)
  hall_list = hall;
  room_list = room;
  cost_list = 0;
  hash_list = [];
  
  cnt = 0;
  cnt2 = 0;
  while true
    cnt = cnt + 1;
    cnt2 = cnt2 + 1;
    [s, i] = min(cost_list);
    hall = hall_list(:,:,i);
    room = room_list(:,:,i);
    
    if is_room_done(room)
      cost = s;
      return
    end
    
    h = state_to_hash(hall, room);
    if any(hash_list == h)
      cost_list(i) = Inf;
      continue
    else
      hash_list(end+1) = h;
    end
    
    [new_hall, new_room, new_cost] = valid_moves(hall, room);
    
    n = numel(new_cost);
    hall_list(:,:,end+1:end+n) = new_hall;
    room_list(:,:,end+1:end+n) = new_room;
    cost_list(end+1:end+n) = s + new_cost;
    
    cost_list(i) = Inf;
    
    if cnt2 > 10000
      cnt2 = 0;
      ind = cost_list < Inf;
      hall_list = hall_list(:,:,ind);
      room_list = room_list(:,:,ind);
      cost_list = cost_list(ind);
    end
  end
end

function [new_hall, new_rooms, new_costs] = valid_moves(hall, room)
  new_hall = zeros(0,0,0);
  new_rooms = zeros(0,0,0);
  new_costs = zeros(0);
  costs = [1 10 100 1000];
  valid_hall = [1 2 4 6 8 10 11];
  rooms_loc = [3 5 7 9];
  nroom = size(room,1);
  rooms_open = sum(room == 1:4 | room == 0) == nroom;
  
  for khall = valid_hall
    if hall(khall) == 0
      continue
    end
    c = hall(khall);
    if rooms_open(c)
      k = rooms_loc(c);
      if khall < k
        ind = khall+1:k;
      else
        ind = k:khall-1;
      end
      if any(hall(ind) > 0)
        continue
      end
      nh = hall;
      nr = room;
      nh(khall) = 0;
      
      for kroom = 0:nroom-1
        lroom = nroom-kroom;
        if nr(lroom,c) == 0
          nr(lroom,c) = c;
          vd = lroom;
          break
        end
      end
      
      new_hall(:,:,end+1) = nh;
      new_rooms(:,:,end+1) = nr;
      new_costs(end+1) = costs(c) * (vd + abs(rooms_loc(c) - khall));
    end
  end
  
  % move from room to hall
  for khall = 1:4
    if rooms_open(khall)
      continue
    end
    k = rooms_loc(khall);
    for kroom = valid_hall
      if kroom < k
        ind = kroom:k;
      else
        ind = k:kroom;
      end
      
      if ~any(hall(ind))
        nh = hall;
        nr = room;
        
        for m = 1:nroom
          if nr(m,khall) ~= 0
            c = nr(m,khall);
            nr(m,khall) = 0;
            vd = m;
            break
          end
        end
        
        nh(kroom) = c;
        new_hall(:,:,end+1) = nh;
        new_rooms(:,:,end+1) = nr;
        new_costs(end+1) = costs(c) * (vd + abs(k - kroom));
      end
    end
  end
end

function [done] = is_room_done(room)
  done = all(room == 1:4, 'all');
end

function h = state_to_hash(hall, room)
  h_ind = [1 2 4 6 8 10 11];
  m = [hall(h_ind), room(:)'];
  p = 5.^(numel(m)-1:-1:0);
  h = sum(p.*m);
end
end