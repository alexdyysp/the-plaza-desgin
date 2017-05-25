function [ plaza ,area ] =change_plaza(plaza ,plazalength, L,B,change_or)
%[plaza, v, time] = create_plaza(B, L, plazalength,theta);
if change_or ==1
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
    dline=dline+1;
%change by ourselves
%3-8
%change_shape_plaza =[
%   -1     0     0     0     0     0     0     0     0    -1
%   -1    -1     0    -1     0     0     0    -1    -0    -1
%   -1    -1    -0    -0    -1     0    -1    -0    -0    -1
%   -1    -1    -1    -0     0     0     0    -0    -1    -1
%   -1    -1    -1    -1     0     0     0    -1    -1    -1
%    ];
%6-10
change_shape_plaza =[
    -1     0     0     0     0     0     0     0     0     0     0    -1
    -1    -0     0    -0     0     0     0     0    -0     0    -0    -1
    -1    -1    -0    -1    -0     0     0    -0    -1    -0    -1    -1
    -1    -1    -0     0    -1     0     0    -1     0    -0    -1    -1
    -1    -1    -1     0    -0     0     0    -0     0    -1    -1    -1
 ];
%
%8-20
%change_shape_plaza =[
%    -1     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0    -1
%    -1    -1     0    -0    -1     0     0    -1     0     0     0     0     0     0    -1     0     0    -1    -0     0    -1    -1
%    -1    -1    -1    -0    -0    -1     0     0    -1     0     0     0     0    -1     0     0    -1    -0    -0    -1    -1    -1
%    -1    -1    -1    -1    -0    -0    -1     0     0    -0     0     0    -0     0     0    -1    -0    -0    -1    -1    -1    -1
%    -1    -1    -1    -1    -1    -0    -0    -1     0     0     0     0     0     0    -1    -0    -0    -1    -1    -1    -1    -1
%    -1    -1    -1    -1    -1    -1    -0     0    -0    -0     0     0    -0    -0    -0    -0    -1    -1    -1    -1    -1    -1
%    -1    -1    -1    -1    -1    -1    -1     0     0     0     0     0     0     0    -0    -1    -1    -1    -1    -1    -1    -1
%];
%
%   
    area=size(change_shape_plaza,1)*size(change_shape_plaza,2);
    area=area+sum(sum(change_shape_plaza));
    change_line_count=0;
    for change_line=floor(plazalength/2)+1:1:floor(plazalength/2)+1+size(change_shape_plaza,1)-1
        change_line_count=change_line_count+1;
        plaza(change_line,:) = change_shape_plaza(change_line_count,:);
    end
else
    plaza=plaza;
    area=0;
end


