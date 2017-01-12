function the_system=input_ex_7(varargin)
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_7.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_7.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% Add one rigid body, along the x-axis
body.name='block';
body.type='body';
body.mass=5;
body.momentsofinertia=[2;2;2];
body.productsofinertia=[0;0;0];
body.location=[0;0;0.5];
the_system.item{end+1}=body;

%% Tie body to ground with a torsional spring
item.type='spring';
item.name='shaft1';
item.body1='ground';
item.body2='block';
item.location1=[0;0;0];
item.location2=[0;0;0.5];
item.stiffness=100;
item.twist=1;
the_system.item{end+1}=item;
item={};

%% Restrict our body to rotary motion using a rigid point
%% constraints are three forces, and moments around x and y
item.type='rigid_point';
item.name='point1';
item.body1='ground';
item.body2='block';
item.location=[0;0;0.5];
item.forces=3;
item.moments=2;
item.axis=[0;0;1];
the_system.item{end+1}=item;
item={};

item.type='actuator';
item.name='actuator one';
item.body1='block';
item.body2='ground';
item.location1=[0;0;0.6];
item.location2=[0;0;0.7];
item.twist=1;  % torsional
item.gain=1;
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='sensor one';
item.body1='block';
item.body2='ground';
item.location1=[0;0;0.8];
item.location2=[0;0;0.9];
item.twist=1;  % torsional
item.gain=1;
the_system.item{end+1}=item;


