function my_specs_123456789() %% Edit this file to enter your vehicle specs

global params; %% Don't change this
% Do not alter the format of this file.

params.std_id_number{1}='123456789'; %% Enter your ID number here 
params.std_name{1}='Isaac Newton'; %% Enter your name here

params.std_id_number{2}='987654321'; %% Enter your ID number here 
params.std_name{2}='Leonhard Euler'; %% Enter your name here

params.e=[5 4 3 2 1]; %% Enter your 5 or 6 gear ratios here, starting from _first_ gear, i.e., in the default values, 1st gear is 5.0:1, note that the defaults are a poor choice
params.ex=3.5; %% Enter your axle final drive ratio here
params.engine.type=2; %% Enter your engine choice here, 1 for engine #1 (higher redline), or 2 for engine #2 (more torque) 

% braking system parameters
params.fbf=0.65; % front brake fraction, from 0 to 1, 0 being rear brakes only, 1 being front brakes only, 0.5 being equal brake torques on both axles

% vehicle chassis model
params.eom_model='full_car_a_arm_pushrod';

% driver model
params.acc_lat_max=0.4; % [g's] maximum lateral acceleration, used to compute max speed in the corner, adjusted automatically if vehicle path tracking is poor
params.acc_brake_max=0.3; % [g's] maximum braking acceleration, used to decide when to apply the brakes during corner entry
params.acc_drive_max=0.7; % [g's] maximum braking acceleration, used to decide when to apply the brakes during corner entry
params.maxv=100; % Driver model max allowed speed (m/s)

