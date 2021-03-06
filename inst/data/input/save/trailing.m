function the_system=trailing(the_system,u,g,varargin)
%% Copyright (C) 2017, Bruce Minaker
%% This file is intended for use with Octave.
%% trailing.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% trailing.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

velocity=[u;0;0];
angular_velocity=[0;u/0.3;0];

%%%%% LR Suspension bodys

item.type='body';
item.name='LR Trailing arm';
item.mass=7.25;
item.momentsofinertia=[0.1;0.1;0.1];
item.productsofinertia=[0;0;0];
item.location=[.16;-.56;.175];
item.velocity=velocity;
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.type='body';
item.name='LR Upright';
item.mass=7;
item.momentsofinertia=[0.1;0.1;0.1];
item.productsofinertia=[0;0;0];
item.location=[-0.024;-0.65;0.28];
item.velocity=velocity;
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.name='LR Wheel+hub';
item.mass=16;
item.momentsofinertia=[2;4;2];
item.productsofinertia=[0;0;0];
item.location=[-0.024;-0.74;0.28];
item.velocity=velocity;
item.angular_velocity=angular_velocity;
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.name='LR Anti-roll arm';
item.mass=1;
item.momentsofinertia=[0.05;0.05;0.05];
item.productsofinertia=[0;0;0];                           %%Adding component for rear sway bar here%% 
item.location=[-0.1;-0.37;0.28];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item={};  %% clear item

%%%%% LR Suspension constraints

item.type='rigid_point';
item.name='LR Wheel bearing';
item.body1='LR Wheel+hub';
item.body2='LR Upright';
item.location=[0;-0.66;0.27];
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='LR Trailing arm pivot 1';
item.body1='LR Trailing arm';
item.body2='Chassis';
item.location=[0.44;-0.51;0.235];
item.forces=3;
item.moments=0;
item.axis=[0;0;0];
the_system.item{end+1}=item;

item.name='LR Trailing arm pivot 2';
item.body1='LR Trailing arm';
item.body2='Chassis';
item.location=[0;-0.125;0.238];
item.forces=2;
item.moments=0;
item.axis=[1;0;0];
the_system.item{end+1}=item;


item.name='LR Anti-roll mount';
item.body1='LR Anti-roll arm';
item.body2='Chassis';
item.location=[-0.2;-0.25;0.23];
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;


item.name='LR Lower Hinge Joint 1';
item.body1='LR Upright';
item.body2='LR Trailing arm ';
item.location=[0;-0.64;0.2];
item.forces=3;
item.moments=0;
item.axis=[0;0;0];
the_system.item{end+1}=item;


item.name='LR Lower Hinge Joint 2';
item.body1='LR Upright';
item.body2='LR Trailing arm ';
item.location=[-0.1;-0.63;0.2];
item.forces=2;
item.moments=0;
item.axis=[1;0;0];
the_system.item{end+1}=item;

item={};


item.type='link';
item.name='LR Upper lateral link';
item.body1='Chassis';
item.body2='LR Upright';
item.location1=[0;-0.365;0.395];
item.location2=[0;-0.665;0.395];
the_system.item{end+1}=item;

item.name='LR Drop link';
item.body1='LR Trailing arm';
item.body2='LR Anti-roll arm';
item.location1=[0;-0.5;0.22];
item.location2=[0;-0.52;0.29];
the_system.item{end+1}=item;

item={};

item.type='spring';
item.name='LR Suspension spring';
item.location1=[0.125;-0.535;0.65];
item.location2=[0.12;-0.525;0.285];
item.body1='Chassis';
item.body2='LR Trailing arm';
item.stiffness=43780;
item.damping=1000;
the_system.item{end+1}=item;

item={};

item.type='flex_point';
item.name='LR Tire, vertical';
item.body1='LR Wheel+hub';
item.body2='ground';
item.location=[0;-.74;0];
item.stiffness=[150000,0];
item.damping=[0;0];
item.forces=1;
item.moments=0;
item.axis=[0;0;1];
item.rolling_axis=[0;1;0];
the_system.item{end+1}=item;

item={};


end  %% Leave
