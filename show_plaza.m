function h = show_plaza(plaza, h, n,yorn)
%
% show_plaza  To show the plaza matrix as a image
% 
% USAGE: h = show_plaza(plaza, h, n)
%        plaza = plaza matrix
%                1 = car, 0 = empty, -1 = forbid, -3 = empty&booth
%        h = handle of the graphics
%        n = pause time
%
% zhou lvwen: zhou.lv.wen@gmail.com

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     R   G   B
if yorn == 1
cc = [0   0   1  ];  % color of car1
ce = [1   1   1  ];  % color of empty
cf = [0.1   0.1   0.1  ];  % color of forbid
cb = [0.5 0.5 0.5];  % color of booth
cc3 = [0   1   0  ];  % color of car00
%ce = [0   0   1  ];  % color of empty
%cf3 = [1   0   0  ];  % color of forbid00
cb2 = [1   0   0  ];  % color of booth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[L, W] = size(plaza); % get its dimensions
[R,G,B] = deal(zeros(size(plaza)));

R(plaza== 1) = cc(1); G(plaza== 1) = cc(2);     B(plaza== 1) = cc(3);%car
R(plaza== 0.6) = cc3(1); G(plaza== 0.6) = cc3(2);     B(plaza== 0.6) = cc3(3);%bus
R(plaza== 0.3) = cb2(1); G(plaza== 0.3) = cb2(2);     B(plaza== 0.3) = cb2(3);%cargo
R(plaza== 0) = ce(1); G(plaza== 0) = ce(2);     B(plaza== 0) = ce(3);%empty
R(plaza==-1) = cf(1); G(plaza==-1) = cf(2);     B(plaza==-1) = cf(3);%forbid
R(plaza==-3) = cb(1); G(plaza==-3) = cb(2);   B(plaza==-3) = cb(3);%booth
PLAZA = cat(3,R,G,B);

if ishandle(h)
    set(h,'CData',PLAZA)
    pause(n)
else
    figure('position',[20,50,200,700])
    h = imagesc(PLAZA);
    hold on
    % draw the grid
    plot([[0:W]',[0:W]']+0.5,[0,L]+0.5,'k')
    plot([0,W]+0.5,[[0:L]',[0:L]']+0.5,'k')
    axis image
    set(gca, 'xtick', [], 'ytick', []);
    pause(n)
end
end