function the_system=input_vibrobeam(varargin)
the_system.item={};

%% Copyright (C) 2005, Bruce Minaker
%% This file is intended for use with Octave.
%% input_vibrobeam.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_vibrobeam.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

item.type='body';
item.name='Bluff body';
item.mass=0.005;
item.momentsofinertia=[0;0;5e-6];
item.productsofinertia=[0;0;0];
item.location=[0.01;0;1];
the_system.item{end+1}=item;
item={};


item.type='load';
item.name='test load';
item.body='Bluff body';
item.location=[0.01;0;1];
item.force=[1;1;1];
the_system.item{end+1}=item;
item={};


item.type='beam';
item.name='Leaf spring';
item.body1='Bluff body';
item.body2='ground';
item.location1=[0.01;0;1];
item.location2=[0;0;1];
item.stiffness=100; %%EI/L
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='Planar';
item.body1='Bluff body';
item.body2='ground';
item.location=[0.01;0;1];
item.forces=0;
item.moments=2;
item.axis=[0;0;1];
the_system.item{end+1}=item;

item.forces=2;
item.moments=0;
item.axis=[0;1;0];
the_system.item{end+1}=item;
item={};

% The actuator is a 'line item' and defined by two locations, location1 attaches to body1, location2 to body2
item.type='actuator';
item.name='Wind force';
item.body1='Bluff body';
item.body2='ground';
item.location1=[0.01;0;1];
item.location2=[0.02;-0.01;1];
the_system.item{end+1}=item;
item={};

%% The actuator is a 'line item' and defined by two locations, location1 attaches to body1, location2 to body2
item.type='sensor';
item.name='Sensor';
item.body1='Bluff body';
item.body2='ground';
item.location1=[0.01;0;1];
item.location2=[0.01;-0.01;1];
the_system.item{end+1}=item;
item={};