function [tout,xout,yout]=solver(out)

global params;

disp(['Gathered data. Simulating ID number: ' params.std_id_number{1}]);

prelim(out);  %% Compute shift speeds, etc
x0=build_model();  %% Build equations of motion
flag_out=0;  %% Don't return extra data until after solution complete

tend=150;  %% Set max end time and plot interval
ts=0.1;

%% Set options for ODE solver
vopt=odeset('RelTol',1e-5,'AbsTol',1e-5,'InitialStep',1e-3,'MaxStep',1,'Events',@dist_to_end);
%% Define function that contains the equations to solve
handle=@(t,x) eqn_of_motion(t,x,flag_out);

tspan=0:ts:tend;
params.ncalls=0;  %% Zero the number of function calls

disp('Equations built, starting simulation...');
tic  %% Start the timer
[tout,xout,params.te]=ode45(handle,tspan,x0,vopt);  %% Simulate, please
toc  %% Stop the timer

disp(['Took ' num2str(params.ncalls) ' timesteps.']);
disp(['Laptime was ' num2str(params.te) ' seconds.']);

%% Recalculate extra derivative data (accerlerations)
yout=zeros(size(xout,1),size(xout,2)+53);  %% Preallocate zeros
flag_out=1;
for i=1:length(tout)
	yout(i,:)=eqn_of_motion(tout(i), xout(i,:)',flag_out)';
end

end  %% Leave

