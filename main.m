% main.m
%
% This is a main script to simulate the approach, service, and departure of 
% vehicles passing through a toll plaza, , as governed by the parameters 
% defined below
%
%   iterations      =  the maximal iterations of simulation
%   B               =  number booths
%   L               =  number lanes in highway before and after plaza
%   Arrival         =  the mean total number of cars that arrives 
%   plazalength     =  length of the plaza
%   Service         =  Service rate of booth
%   plaza           =  plaza matrix
%                      1 = car, 0 = empty, -1 = forbid, -3 = empty&booth
%   v               =  velocity matrix
%   vmax            =  max speed of car
%   time            =  time matrix, to trace the time that the car cost to
%                      pass the plaza.
%   dt              =  time step
%   t_h             =  time factor
%   departurescount =  number of cars that departure the plaza in the step
%   departurestime  =  time cost of the departure cars
%   influx          =  influx vector
%   outflux         =  outflux vector
%   timecost        =  time cost of all car
%   h               =  handle of the graphics
%   
clear;clc
iterations = 500; % the maximal iterations of simulation
B = 10; % number booths
L = 6; % number lanes in highway before and after plaza
Arrival=5; % the mean total number of cars that arrives 
plazalength = 2*35; % length of the plaza
Service = 0.5; % Service rate
dt =  0.2; % time step
t_h = 1; % time factor
vmax = 5; % max speed
an=1;
timecost = [];
count_change=1;
count_n=zeros(1,iterations);
decel_count=zeros(1,iterations);
mar_outflux_count=zeros(iterations,B+2);
mar_influx_count=zeros(1,B+2);
bath=zeros(1,B+2);
average_speed_count=0;
yorn = 1;%print figure
theta=[70 70 55 55]*pi/180;
[plaza, v, time] = create_plaza(B, L, plazalength,theta);
%
changeornot=0;
[ plaza , area ] =change_plaza(plaza ,plazalength, L,B,changeornot);
h = show_plaza(plaza, NaN, 0.01,yorn);
%找出那几行属于toll plaza
line_count=0;
for line=floor(plazalength/2)+1:1:plazalength
	line_count=line_count+1;
	wine(line_count)=sum(plaza(line,:)==0);
end
for line_find=1:1:floor(plazalength/2)
	if wine(line_find)==L
		dline=line_find;
		break
	end
end
%empty toll plaza
if changeornot == 0
    empty_toll_plaza = plaza(floor(plazalength/2)+1:floor(plazalength/2)+dline,1:2+B);	%get empty toll plaza
    area = size(empty_toll_plaza,1)*size(empty_toll_plaza,2)+sum(nonzeros(empty_toll_plaza));
end
%
v_count=v(plazalength/2:plazalength/2+dline,2:1+B);
%
for i = 1:iterations
    % introduce new cars
    [plaza, v, arrivalscount] = new_cars(Arrival, dt, plaza, v, vmax,an);
    h = show_plaza(plaza, h, 0.01,yorn);
    % update rules for lanes
    [plaza, v, time, change_lane] = switch_lanes(plaza, v, time); % lane changes
    count_change=count_change+change_lane;
    [plaza, v, time, sud_decel] = move_forward(plaza, v, time, vmax, Service); % move cars forward
    %计数TOLL BATH 车流量
    bath=plaza(floor(plazalength/2)+1,:);
    if (sum(ismember(bath,1))+sum(ismember(bath,0.6))+sum(ismember(bath,0.3))) > 0
        for bath_line=1:1:B+2
            if bath(bath_line) == 1
                mar_influx_count(bath_line) = bath(bath_line)*1+mar_influx_count(bath_line);
            end
            if bath(bath_line) == 0.6
                mar_influx_count(bath_line) = bath(bath_line)*2+mar_influx_count(bath_line);
            end
            if bath(bath_line) == 0.3
                mar_influx_count(bath_line) = bath(bath_line)*2+mar_influx_count(bath_line);
            end
        end
    end
    %
    decel_count(i)=sud_decel;
    [plaza, v, time, departurescount,out_count, departurestime, mar_outflux] = clear_boundary(plaza, v, time);
    mar_outflux_count(i,:)=mar_outflux;
    % flux calculations    
    %average speed
    v_count=v(floor(plazalength/2)+1:floor(plazalength/2)+dline,2:1+B);
    if ~isempty(nonzeros(v_count))
        count_n(i)=length(nonzeros(v_count));
        average_speed_count(i)=sum(sum(v_count));
    end
    %average_speed_count=sum(sum(v_count))/length(nonzeros(v_count));
    %average_speed_count(i)=sum(sum(v_count));
    influx(i) = arrivalscount;
    outflux(i) = out_count;
    timecost = [timecost, departurestime];
end
%staticis
mar_influx_count=mar_influx_count/(dt*iterations*t_h)*3600
outflux_marco_data=sum(mar_outflux_count)/(dt*iterations*t_h)*3600
sharp_braking_ratio=sum(decel_count)/sum(outflux);
average_speed = sum(average_speed_count)/sum(count_n);
limda=sum(count_n)/area/iterations;
shift_ratio=count_change/sum(outflux);
cap=sum(outflux)/(dt*iterations*t_h)*3600;
h = show_plaza(plaza, h, 0.01,yorn);
xlabel({
strcat('B = ',num2str(B)), ...
strcat('mean cost time = ', num2str(mean(timecost))),...
strcat('passthrough capicity =',num2str(cap)),...
strcat('shift frequency =',num2str(shift_ratio/area)),...
strcat('average speed =',num2str(average_speed)),...
strcat('sharp brake frequency =',num2str(sharp_braking_ratio/area)),...
strcat('vehicle linear density =',num2str(limda))   })