function the_system=input_ex_shimmy(abyl,varargin)
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_shimmy.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_shimmy.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------


%%  Implement the wheel shimmy problem from Schwab and Meijaard paper
%%  Schwab,A.L., Meijaard,J.P., Dynamics Of Flexible Multibody Systems With Non-Holonomic Constraints: A Finite Element Approach, Multibody System Dynamics 10: (2003) pp. 107-123


%% Arbitrary mass, length
m=2;
l=3;

%%  Inertia to match paper
I=0.21*m*l*l;

%% Length fractions to vary by input ratio a/l
%%
a=abyl*l;
b=l-a;

v=l;  %% Choose v=l, to make omega = 1
k=0.3*m;  %% Choose k=0.3m to make omega0 = 1


%% Add one rigid body, along the x-axis
item.name='chassis';
item.type='body';
item.mass=m;
item.momentsofinertia=[0;0;I];
item.productsofinertia=[0;0;0];
item.location=[0;0;0];
item.velocity=[v;0;0];
the_system.item{end+1}=item;
item={};

%% Add a spring at the front
item.name='spring';
item.type='flex_point';
item.body1='chassis';
item.body2='ground';
item.location=[b;0;0];
item.forces=1;
item.moments=0;
item.axis=[0;1;0];
item.stiffness=k;
the_system.item{end+1}=item;
item={};

%% Add a no-slip tire at the back
item.type='nh_point';
item.name='tire';
item.body1='chassis';
item.body2='ground';
item.location=[-a;0;0];
item.forces=1;
item.moments=0;
item.axis=[0;1;0];
the_system.item{end+1}=item;
item={};

%% Constrain to planar motion
item.type='rigid_point';
item.name='road';
item.body1='chassis';
item.body2='ground';
item.location=[0;0;0];
item.forces=1;
item.moments=2;
item.axis=[0;0;1];
the_system.item{end+1}=item;

%% Constrain chassis in the forward direction
%% The left/right symmetry of the chassis tells us that the lateral and longitudinal motions are decoupled anyway
item.type='nh_point';
item.name='speed';
item.body1='chassis';
item.body2='ground';
item.location=[0;0;0];
item.forces=1;
item.moments=0;
item.axis=[1;0;0];
the_system.item{end+1}=item;
item={};

%% Add an actuator and sensor in the lateral direction
item.name='$fy$';
item.type='actuator';
item.body1='chassis';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[0;0.1;0];
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='$y$';
item.body1='chassis';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[0;0.1;0];
the_system.item{end+1}=item;
item={};
