run_eom('input_ex_smd');  %% Spring mass damper - default parameters
% options are 'noreport' to supresss latex,
% 'noanimate', to supress writing vrml,
% 'quiet' to supress both
% 'sketch' to include 3D figure, linux only
% 'schematic' to include input figure, linux only

pause(1);

item.k=20; %% Choose new stiffness
eqns=run_eom('input_ex_smd',item,'quiet');
