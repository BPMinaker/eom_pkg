function the_system=input_ex_8(varargin)
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_8.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_8.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% Add three rigid bodys, at the corners of a unit square (ground is at the origin)
item.type='body';
item.name='block1';
item.mass=5;
item.location=[0;1;0];
item.momentsofinertia=[2;2;2];
item.productsofinertia=[0;0;0];
the_system.item{end+1}=item;

item.name='block2';
item.location=[1;1;0];
the_system.item{end+1}=item;

item.name='block3';
item.location=[1;0;0];
the_system.item{end+1}=item;
item={};

%% Connect the bodies with springs 
item.type='spring';
item.name='spring 1 ';
item.body1='block1';
item.body2='ground';
item.location1=[0;1;0];
item.location2=[0;0;0];
item.stiffness=10; %(AE/L)
the_system.item{end+1}=item;

item.name='spring 2 ';
item.body1='block1';
item.body2='block2';
item.location1=[0;1;0];
item.location2=[1;1;0];
the_system.item{end+1}=item;

item.name='spring 3 ';
item.body1='block2';
item.body2='block3';
item.location1=[1;1;0];
item.location2=[1;0;0];
the_system.item{end+1}=item;

%% Diagonals are not as stiff
item.name='spring 4 ';
item.body1='block2';
item.body2='ground';
item.location1=[1;1;0];
item.location2=[0;0;0];
item.stiffness=7; %(AE/L)
the_system.item{end+1}=item;

item.name='spring 5 ';
item.body1='block1';
item.body2='block3';
item.location1=[0;1;0];
item.location2=[1;0;0];
the_system.item{end+1}=item;
item={};

%% Constrain all bodys to planar translation in x-y plane, with no rotation
item.type='rigid_point';
item.name='slider 1';
item.body1='block1';
item.body2='ground';
item.location=[0;1;0];
item.forces=1;
item.moments=3;
item.axis=[0;0;1];
the_system.item{end+1}=item;

item.name='slider 2';
item.body1='block2';
item.body2='ground';
item.location=[1;1;0];
the_system.item{end+1}=item;

%% Restrict one body to motion in x axis only
item.name='slider 3';
item.body1='block3';
item.body2='ground';
item.location=[1;0;0];
item.forces=2;
item.moments=3;
item.axis=[1;0;0];
the_system.item{end+1}=item;
item={};

item.type='load';
item.name='load 1';
item.body='block1';
item.force=[10;10;0];
item.moment=[0;0;0];
item.location=[0;1;0];
the_system.item{end+1}=item;

item.name='load 2';
item.body='block2';
item.force=[10;10;0];
item.moment=[0;0;0];
item.location=[1;1;0];
the_system.item{end+1}=item;




