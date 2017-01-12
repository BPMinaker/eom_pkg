function the_system=input_ex_20(varargin)
the_system.item={};

%% Copyright (C) 2005, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_20.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_20.m is distributed in the hope that it will be useful, but
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
body.location=[0;0;0];
the_system.item{end+1}=body;

body.name='body two';
body.location=[1;0;0];
the_system.item{end+1}=body;

body.name='body three';
body.location=[2;0;0];
the_system.item{end+1}=body;


item.type='beam';
item.name='beam one';
item.body1='body one';
item.body2='body two';
item.location1=[0;0;0];
item.location2=[1;0;0];
item.stiffness=100; %%EI/L
the_system.item{end+1}=item;

item.name='beam two';
item.body1='body two';
item.body2='body three';
item.location1=[1;0;0];
item.location2=[2;0;0];
the_system.item{end+1}=item;

item={};

item.type='rigid_point';
item.name='pin one';
item.body1='body one';
item.body2='ground';
item.location=[0;0;0];
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;


item.name='pin two';
item.body1='body three';
item.body2='ground';
item.location=[2;0;0];
the_system.item{end+1}=item;

item={}

item.type='load';
item.name='preload';
item.body='body two';
item.location=[1;0;0];
item.force=[0;5;0];
item.moment=[0;0;0];
the_system.item{end+1}=item;

item.type='actuator';
item.name='servo one';
item.body1='ground';
item.body2='body two';
item.location1=[1;-0.5;0];
item.location2=[1;0;0];
item.twist=1;
item.gain=1;
the_system.item{end+1}=item;

item.type='sensor';
item.name='sensor one';
the_system.item{end+1}=item;


