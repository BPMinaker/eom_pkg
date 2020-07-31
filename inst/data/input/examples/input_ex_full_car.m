function the_system=input_ex_full_car(~,varargin)
the_system.item={};

%% Copyright (C) 2010, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_full_car.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_full_car.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% A 'full-car' model, five bodys. The point spring has stiffness and damping defined in translation along the z axis only, suspension motion constrained to simple vertical.  An actuator connects the sprung mass to the ground as well, to provide input forces.  Note that the ground body is pre-defined.


params.a=1.189;
params.b=2.885-1.189;
params.kf=35000/2;
params.kr=38000/2;
params.kfb=3000;
params.krb=1000;
params.cf=1000;
params.cr=1200;
params.ktf=180000;
params.ktr=180000;
params.m=16975/9.81;
params.Ixx=818;
params.Iyy=3267;
params.Izz=3508;
params.h=0.696;
params.tf=1.595;
params.tr=1.631;
params.mf=35;
params.mr=30;


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


%% Add the unsprung mass
body.type='body';
body.name='lf-wheel';
body.mass=params.mf;
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
body.location=[params.a;params.tf/2;0.3];
the_system.item{end+1}=body;

body.name='rf-wheel';
body.location=[params.a;-params.tf/2;0.3];
the_system.item{end+1}=body;

body.name='lr-wheel';
body.mass=params.mr;
body.location=[-params.b;params.tr/2;0.3];
the_system.item{end+1}=body;

body.name='rr-wheel';
body.location=[-params.b;-params.tr/2;0.3];
the_system.item{end+1}=body;


%% Add the chassis
body.name='chassis';
body.mass=params.m;
body.momentsofinertia=[params.Ixx;params.Iyy;params.Izz];
body.location=[0;0;params.h];
the_system.item{end+1}=body;


%% Add a spring, with no damping, to connect our unsprung mass to ground, aligned with z-axis
spring.type='flex_point';
spring.name='lf-tire';
spring.body1='lf-wheel';
spring.body2='ground';
spring.stiffness=[params.ktf;0];
spring.damping=[0;0];
spring.location=[params.a;params.tf/2;0];
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
the_system.item{end+1}=spring;

spring.name='rf-tire';
spring.body1='rf-wheel';
spring.location=[params.a;-params.tf/2;0];
the_system.item{end+1}=spring;

spring.name='lr-tire';
spring.body1='lr-wheel';
spring.stiffness=[params.ktr;0];
spring.location=[-params.b;params.tr/2;0];
the_system.item{end+1}=spring;

spring.name='rr-tire';
spring.body1='rr-wheel';
spring.location=[-params.b;-params.tr/2;0];
the_system.item{end+1}=spring;


%% Add another spring, with damping, to connect our sprung and unsprung mass
spring.name='lf-susp';
spring.body1='lf-wheel';
spring.body2='chassis';
spring.stiffness=[params.kf;0];
spring.damping=[params.cf;0];
spring.location=[params.a;params.tf/2;0.35];
the_system.item{end+1}=spring;

spring.name='rf-susp';
spring.body1='rf-wheel';
spring.location=[params.a;-params.tf/2;0.35];
the_system.item{end+1}=spring;

spring.name='lr-susp';
spring.body1='lr-wheel';
spring.stiffness=[params.kr;0];
spring.damping=[params.cr;0];
spring.location=[-params.b;params.tr/2;0.35];
the_system.item{end+1}=spring;

spring.name='rr-susp';
spring.body1='rr-wheel';
spring.location=[-params.b;-params.tr/2;0.35];
the_system.item{end+1}=spring;


%% add anti-roll
spring.name='lf-tire';
spring.body1='lf-wheel';
spring.body2='rf-wheel';
spring.stiffness=[params.kfb;0];
spring.damping=[0;0];
spring.location=[params.a;0;0.3];
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
the_system.item{end+1}=spring;

spring.body1='lr-wheel';
spring.body2='rr-wheel';
spring.stiffness=[params.kfb;0];
spring.damping=[0;0];
spring.location=[-params.b;0;0.3];
the_system.item{end+1}=spring;


%% Constrain unsprung mass to sprung mass
point.type='rigid_point';
point.name='lf-slider';
point.body1='lf-wheel';
point.body2='chassis';
point.location=[params.a+0.3;params.tf/2;0.3];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='rf-slider';
point.body1='rf-wheel';
point.location=[params.a+0.3;-params.tf/2;0.3];
the_system.item{end+1}=point;

point.name='lr-slider';
point.body1='lr-wheel';
point.location=[-params.b+0.3;params.tr/2;0.3];
the_system.item{end+1}=point;

point.name='rr-slider';
point.body1='rr-wheel';
point.location=[-params.b+0.3;-params.tr/2;0.3];
the_system.item{end+1}=point;

%% Add external force between unsprung mass and sprung mass
item.type='actuator';
item.name='actuator';
item.body1='lf-wheel';
item.body2='ground';
item.gain=params.ktf;
item.location1=[params.a;params.tf/2;0.1];
item.location2=[params.a;params.tf/2;0];
the_system.item{end+1}=item;
item={};

%% Add measure between sprung mass and ground
item.type='sensor';
item.name='sensor';
item.body1='chassis';
item.body2='ground';
item.location1=[0;0;params.h];
item.location2=[0;0;params.h-0.1];
item.gain=1;
the_system.item{end+1}=item;

