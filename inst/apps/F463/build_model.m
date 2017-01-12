function z0=build_model()

global params;

[~,syst]=run_eom(params.eom_model,'quiet',0);  %% Generate equations of motion from EoM

syst=syst{1};

params.rads=[syst.data.bodys.location];  %% Record info from EoM
params.mass=[syst.data.bodys.mass];
params.inertia=[syst.data.bodys.inertia];

names=lower({syst.data.bodys.name});  %% Search for the chassis and wheels
params.chassnum=[];
params.wheelnum=[];

for i=1:length(names)    %% Loop over each body
	if(~isempty(strfind(names{i},'chassis')))
		params.chassnum=[params.chassnum i];
	end
	if(~isempty(strfind(names{i},'wheel')))
		params.wheelnum=[params.wheelnum i];
	end
end
%params.wheelnum
%params.chassnum
if(isempty(params.chassnum))
	error('Missing chassis.');
end

params.tirenum=[];
names=lower({syst.data.flex_points.name});  %% Search for the tire vert spring
for i=1:length(names)    %% Loop over each body
	if(~isempty(strfind(names{i},'tire'))  && ~isempty(strfind(names{i},'vertical')))
		params.tirenum=[params.tirenum i];
	end
end
%params.tirenum
params.preload=[syst.data.flex_points(params.tirenum).preload];
%params.preload

params.lat_sen_num=[];
params.vert_sen_num=[];
params.long_sen_num=[];

names=lower({syst.data.sensors.name});  %% Search for tire speed and vert disp sensors
for i=1:length(names)    %% Loop over each body
	if(~isempty(strfind(names{i},'tire')) && ~isempty(strfind(names{i},'lateral')))
		params.lat_sen_num=[params.lat_sen_num i];
	end
	if(~isempty(strfind(names{i},'tire')) && ~isempty(strfind(names{i},'vertical')))
		params.vert_sen_num=[params.vert_sen_num i];
	end
	if(~isempty(strfind(names{i},'tire')) && ~isempty(strfind(names{i},'longitudinal')))
		params.long_sen_num=[params.long_sen_num i];
	end
end
% disp('lat_sen');
% params.lat_sen_num
% disp('vert_sen');
% params.vert_sen_num
% disp('long_sen');
% params.long_sen_num


params.lat_act_num=[];
params.long_act_num=[];
params.aero_act_num=[];
params.torque_act_num=[];
params.brake_act_num=[];

names=lower({syst.data.actuators.name});  %% Search for aero, torque, and tire force actuators
for i=1:length(names)    %% Loop over each actuator
	if(~isempty(strfind(names{i},'tire')) && ~isempty(strfind(names{i},'lateral')))
		params.lat_act_num=[params.lat_act_num i];
	end
	if(~isempty(strfind(names{i},'tire')) && ~isempty(strfind(names{i},'longitudinal')))
		params.long_act_num=[params.long_act_num i];
	end
	if(~isempty(strfind(names{i},'aero')))
		params.aero_act_num=[params.aero_act_num i];
	end	
	if(~isempty(strfind(names{i},'torque')))
		params.torque_act_num=[params.torque_act_num i];
	end
	if(~isempty(strfind(names{i},'brake')))
		params.brake_act_num=[params.brake_act_num i];
	end
end

% disp('lat_act');
% params.lat_act_num
% disp('long_act');
% params.long_act_num
% disp('aero_act');
% params.aero_act_num
% disp('torque_act');
% params.torque_act_num



%error('stop');

[q,r]=size(syst.eom.rigid.cnsrt_mtx);  %% q = the number of rows in the constraint matrix
params.nbods=r/6;

if(q>0)
	params.r_orth=null(syst.eom.rigid.cnsrt_mtx);
else
	params.r_orth=eye(r);
end
params.l_orth=params.r_orth';  %% Build the coordinate reduction matrices

params.m_mtx=params.l_orth*syst.eom.mass.mtx*params.r_orth;  %% Reduced mass matrix
params.c_mtx=params.l_orth*syst.eom.elastic.dmpng_mtx*params.r_orth;  %% Reduced damping
params.k_mtx=params.l_orth*syst.eom.eqn_of_mtn.stiff_mtx*params.r_orth;  %% Reduced stiffness
params.g_mtx=syst.eom.outputs.sensor_mtx*params.r_orth;  %% Sensors matrix
params.f_mtx=params.l_orth*syst.eom.forced.f_mtx;  %% Actuators matrix

%params.m_mtx
%params.c_mtx
%params.k_mtx
%error('stopped');

init_vel=[syst.data.bodys.velocity];  %% Set initial conditions, bodies and ref frame
init_angvel=[syst.data.bodys.angular_velocity];
vfi=[syst.data.bodys(params.chassnum).velocity(1); 0;0;0;0;syst.data.bodys(params.chassnum).angular_velocity(3)];

%error('stop')

v=zeros(r,1);  %% Preallocate , r is number of velocities, full set 
for i=1:params.nbods
	v(6*i+(-5:-3))=init_vel(:,i);
	v(6*i+(-2:0))=init_angvel(:,i);
end

n=size(params.l_orth,1);  %% Should be r-q, but get it here just in case
zmin0=[zeros(n,1);params.l_orth*v];  %% Two first order ODE for each DOF, disp zeros, vel from model

z0=[0;0;0;1;0;0;0;vfi;0;0;0;zmin0];  %% Set initial conditions for frame and system
% initial position of ref frame (0 0 0)
% initial orientation of ref frame (0 0 0 1) (Euler parameters)
% initial velocities of reference frame vx,vy,vz,wx,wy,wz, from input file to match chassis
% initial distance along track
% initial orientation
% initial steer angle
% positions and velocities of vehicle, from input file

end %% Leave
