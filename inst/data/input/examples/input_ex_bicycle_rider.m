function the_system=input_ex_bicycle_rider(v,varargin)
the_system.name='Rigid Rider Bicycle';
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_bicycle_rider.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_bicycle_rider.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------


%%  This is the benchmark bicycle problem that has been well studied in the literature
%%  Meijaard, J.P., Papadopoulos, J.M., Ruina, A., Schwab, A.L., linearised dynamics equations for the balance and steer of a bicycle: a benchmark and review, Proc. Roy. Soc. A., Volume 463, Number 2084, 2007

g=-9.81;
rake=pi/10;

body.type='body';  %% The main frame
body.name='frame';
body.mass=85;
body.momentsofinertia=[9.2;11;2.8];
body.productsofinertia=[0;0;-2.4];
body.location=[0.3;0;-0.9];
body.velocity=[v;0;0];
body.angular_velocity=[0;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='fork';  %% The front fork, same velocities as the frame
body.mass=4;
body.momentsofinertia=[0.05892;0.06;0.00708];
body.productsofinertia=[0;0;0.00756];
body.location=[0.9;0;-0.7];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='front-wheel';  %% The front-wheel, with non-zero angular velocity
body.mass=3;
body.momentsofinertia=[0.1405;0.28;0.1405];
body.productsofinertia=[0;0;0];
body.location=[1.02;0;-0.35];
body.angular_velocity=[0;-v/0.35;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='rear-wheel';  %% The rear-wheel, also with non-zero angular velocity
body.mass=2;
body.momentsofinertia=[0.0603;0.12;0.0603];
body.productsofinertia=[0;0;0];
body.location=[0;0;-0.3];
body.angular_velocity=[0;-v/0.3;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

point.type='rigid_point';  %% The steering head bearing, connects the frame and fork
point.name='head';
point.body1='frame';
point.body2='fork';
point.location=[1.1-0.8*sin(rake);0;-0.8*cos(rake)];
point.forces=3;
point.moments=2;
point.axis=[sin(rake);0;cos(rake)];
the_system.item{end+1}=point;

point.name='rear axle';  %% Rear axle rigid point
point.body1='frame';
point.body2='rear-wheel';
point.location=[0;0;-0.3];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='front axle';  %% Front axle rigid point
point.body1='fork';
point.body2='front-wheel';
point.location=[1.02;0;-0.35];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='rear road';  %% Rear wheel touches the ground - holonomic constraint in vertical and longitudinal
point.body1='rear-wheel';
point.body2='ground';
point.location=[0;0;0];
point.forces=2;
point.moments=0;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='front road';  %% Front wheel touches the ground - holonomic constraint in vertical and longitudinal
point.body1='front-wheel';
point.body2='ground';
point.location=[1.02;0;0];
point.forces=2;
point.moments=0;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.type='nh_point';  %% Front wheel touches the ground - nonholonomic constraint in lateral (i.e. displacement ok, but not slip) 
point.name='front tire';
point.body1='front-wheel';
point.body2='ground';
point.location=[1.02;0;0];
point.forces=1;
point.moments=0;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.type='nh_point';  %% Rear wheel touches the ground - nonholonomic constraint in lateral (i.e. displacement ok, but not slip) 
point.name='rear tire';
point.body1='rear-wheel';
point.body2='ground';
point.location=[0;0;0];
point.forces=1;
point.moments=0;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.type='rigid_point';  %% Constrain the speed to constant,
point.name='speed';  %% This could be nonholonomic also, I suppose, but that would just give another zero root
point.body1='frame';
point.body2='ground';
point.location=[0.3;0;-0.9];
point.forces=1;
point.moments=0;
point.axis=[1;0;0];
the_system.item{end+1}=point;


item={};
item.type='actuator';  %% The steer torque is the input
item.name='$m_{\\delta}$';
item.body1='frame';
item.body2='fork';
item.gain=1;
item.twist=1;
item.location1=[1.1-0.8*sin(rake);0;-0.8*cos(rake)];
item.location2=item.location1+0.25*[sin(rake);0;cos(rake)];  %% pi/10 rake angle
the_system.item{end+1}=item;
item={};

item.type='sensor';  %% Yaw rate sensor
% item.name='$r$';
item.body1='frame';
item.body2='ground';
item.location1=[0.3;0;-0.9];
% item.location2=[0.3;0;-1.1];
% item.order=2;
% item.frame=1;
item.twist=1;
item.gain=1;
% the_system.item{end+1}=item;

% item.name='$\\psi$';
% item.order=1;
% the_system.item{end+1}=item;

item.name='$\\phi$';
item.location2=[0.1;0;-0.9];  %% Roll angle sensor
item.order=1;
the_system.item{end+1}=item;


%% Extra sensors off

%item.name='$p$';
%item.order=2;
%the_system.item{end+1}=item;
  
item.name='$\\delta$';
item.body1='frame';
item.body2='fork';
item.location1=[1.1-0.8*sin(pi/10);0;-0.8*cos(pi/10)];
item.location2=item.location1+0.25*[sin(pi/10);0;cos(pi/10)];  %% pi/10 rake angle
item.order=1;
the_system.item{end+1}=item;

%item.name='$\\dot\\delta$';
%item.order=2;
%the_system.item{end+1}=item;
