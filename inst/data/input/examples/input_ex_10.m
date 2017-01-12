function the_system=input_ex_10(varargin)
the_system.item={};

%% Copyright (C) 2005, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_10.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_10.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

body.type='body';
body.name='body one';
body.mass=5;
body.momentsofinertia=[2;2;2];
body.productsofinertia=[0;0;0];
body.location=[0;0;1.2];
the_system.item{end+1}=body;

item.type='beam';
item.name='beam one';
item.body1='body one';
item.body2='ground';
item.location1=[0;0;1.2];
item.location2=[0;0;0];
item.stiffness=100; %%EI/L
the_system.item{end+1}=item;

item={};

%  item.type='rigid_point';
%  item.name='pin one';
%  item.body1='body one';
%  item.body2='ground';
%  item.location=[0;0;1.2];
%  item.forces=0;
%  item.moments=2;
%  item.axis=[0;1;0];
%  the_system.item{end+1}=item;

item.type='rigid_point';
item.name='pin one';
item.body1='body one';
item.body2='ground';
item.location=[0;0;1.2];
item.forces=1;
item.moments=1;
item.axis=[0;0;1];
the_system.item{end+1}=item;

item={};

item.type='load';
item.name='preload';
item.body='body one';
item.location=[0;0;1.2];
item.force=[5;6;7];
item.moment=[9;10;0];
the_system.item{end+1}=item;

item={};

item.type='actuator';
item.name='servo one';
item.body1='body one';
item.body2='ground';
item.location1=[0;0;1.2];
item.location2=[-0.1;0;1.2];
the_system.item{end+1}=item;

item.type='sensor';
item.name='sensor one';
the_system.item{end+1}=item;


