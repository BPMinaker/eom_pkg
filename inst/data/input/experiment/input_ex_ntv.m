function the_system=input_ex_ntv(u,varargin)
the_system.item={};

%% Copyleft (C) 2010, left Minaker
%% This file is intended for use with Octave.
%% input_ex_trike_simple.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_trike.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyright/gpl.html.
%%
%%--------------------------------------------------------------------


rc=0.15;

%*********************************************************************
% Model Definition
%--------------------------------------------------------------------

%% Chassis
group = 'chassis';

body.name='bike';
body.type='body';
body.group = group;
body.mass=270;
body.momentsofinertia=[80;110;40];
body.productsofinertia=[0;0;0];
body.location=[0;0;0.75];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body);
body={};

cnst.name='x_motion';
cnst.type ='nh_point';
cnst.group=group;
cnst.body1 = 'bike';
cnst.body2 = 'ground';
cnst.location = [0;0;0.75];
cnst.forces = 1;
cnst.moments = 0;
cnst.axis = [1;0;0];
the_system.item{end+1}=cnst;
cnst={};

%------------------------------------------------------------
% Front Suspension
group='fr_suspension';
steer_axis = [-atan(5*pi/180);0;1];

body.name='left front arm';
body.type='body';
body.group=group;
body.mass=10;
body.location=[0.8;0.25;0.2];
body.momentsofinertia=[0.25;0.1;0.25];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body);

body.name='right front arm';
body.location=[0.8;-0.25;0.2];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body);


body.name='left front wheel';
body.type='body';
body.group=group;
body.location=[0.8;0.5;0.3];
body.mass=10;
body.momentsofinertia=[0.25;0.5;0.25];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
body.angular_velocity=[0;u/0.3;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body);

body.name='right front wheel';
body.location=[0.8;-0.5;0.3];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body);


body.name='left front upright';
body.type='body';
body.group=group;
body.location=[0.8;0.45;0.3];
body.mass=10;
body.momentsofinertia=[0.25;0.5;0.25];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
body.angular_velocity=[0;u/0.3;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body);

body.name='right front upright';
body.location=[0.8;-0.45;0.3];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body);
body={};


point.name='left revolute';
point.type='rigid_point';
point.group=group;
point.body1='bike';
point.body2='left front arm';
point.forces=3;
point.moments=2;
point.axis=[1;0;0];
point.location=[0.8;0;rc];
the_system.item{end+1}=point;

point.name='right revolute';
point.body2='right front arm';
point.location=[0.8;0;rc];
the_system.item{end+1}=point;

%  point.name='left steer axis';
%  point.type='rigid_point';
%  point.group= group;
%  point.body1='left front arm';
%  point.body2='left front upright';
%  point.forces=3;
%  point.moments=2;
%  point.axis=[-0.1;0;1];
%  point.location=[0.8;0.45;0.3];
%  the_system.item{end+1}=point;
%  
%  point.name='right steer axis';
%  point.body1='right front arm';
%  point.body2='right front upright';
%  point.location=[0.8;-0.45;0.3];
%  the_system.item{end+1}=point;



point.name='left lower ball joint';
point.type='rigid_point';
point.group= group;
point.body1='left front arm';
point.body2='left front upright';
point.forces=3;
point.moments=0;
point.location=[0.85;0.45;0.15];
the_system.item{end+1}=point;

point.name='right lower ball joint';
point.body1='right front arm';
point.body2='right front upright';
point.location=[0.85;-0.45;0.15];
the_system.item{end+1}=point;


link.name='left upper a-arm 1';
link.type='link';
link.group=group;
link.body1='bike';
link.body2='left front upright';
link.location1=[0.7;0;rc+0.1];
link.location2=[0.75;0.45;0.4]; ;
the_system.item{end+1}=link;

link.name='right upper a-arm 1';
link.body2='right front upright';
link.location2=[0.75;-0.45;0.4]; ;
the_system.item{end+1}=link;


link.name='left upper a-arm 2';
link.type='link';
link.group=group;
link.body1='bike';
link.body2='left front upright';
link.location1=[0.8;0;rc+0.1];
link.location2=[0.75;0.45;0.4]; ;
the_system.item{end+1}=link;

link.name='right upper a-arm 2';
link.body2='right front upright';
link.location2=[0.75;-0.45;0.4]; ;
the_system.item{end+1}=link;


point.name='left front wheel bearing';
point.type='rigid_point';
point.group= group;
point.body1='left front wheel';
point.body2='left front upright';
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
point.location=[0.8;0.5;0.3];
the_system.item{end+1}=point;

point.name='right front wheel bearing';
point.body1='right front wheel';
point.body2='right front upright';
point.location=[0.8;-0.5;0.3];
the_system.item{end+1}=point;
point={};

point.name='left front road';
point.type='rigid_point';
point.group=group;
point.body1='left front wheel';
point.body2='ground';
point.location=[0.8;0.5;0];
point.forces=2;
point.moments=0;
point.axis=[0;1;0];
point.rolling_axis=[0;1;0];
the_system.item{end+1}=point;

point.name='right front road';
point.body1='right front wheel';
point.location=[0.8;-0.5;0];
the_system.item{end+1}=point;
point={};

