function [plaza, v, time, sud_decel] = move_forward(plaza, v, time, vmax,Service)
% move_forward   car move forward governed by NS algorithm:
% 1. Acceleration. If the vehicle can speed up without hitting the speed limit
% vmax it will add one to its velocity, vn -> vn + 1. Otherwise, the vehicle 
% has constant speed, vn -> vn .
% 2. Collision prevention. If the distance between the vehicle and the car ahead
% of it, dn , is less than or equal to vn , i.e. the nth vehicle will collide
% if it doesnâ€™t slow down, then vn -> dn âˆ?1.
% 3. Random slowing. Vehicles often slow for non-traffic reasons (cell phones,
% coffee mugs, even laptops) and drivers occasionally make irrational choices.
% With some probability pbrake , vn -> vn âˆ?1, presuming vn > 0.
% 4. Vehicle movement. The vehicles are deterministically moved by their velocities, 
% xn -> xn + vn.
% USAGE: [plaza, v, time] = move_forward(plaza, v, time, vmax)
%        plaza = plaza matrix
%                1 = car, 0 = empty, -1 = forbid, -3 = empty&booth
%        v = velocity matrix
%        time = time matrix, to trace the time that the car cost to pass the plaza.
%        vmax = max speed of car
%Service = 0.8; % Service rate
dt = 0.2; % time step
% Prob acceleration
probac = 0.7;
% Prob of random deceleration
probrd = 0.3;
cucar=1;
cubus=0.6;
cucargo=0.3;
sud_decel=0;
[L,W] = size(plaza);
% gap measurement for car in (i,j)
gap = zeros(L,W);
car = find(plaza==cucar);%car
bus = find(plaza==cubus);%bus
cargo=find(plaza==cucargo);%cargo
%find plaza k
wh=[floor(L/2)+1:1:L];
for whi=2:1:W
    wh=[wh,[floor(L/2)+(whi-1)*L+1:1:L+L*(whi-1)]];
end
%
%car
f=car;
cu=cucar;%car unit
for k=f'
    [i,j] = ind2sub([L,W], k);
    d = plaza(i+1:end, j);
    gap(k) = min( find([d~=0;1]) )-1;
end
gap(end,:) = 0;
%count_sharp_decel
k=f;
k_for=size(k,1);
if sum(ismember(wh,k)) > 0
    for k_sum=1:1:k_for
        if ismember(k(k_sum),wh)
            if v(f(k_sum))-gap(k_sum) > 2
                sud_decel=sud_decel+1;
            end
        end
    end
end
%
% update rules for speed:
% 1 Speed up, provided room
k = find(gap(f)>v(f) & rand(size(f))<=probac);
v(f(k)) = min( v(f(k))+1, vmax);
% 2 No crashing
k = find(v(f)>gap(f));
v(f(k)) = gap(f(k));
% 3 Random decel
k = find(rand(size(f)) <= probrd);
v(f(k)) = max(v(f(k)) - 1,0);
% Service: enter and out the booths
booth_row = ceil(L/2);
for i = 2:W-1
    if (plaza(booth_row,i) ~= cucar) & (plaza(booth_row,i) ~= cubus) & (plaza(booth_row,i) ~= cucargo)
        if (plaza(booth_row-1,i) == cu)
            v(booth_row - 1 ,i) = 1;% enter into booth
        end
        plaza(booth_row,i) = -3;
    else % cars pass through service with exponential rate Service
        if (plaza(booth_row+1,i) ~= cu)&(rand > exp(-Service*dt))
            v(booth_row,i) = 1; % out booths
        else
            v(booth_row,i) = 0;
        end
     end
end

%bus
f=bus;
cu=cubus;%bus unit
for k=f'
    [i,j] = ind2sub([L,W], k);
    d = plaza(i+1:end, j);
    gap(k) = min( find([d~=0;1]) )-1;
end
gap(end,:) = 0;
%count_sharp_decel
k=f;
k_for=size(k,1);
if sum(ismember(wh,k)) > 0
    for k_sum=1:1:k_for
        if ismember(k(k_sum),wh)
            if v(f(k_sum))-gap(k_sum) > 2
                sud_decel=sud_decel+1;
            end
        end
    end
end
%
% update rules for speed:
% 1 Speed up, provided room
k = find(gap(f)>v(f) & rand(size(f))<=probac);
v(f(k)) = min( v(f(k))+1, vmax);
% 2 No crashing
k = find(v(f)>gap(f));
v(f(k)) = gap(f(k));
% 3 Random decel
k = find(rand(size(f)) <= probrd);
v(f(k)) = max(v(f(k)) - 1,0);
% Service: enter and out the booths
booth_row = ceil(L/2);
for i = 2:W-1
    if (plaza(booth_row,i) ~= cucar) & (plaza(booth_row,i) ~= cubus) & (plaza(booth_row,i) ~= cucargo)
        if (plaza(booth_row-1,i) == cu)
            v(booth_row - 1 ,i) = 1;% enter into booth
        end
        plaza(booth_row,i) = -3;
    else % cars pass through service with exponential rate Service
        if (plaza(booth_row+1,i) ~= cu)&(rand > exp(-Service*dt))
            v(booth_row,i) = 1; % out booths
        else
            v(booth_row,i) = 0;
        end
     end
end

%cargo
f=cargo;
cu=cucargo;%cargo unit
for k=f'
    [i,j] = ind2sub([L,W], k);
    d = plaza(i+1:end, j);
    gap(k) = min( find([d~=0;1]) )-1;
end
gap(end,:) = 0;
%count_sharp_decel
k=f;
k_for=size(k,1);
if sum(ismember(wh,k)) > 0
    for k_sum=1:1:k_for
        if ismember(k(k_sum),wh)
            if v(f(k_sum))-gap(k_sum) > 2
                sud_decel=sud_decel+1;
            end
        end
    end
end
%
% update rules for speed:
% 1 Speed up, provided room
k = find(gap(f)>v(f) & rand(size(f))<=probac);
v(f(k)) = min( v(f(k))+1, vmax);
% 2 No crashing
k = find(v(f)>gap(f));
v(f(k)) = gap(f(k));
% 3 Random decel
k = find(rand(size(f)) <= probrd);
v(f(k)) = max(v(f(k)) - 1,0);

% Service: enter and out the booths
booth_row = ceil(L/2);
for i = 2:W-1
    if (plaza(booth_row,i) ~= cucar) & (plaza(booth_row,i) ~= cubus) & (plaza(booth_row,i) ~= cucargo)
        if (plaza(booth_row-1,i) == cu)
            v(booth_row - 1 ,i) = 1;% enter into booth
        end
        plaza(booth_row,i) = -3;
    else % cars pass through service with exponential rate Service
        if (plaza(booth_row+1,i) ~= cu)&(rand > exp(-Service*dt))
            v(booth_row,i) = 1; % out booths
        else
            v(booth_row,i) = 0;
        end
     end
end
%
%3b March
plaza(car) = 0;
plaza(bus) = 0;
plaza(cargo) = 0;
plaza(car+v(car)) = cucar;
plaza(bus+v(bus)) = cubus;
plaza(cargo+v(cargo)) = cucargo;
%
time(car + v(car)) = time(car) + 1;
time(bus + v(bus)) = time(bus) + 1;
time(cargo + v(cargo)) = time(cargo) + 1;
time(plaza~=cucar&plaza~=cubus&plaza~=cucargo) = 0;
%
v(car + v(car)) = v(car);
v(bus + v(bus)) = v(bus);
v(cargo + v(cargo)) = v(cargo);
v(plaza~=cucar&plaza~=cubus&plaza~=cucargo)=0;