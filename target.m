function [ di ] = target( x )
%
iterations = 1000; % the maximal iterations of simulation
B = 8; % number booths
L = 3; % number lanes in highway before and after plaza
Arrival=3; % the mean total number of cars that arrives 
plazalength = 2*35; % length of the plaza
Service = 0.6; % Service rate
dt =  0.2; % time step
t_h = 1; % time factor
vmax = 5; % max speed
an=1;
timecost = [];
count_change=0;
count_n=zeros(1,iterations);
decel_count=zeros(1,iterations);
mar_outflux_count=zeros(iterations,B+2);
mar_influx_count=zeros(1,B+2);
bath=zeros(1,B+2);
average_speed_count=0;
yorn = 1;%print figure
theta=[75 80 x(1) x(2)]*pi/180;
[plaza, v, time] = create_plaza(B, L, plazalength,theta);
%
changeornot=0;
%[ plaza , area ] =change_plaza(plaza ,plazalength, L,B,changeornot);
%h = show_plaza(plaza, NaN, 0.01,yorn);
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
    %h = show_plaza(plaza, h, 0.01,yorn);
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
%mar_influx_count=mar_influx_count/(dt*iterations*t_h)*3600;
%outflux_marco_data=sum(mar_outflux_count)/(dt*iterations*t_h)*3600;
sharp_braking_ratio=sum(decel_count)/sum(outflux)/area; %
average_speed = sum(average_speed_count)/sum(count_n);  %
shift_ratio=count_change/sum(outflux)/area;             %
cap=sum(outflux)/(dt*iterations*t_h)*3600;              %
di=-cap/area;
cap
area
well_bad=[average_speed,shift_ratio,sharp_braking_ratio]
end

