function the_system=input_ex_susp_bike(u,varargin)
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_genta_bike.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_genta_bike.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

g=9.81;

body.type='body';
body.name='bike';
body.location=[0;0;0.496];
body.mass=270;
body.momentsofinertia=[80;110;40];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='fork rod';
body.location=[0.5;0;0.6];
body.mass=2;
body.momentsofinertia=[2;2;2];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body=thin_rod([[0.641;0.1;0.3] [0.5;0.1;0.6]],10);
body.name='left fork arm';
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body=thin_rod([[0.641;-0.1;0.3] [0.5;-0.1;0.6]],10);
body.name='right fork arm';
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


body=thin_rod([[0.45;0.3;0.7] [0.45;-0.3;0.7]],1);
body.name='handle bar';
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


body=thin_rod([[0.45;0;0.7] [0.5;0;0.6]],1);
body.name='steer arm';
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


body={};
body.type='body';
body.name='swing arm';
body.location=[-0.35;0;0.32];
body.mass=20;
body.momentsofinertia=[2;2;2];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='front wheel, bike';
body.location=[0.641;0;0.3];
body.mass=20;
body.momentsofinertia=[1;2;1];
body.velocity=[u;0;0];
body.angular_velocity=[0;u/0.3;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='rear wheel, bike';
body.location=[-0.674;0;0.3];
body.mass=20;
body.momentsofinertia=[1;2;1];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);



%  %% Constrain body1 to body2 in rotation
%  point.type='rigid_point';
%  point.name='head';
%  point.location=[0.641+0.100/cos(23*pi/180)-0.5*tan(23*pi/180) ;0;0.5];
%  point.body1='bike';
%  point.body2='fork';
%  point.forces=3;
%  point.moments=2;
%  point.axis=[-sin(23*pi/180);0;cos(23*pi/180)];
%  the_system.item{end+1}=point;


aa=[[0.54;0.09;0.25] [0.24;0.25;0.25]]';
bb=[[0.54;0.08;0.35] [0.24;0.25;0.35]]';

cc=aa*diag([1 -1 1]);
dd=bb*diag([1 -1 1]);

