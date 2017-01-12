function the_system=input_ex_yaw_plane(u,varargin)
the_system.name='Yaw Plane Vehicle';
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_yaw_plane.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_yaw_plane.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

if(u==0)
	error(sprintf('Speed must be non-zero'));
end

params.a=1.189;
params.b=2.885-1.189;
params.cf=80000;
params.cr=80000;
params.m=16975/9.81;
params.I=3508;

if(nargin()==2)  %% Are there two arguments?
	if(isa(varargin{1},'struct'))  %% If so, is the second a struct?
		names=fieldnames(varargin{1});  %% If so, get the fieldnames
		for i=1:length(names)  %% For each fieldname
			if(isfield(params,names{i}))  %% Is this a field in our default?
				params.(names{i})=varargin{1}.(names{i});  %% If so, copy the field content over the default
			end
		end
	end
end

%% Add one rigid body
item.mass=params.m;
item.momentsofinertia=[0;0;params.I];
item.productsofinertia=[0;0;0];
item.location=[0;0;0];
item.name='chassis';
item.type='body';
item.velocity=[u;0;0];
the_system.item{end+1}=item;
item={};

%% Add a damping, to connect our body to ground, aligned with y-axis (front tire)
item.name='front tire';
item.type='flex_point';
item.body1='chassis';
item.body2='ground';
item.location=[params.a;0;0];
item.forces=1;
item.moments=0;
item.axis=[0;1;0];
item.damping=[params.cf/u;0];
the_system.item{end+1}=item;

%% Rear tire
item.name='rear tire'; 
item.location=[-params.b;0;0];
item.damping=[params.cr/u;0];
the_system.item{end+1}=item;
item={};

%% Add an actuator to apply the steering force
item.name='$\\delta_{\\text{f}}$';
item.type='actuator';
item.body1='chassis';
item.body2='ground';
item.location1=[params.a;0;0];
item.location2=[params.a;0.1;0];
item.gain=params.cf;
the_system.item{end+1}=item;

%% Rear wheel steer off by default
%  item.name='$\\delta_{\\text{r}}$';
%  item.location1=[-params.b;0;0];
%  item.location2=[-params.b;-0.1;0];
%  item.gain=params.cr;
%  the_system.item{end+1}=item;
item={};

%% Constrain to planar motion
item.type='rigid_point';
item.name='road';
item.body1='chassis';
item.body2='ground';
item.location=[0;0;0];
item.forces=1;
item.moments=2;
item.axis=[0;0;1];
the_system.item{end+1}=item;

%% Constrain chassis in the forward direction
%% The left/right symmetry of the chassis tells us that the lateral and longitudinal motions are decoupled anyway
item.type='nh_point';
item.name='speed';
item.body1='chassis';
item.body2='ground';
item.location=[0;0;0];
item.forces=1;
item.moments=0;
item.axis=[1;0;0];
the_system.item{end+1}=item;
item={};

%% Measure the yaw rate
item.type='sensor';
item.name='$r$';
item.body1='chassis';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[0;0;0.1];
item.twist=1;
item.order=2;
the_system.item{end+1}=item;

%% Measure the body slip angle
item.name='$\\beta$';
item.body1='chassis';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[0;0.1;0];
item.twist=0;
item.order=2;
item.frame=0;
item.gain=1/u;
the_system.item{end+1}=item;

%% Measure the lateral acceleration
item.name='$a_{\\text{lat}}$';
item.body1='chassis';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[0;0.1;0];
item.twist=0;
item.order=3;
item.frame=1;
item.gain=1;
the_system.item{end+1}=item;


%% Note that the y location will not reach steady state with constant delta
%% input, so adding the sensor will give an error if the steady state gain
%% is computed.  It will work fine when a time history is computed.
item.name='$y$';
item.body1='chassis';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[0;0.1;0];
item.twist=0;
item.order=1;
item.frame=1;
item.gain=1;
the_system.item{end+1}=item;




%  r_by_delta=u/(params.a+params.b-params.m*u^2*(params.a*params.cf-params.b*params.cr)/(params.a+params.b)/params.cf/params.cr)
%  beta_by_delta=(params.b-params.a*params.m*u^2/(params.a+params.b)/params.cr)/(params.a+params.b-params.m*u^2*(params.a*params.cf-params.b*params.cr)/(params.a+params.b)/params.cf/params.cr)

%  if(params.a*params.cf-params.b*params.cr>0)
%  	ucrit=sqrt(params.cf*params.cr*(params.a+params.b)^2/(params.a*params.cf-params.b*params.cr)/params.m)
%  else
%  	uchar=sqrt(params.cf*params.cr*(params.a+params.b)^2/(params.b*params.cr-params.a*params.cf)/params.m)
%  	utrans=(params.I/(params.b*params.cr-params.a*params.cf)/4*((params.a^2*params.cf+params.b^2*params.cr)/params.I + (params.cf+params.cr)/params.m)^2-uchar^2)^0.5
%  end

