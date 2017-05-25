function [plaza, v, ncars] = new_cars(Arrival, dt, plaza, v, vmax,an)
%
% new_cars   introduce new cars. Cars arrive at the toll plaza uniformly in
% time (the interarrival distribution is exponential with rate Arrival?). 
% "rush hour" phenomena can be consider by varying the arrival rate.
% USAGE: [plaza, v, number_cars] = new_cars(Arrival, dt, plaza, v, vmax)
%        Arrival = the mean total number of cars that arrives 
%        dt = time step
%        plaza = plaza matrix
%                1 = car, 0 = empty, -1 = forbid, -3 = empty&booth
%        v = velocity matrix
%        vmax = max speed of car
% Find the empty lanes of the entrance where a new car can be add.
%for appear_number=1:3:an
    appear_number=1;
    unoccupied = find(plaza(appear_number,:) == 0);
    n = length(unoccupied); % number of available lanes
% The number of vehicles must be integer and not exceeding the number of
% available lanes
    ncars =min( poissrnd(Arrival,1), n);
    if ncars > 0
        x=unoccupied(randperm(n));
        x=x(1:ncars); 
        for c=1:1:ncars
            if rand < 0.6
                plaza(appear_number, (x(c))) = 1;         %car
                v(appear_number, (x(c))) = vmax;
            else
                if rand < 3/4
                    plaza(appear_number, (x(c))) = 0.6;   %bus
                    v(appear_number, (x(c))) = vmax*4/5;
                else
                    plaza(appear_number, (x(c))) = 0.3;   %cargo
                    v(appear_number, (x(c))) = vmax*3/5;
                end
            end
        end
    end
    