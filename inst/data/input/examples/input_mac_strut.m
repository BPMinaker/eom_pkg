function the_system=input_mac_strut(varargin)
the_system.item={};

%% Copyright (C) 2011, Bruce Minaker
%% This file is intended for use with Octave.
%% input_mac_strut.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_mac_strut.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

item.type='body';
item.name='upright';
item.mass=10;
item.momentsofinertia=[2;2;2];
item.productsofinertia=[0;0;0];
item.location=[1.5;0.8;0.3];
the_system.item{end+1}=item;
item={};

item.type='body';
item.name='wheel';
item.mass=10;
item.momentsofinertia=[2;2;2];
item.productsofinertia=[0;0;0];
item.location=[1.5;0.9;0.3];
the_system.item{end+1}=item;
item={};

item.type='body';
item.name='strut';
item.mass=10;
item.momentsofinertia=[2;2;2];
item.productsofinertia=[0;0;0];
item.location=[1.5;0.75;0.6];
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='bearing';
item.body1='wheel';
item.body2= 'upright';
item.location=[1.5;0.9;0.3];
item.forces=3;
item.moments=3;
the_system.item{end+1}=item;
item={};

item.type='flex_point';
item.name='tire';
item.body1='ground';
item.body2='upright';
item.location=[1.5;0.9;0];
item.forces=1;
item.moments=0;
item.stiffness=[150000;0];
item.axis=[0;0;1];
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='slider';
item.body1='upright';
item.body2= 'strut';
item.location=[1.5;0.8;0.4];
item.forces=2;
item.moments=2;
item.axis=[0;-0.1;0.4];
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='tower';
item.body1='strut';
item.body2= 'ground';
item.location=[1.5;0.7;0.8];
item.forces=3;
item.moments=1;
item.axis=[0;-0.1;0.4];
the_system.item{end+1}=item;
item={};

item.type='spring';
item.name='spring';
item.location1=[1.5;0.8;0.4];
item.location2=[1.5;0.7;0.8];
item.body1='upright';
item.body2='strut';
item.stiffness=15000;
item.damping=500;
the_system.item{end+1}=item;
item={};

item.type='link';
item.name='tie rod';
item.location1=[1.25;0.3;0.27];
item.location2=[1.45;0.8;0.3];
item.body1='ground';
item.body2='upright';
the_system.item{end+1}=item;
item={};

item.type='link';
item.name='ra link';
item.location1=[1.3;0.3;0.2];
item.location2=[1.5;0.8;0.15];
item.body1='ground';
item.body2='upright';
the_system.item{end+1}=item;
item={};

item.type='link';
item.name='fa link';
item.location1=[1.7;0.3;0.2];
item.location2=[1.5;0.8;0.15];
item.body1='ground';
item.body2='upright';
the_system.item{end+1}=item;
item={};

item.type='actuator';
item.name='actuator';
item.location1=[1.5;1;0.3];
item.location2=[1.5;1;0];
item.body1='wheel';
item.body2='ground';
item.gain=4000;
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='sensor';
item.location1=[1.5;1.1;0.3];
item.location2=[1.5;1.1;0];
item.body1='wheel';
item.body2='ground';
item.gain=1;
the_system.item{end+1}=item;
item={};




