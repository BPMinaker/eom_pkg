function vehicle_specs() 

global params;

params.g=9.807;

% aerodynamic properties
params.cod=0.32; % coefficient of drag
params.farea=2.5; % frontal area [m*m]

% tire properties
% magic tire model coefficients
params.a_mtm=[1.6929 -55.2084 1271.28 1601.8 6.4946 4.7966E-3 -0.3875 1 -4.5399E-2 4.2832E-3 8.6536E-2 -7.973 -0.2231 7.668 45.8764]; % magic tire model (lateral), Genta pg 510
% magic tire model coefficients
params.b_mtm=[1.65 -7.6118 1122.6 -7.36E-3 144.82 -7.6614E-2 -3.86E-3 8.5055E-2 7.5719E-2 2.3655E-2 2.3655E-2]; % magic tire model (longitudinal), Genta pg 510
% magic tire model coefficients
params.c_mtm=[2.2264 -3.0428 -9.2284 0.500088 -5.56696 -0.25964 -1.29724E-3 -0.358348 3.74476 -15.1566 2.1156E-3 3.4600E-4 9.13952E-3 -0.244556 0.100695 -1.398 0.44441 -0.998344]; % magic tire model (restoring moment), Genta pg 510

% drivetrain
%params.rad=16/2*0.0254+205*50/100000; % tire radius [m]
params.rad=0.3; % tire radius [m]
params.drive='RearWheelDrive';

% engine #1
comp.engine{1}.name='Nova Race Tech 310V6';
comp.engine{1}.rpm=[667,1333,2000,2667,3333,4000,4667,5333,6000,6667,7333,8000,8667];
comp.engine{1}.torque=[98,124,146,195,220,225,220,248,254,244,230,209,186];
% engine #2
comp.engine{2}.name='Reynolds x463';
comp.engine{2}.rpm=[500,1000,1500,2000,2500,3000,3500,4000,4500,5000,5500,6000,6500];
comp.engine{2}.torque=[156,176,215,299,319,345,332,312,312,299,280,234,169];

% which engine did the student specify?
params.revs=comp.engine{params.engine.type}.rpm;
params.torque=comp.engine{params.engine.type}.torque;
params.redline=params.revs(end);

% compute maximum theoretical vehicle speed limited by engine power (not
% gear ratios)
%Pmax=max(params.torque_max.*params.revs*2*pi/60);
%vmax_roots=roots([-0.5*params.farea*params.cod*1.23-params.mass*params.g*5.2*10^-7 0 -params.mass*params.g*0.0136 Pmax]);
%real_vmax_roots=vmax_roots(find(imag(vmax_roots)==0));
%params.maxv=max(real_vmax_roots);