body=thin_rod(aa',2);
body.name='lower left arm';
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


plx=polyfit(aa(:,2),aa(:,1),1);
plz=polyfit(aa(:,2),aa(:,3),1);

lx=polyval(plx,0);
lz=polyval(plz,0);


body=thin_rod(bb',2);
body.name='upper left arm';
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


pux=polyfit(bb(:,2),bb(:,1),1);
puz=polyfit(bb(:,2),bb(:,3),1);

ux=polyval(pux,0);
uz=polyval(puz,0);

pa=polyfit([uz;lz],[ux;lx],1);

rake=180/pi*atan2(uz-lz,ux-lx)-90
trail=polyval(pa,0)-0.641



body=thin_rod(cc',2);
body.name='lower right arm';
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body=thin_rod(dd',2);
body.name='upper right arm';
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);



%  item.type='spring';
%  item.name='front spring';
%  item.body1='fork rod';
%  item.body2='bike';
%  item.location1=[0.65;0;0.65];
%  item.location2=[0.6;0;0.85];
%  item.stiffness=5000;
%  item.damping=100;
%  the_system.item{end+1}=item;



item.type='spring';
item.name='rear spring';
item.body1='swing arm';
item.body2='bike';
item.location1=[-0.25;0;0.4];
item.location2=[-0.2;0;0.6];
item.stiffness=15000;
item.damping=300;
the_system.item{end+1}=item;

bbs=[0.2 0.8]*bb;
dds=[0.2 0.8]*dd;

item.name='left front spring';
item.body1='upper left arm';
item.body2='bike';
item.location1=bbs';
item.location2=[0.2;0.2;0.6];
item.stiffness=7500;
item.damping=100;
the_system.item{end+1}=item;

item.name='right front spring';
item.body1='upper right arm';
item.body2='bike';
item.location1=dds';
item.location2=[0.2;-0.2;0.6];
item.stiffness=7500;
item.damping=100;
the_system.item{end+1}=item;


point.type='rigid_point';
point.name='left front axle';
point.location=[0.641;0.1;0.3];
point.body1='left fork arm';
point.body2='front wheel, bike';
point.forces=3;
point.moments=0;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='front axle';
point.location=[0.641;-0.1;0.3];
point.body1='right fork arm';
point.body2='front wheel, bike';
point.forces=2;
point.moments=0;
point.axis=[0;1;0];
the_system.item{end+1}=point;
point={};

point.type='rigid_point';
point.name='left fork joint';
point.location=[0.5;0.1;0.6];
point.body1='left fork arm';
point.body2='fork rod';
point.forces=3;
point.moments=3;
the_system.item{end+1}=point;

point.name='right fork joint';
point.location=[0.5;-0.1;0.6];
point.body1='right fork arm';
point.body2='fork rod';
point.forces=3;
point.moments=3;
the_system.item{end+1}=point;

point.name='joint';
point.location=aa(2,:)';
point.body1='lower left arm';
point.body2='bike';
point.forces=3;
point.moments=1;
point.axis=[1;0;0];
the_system.item{end+1}=point;

point.location=aa(1,:)';
point.body1='lower left arm';
point.body2='left fork arm';
point.forces=3;
point.moments=0;
point.axis=[0;0;0];
the_system.item{end+1}=point;

point.location=bb(2,:)';
point.body1='upper left arm';
point.body2='bike';
point.forces=3;
point.moments=1;
point.axis=[1;0;0];
the_system.item{end+1}=point;

point.location=bb(1,:)';
point.body1='upper left arm';
point.body2='left fork arm';
point.forces=3;
point.moments=0;
point.axis=[0;0;0];
the_system.item{end+1}=point;


point.name='joint';
point.location=cc(2,:)';
point.body1='lower right arm';
point.body2='bike';
point.forces=3;
point.moments=1;
point.axis=[1;0;0];
the_system.item{end+1}=point;

point.location=cc(1,:)';
point.body1='lower right arm';
point.body2='right fork arm';
point.forces=3;
point.moments=0;
point.axis=[0;0;0];
the_system.item{end+1}=point;

point.location=dd(2,:)';
point.body1='upper right arm';
point.body2='bike';
point.forces=3;
point.moments=1;
point.axis=[1;0;0];
the_system.item{end+1}=point;

point.location=dd(1,:)';
point.body1='upper right arm';
point.body2='right fork arm';
point.forces=3;
point.moments=0;
point.axis=[0;0;0];
the_system.item{end+1}=point;

point.name='rear axle';
point.location=[-0.674;0;0.3];
point.body1='swing arm';
point.body2='rear wheel, bike';
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;


point.name='arm pivot';
point.location=[-0.1;0;0.35];
point.body1='swing arm';
point.body2='bike';
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;



point.name='steering head';
point.location=[0.4;0;0.7];
point.body1='handle bar';
point.body2='bike';
point.forces=3;
point.moments=2;
point.axis=[-1;0;2];
the_system.item{end+1}=point;


point.name='steering arm joint 1';
point.location=[0.45;0;0.7];
point.body1='steer arm';
point.body2='handle bar';
point.forces=2;
point.moments=1;
point.axis=[-1;0;2];
the_system.item{end+1}=point;


point.name='steering arm joint 2';
point.location=[0.5;0;0.6];
point.body1='fork rod';
point.body2='steer arm';
point.forces=3;
point.moments=1;
point.axis=[-1;0;2];
the_system.item{end+1}=point;


point.type='flex_point';
point.name='front tire lateral';
point.location=[0.641;0;0];
point.body1='front wheel, bike';
point.body2='ground';
point.damping=[40000/u;0];
point.forces=1;
point.moments=0;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='rear tire lateral';
point.location=[-0.674;0;0];
point.body1='rear wheel, bike';
point.damping=[40000/u;0];
the_system.item{end+1}=point;


point.name='front tire longitudinal';
point.location=[0.641;0;0];
point.body1='front wheel, bike';
point.body2='ground';
point.damping=[60000/u;0];
point.forces=1;
point.moments=0;
point.axis=[1;0;0];
the_system.item{end+1}=point;

point.name='rear tire longitudinal';
point.location=[-0.674;0;0];
point.body1='rear wheel, bike';
point.damping=[60000/u;0];
the_system.item{end+1}=point;


point.name='front tire vertical';
point.location=[0.641;0;0];
point.body1='front wheel, bike';
point.stiffness=[100000,0];
point.damping=[0;0];
point.forces=1;
point.moments=0;
point.axis=[0;0;1];
point.rolling_axis=[0;1;0];
the_system.item{end+1}=point;

point.name='rear tire vertical';
point.location=[-0.674;0;0];
point.body1='rear wheel, bike';
the_system.item{end+1}=point;

item={};
item.type='sensor';
item.name='yaw rate';
item.body1='bike';
item.body2='ground';
item.location1=[0;0;0.496];
item.location2=[0;0.0;0.396];
item.order=2;
item.twist=1;
the_system.item{end+1}=item;

item.name='roll angle';
item.location2=[0.1;0.0;0.496];
item.order=1;
item.twist=1;
the_system.item{end+1}=item;

item={};
item.type='actuator';
item.name='steer torque';
item.body1='handle bar';
item.body2='bike';
item.twist=1;
item.location1=[0.45;0;0.7];
item.location2=[0.35;0;0.9];
the_system.item{end+1}=item;


