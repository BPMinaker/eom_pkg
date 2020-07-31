
params.kf=20000;  %% Front spring stiffness  [N/m]
params.kr=20000;  %% Rear spring stiffness  [N/m]
params.cf=100;  %% Front damping  [Ns/m]
params.cr=100;  %% Rear damping  [Ns/m]
params.tf=100;  %% Anti roll bar stiffness  [Nm / rad]

run_eom('baja_anti_roll',params);

% options are 'noreport' to supresss latex,
% 'noanimate', to supress writing vrml,
% 'quiet' to supress both
% 'sketch' to include 3D figure, linux only
% 'schematic' to include input figure, linux only

% run_eom('baja_anti_roll',params,option);

