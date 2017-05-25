clear;clc
B = 20; % number booths
L = 8; % number lanes in highway before and after plaza
Service = 0.5; % Service rate
dt = 0.2; % time step
t_h = 1; % time factor
vmax = 5; % max speed
timecost = [];
an=1;
iterations = 1000;  % the maximal iterations of simulation
yorn = 0;   %print figure
plazalength = 2*35; % length of the plaza
Arrival=4;  % the mean total number of cars that arrives 
theta_count=0;count_change=0;
theta=[75 80 60 60]*pi/180;
dtheta=5;
minmaxtheta=[0 84];
%
%
for theta_plot = minmaxtheta(1):dtheta:minmaxtheta(2)
    theta_count=theta_count+1;
    theta(3)=theta_plot*pi/180;
    theta(4)=theta_plot*pi/180;
    %initial in for
    count_change=0;     %     
    count_n=zeros(1,iterations);    %
    decel_count=zeros(1,iterations);    %
    average_speed_count=0;  %
    [plaza, v, time] = create_plaza(B, L, plazalength,theta);
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
    empty_toll_plaza=plaza(floor(plazalength/2)+1:floor(plazalength/2)+dline,1:2+B);	%get empty toll plaza
    area_toll_plaza(theta_count)=size(empty_toll_plaza,1)*size(empty_toll_plaza,2)+sum(nonzeros(empty_toll_plaza));
    %v initial
    v_count=v(plazalength/2:plazalength/2+dline,2:1+B);
    %multiple examine for theta_j(end) times
    for theta_j=1:20
    count_change=0;     %initialize count_change
    [plaza, v, time] = create_plaza(B, L, plazalength,theta);
    h = show_plaza(plaza, NaN, 0.01,yorn);
        for i = 1:iterations
            % introduce new cars
            [plaza, v, arrivalscount] = new_cars(Arrival, dt, plaza, v, vmax,an);
            h = show_plaza(plaza, h, 0.01,yorn);
            % update rules for lanes
            [plaza, v, time, change_lane] = switch_lanes(plaza, v, time);   % lane shfit
            count_change=count_change+change_lane;                          %lanes shfit
            [plaza, v, time, sud_decel] = move_forward(plaza, v, time, vmax, Service); % move cars forward
            decel_count(i)=sud_decel;   %sudden decel
            [plaza, v, time, departurescount,out_count, departurestime, mar_outflux] = clear_boundary(plaza, v, time);
            v_count=v(floor(plazalength/2)+1:floor(plazalength/2)+dline,2:1+B);
            if ~isempty(nonzeros(v_count))
                count_n(i)=length(nonzeros(v_count));
                average_speed_count(i)=sum(sum(v_count));
            end
            % flux calculations
            influx(i) = arrivalscount;
            outflux(i) = out_count;
            timecost = [timecost, departurestime];
        end
    car_n(theta_count,theta_j)=sum(count_n)/area_toll_plaza(theta_count)/iterations;
    average_speed(theta_count,theta_j)=sum(average_speed_count)/sum(count_n);   %average speed   
    sud_decel_count(theta_count,theta_j)=sum(decel_count)/sum(outflux)/area_toll_plaza(theta_count);         %sudden decel 
    car_count(theta_count,theta_j)=sum(outflux);                                %count car
    cap(theta_count,theta_j)=sum(outflux)/(dt*iterations*t_h)*3600;             %capicity
    shift_count(theta_count,theta_j)=count_change;                              %count shift
    end
end
%线密度
limda=zeros(theta_count,theta_j);
limda=car_n;
mean_limda=sum(limda')/theta_j;
%
%shfit
shift_ratio=zeros(theta_count,theta_j);
for s_c=1:1:theta_count
    shift_ratio(s_c,:)=shift_count(s_c,:)./car_count(s_c,:)/area_toll_plaza(s_c);
end
shift_ratio_aver = sum(shift_ratio')/theta_j;
iplot=minmaxtheta(1):dtheta:minmaxtheta(2);
%capicity throughput
cap_aver = sum(cap')/theta_j;
%average speed
mean_average_speed=sum(average_speed')/theta_j;
%mean decel count
mean_sud_decel=sum(sud_decel_count')/theta_j;
%axis([0 90 13000 18000])% 设置坐标轴在指定的区间
figure (1)  % throughput capicity plot
    hold on
    f1 = plot(iplot,cap,'.');
    f2 = plot(iplot,cap_aver,'-o');
    xlabel('angel / deg')
    ylabel('throughput veh/h')
    title('throughput scatterplot and mean graph')
    legend([f1(1),f2],'scatter','mean line')
%
%
figure (2)  %shfit ratio plot
    hold on
    f3 = plot(iplot,shift_ratio,'.');
    f4 = plot(iplot,shift_ratio_aver,'-o');
    xlabel('angel / deg ')
    ylabel('shift frequency /per car in unit square ')
    title('shift frequency scatterplot and mean graph')
    legend([f3(1),f4],'scatter','mean line')
%
%
figure (3)  %average speed
    hold on
    f5 = plot(iplot,average_speed,'.');
    f6 = plot(iplot,mean_average_speed,'-o');
    xlabel('angel / deg')
    ylabel('average speed ceil/dt')
    title('average speed scatterplot and mean graph')
    legend([f5(1),f6],'scatter','mean line')
%
%
figure (4)  %sharp braking ratio
    hold on
    f7 = plot(iplot,sud_decel_count,'.');
    f8 = plot(iplot,mean_sud_decel,'-o');
    xlabel('angel / deg')
    ylabel('sharp brake frequency /per car in unit square')
    title('sharp brake frequency scatterplot and mean graph')
    legend([f7(1),f8],'scatter','mean line')
%
%
figure (5)  %linear density
    hold on
    f9 = plot(iplot,limda,'.');
    f10 = plot(iplot,mean_limda,'-o');
    xlabel('angel / deg')
    ylabel('linear density /per car in unit square')
    title('linear density scatterplot and mean graph')
    legend([f9(1),f10],'scatter','mean line')