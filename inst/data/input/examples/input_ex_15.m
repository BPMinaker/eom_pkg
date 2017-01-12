function the_system=input_ex_15(v,varargin)
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_14.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_14.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% The monocycle problem


m=4;
r=0.5;
m2=4;
l2=0.5;
theta=pi/4;
I2=1/12*m2*l2^2;

item.type='body';
item.name='wheel';
item.mass=m;
item.momentsofinertia=[0.25*m*r^2;0.5*m*r^2;0.25*m*r^2];
item.productsofinertia=[0;0;0];
item.location=[0;0;r];
item.velocity=[v;0;0];
item.angular_velocity=[0;v/r;0];
the_system.item{end+1}=item;


item.name='rider';
item.mass=m2;
item.momentsofinertia=[(sin(theta))^2;I2;(cos(theta))^2*I2];
item.productsofinertia=[0;0;-cos(theta)*sin(theta)*I2];
item.location=[-r/2;0;r];
item.velocity=[v;0;0];
item.angular_velocity=[0;0;0];
the_system.item{end+1}=item;
item={};

%% Add external force
item.type='load';
item.name='weight';
item.body='wheel';
item.location=[0;0;r];
item.force=[0;0;-m*9.8];
item.moment=[0;0;0];
the_system.item{end+1}=item;

item.name='rider-weight';
item.body='rider';
item.location=[-r/2;0;r];
item.force=[0;0;-m2*9.8];
item.moment=[0;0;0];
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='contact';
item.body1='wheel';
item.body2='ground';
item.location=[0;0;0];
item.forces=2;
item.moments=0;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='hub';
item.body1='wheel';
item.body2='rider';
item.location=[0;0;r];
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='caster';
item.body1='rider';
item.body2='ground';
item.location=[-1.5*r;0;0];
item.forces=1;
item.moments=0;
item.axis=[0;0;1];
the_system.item{end+1}=item;
item={};

item.type='nh_point';
item.name='rolling';
item.body1='wheel';
item.body2='ground';
item.location=[0;0;0];
item.forces=1;
item.moments=0;
item.axis=[0;1;0];
the_system.item{end+1}=item;
item={};

item.type='nh_point';
item.name='constant speed';
item.body1='wheel';
item.body2='ground';
item.location=[0;0;r];
item.forces=1;
item.moments=0;
item.axis=[1;0;0];
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='sensor';
item.body1='wheel';
item.body2='ground';
item.location1=[0;0;r];
item.location2=[0.1;0;r];
item.twist=1;
item.penalty=1;
item.order=2;
item.frame=1;
item.active=1;
the_system.item{end+1}=item;
item={};

item.type='actuator';
item.name='servo';
item.body1='wheel';
item.body2='ground';
item.location1=[0;0;r];
item.location2=[0;0;0];
item.twist=1;
item.gain=1;
item.penalty=1;
the_system.item{end+1}=item;
item={};



