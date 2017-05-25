function [plaza, v, time,change_lane] =  switch_lanes(plaza, v, time)
%
% switch_lanes  Merge to avoid obstacles.
%  
% The vehicle will attempt to merge if its forward path is obstructed (dn = 0). 
% The vehicle then randomly chooses an intended direction, right or left. If 
% that intended direction is blocked, the car will move in the other direction
% unless both directions are blocked (the car is surrounded). 
% 
% USAGE: [plaza, v, time] =  switch_lanes(plaza, v, time)
%        plaza = plaza matrix
%                1 = car, 0 = empty, -1 = forbid, -3 = empty&booth
%        v = velocuty matrix
%        time = time matrix, to trace the time that the car cost to pass the plaza.
%
% zhou lvwen: zhou.lv.wen@gmail.com
cucar=1;cubus=0.6;cucargo=0.3;
[L, W] = size(plaza);
change_lane=0;
%car
cu=cucar;
found = find(plaza==cucar);
found = found(randperm(length(found)));
%find where is toll plaza 
wh=[floor(L/2)+1:1:L];
for whi=2:1:W
    wh=[wh,[floor(L/2)+(whi-1)*L+1:1:L+L*(whi-1)]];
end
%
for k=found'
     %让它走出障碍物
    if (plaza(k+1) == -1 ) & ( (plaza(k-L+1) == -1) | (plaza(k+L+1) == -1) )
        if k < L*W/2
            plaza(k+L) = cu;
            plaza(k) = 0;
            v(k+L) = v(k);
            v(k) = 0;
            time(k+L) = time(k);
            time(k) = 0;
            if sum(ismember(wh,k))
                change_lane=change_lane+1;
            end
        else
            plaza(k-L) = cu;
            plaza(k) = 0;
            v(k-L) = v(k);
            v(k) = 0;
            time(k-L) = time(k);
            time(k) = 0;
            if sum(ismember(wh,k))
                change_lane=change_lane+1;
            end
        end
    end
    %random change lane
    if (plaza(k+1)~=0 ) & rem(k,L)~=floor(L/2)
        if (rand < .5 )
            if plaza(k+L) == 0 & plaza(k+L+1) == 0
                plaza(k+L) = cu;
                plaza(k) = 0;
                v(k+L) = v(k);
                v(k) = 0;
                time(k+L) = time(k);
                time(k) = 0;
            if sum(ismember(wh,k))
                change_lane=change_lane+1;
            end
            elseif plaza(k-L) == 0 & plaza(k-L+1) == 0
                plaza(k-L) = cu;
                plaza(k) = 0;
                v(k-L) = v(k);
                v(k) = 0;
                time(k-L) = time(k);
                time(k) = 0;
            if sum(ismember(wh,k))
                change_lane=change_lane+1;
            end
            end
        else
            if plaza(k-L) == 0 & plaza(k-L+1) == 0
                plaza(k-L) = cu;
                plaza(k) = 0;
                v(k-L) = v(k);
                v(k) = 0;
                time(k-L) = time(k);
                time(k) = 0;
            if sum(ismember(wh,k))
                change_lane=change_lane+1;
            end
            elseif plaza(k+L) == 0 & plaza(k+L+1) == 0
                plaza(k+L) = cu;
                plaza(k) = 0;
                v(k+L) = v(k);
                v(k) = 0;
                time(k+L) = time(k);
                time(k) = 0;
            if sum(ismember(wh,k))
                change_lane=change_lane+1;
            end
            end
        end
    end
