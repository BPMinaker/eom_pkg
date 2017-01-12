function the_system=input_ex_genta_bike(u,varargin)
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_genta_bike.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_genta_bike.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------


%%  Implement Genta's motorcycle, but missing aerodynamic effects

%% Add one rigid body, along the x-axis
body.mass=270;
body.momentsofinertia=[80;110;40];
body.productsofinertia=[0;0;0];
body.location=[0;0;0.496];
body.name='bike';
body.type='body';
body.velocity=[u;0;0];
the_system.item{end+1}=body;

%% Add another identical rigid body, along the x-axis
body.location=[0.56;0;0.432];
body.mass=20;
body.momentsofinertia=[2;2;2];
body.name='fork';
the_system.item{end+1}=body;

%% Add a damping, to connect our body to ground, aligned with y-axis
spring.forces=1;
spring.moments=0;
spring.axis=[0;1;0];
spring.damping=[40000/u;0];
spring.name='front tire';
spring.body1='fork';
spring.body2='ground';
spring.location=[0.641;0;0];
spring.type='flex_point';
the_system.item{end+1}=spring;

spring.name='rear tire';
spring.location=[-0.674;0;0];
spring.damping=[40000/u;0];
spring.body1='bike';
the_system.item{end+1}=spring;

%% Constrain body1 to body2 in rotation
point.type='rigid_point';
point.forces=3;
point.moments=2;
point.axis=[-sin(23*pi/180);0;cos(23*pi/180)];
point.name='head';
point.body1='bike';
point.body2='fork';
point.location=[0.641+.100/cos(23*pi/180)-0.5*tan(23*pi/180) ;0;0.5];
the_system.item{end+1}=point;

point.name='rear road';
point.body1='bike';
point.body2='ground';
point.location=[-0.674;0;0];
point.forces=1;
point.moments=0;
point.axis=[0;0;1];
the_system.item{end+1}=point;

point.name='front road';
point.body1='fork';
point.body2='ground';
point.location=[0.641;0;0];
the_system.item{end+1}=point;

point.name='speed';
point.body1='bike';
point.body2='ground';
point.axis=[1;0;0];
point.location=[0;0;0.496];
the_system.item{end+1}=point;

item.type='load';
item.name='weight';
item.body='bike';
item.force=[0;0;-270*9.8];
item.moment=[0;0;0];
item.location=[0;0;0.496];
the_system.item{end+1}=item;

item.name='front weight';
item.body='fork';
item.force=[0;0;-20*9.8];
item.moment=[0;0;0];
item.location=[0.56;0;0.432];
the_system.item{end+1}=item;