point.name='left front tire';
point.type='flex_point';
point.group=group;
point.body1='left front wheel';
point.body2='ground';
point.stiffness=0;
point.damping=[30000/u];
point.location=[0.8;0.5;0];
point.forces=1;
point.moments=0;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='right front tire';
point.body1='right front wheel';
point.location=[0.8;-0.5;0];
the_system.item{end+1}=point;
point={};


spring.name='front spring';
spring.type='spring';
spring.group = group;
spring.body1='left front arm';
spring.body2='right front arm';
spring.location1=[0.8;0.2;rc+0.15];%% z=0.35
spring.location2=[0.8;-0.2;rc+0.15];
spring.stiffness=20000; %(AE/L)
spring.damping=500;
the_system.item{end+1}=spring;

spring = {}; % reset used structures

%--------------------------------------------------
% Steering System
group = 'steering';


body.name='pitman arm';
body.type='body';
body.group=group;
body.mass=0.5;
body.location=[0.7;0;0.3];
body.momentsofinertia=[0.01;0.01;0.01];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;


point.name='pitman hinge';
point.type='rigid_point';
point.group=group;
point.body1='bike';
point.body2='pitman arm';
point.location=[0.7;0;0.4];
point.forces=3;
point.moments=2;
point.axis=[1;0;0];
the_system.item{end+1}=point;

act.name='steer input';
act.type='actuator';
act.group = group;
act.body1='bike';
act.body2='pitman arm';
act.location1=[0.7;0;0.4];
act.location2=[0.75;0;0.4];
act.twist=1;
the_system.item{end+1}=act;


tierod_outer=[0.70;0.45;rc];

link.name='left front tierod';
link.type='link';
link.group=group;
link.body1='pitman arm';
link.body2='left front upright';
link.location1=[0.7;0;rc];
link.location2=tierod_outer;
the_system.item{end+1}=link;

link.name='right front tierod';
link.type='link';
link.group=group; 
link.body1='pitman arm';
link.body2='right front upright';
link.location1=[0.7;0;rc];
link.location2=[1;-1;1].*tierod_outer;
the_system.item{end+1}=link;


body={};
point={};
link={};
spring={};

%--------------------------------------------------
% Rear Suspension
group = 'rear_suspension';

body.name='left rear arm';
body.type='body';
body.group=group;
body.mass=10;
body.location=[-0.8;0.25;0.2];
body.momentsofinertia=[0.25;0.1;0.25];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body);

body.name='right rear arm';
body.location=[-0.8;-0.25;0.2];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body);

body.name='left rear wheel';
body.type='body';
body.group=group;
body.location=[-0.8;0.5;0.3];
body.mass=10;
body.momentsofinertia=[0.5;0.25;0.5];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
body.angular_velocity=[0;u/0.3;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body);

body.name='right rear wheel';
body.location=[-0.8;-0.5;0.3];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body);
body={};


point.name='left rear revolute';
point.type='rigid_point';
point.group=group;
point.body1='bike';
point.body2='left rear arm';
point.forces=3;
point.moments=2;
point.axis=[1;0;0];
point.location=[-0.8;0;0.2];
the_system.item{end+1}=point;

point.name='right rear revolute';
point.body2='right rear arm';
the_system.item{end+1}=point;

point.name='left rear axle';
point.body1='left rear arm';
point.body2='left rear wheel';
point.location=[-0.8;0.5;0.3];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='right rear axle';
point.body1='right rear arm';
point.body2='right rear wheel';
point.location=[-0.8;-0.5;0.3];
the_system.item{end+1}=point;
point={};

point.name='left rear road';
point.type='rigid_point';
point.group=group;
point.body1='left rear wheel';
point.body2='ground';
point.location=[-0.8;0.5;0];
point.forces=2;
point.moments=0;
point.axis=[0;1;0];
point.rolling_axis=[0;1;0];
the_system.item{end+1}=point;

point.name='right rear road';
point.body1='right rear wheel';
point.location=[-0.8;-0.5;0];
the_system.item{end+1}=point;
point={};

point.name='left rear tire';
point.type='flex_point';
point.group=group;
point.body1='left rear wheel';
point.body2='ground';
point.stiffness=0;
point.damping=[30000/u];
point.location=[-0.8;0.5;0];
point.forces=1;
point.moments=0;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='right rear tire';
point.body1='right rear wheel';
point.location=[-0.8;-0.5;0];
the_system.item{end+1}=point;
point={};


spring.name='rear spring';
spring.type='spring';
spring.group = group;
spring.body1='left rear arm';
spring.body2='right rear arm';
spring.location1=[-0.8;0.2;0.35];
spring.location2=[-0.8;-0.2;0.35];
spring.stiffness=20000; %(AE/L)
spring.damping = 500;
the_system.item{end+1}=spring;
spring = {};


item.type='sensor';
item.name='yaw rate sensor';
item.body1='bike';
item.body2='ground';
item.location1=[0;0;0.75];
item.location2=[0;0;0.65];
item.order=2;
item.frame=1;
item.twist=1;
item.gain=1;
the_system.item{end+1}=item;


item.name='roll angle sensor';
item.location2=[0.1;0;0.75];
item.order=1;
the_system.item{end+1}=item;


item.name='roll rate sensor';
item.location2=[0.1;0;0.75];
item.order=2;
the_system.item{end+1}=item;


