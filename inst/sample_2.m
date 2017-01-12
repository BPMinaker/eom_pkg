item.a=2.3*0.45;
item.b=2.3*0.55;
item.m=2000;
item.I=3000;
item.cf=50000;
item.cr=44000;
run_eom('input_ex_yaw_plane',(0.5:0.5:30),item); %% Yaw plane model


% pause(1);
% 
% run_eom('input_ex_truck_trailer',(0.5:0.5:30)); %% Truck trailer model
%  
% pause(1);
% 
% run_eom('input_ex_bicycle_rider',(0:0.2:10)); %% Bike and rider model
% 

