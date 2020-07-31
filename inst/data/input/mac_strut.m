function the_system=mac_strut(the_system,u,g,varargin)
%% Copyright (C) 2017, Bruce Minaker
%% This file is intended for use with Octave.
%% mac_strut.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% mac_strut.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%Origin at rear axle center

velocity=[u;0;0];
angular_velocity=[0;u/0.3;0];

item.type='body';
item.name='LF Upright';
item.mass=5;
item.momentsofinertia=[2;2;2];
item.productsofinertia=[0;0;0];
item.location=[2.62;0.71;0.27];
item.velocity=velocity;
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LF Lower A-arm';
item.mass=1.4;
item.momentsofinertia=[1;1;2];
item.productsofinertia=[0;0;0];
item.location=[2.61;0.54;0.175];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LF Strut';
item.mass=10;
item.momentsofinertia=[2;2;2];
item.productsofinertia=[0;0;0];
item.location=[2.615;0.625;0.75];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LF Anti-roll arm';
item.mass=1;
item.momentsofinertia=[0.05;0.05;0.05];
item.productsofinertia=[0;0;0];
item.location=[2.41;0.265;0.2];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LF Wheel+hub';
item.mass=16;
item.momentsofinertia=[2;2;2];
item.productsofinertia=[0;0;0];
item.location=[2.62;0.74;.27];
item.velocity=velocity;
item.angular_velocity=angular_velocity;
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item={};

item.type='rigid_point';
item.name='LF Wheel bearing';
item.body1='LF Wheel+hub';
item.body2='LF Upright';
item.location=[2.62;0.735;0.27];
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='LF Strut Bushing';
item.body1='LF Upright';
item.body2= 'LF Strut';
item.location=[2.62;0.66;0.355];
item.forces=2;
item.moments=2;
item.axis=[0;-0.1;0.5];
the_system.item{end+1}=item;

item.name='LF Strut Bearing';
item.body1='LF Strut';
item.body2= 'Chassis';
item.location=[2.6;0.61;0.81];
item.forces=3;
item.moments=1;
item.axis=[0;-0.1;0.5];
the_system.item{end+1}=item;

item.name='LF Lower ball joint';
item.body1='LF Upright';
item.body2= 'LF Lower A-arm';
item.location=[2.63;0.68;.15];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LF Lower A-arm pivot, rear';
item.body1='LF Lower A-arm';
item.body2='Chassis';
item.location=[2.53;0.345;.195];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LF Lower A-arm pivot, front';
item.body1='LF Lower A-arm';
item.body2='Chassis';
item.location=[2.915;0.43;.175];
item.forces=2;
item.moments=0;
item.axis=[1;0;0;];
the_system.item{end+1}=item;

item.name='LF Anti-roll mount';
item.body1='LF Anti-roll arm';
item.body2='Chassis';
item.location=[2.34;0.275;.165];
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item={};

item.type='link';
item.name='LF Drop link';
item.body1='LF Lower A-arm';
item.body2='LF Anti-roll arm';
item.location1=[2.435;0.495;.195];   %Lower endlink
item.location2=[2.44;0.498;.25];   %Upper endlink
the_system.item{end+1}=item;

item.name='LF Tie Rod';
item.body1='Chassis';
item.body2='LF Upright';
item.location1=[2.50;0.128;.50];  %Inner
item.location2=[2.485;0.56;.555];    %Outer
the_system.item{end+1}=item;

item={};

item.type='spring';
item.name='LF Spring';
item.location1=[2.62;0.66;0.355];
item.location2=[2.6;0.61;0.81];
item.body1='LF Upright';
item.body2='LF Strut';
item.stiffness=26270;
item.damping=2000;
the_system.item{end+1}=item;

item={};

item.type='flex_point';
item.name='LF Tire, vertical';
item.body1='LF Wheel+hub';
item.body2='ground';
item.location=[2.62;0.74;0];
item.forces=1;
item.moments=0;
item.stiffness=[150000;0];
item.axis=[0;0;1];
item.rolling_axis=[0;1;0];
the_system.item{end+1}=item;

