function the_system=wheel_table(g,varargin)
the_system.item={};

%% Copyright (C) 2011, Bruce Minaker
%% This file is intended for use with Octave.
%% wheel_table.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% wheel_table.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------


% r=0.25m
item.type='body';
item.name='Wheel';
item.mass=1;
item.momentsofinertia=[(1/4)*1*0.25^2;(1/2)*1*0.25^2;(1/4)*1*0.25^2];
item.productsofinertia=[0;0;0];
item.location=[0;0;0.25];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);
item={};


% 1 x 1 m
item.type='body';
item.name='Table';
item.mass=1;
item.momentsofinertia=[1/12*1*(1^2);1/12*1*(1^2);1/12*1*(2*1^2)];
item.productsofinertia=[0;0;0];
item.location=[0;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);
item={};


item.type='rigid_point';
item.name='Tire';
item.body1='Wheel';
item.body2='Table';
item.location=[0;0;0];
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
item.rolling_axis=[0;1;0];
the_system.item{end+1}=item;
item={};

%  item.type='flex_point';
%  item.name='Table joint';
%  item.body1='Table';
%  item.body2='ground';
%  item.location=[0;0;0];
%  item.forces=0;
%  item.moments=1;
%  item.stiffness=[0;5.0];
%  item.damping=[0;0.5];
%  item.axis=[0;1;0];
%  the_system.item{end+1}=item;
%  item={};


item.type='rigid_point';
item.name='Table joint';
item.body1='Table';
item.body2='ground';
item.location=[0;0;0];
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;
item={};


item.type='actuator';
item.name='Table actuator';
item.location1=[0;0;0];
item.location2=[0;1;0];
item.body1='Table';
item.body2='ground';
item.twist=1;
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='Wheel sensor';
item.location1=[0;0;0];
item.location2=[0;1;0];
item.body1='Wheel';
item.body2='ground';
item.twist=1;
the_system.item{end+1}=item;
item={};