end
%bus
cu=cubus;
found = find(plaza==cubus);
found = found(randperm(length(found)));
for k=found'
    %让它走出障碍物
    if (plaza(k+1) == -1 ) &  ((plaza(k-L+1) == -1) | (plaza(k+L+1) == -1) )
        if k < L*W/2
            plaza(k+L) = cu;
            plaza(k) = 0;
            v(k+L) = v(k);
            v(k) = 0;
            time(k+L) = time(k);
            time(k) = 0;
            if sum(ismember(wh,k))
                change_lane=change_lane+1;
            end
        else
            plaza(k-L) = cu;
            plaza(k) = 0;
            v(k-L) = v(k);
            v(k) = 0;
            time(k-L) = time(k);
            time(k) = 0;
            if sum(ismember(wh,k))
                change_lane=change_lane+1;
            end
        end        
    end
    %
    if (plaza(k+1)~=0 ) & rem(k,L)~=floor(L/2)
        if (rand < .5 )
            if plaza(k+L) == 0 & plaza(k+L+1) == 0
                plaza(k+L) = cu;
                plaza(k) = 0;
                v(k+L) = v(k);
                v(k) = 0;
                time(k+L) = time(k);
                time(k) = 0;
            if sum(ismember(wh,k))
                change_lane=change_lane+1;
            end
            elseif plaza(k-L) == 0 & plaza(k-L+1) == 0
                plaza(k-L) = cu;
                plaza(k) = 0;
                v(k-L) = v(k);
                v(k) = 0;
                time(k-L) = time(k);
                time(k) = 0;
            if sum(ismember(wh,k))
                change_lane=change_lane+1;
            end
            end
        else
            if plaza(k-L) == 0 & plaza(k-L+1) == 0
                plaza(k-L) = cu;
                plaza(k) = 0;
                v(k-L) = v(k);
                v(k) = 0;
                time(k-L) = time(k);
                time(k) = 0;
            if sum(ismember(wh,k))
                change_lane=change_lane+1;
            end
            elseif plaza(k+L) == 0 & plaza(k+L+1) == 0
                plaza(k+L) = cu;
                plaza(k) = 0;
                v(k+L) = v(k);
                v(k) = 0;
                time(k+L) = time(k);
                time(k) = 0;
            if sum(ismember(wh,k))
                change_lane=change_lane+1;
            end
            end
        end
    end
end
%cargo
cu=cucargo;
found = find(plaza==cucargo);
found = found(randperm(length(found)));
for k=found'
    %让它走出障碍物
    if (plaza(k+1) == -1 ) & ((plaza(k-L+1) == -1) | (plaza(k+L+1) == -1))
        if k < L*W/2
            plaza(k+L) = cu;
            plaza(k) = 0;
            v(k+L) = v(k);
            v(k) = 0;
            time(k+L) = time(k);
            time(k) = 0;
            if sum(ismember(wh,k))
                change_lane=change_lane+1;
            end
        else
            plaza(k-L) = cu;
            plaza(k) = 0;
            v(k-L) = v(k);
            v(k) = 0;
            time(k-L) = time(k);
            time(k) = 0;
            if sum(ismember(wh,k))
                change_lane=change_lane+1;
            end
        end        
    end
    %
    if (plaza(k+1)~=0 & rem(k,L)~=floor(L/2))
        if (rand < .5 )
            if plaza(k+L) == 0 & plaza(k+L+1) == 0
                plaza(k+L) = cu;
                plaza(k) = 0;
                v(k+L) = v(k);
                v(k) = 0;
                time(k+L) = time(k);
                time(k) = 0;
            if sum(ismember(wh,k))
                change_lane=change_lane+1;
            end
            elseif plaza(k-L) == 0 & plaza(k-L+1) == 0
                plaza(k-L) = cu;
                plaza(k) = 0;
                v(k-L) = v(k);
                v(k) = 0;
                time(k-L) = time(k);
                time(k) = 0;
            if sum(ismember(wh,k))
                change_lane=change_lane+1;
            end
            end
        else
            if plaza(k-L) == 0 & plaza(k-L+1) == 0
                plaza(k-L) = cu;
                plaza(k) = 0;
                v(k-L) = v(k);
                v(k) = 0;
                time(k-L) = time(k);
                time(k) = 0;
            if sum(ismember(wh,k))
                change_lane=change_lane+1;
            end
            elseif plaza(k+L) == 0 & plaza(k+L+1) == 0
                plaza(k+L) = cu;
                plaza(k) = 0;
                v(k+L) = v(k);
                v(k) = 0;
                time(k+L) = time(k);
                time(k) = 0;
            if sum(ismember(wh,k))
                change_lane=change_lane+1;
            end
            end
        end
    end
end