function the_system=input_pendulum_cart(varargin)
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_1.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_1.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------


g=9.81;

%% Add the bodys
item.type='body';
item.name='one';
item.mass=1;
item.momentsofinertia=[0;0;0];
item.productsofinertia=[0;0;0];
item.location=[0;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);
item={};

item.type='body';
item.name='two';
item.mass=2;
item.momentsofinertia=[1/12*2*1^2;1/12*2*1^2;0];
item.productsofinertia=[0;0;0];
item.location=[0;0;-0.5];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);
item={};

item.type='body';
item.name='three';
item.mass=1;
item.momentsofinertia=[1/12*1*0.5^2;1/12*1*0.5^2;0];
item.productsofinertia=[0;0;0];
item.location=[0;0;-1.25];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);
item={};

item.type='rigid_point';
item.name='cart';
item.body1='one';
item.body2='ground';
item.location=[0;0;0];
item.forces=2;
item.moments=3;
item.axis=[0;1;0];
the_system.item{end+1}=item;
item={};


item.type='rigid_point';
item.name='hinge one';
item.body1='one';
item.body2='two';
item.location=[0;0;0];
item.forces=3;
item.moments=2;
item.axis=[1;0;0];
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='hinge two';
item.body1='two';
item.body2='three';
item.location=[0;0;-1];
item.forces=3;
item.moments=2;
item.axis=[1;0;0];
the_system.item{end+1}=item;
item={};

item.type='flex_point';
item.name='bushing';
item.body1='one';
item.body2='ground';
item.location=[0;0;0];
item.stiffness=[10;0];
item.damping=[1;0];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;
item={};

%% The actuator is a 'line item' and defined by two locations, location1 attaches to body1, location2 to body2
item.type='actuator';
item.name='actuator';
item.body1='one';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[0;-1;0];
the_system.item{end+1}=item;
item={};

%% The actuator is a 'line item' and defined by two locations, location1 attaches to body1, location2 to body2
item.type='sensor';
item.name='sensor one';
item.body1='one';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[0;-1;0];
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='sensor two';
item.body1='two';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[-1;0;0];
item.twist=1;
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='sensor three';
item.body1='three';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[-1;0;0];
item.twist=1;
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='sensor d one';
item.body1='one';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[0;-1;0];
item.order=2;
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='sensor d two';
item.body1='two';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[-1;0;0];
item.twist=1;
item.order=2;
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='sensor d three';
item.body1='three';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[-1;0;0];
item.twist=1;
item.order=2;
the_system.item{end+1}=item;






