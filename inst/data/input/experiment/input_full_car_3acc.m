function the_system=input_full_car_acc(ii,params)
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

%% A full-car model made from five bodies, with suspension motion constrained to simple vertical relative to chassis.  Each suspension spring has stiffness and damping defined in translation along the z axis only.  Simple linear spring tire model.  An actuator acts on each wheel to simulate vertical road inputs.  Sensors record vertical acceleration of each wheel, plus the bounce, roll, and pitch of the chassis at the cg.

%% Units are meters, kg, Newton, seconds, radians!!

g=9.81;

%% Add chassis mass
body.type='body';
body.name='chassis';
body.mass=params.ms;
body.momentsofinertia=[params.ixx;params.iyy;0];
body.location=[0;0;0.5];
body.velocity=[params.vx;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%% Add the wheel mass, along the z-axis
body.name='lf-wheel';
body.mass=params.muf;
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
body.location=[params.fwf*params.wb;params.tw/2;0.3];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='rf-wheel';
body.location=[params.fwf*params.wb;-params.tw/2;0.3];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='lr-wheel';
body.mass=params.mur;
body.location=[(params.fwf-1)*params.wb;params.tw/2;0.3];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='rr-wheel';
body.location=[(params.fwf-1)*params.wb;-params.tw/2;0.3];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


%% Add the anti roll bar arm, ignore mass
body.name='lf-arb';
body.mass=0;
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
body.location=[params.fwf*params.wb-0.3;params.tw/2;0.3];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='rf-arb';
body.location=[params.fwf*params.wb-0.3;-params.tw/2;0.3];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='lr-arb';
body.location=[(params.fwf-1)*params.wb+0.3;params.tw/2;0.3];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='rr-arb';
body.location=[(params.fwf-1)*params.wb+0.3;-params.tw/2;0.3];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


%% Add a spring, with no damping, to connect our wheel mass to ground, aligned with z-axis
spring.type='flex_point';
spring.name='lf-tire';
spring.body1='lf-wheel';
spring.body2='ground';
spring.stiffness=[params.ktf;0];
spring.damping=[0;0];
spring.location=[params.fwf*params.wb;params.tw/2;0];
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
the_system.item{end+1}=spring;

spring.name='rf-tire';
spring.body1='rf-wheel';
spring.location=[params.fwf*params.wb;-params.tw/2;0];
the_system.item{end+1}=spring;

spring.name='lr-tire';
spring.body1='lr-wheel';
spring.stiffness=[params.ktr;0];
spring.location=[(params.fwf-1)*params.wb;params.tw/2;0];
the_system.item{end+1}=spring;

spring.name='rr-tire';
spring.body1='rr-wheel';
spring.location=[(params.fwf-1)*params.wb;-params.tw/2;0];
the_system.item{end+1}=spring;

%% Add another spring, with damping, to connect our chassis and wheel mass
spring.name='lf-susp';
spring.body1='lf-wheel';
spring.body2='chassis';
spring.stiffness=[params.ksf;0];
spring.damping=[params.csf;0];
spring.location=[params.fwf*params.wb;params.tw/2;0.3];
the_system.item{end+1}=spring;

spring.name='rf-susp';
spring.body1='rf-wheel';
spring.location=[params.fwf*params.wb;-params.tw/2;0.3];
the_system.item{end+1}=spring;

spring.name='lr-susp';
spring.body1='lr-wheel';
spring.stiffness=[params.ksr;0];
spring.damping=[params.csr;0];
spring.location=[(params.fwf-1)*params.wb;params.tw/2;0.3];
the_system.item{end+1}=spring;

spring.name='rr-susp';
spring.body1='rr-wheel';
spring.location=[(params.fwf-1)*params.wb;-params.tw/2;0.3];
the_system.item{end+1}=spring;
spring={};

%% Add anti roll bars
spring.type='spring';
spring.name='f-arb';
spring.body1='lf-arb';
spring.body2='rf-arb';
spring.stiffness=params.krf;
spring.damping=0;
spring.twist=1;
spring.location1=[params.fwf*params.wb-0.3;params.tw/2;0.3];
spring.location2=[params.fwf*params.wb-0.3;-params.tw/2;0.3];
the_system.item{end+1}=spring;

spring.name='r-arb';
spring.body1='lr-arb';
spring.body2='rr-arb';
spring.stiffness=params.krr;
spring.location1=[(params.fwf-1)*params.wb+0.3;params.tw/2;0.3];
spring.location2=[(params.fwf-1)*params.wb+0.3;-params.tw/2;0.3];
the_system.item{end+1}=spring;


%% Constrain wheel mass to chassis mass
point.type='rigid_point';
point.name='lf-slider';
point.body1='lf-wheel';
point.body2='chassis';
point.location=[params.fwf*params.wb;params.tw/2;0.3];
point.forces=2;
point.moments=3;
point.axis=[0;0;1];
the_system.item{end+1}=point;

point.name='rf-slider';
point.body1='rf-wheel';
point.location=[params.fwf*params.wb;-params.tw/2;0.3];
the_system.item{end+1}=point;

point.name='lr-slider';
point.body1='lr-wheel';
point.location=[(params.fwf-1)*params.wb;params.tw/2;0.3];
the_system.item{end+1}=point;

point.name='rr-slider';
point.body1='rr-wheel';
point.location=[(params.fwf-1)*params.wb;-params.tw/2;0.3];
the_system.item{end+1}=point;


%% Constrain arb arms to chassis
point.name='lf-arb';
point.body1='lf-arb';
point.body2='chassis';
point.location=[params.fwf*params.wb-0.3;params.tw/2;0.3];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='rf-arb';
point.body1='rf-arb';
point.location=[params.fwf*params.wb-0.3;-params.tw/2;0.3];
the_system.item{end+1}=point;

point.name='lr-arb';
point.body1='lr-arb';
point.location=[(params.fwf-1)*params.wb+0.3;params.tw/2;0.3];
the_system.item{end+1}=point;

point.name='rr-arb';
point.body1='rr-arb';
point.location=[(params.fwf-1)*params.wb+0.3;-params.tw/2;0.3];
the_system.item{end+1}=point;


%% Constrain arb arms to wheel
point.name='lf-arb';
point.body1='lf-arb';
point.body2='lf-wheel';
point.location=[params.fwf*params.wb;params.tw/2;0.3];
point.forces=1;
point.moments=0;
point.axis=[0;0;1];
the_system.item{end+1}=point;

point.name='rf-arb';
point.body1='rf-arb';
point.body2='rf-wheel';
point.location=[params.fwf*params.wb;-params.tw/2;0.3];
the_system.item{end+1}=point;

point.name='lr-arb';
point.body1='lr-arb';
point.body2='lr-wheel';

point.location=[(params.fwf-1)*params.wb;params.tw/2;0.3];
the_system.item{end+1}=point;

point.name='rr-arb';
point.body1='rr-arb';
point.body2='rr-wheel';
point.location=[(params.fwf-1)*params.wb;-params.tw/2;0.3];
the_system.item{end+1}=point;


%% Constrain chassis mass to translation in z-axis, pitch, roll
point.name='slider two';
point.body1='chassis';
point.body2='ground';
point.location=[0;0;0.5];
point.forces=2;
point.moments=1;
point.axis=[0;0;1];
the_system.item{end+1}=point;

%% Add external force between wheel mass and ground
item.type='actuator';
item.name='lf-road';
item.body1='lf-wheel';
item.body2='ground';
item.gain=params.ktf;
item.location1=[params.fwf*params.wb;params.tw/2;0.3];
item.location2=[params.fwf*params.wb;params.tw/2;0];
the_system.item{end+1}=item;

item.name='rf-road';
item.body1='rf-wheel';
item.location1=[params.fwf*params.wb;-params.tw/2;0.3];
item.location2=[params.fwf*params.wb;-params.tw/2;0];
the_system.item{end+1}=item;

item.name='lr-road';
item.body1='lr-wheel';
item.gain=params.ktr;
item.location1=[(params.fwf-1)*params.wb;params.tw/2;0.3];
item.location2=[(params.fwf-1)*params.wb;params.tw/2;0];
the_system.item{end+1}=item;

item.name='rr-road';
item.body1='rr-wheel';
item.location1=[(params.fwf-1)*params.wb;-params.tw/2;0.3];
item.location2=[(params.fwf-1)*params.wb;-params.tw/2;0];
the_system.item{end+1}=item;
item={};

%% Add acceleration sensors on all four wheels
item.type='sensor';
item.name='lf-acc-ws';
item.body1='lf-wheel';
item.body2='ground';
item.location1=[params.fwf*params.wb;params.tw/2;0.3];
item.location2=[params.fwf*params.wb;params.tw/2;0];
item.order=3;
the_system.item{end+1}=item;

item.name='rf-acc-ws';
item.body1='rf-wheel';
item.location1=[params.fwf*params.wb;-params.tw/2;0.3];
item.location2=[params.fwf*params.wb;-params.tw/2;0];
the_system.item{end+1}=item;

item.name='lr-acc-ws';
item.body1='lr-wheel';
item.location1=[(params.fwf-1)*params.wb;params.tw/2;0.3];
item.location2=[(params.fwf-1)*params.wb;params.tw/2;0];
the_system.item{end+1}=item;

item.name='rr-acc-ws';
item.body1='rr-wheel';
item.location1=[(params.fwf-1)*params.wb;-params.tw/2;0.3];
item.location2=[(params.fwf-1)*params.wb;-params.tw/2;0];
the_system.item{end+1}=item;
item={};

%% Add acceleration sensors on chassis
item.type='sensor';
item.name='chassis-wdot';
item.body1='chassis';
item.body2='ground';
item.location1=[0;0;0.5];
item.location2=[0;0;0];
item.order=3;
the_system.item{end+1}=item;

item.name='chassis-pdot';
item.location1=[0;0;0.5];
item.location2=[-0.10;0;0.5];
item.twist=1;
the_system.item{end+1}=item;

item.name='chassis-qdot';
item.location1=[0;0;0.5];
item.location2=[0;-0.1;0.5];
the_system.item{end+1}=item;
item={};
