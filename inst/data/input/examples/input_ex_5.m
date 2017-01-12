function the_system=input_ex_5(varargin)
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_5.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_5.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% A single body, tied to the ground with a rigid wire, with an external load at the mass centre.  Constrained to planar motion.

%% Add one rigid body
item.type='body';
item.name='block';
item.mass=5;
item.momentsofinertia=[2;2;2];
item.productsofinertia=[0;0;0];
item.location=[0;0;0.5];
the_system.item{end+1}=item;
item={};

%% Tie body to ground with a rigid wire, called a link
item.type='link';
item.name='link 1';
item.body1='ground';
item.body2='block';
item.location1=[0;0;1];
item.location2=[0;0;0.75];
the_system.item{end+1}=item;
item={};

%% Restrict our body to y-z planar motion using a rigid point
%% Constraints are one force in x-dirn, and moments around y and z
item.type='rigid_point';
item.name='planar';
item.body1='ground';
item.body2='block';
item.location=[0;0;0.5];
item.forces=1;
item.moments=2;
item.axis=[1;0;0];
the_system.item{end+1}=item;
item={};

%% Add a force acting in -z-dirn to our body
item.type='load';
item.name='ext force';
item.body='block';
item.location=[0;0;0.5];
item.force=[0;0;-10];
item.moment=[0;0;0];
the_system.item{end+1}=item;
item={};

item.type='actuator';
item.name='actuator one';
item.body1='block';
item.body2='ground';
item.location1=[0.1;0;0.5];
item.location2=[0.2;0;0.5];
item.twist=1;  % torsional
item.gain=1;
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='sensor one';
item.body1='block';
item.body2='ground';
item.location1=[0.3;0;0.5];
item.location2=[0.4;0;0.5];
item.twist=1;  % torsional
item.gain=1;
the_system.item{end+1}=item;




