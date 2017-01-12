function the_system=input_ex_truck_trailer_trailer(u,varargin)
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_truck_trailer.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_truck_trailer.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

if(u==0)
	error('%s\n','Speed must be non-zero.');
end

params.a=1.5;  %% front axle to truck cg
params.b=1.7;  %% rear axle to truck cg
params.d=2.7;  %% hitch to truck cg
params.e=2.5;  %% hitch to trailer cg
params.h=0.5;  %% trailer axle to trailer cg

params.cf=80000;
params.cr=80000;
params.ct=80000;
params.m=1700;
params.I=2000;
params.mt=2000;
params.It=3000;

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

%% Add the truck at the origin
body.type='body';
body.name='truck';
body.mass=params.m;
body.momentsofinertia=[0;0;params.I];
body.productsofinertia=[0;0;0];
body.location=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;

%% Add the trailer, along the x-axis
%% note that location unstable at -6.5, -6.9
body.name='trailer';
body.mass=params.mt;
body.momentsofinertia=[0;0;params.It];
body.location=[-params.d-params.e;0;0];
the_system.item{end+1}=body;

body.name='trailer2';
body.location=[-params.d-params.e-3.5;0;0];
the_system.item{end+1}=body;




%% Add a damping, to connect our body to ground, aligned with y-axis, to model the tire
%% Note that the damping decays with speed
spring.type='flex_point';
spring.name='front tire';
spring.body1='truck';
spring.body2='ground';
spring.location=[params.a;0;0];
spring.damping=[params.cf/u;0];
spring.forces=1;
spring.moments=0;
spring.axis=[0;1;0];
the_system.item{end+1}=spring;

spring.name='rear tire';
spring.location=[-params.b;0;0];
spring.damping=[params.cr/u;0];
the_system.item{end+1}=spring;

spring.name='trailer tire';
spring.body1='trailer';
spring.location=[-params.d-params.e-params.h;0;0];
spring.damping=[params.ct/u;0];
the_system.item{end+1}=spring;


spring.name='trailer2 tire';
spring.body1='trailer2';
spring.location=[-params.d-params.e-params.h-3.5;0;0];
spring.damping=[params.ct/u;0];
the_system.item{end+1}=spring;



%% Constrain truck to planar motion
point.type='rigid_point';
point.name='road';
point.body1='truck';
point.body2='ground';
point.location=[0;0;0];
point.forces=1;
point.moments=2;
point.axis=[0;0;1];
the_system.item{end+1}=point;

%% Constrain truck to trailer with hinge
point.name='hitch';
point.body1='truck';
point.body2='trailer';
point.location=[-params.d;0;0];
point.forces=3;
point.moments=2;
point.axis=[0;0;1];
the_system.item{end+1}=point;

point.name='hitch2';
point.body1='trailer';
point.body2='trailer2';
point.location=[-params.d-3.5;0;0];
point.forces=3;
point.moments=2;
point.axis=[0;0;1];
the_system.item{end+1}=point;



point.type='nh_point';
point.name='speed';
point.body1='truck';
point.body2='ground';
point.location=[0;0;0];
point.forces=1;
point.moments=0;
point.axis=[1;0;0];
the_system.item{end+1}=point;

act.type='actuator';
act.name='$\\delta$';
act.body1='truck';
act.body2='ground';
act.location1=[params.a;0;0];
act.location2=[params.a;0.1;0];
act.gain=params.cf;
the_system.item{end+1}=act;

item.type='sensor';
item.name='$\\psi$';
item.body1='truck';
item.body2='trailer';
item.location1=[-params.d;0;0];
item.location2=[-params.d;0;0.1];
item.twist=1;
the_system.item{end+1}=item;

item.name='$r$';
item.body1='truck';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[0;0;0.1];
item.twist=1;
item.order=2;
the_system.item{end+1}=item;

item.name='$\\beta$';
item.body1='truck';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[0;0.1;0];
item.twist=0;
item.order=2;
item.frame=0;
item.gain=1/u;
the_system.item{end+1}=item;

