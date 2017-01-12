function the_system=input_ex_3(varargin)
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_3.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_3.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% A single body, hinged to the ground, with an external load at the mass centre, with a linear actuator

%% Add one rigid body
item.type='body';
item.name='block';
item.mass=1;
item.momentsofinertia=[1;1;1];
item.productsofinertia=[0;0;0];
item.location=[0;0;1];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item);
item={};

%  Add one bushing
% Linear stiffness of 10 N/m, all translation directions
% Torsional stiffness of 5 Nm/rad, all rotation directions
item.type='flex_point';
item.name='bushing';
item.body1='block';
item.body2='ground';
item.location=[0;0;1.5];
item.stiffness=[10;5];
item.forces=3;
item.moments=3;
the_system.item{end+1}=item;
item={};

%% Add torsional actuator
item.type='actuator';
item.name='actuator 1';
item.body1='block';
item.body2='ground';
item.location1=[0;0;1];
item.location2=[0.1;0;1];
item.twist=1;
the_system.item{end+1}=item;
item={};

%% Add rotary sensor
item.type='sensor';
item.name='sensor one';
item.body1='block';
item.body2='ground';
item.location1=[0;0;1];
item.location2=[0.1;0;1];
item.twist=1;
the_system.item{end+1}=item;


