function [plaza, v, time] = create_plaza(B, L, plazalength,theta)
%
% create_plaza    create the empty plaza matrix( no car ). 
%                 1 = car, 0 = empty, -1 = forbid, -3 = empty&booth
%
% USAGE: [plaza, v, time] = create_plaza(B, L, plazalength)
%        B = number booths
%        L = number lanes in highway before and after plaza
%        plazalength = length of the plaza
%
% zhou lvwen: zhou.lv.wen@gmail.com


plaza = zeros(plazalength,B+2); % 1 = car, 0 = empty, -1 = forbid, -3 = empty&booth
v = zeros(plazalength,B+2); % velocity of automata (i,j), if it exists
time = zeros(plazalength,B+2); % cost time of automata (i,j) if it exists

plaza(1:plazalength,[1,2+B]) = -1;
plaza(ceil(plazalength/2),[2:1+B]) = -3;
%left: angle of width decline for boundaries

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toptheta_left = theta(1); 
bottomtheta_left = theta(3);

% toptheta = 1.1;
% bottomtheta = 1.5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for col = 2:ceil(B/2-L/2) + 1
    for row = 1:(plazalength-1)/2 - floor(tan(toptheta_left) * (col-1))
        plaza(row, col) = -1;
    end
    for row = 1:(plazalength-1)/2 - floor(tan(bottomtheta_left) * (col-1))
        plaza(plazalength+1-row, col) = -1;
    end
end

%fac = ceil(B/2-L/2)/floor(B/2-L/2);
%right: angle of width decline for boundaries
%toptheta= atan(fac*tan(toptheta));
%bottomtheta = atan(fac*tan(bottomtheta));
toptheta_right=theta(2);
bottomtheta_right=theta(4);
for col = 2:floor(B/2-L/2) + 1
    for row = 1:(plazalength-1)/2 - floor(tan(toptheta_right) * (col-1))
        plaza(row,B+3-col) = -1;
    end
    for row = 1:(plazalength-1)/2 - floor(tan(bottomtheta_right) * (col-1))
        plaza(plazalength+1-row,B+3-col) = -1;
    end
end