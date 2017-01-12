function the_system=input_ex_bounce_pitch(u,varargin)
the_system.item={};

%% Copyright (C) 2011, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_bounce_pitch.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_bounce_pitch.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------


%% A bounce pitch model that should match the example from the notes.  No damping, but can be easily added

params.a=1.189;
params.b=2.885-1.189;
params.kf=35000;
params.kr=38000;
params.cf=1000;
params.cr=1200;
params.m=16975/9.81;
params.I=3267;

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


%% Add one body representing the chassis
body.mass=params.m;
body.momentsofinertia=[0;params.I;0];  %% Only the Iy term matters here
body.productsofinertia=[0;0;0];
body.location=[0;0;0.25];  %% Put cg at origin, but offset vertically to make animation more clear 
body.velocity=[u;0;0];
body.name='chassis';
body.type='body';
the_system.item{end+1}=body;

%% Add a spring, to connect our chassis to ground, representing the front suspension
spring.name='front susp';
spring.type='flex_point';
spring.body1='chassis';
spring.body2='ground';
spring.location=[params.a;0;0.25];  %% Front axle 'a' m ahead of cg
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];  %% Spring acts in z direction
spring.stiffness=[params.kf;0];  %% Linear stiffness 'kf' N/m; (torsional stiffness zero, not a torsion spring so has no effect
spring.damping=[params.cf;0];
the_system.item{end+1}=spring;

%% Rear suspension
spring.name='rear susp';  %% We reset location and stiffness, but other properties are the same
spring.location=[-params.b;0;0.25];  %% Rear axle 'b' m behind cg
spring.stiffness=[params.kr;0];
spring.damping=[params.cr;0];
the_system.item{end+1}=spring;

%% Constrain to linear motion in z direction (bounce)
point.type='rigid_point';
point.name='road';
point.body1='chassis';
point.body2='ground';
point.location=[0;0;0.25];
point.forces=2;
point.moments=0;
point.axis=[0;0;1];
the_system.item{end+1}=point;

point.forces=0;  %% Constrain to rotational motion around y axis (pitch)
point.moments=2;  %% Reset forces, moments axis, all other properties are the same
point.axis=[0;1;0];
the_system.item{end+1}=point;

%% Measure the bounce and pitch
item.type='sensor';
item.name='$z_{\\textrm G}$';
item.body1='chassis';
item.body2='ground';
item.location1=[0;0;0.25];
item.location2=[0;0;0];
item.gain=1;
the_system.item{end+1}=item;

item.name='$(a+b)\\theta$';
item.location2=[0;0.25;0.25];
item.twist=1;
item.gain=params.a+params.b;
the_system.item{end+1}=item;

%% Force the bounce and pitch
item.type='actuator';
item.name='$u_{\\textrm f}$';
item.location1=[params.a;0;0.25];
item.location2=[params.a;0;0];
item.twist=0;
item.gain=params.kf;
item.rategain=params.cf;
the_system.item{end+1}=item;

item.name='$u_{\\textrm r}$';
item.location1=[-params.b;0;0.25];
item.location2=[-params.b;0;0];
item.gain=params.kr;
item.rategain=params.cr;
the_system.item{end+1}=item;


