function the_system=input_3_yaw_plane_mod(u,varargin)
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_11.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_11.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

if(u==0)
	error(sprintf('Speed must be non-zero'));
end

params.a=1.5;
params.b=1.7;
params.cf=80000;
params.cr=80000;
params.m=1700;
params.I=2000;

if(nargin()==2)  %% Are there two arguments?
	if(isa(varargin{1},'struct'))  %% If so, is the second a struct?
		names=fieldnames(varargin{1});  %% If so, get the fieldnames
		for i=1:length(names)  %% For each fieldname
			if(isfield(params,names{i}))  %% Is this a field in our default?
				params.(names{i})=varargin{1}.(names{i});  %% If so, copy the field content to the default
			end
		end
	end
end

%r_by_delta=u/(a+b-m*u^2*(a*cf-b*cr)/(a+b)/cf/cr)
%beta_by_delta=(b-a*m*u^2/(a+b)/cr)/(a+b-m*u^2*(a*cf-b*cr)/(a+b)/cf/cr)

%% Add one rigid body, along the x-axis
body.mass=params.m;
body.momentsofinertia=[0;0;params.I];
body.productsofinertia=[0;0;0];
body.location=[0;0;0];
body.name='chassis';
body.type='body';
body.velocity=[u;0;0];
the_system.item{end+1}=body;

%% Add a damping, to connect our body to ground, aligned with y-axis (front tire)
spring.name='front tire';
spring.type='flex_point';
spring.body1='chassis';
spring.body2='ground';
spring.location=[params.a;0;0];
spring.forces=1;
spring.moments=0;
spring.axis=[0;1;0];
spring.damping=[params.cf/u;0];
the_system.item{end+1}=spring;

%% Rear tire
spring.name='rear tire'; 
spring.location=[-params.b;0;0];
spring.damping=[params.cr/u;0];
the_system.item{end+1}=spring;

act.name='$\\delta$';
act.type='actuator';
act.body1='chassis';
act.body2='ground';
act.location1=[params.a;0;0];
act.location2=[params.a;0.1;0];
act.gain=params.cf;
the_system.item{end+1}=act;

%% Constrain to planar motion
point.type='rigid_point';
point.name='road';
point.body1='chassis';
point.body2='ground';
point.location=[0;0;0];
point.forces=1;
point.moments=2;
point.axis=[0;0;1];
the_system.item{end+1}=point;

%% Constrain chassis in the forward direction
%% The left/right symmetry of the chassis tells us that the lateral and longitudinal motions are decoupled anyway
%  point.type='nh_point';
%  point.name='speed';
%  point.body1='chassis';
%  point.body2='ground';
%  point.location=[0;0;0];
%  point.forces=1;
%  point.moments=0;
%  point.axis=[1;0;0];
%  the_system.item{end+1}=point;

item.type='sensor';
item.name='$r$';
item.body1='chassis';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[0;0;0.1];
item.twist=1;
item.order=2;
the_system.item{end+1}=item;

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
