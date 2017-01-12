function the_system=input_ex_bmd_bike_trailer(v,varargin)

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_bmd_bike_trailer.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_bmd_bike_trailer.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%%  This is the bicycle trailer model used in BMD2010
%%  Minaker, Automatic Generation of Linearised Equations of Motion for Moving Vehicles, Proceedings Bicycle and Motorcycle Dynamics, 2010, TU Delft


the_system=input_ex_bicycle_rider(v);

body.type='body';  %% The main frame
body.name='trailer';
body.mass=15;
body.momentsofinertia=[1;1;3];
body.productsofinertia=[0;0;0];
body.location=[-0.75;0;-0.4];
body.velocity=[v;0;0];
body.angular_velocity=[0;0;0];
the_system.item{end+1}=body;

body.name='left wheel';  %% The rear wheel, also with non-zero angular velocity
body.mass=2;
body.momentsofinertia=[0.0603;0.12;0.0603];
body.productsofinertia=[0;0;0];
body.location=[-0.9;0.3;-0.3];
body.angular_velocity=[0;-v/0.3;0];
the_system.item{end+1}=body;

body.name='right wheel';  %% The rear wheel, also with non-zero angular velocity
body.mass=2;
body.momentsofinertia=[0.0603;0.12;0.0603];
body.productsofinertia=[0;0;0];
body.location=[-0.9;-0.3;-0.3];
body.angular_velocity=[0;-v/0.3;0];
the_system.item{end+1}=body;

point={};
point.type='rigid_point';  %% The steering head bearing, connects the frame and fork
point.name='hitch';
point.body1='frame';
point.body2='trailer';
point.location=[0;0.0;-0.3];
point.forces=3;
point.moments=0;
the_system.item{end+1}=point;

point.name='left axle';  %% Rear axle rigid point
point.body1='trailer';
point.body2='left wheel';
point.location=[-0.9;0.3;-0.3];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='right axle';  %% Front axle rigid point
point.body1='trailer';
point.body2='right wheel';
point.location=[-0.9;-0.3;-0.3];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='left road';  %% left wheel touches the ground - holonomic constraint in vertical and longitudinal
point.body1='left wheel';
point.body2='ground';
point.location=[-0.9;0.3;0];
point.forces=2;
point.moments=0;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='front road';  %% right wheel touches the ground - holonomic constraint in vertical and longitudinal
point.body1='right wheel';
point.body2='ground';
point.location=[-0.9;-0.3;0];
point.forces=2;
point.moments=0;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.type='nh_point';  %% left wheel touches the ground - nonholonomic constraint in lateral (i.e. displacement ok, but not slip) 
point.name='left tire';
point.body1='left wheel';
point.body2='ground';
point.location=[-0.9;0.3;0];
point.forces=1;
point.moments=0;
point.axis=[0;1;0];
the_system.item{end+1}=point;


point.type='nh_point';  %% right wheel touches the ground - nonholonomic constraint in lateral (i.e. displacement ok, but not slip) 
point.name='right tire';
point.body1='right wheel';
point.body2='ground';
point.location=[-0.9;-0.3;0];
point.forces=1;
point.moments=0;
point.axis=[0;1;0];
the_system.item{end+1}=point;

item={};
item.type='load';  %% The weights of each component, at their centres of mass
item.name='trailer weight';
item.body='trailer';
item.location=[-0.75;0;-0.3];
item.force=[0;0;20*9.81];
item.moment=[0;0;0];
the_system.item{end+1}=item;

item.name='left wheel weight';
item.body='left wheel';
item.location=[-0.9;0.3;-0.3];
item.force=[0;0;2*9.81];
item.moment=[0;0;0];
the_system.item{end+1}=item;

item.name='right wheel weight';
item.body='right wheel';
item.location=[-0.9;-0.3;-0.3];
item.force=[0;0;2*9.81];
item.moment=[0;0;0];
the_system.item{end+1}=item;


item={};
item.type='sensor';
item.name='heading angle sensor';
item.body1='trailer';
item.body2='ground';
item.location1=[-0.75;0;-0.3];
item.location2=[-0.75;0;0];
item.order=1;
item.frame=1;
item.twist=1;
item.gain=1;
the_system.item{end+1}=item;


