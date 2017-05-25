function [plaza, v, time, departurescount,out_count, departurestime, mar_outflux] = clear_boundary(plaza, v, time)
%
% clear_boundary  remove the cars of the exit cell
%
% USAGE: [plaza, v, time, departurescount, departurestime] = clear_boundary(plaza, v, time)
%        plaza = plaza matrix
%                1 = car, 0 = empty, -1 = forbid, -3 = empty&booth
%        v = velocity matrix
%        time = time matrix, to trace the time that the car cost to pass the plaza.
%
% zhou lvwen: zhou.lv.wen@gmail.com

departurescount = 0;
out_count=0;
dcount=0;
departurestime = [];
[a,b] = size(plaza);
mar_outflux=zeros(1,b);
mar_count=zeros(1,b);
for i = 2:b-1
    if plaza(a,i) > 0
        departurescount = departurescount + 1;
        if plaza(a,i)==1
            out_count = out_count + plaza(a,i)*1;
        end
        if plaza(a,i)==0.6
            out_count = out_count + plaza(a,i)*2;
        end
        if plaza(a,i)==0.3
            out_count = out_count + plaza(a,i)*2;
        end
        departurestime(departurescount) = time(a,i);
        plaza(a,i) = 0;
        v(a,i) = 0;
        time(a,i) = 0;
        mar_count(i)=out_count;
        mar_outflux(i) = mar_count(i)-dcount; %计算每个车道的车流量
        dcount=out_count;
    end    
end
