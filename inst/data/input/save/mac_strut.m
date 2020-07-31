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

velocity=[u;0;0];
angular_velocity=[0;u/0.3;0];

item.type='body';
item.name='LF Upright';
item.mass=5;
item.momentsofinertia=[2;2;2];
item.productsofinertia=[0;0;0];
item.location=[2.62;-.71;0.295];
item.velocity=velocity;
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LF Lower A-arm';
item.mass=1.4;
item.momentsofinertia=[1;1;2];
item.productsofinertia=[0;0;0];
item.location=[2.62;-.51;0.17];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LF Strut';
item.mass=10;
item.momentsofinertia=[2;2;2];
item.productsofinertia=[0;0;0];
item.location=[2.62;-0.585;0.52];
%[2.62;-0.625;0.44];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LF Anti-roll arm';
item.mass=1;
item.momentsofinertia=[0.05;0.05;0.05];
item.productsofinertia=[0;0;0];
item.location=[2.47;-0.375;0.18];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LF Wheel+hub';
item.mass=16;
item.momentsofinertia=[2;2;2];
item.productsofinertia=[0;0;0];
item.location=[2.62;-.74;.28];
item.velocity=velocity;
item.angular_velocity=angular_velocity;
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item={};

item.type='rigid_point';
item.name='LF Wheel bearing';
item.body1='LF Wheel+hub';
item.body2='LF Upright';
item.location=[2.62;-.735;0.27];
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='LF Strut Bushing';
item.body1='LF Upright';
item.body2= 'LF Strut';
item.location=[2.62;-0.585;0.52];
item.forces=2;
item.moments=2;
item.axis=[0;-0.1;0.4];
the_system.item{end+1}=item;

item.name='LF Strut Bearing';
item.body1='LF Strut';
item.body2= 'Chassis';
item.location=[2.62;-0.65;0.8];
%[2.62;-.66;.35]; %???
item.forces=3;
item.moments=1;
item.axis=[0;-0.1;0.4];
the_system.item{end+1}=item;

item.name='LF Lower ball joint';
item.body1='LF Upright';
item.body2= 'LF Lower A-arm';
item.location=[2.62;-.7;.135];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LF Lower A-arm pivot, rear';
item.body1='LF Lower A-arm';
item.body2='Chassis';
item.location=[2.47;-.367;.15];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LF Lower A-arm pivot, front';
item.body1='LF Lower A-arm';
item.body2='Chassis';
item.location=[2.895;-.43;.165];
item.forces=2;
item.moments=0;
item.axis=[1;0;0;];
the_system.item{end+1}=item;

item.name='LF Anti-roll mount';
item.body1='LF Anti-roll arm';
item.body2='Chassis';
item.location=[2.33;-.28;.155];
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item={};

item.type='link';
item.name='LF Drop link';
item.body1='LF Lower A-arm';
item.body2='LF Anti-roll arm';
item.location1=[2.535;-.50;.18];   %Lower endlink
item.location2=[2.535;-.51;.23];   %Upper endlink
the_system.item{end+1}=item;

item.name='LF Tie Rod';
item.location1=[2.475;-.26;.57];
item.location2=[2.475;-.56;.57];
item.body1='Chassis';
item.body2='LF Upright';
the_system.item{end+1}=item;

item={};

item.type='spring';
item.name='LF Spring';
item.location1=[2.62;-0.585;0.52];
item.location2=[2.62;-0.65;0.8];
%[2.62;-0.6;.61]
item.body1='LF Upright';
item.body2='LF Strut';
item.stiffness=26270;
item.damping=1000;
the_system.item{end+1}=item;

item={};

item.type='flex_point';
item.name='LF Tire, vertical';
item.body1='LF Wheel+hub';
item.body2='ground';
item.location=[2.62;-.74;0];
item.forces=1;
item.moments=0;
item.stiffness=[150000;0];
item.axis=[0;0;1];
item.rolling_axis=[0;1;0];
the_system.item{end+1}=item;



