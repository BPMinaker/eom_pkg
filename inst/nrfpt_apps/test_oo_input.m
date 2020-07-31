function the_system=test_oo_input(varargin)
the_system.item={};


params.k=100;
params.m=1;
params.c=2;

if(nargin()==2)  %% Are there two arguments? (ignore the first)
	if(isa(varargin{2},'struct'))  %% If so, is the second a struct?
		names=fieldnames(varargin{2});  %% If so, get the fieldnames
		for i=1:length(names)  %% For each fieldname
			if(isfield(params,names{i}))  %% Is this a field in our default?
				params.(names{i})=varargin{2}.(names{i});  %% If so, copy the field content to the default
			end
		end
	end
end

%% Add the body
temp=body('block');
temp.mass=params.m;
temp.momentsofinertia=[0;0;0];
temp.productsofinertia=[0;0;0];
temp.location=[0;0;1];
the_system.item{end+1}=temp;
the_system.item{end+1}=weight(temp);


%% Constrain the body to one translation in z, and no rotations
temp=rigid_point('slider 1');
temp.body{1}='block';
temp.body{2}='ground';
temp.location=[0;0;1];
temp.forces=2;
temp.moments=3;
temp.axis=[0;0;1];
the_system.item{end+1}=temp;

%% Add a spring, with damping, to connect our body to ground, aligned with z-axis
temp=flex_point('spring 1');
temp.body{1}='block';
temp.body{2}='ground';
temp.location=[0;0;0.5];
temp.stiffness=[params.k;0]; %(AE/L)
temp.damping=[params.c;0];
temp.forces=1;
temp.moments=0;
temp.axis=[0;0;1];
the_system.item{end+1}=temp;

%% The actuator is a 'line item' and defined by two locations, location1 attaches to body1, location2 to body2
temp=actuator('actuator 1');
temp.body{1}='block';
temp.body{2}='ground';
temp.location(:,1)=[0.05;0;1];
temp.location(:,2)=[0.05;0;0];
the_system.item{end+1}=temp;

%% The sensor is a 'line item' and defined by two locations, location1 attaches to body1, location2 to body2
temp=sensor('sensor 1');
temp.body{1}='block';
temp.body{2}='ground';
temp.location(:,1)=[0;0.05;1];
temp.location(:,2)=[0;0.05;0];
the_system.item{end+1}=temp;
%% Marker
temp=marker('marker 1');
temp.body{1}='block';
temp.location=[0;0;1];
the_system.item{end+1}=temp;
%% nh_point
temp=nh_point('nh_point 1');
temp.body{1}='block';
temp.body{2}='ground';
temp.location=[0;0;0.5];
temp.forces=1;
temp.moments=0;
temp.axis=[0;0;1];
the_system.item{end+1}=temp;
%% triangle_3
temp=triangle_3('triangle_3 1');
temp.body{1}='block';
temp.body{2}='ground';
temp.body{3}='ground';
temp.location(:,1)=[0;0.05;1];
temp.location(:,2)=[0;0.05;0];
temp.location(:,3)=[0;0.05;1];
temp.thickness=2;
temp.modulus=1;
the_system.item{end+1}=temp;
%% triangle_5
temp=triangle_5('triangle_5 1');
temp.body{1}='block';
temp.body{2}='ground';
temp.body{3}='ground';
temp.location(:,1)=[0;0.05;1];
temp.location(:,2)=[0;0;1];
temp.location(:,3)=[0;0.05;1];
temp.thickness=2;
temp.modulus=1;
the_system.item{end+1}=temp;
%% wing
temp=wing('wing 1');
temp.body{1}='block';
temp.body{2}='ground';
temp.location=[0;0;0.5];
temp.span=0;
temp.chord=0;
temp.airspeed=0;
temp.forces=3;
temp.moments=3;
temp.axis=[0;1;0];
temp.cxu=1;
the_system.item{end+1}=temp;
%% tire
% temp=tire('tire 1');
% temp.location(:,1)=[0;0.05;1];
% temp.location(:,2)=[0;0;1];
% temp.axis=[1;0;0];
% temp.forces=2;
% temp.moments=1;
% temp.roadspeed=1;
% temp.cy=1;
% temp.kz=1;
% the_system.item{end+1}=temp;
%% Beam
temp=beam('beam 1');
temp.body{1}='block';
temp.body{2}='ground';
temp.location(:,1)=[0;0.05;1];
temp.location(:,2)=[0;0;1];
temp.stiffness=1;
the_system.item{end+1}=temp;
















