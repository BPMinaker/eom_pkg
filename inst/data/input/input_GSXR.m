function the_system=input_GSXR(u,varargin)
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



bike;  %% call baseline script


point={};
point.type='rigid_point';
point.name='Fork slider';
point.location=p4;
point.body1='Upper fork';
point.body2='Lower fork';
point.forces=2;
point.moments=3;
point.axis=p4-p6;
the_system.item{end+1}=point;

spring.type='spring';
spring.name='Right front spring';
spring.body1='Upper fork';
spring.body2='Lower fork';
axis=p4-p6;
spring.location1=p6+2.7*axis-[0;0.1;0];
spring.location2=p6+0.2*axis-[0;0.1;0];
spring.stiffness=kf/2;
spring.damping=cf/2;
the_system.item{end+1}=spring;

spring.name='Left front spring';
spring.location1=p6+2.7*axis+[0;0.1;0];
spring.location2=p6+0.2*axis+[0;0.1;0];
the_system.item{end+1}=spring;

