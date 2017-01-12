function the_system=input_half_car_acc(varargin)
the_system.item={};

%% Copyright (C) 2010, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_half_car.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_half_car.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% A 'half-car' model, three bodys. The point spring has stiffness and damping defined in translation along the z axis only, suspension motion constrained to simple vertical.  An actuator connects the chassis mass to the ground as well, to provide input forces.  Note that the ground body is pre-defined.
params.muf=30;
params.mur=35;
params.ms=900;

params.iyy=600;

params.vx=10;

params.ksf=18000;
params.csf=1500;

params.ksr=20000;
params.csr=1400;

params.ktf=150000;
params.ktr=150000;

params.wb=2.8;
params.fwf=0.6;

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

g=9.81;

%% Add chassis mass
body.type='body';
body.name='chassis';
body.mass=params.ms;
body.momentsofinertia=[0;params.iyy;0];
body.location=[0;0;0.5];
body.velocity=[params.vx;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


%% Add the wheel mass, along the z-axis
body.name='f-wheel';
body.mass=params.muf;
body.momentsofinertia=[1;1;1];
body.productsofinertia=[0;0;0];
body.location=[params.fwf*params.wb;0;0.3];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='r-wheel';
body.mass=params.mur;
body.location=[(params.fwf-1)*params.wb;0;0.3];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


%% Add a spring, with no damping, to connect our wheel mass to ground, aligned with z-axis
spring.type='flex_point';
spring.name='f-tire';
spring.body1='f-wheel';
spring.body2='ground';
spring.stiffness=[params.ktf;0];
spring.damping=[0;0];
spring.location=[params.fwf*params.wb;0;0];
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
the_system.item{end+1}=spring;

spring.name='r-tire';
spring.body1='r-wheel';
spring.location=[(params.fwf-1)*params.wb;0;0];
the_system.item{end+1}=spring;


%% Add another spring, with damping, to connect our chassis and wheel mass
spring.name='f-susp';
spring.body1='f-wheel';
spring.body2='chassis';
spring.stiffness=[params.ksf;0];
spring.damping=[params.csf;0];
spring.location=[params.fwf*params.wb;0;0.35];
the_system.item{end+1}=spring;


spring.name='r-susp';
spring.body1='r-wheel';
spring.stiffness=[params.ksr;0];
spring.damping=[params.csr;0];
spring.location=[(params.fwf-1)*params.wb;0;0.35];
the_system.item{end+1}=spring;



%% Constrain wheel mass to chassis mass
point.type='rigid_point';
point.name='f-slider';
point.body1='f-wheel';
point.body2='chassis';
point.location=[params.fwf*params.wb;0;0.37];
point.forces=2;
point.moments=3;
point.axis=[0;0;1];
the_system.item{end+1}=point;


point.name='r-slider';
point.body1='r-wheel';
point.location=[(params.fwf-1)*params.wb;0;0.37];
the_system.item{end+1}=point;


%% Constrain chassis mass to translation in z-axis, pitch, roll
point.name='slider one';
point.body1='chassis';
point.body2='ground';
point.location=[0;0;0.5];
point.forces=2;
point.moments=0;
point.axis=[0;0;1];
the_system.item{end+1}=point;


point.name='slider two';
point.body1='chassis';
point.body2='ground';
point.location=[0;0;0.5];
point.forces=0;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;



%% Add external force between wheel mass and ground
item.type='actuator';
item.name='f-road';
item.body1='f-wheel';
item.body2='ground';
item.gain=params.ktf;
item.location1=[params.fwf*params.wb;0;0.1];
item.location2=[params.fwf*params.wb;0;0];
the_system.item{end+1}=item;

item.name='r-road';
item.body1='r-wheel';
item.gain=params.ktr;
item.location1=[(params.fwf-1)*params.wb;0;0.1];
item.location2=[(params.fwf-1)*params.wb;0;0];
the_system.item{end+1}=item;
item={};

%% Add sensors between wheel mass and ground
item.type='sensor';
item.name='f-acc-ws';
item.body1='f-wheel';
item.body2='ground';
item.location1=[params.fwf*params.wb;0;0.1];
item.location2=[params.fwf*params.wb;0;0];
item.order=3;
the_system.item{end+1}=item;


item.name='r-acc-ws';
item.body1='r-wheel';
item.location1=[(params.fwf-1)*params.wb;0;0.1];
item.location2=[(params.fwf-1)*params.wb;0;0];
the_system.item{end+1}=item;
item={};


%% Add sensors between chassis mass and ground
item.type='sensor';
item.name='f-acc-fs';
item.body1='chassis';
item.body2='ground';
item.location1=[params.fwf*params.wb;0;0.5];
item.location2=[params.fwf*params.wb;0;0];
item.order=3;
the_system.item{end+1}=item;


item.name='r-acc-fs';
item.location1=[(params.fwf-1)*params.wb;0;0.5];
item.location2=[(params.fwf-1)*params.wb;0;0];
the_system.item{end+1}=item;


