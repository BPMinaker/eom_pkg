function the_system=input_ex_ellis_benchmark(u,varargin)
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_ellis_benchmark.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_ellis_benchmark.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% Ellis truck trailer, note imperial units (ft,slugs), and total trailer length is 20 ft. (e+h=20)
%% u=30, d=6, e=10, should give s=-1.3, -9.3, -6.3+/-1.1i
%% u=30, d=4, e=15, should give s=-2.2+/-1.2i, -11.2+/-3.9i

a=3.75;
b=5.25;
u=30;
d=4;
e=15;
h=20-e;

body.type='body';
body.name='truck';
body.mass=186;
body.momentsofinertia=[100;100;2980];
body.productsofinertia=[0;0;0];
body.location=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;

body.name='trailer';
body.location=[-d-e;0;0];
body.mass=620;
body.momentsofinertia=[100;100;35000];
the_system.item{end+1}=body;

spring.type='flex_point';
spring.name='front tire';
spring.body1='truck';
spring.body2='ground';
spring.location=[a;0;0];
spring.damping=[23250/u;0];
spring.forces=1;
spring.moments=0;
spring.axis=[0;1;0];
the_system.item{end+1}=spring;

spring.name='rear tire';
spring.location=[-b;0;0];
spring.damping=[68500/u;0];
the_system.item{end+1}=spring;

spring.name='trailer tire';
spring.body1='trailer';
spring.location=[-d-e-h;0;0];
spring.damping=[57500/u;0];
the_system.item{end+1}=spring;

act.name='steer';
act.body1='truck';
act.body2='ground';
act.location1=[a;0;0];
act.location2=[a;0.1;0];
act.type='actuator';
act.gain=23250;
the_system.item{end+1}=act;

item.type='sensor';
item.name='sway sensor';
item.body1='truck';
item.body2='trailer';
item.location1=[-d;0;0];
item.location2=[-d;0;0.1];
item.twist=1;
the_system.item{end+1}=item;

point.type='rigid_point';
point.name='road';
point.body1='truck';
point.body2='ground';
point.location=[0;0;0];
point.forces=1;
point.moments=2;
point.axis=[0;0;1];
the_system.item{end+1}=point;

point.name='hitch';
point.body1='truck';
point.body2='trailer';
point.location=[-d;0;0];
point.forces=3;
point.moments=2;
point.axis=[0;0;1];
the_system.item{end+1}=point;

point.name='speed';
point.body1='truck';
point.body2='ground';
point.location=[0;0;0];
point.forces=1;
point.moments=0;
point.axis=[1;0;0];
the_system.item{end+1}=point;

