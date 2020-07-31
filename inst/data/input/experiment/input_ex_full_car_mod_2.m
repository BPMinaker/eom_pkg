function the_system=input_ex_full_car_mod_2(u,varargin)
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


a=1.2;
b=1.3;
t=1.4;

r=0.3;

body.type='body';
body.name='chassis';
body.mass=1800;
body.momentsofinertia=[500;1200;1800];
body.location=[0;0;0.5];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body);

%% Add the unsprung mass
body.name='lf-wheel';
body.mass=30;
body.momentsofinertia=[1;1;1];
body.productsofinertia=[0;0;0];
body.location=[a;t/2;r];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body);

body.name='rf-wheel';
body.location=[a;-t/2;r];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body);

body.name='lr-wheel';
body.location=[-b;t/2;r];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body);

body.name='rr-wheel';
body.location=[-b;-t/2;r];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body);


%% Add a spring, with no damping, to connect our unsprung mass to ground, aligned with z-axis
spring.type='flex_point';
spring.name='lf-tire';
spring.body1='lf-wheel';
spring.body2='ground';
spring.stiffness=[150000;0]; %(AE/L)
spring.damping=[0;0];
spring.location=[a;t/2;0];
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
the_system.item{end+1}=spring;

spring.name='rf-tire';
spring.body1='rf-wheel';
spring.location=[a;-t/2;0];
the_system.item{end+1}=spring;

spring.name='lr-tire';
spring.body1='lr-wheel';
spring.location=[-b;t/2;0];
the_system.item{end+1}=spring;

spring.name='rr-tire';
spring.body1='rr-wheel';
spring.location=[-b;-t/2;0];
the_system.item{end+1}=spring;


%% Add another spring, with damping, to connect our sprung and unsprung mass
spring.name='lf-susp';
spring.body1='lf-wheel';
spring.body2='chassis';
spring.stiffness=[18000;0]; %(AE/L)
spring.damping=[2000;0];
spring.location=[a;t/2;2*r];
the_system.item{end+1}=spring;

spring.name='rf-susp';
spring.body1='rf-wheel';
spring.location=[a;-t/2;2*r];
the_system.item{end+1}=spring;

spring.name='lr-susp';
spring.body1='lr-wheel';
spring.location=[-b;t/2;2*r];
the_system.item{end+1}=spring;

spring.name='rr-susp';
spring.body1='rr-wheel';
spring.location=[-b;-t/2;2*r];
the_system.item{end+1}=spring;


%% Constrain unsprung mass to sprung mass
point.type='rigid_point';
point.name='lf-slider';
point.body1='lf-wheel';
point.body2='chassis';
point.location=[a;t/8;r/2];
point.forces=3;
point.moments=2;
point.axis=[1;0;0];
the_system.item{end+1}=point;

point.name='rf-slider';
point.body1='rf-wheel';
point.location=[a;-t/8;r/2];
the_system.item{end+1}=point;

point.name='lr-slider';
point.body1='lr-wheel';
point.location=[-b;t/8;r/2];
the_system.item{end+1}=point;

point.name='rr-slider';
point.body1='rr-wheel';
point.location=[-b;-t/8;r/2];
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%
item.type='actuator';
item.name='lf-steer';
item.body1='lf-wheel';
item.body2='ground';
item.gain=1;
item.location1=[a;t/2;0];
item.location2=[a;t/2-0.1;0];
the_system.item{end+1}=item;

item.name='rf-steer';
item.body1='rf-wheel';
item.body2='ground';
item.gain=1;
item.location1=[a;-t/2;0];
item.location2=[a;-t/2-0.1;0];
the_system.item{end+1}=item;

item.name='lr-steer';
item.body1='lr-wheel';
item.body2='ground';
item.gain=1;
item.location1=[-b;t/2;0];
item.location2=[-b;t/2-0.1;0];
the_system.item{end+1}=item;

item.name='rr-steer';
item.body1='rr-wheel';
item.body2='ground';
item.gain=1;
item.location1=[-b;-t/2;0];
item.location2=[-b;-t/2-0.1;0];
the_system.item{end+1}=item;

item={};

%% Add measure between sprung mass and ground
item.type='sensor';
item.name='lf-normal';
item.body1='lf-wheel';
item.body2='ground';
item.location1=[a;t/2;r];
item.location2=[a;t/2;0];
item.gain=150000;
the_system.item{end+1}=item;

item.name='rf-normal';
item.body1='rf-wheel';
item.body2='ground';
item.location1=[a;-t/2;r];
item.location2=[a;-t/2;0];
item.gain=150000;
the_system.item{end+1}=item;

item.name='lr-normal';
item.body1='lr-wheel';
item.body2='ground';
item.location1=[-b;t/2;r];
item.location2=[-b;t/2;0];
item.gain=150000;
the_system.item{end+1}=item;

item.name='rr-normal';
item.body1='rr-wheel';
item.body2='ground';
item.location1=[-b;-t/2;r];
item.location2=[-b;-t/2;0];
item.gain=150000;
the_system.item{end+1}=item;
item={};


item.type='sensor';
item.name='lf-slip';
item.body1='lf-wheel';
item.body2='ground';
item.gain=1;
item.location1=[a;t/2;0];
item.location2=[a;t/2-0.1;0];
the_system.item{end+1}=item;

item.name='rf-slip';
item.body1='rf-wheel';
item.body2='ground';
item.gain=1;
item.location1=[a;-t/2;0];
item.location2=[a;-t/2-0.1;0];
the_system.item{end+1}=item;

item.name='lr-slip';
item.body1='lr-wheel';
item.body2='ground';
item.gain=1;
item.location1=[-b;t/2;0];
item.location2=[-b;t/2-0.1;0];
the_system.item{end+1}=item;

item.name='rr-slip';
item.body1='rr-wheel';
item.body2='ground';
item.gain=1;
item.location1=[-b;-t/2;0];
item.location2=[-b;-t/2-0.1;0];
the_system.item{end+1}=item;


