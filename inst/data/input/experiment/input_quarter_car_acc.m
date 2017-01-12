function the_system=input_quarter_car_acc(varargin)
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_quarter_car.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_quarter_car.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% A 'quarter-car' model, two bodys, constrained to ground, allowing translation in the z axis only, with two point springs connecting them.  The point spring has stiffness and damping defined in translation along the z axis only.  An actuator connects the sprung mass to the ground as well, to provide input forces.  Note that the ground body is pre-defined.
params.mu=50;
params.ms=500;
params.ks=18000;
params.cs=1500;
params.kt=150000;

if(nargin()==2)  %% Are there two arguments?
	if(isa(varargin{2},'struct'))  %% If so, is the second a struct?
		names=fieldnames(varargin{2});  %% If so, get the fieldnames
		for i=1:length(names)  %% For each fieldname
			if(isfield(params,names{i}))  %% Is this a field in our default?
				params.(names{i})=varargin{2}.(names{i});  %% If so, copy the field content to the default
			end
		end
	end
end

%% Add the unsprung mass, along the z-axis
body.type='body';
body.name='unsprung';
body.mass=params.mu;
body.location=[0;0;0.3];
the_system.item{end+1}=body;

%% Add another identical rigid body, along the z-axis
body.name='sprung';
body.mass=params.ms;
body.location=[0;0;0.6];
the_system.item{end+1}=body;

%% Add a spring, with no damping, to connect our unsprung mass to ground, aligned with z-axis
spring.type='flex_point';
spring.name='tire';
spring.body1='unsprung';
spring.body2='ground';
spring.stiffness=[params.kt;0];
spring.damping=[0;0];
spring.location=[0;0;0.15];
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
the_system.item{end+1}=spring;

%% Add another spring, with damping, to connect our sprung and unsprung mass
spring.name='susp';
spring.body1='sprung';
spring.body2='unsprung';
spring.stiffness=[params.ks;0];
spring.damping=[params.cs;0];
spring.location=[0;0;0.45];
the_system.item{end+1}=spring;

%% Constrain unsprung mass to translation in z-axis, no rotation
point.type='rigid_point';
point.name='slider one';
point.body1='unsprung';
point.body2='ground';
point.location=[0;0;0.3];
point.forces=2;
point.moments=3;
point.axis=[0;0;1];
the_system.item{end+1}=point;

%% Constrain sprung mass to translation in z-axis, no rotation
point.name='slider two';
point.body1='sprung';
point.body2='ground';
point.location=[0;0;0.6];
the_system.item{end+1}=point;

%% Add external force between unsprung mass and ground (represents ground motion)
item.type='actuator';
item.name='$z_0$';
item.body1='unsprung';
item.body2='ground';
item.gain=params.kt;
item.location1=[0.05;0;0.3];
item.location2=[0.05;0;0];
the_system.item{end+1}=item;
item={};

item.type='actuator';
item.name='$z_1$';
item.body1='sprung';
item.body2='ground';
item.gain=1;
item.location1=[0;0.05;0.6];
item.location2=[0;0.05;0];
the_system.item{end+1}=item;
item={};

%% Add measure between ground and sprung mass
item.type='sensor';
item.name='$\\ddot{z}_1$';
item.body1='sprung';
item.body2='ground';
item.location1=[0.1;0;0.6];
item.location2=[0.1;0;0];
item.order=3;
the_system.item{end+1}=item;

%% Add measure between ground and unsprung mass
item.name='$\\ddot{z}_2$';
item.body1='unsprung';
item.body2='ground';
item.location1=[0.1;0;0.3];
item.location2=[0.1;0;0];
the_system.item{end+1}=item;

%% Add measure between ground and unsprung mass
item.name='$\\dot{z}_2$';
item.order=2;
the_system.item{end+1}=item;

%% Add measure between ground and unsprung mass
item.name='$z_2$';
item.order=1;
the_system.item{end+1}=item;

