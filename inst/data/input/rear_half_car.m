function the_system=rear_half_car(varargin)
the_system.name='Rear A-Arm Half Car';
the_system.item={};

%% Copyright (C) 2011, Bruce Minaker
%% This file is intended for use with Octave.
%% rear_half_car.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% rear_half_car.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------


g=0;

item.type='body';
item.name='Chassis';
item.mass=1400*1.2/2.5;
item.momentsofinertia=[0;0;0];
item.productsofinertia=[0;0;0];
item.location=[-1.3;0;0.5];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item={};

%%%%% R Suspension
the_system=rear_susp(the_system,0,g);

%%%% Constrain chassis
item.type='rigid_point';
item.name='Mount';
item.body1='Chassis';
item.body2='ground';
item.location=[-1.3;0;0];
item.forces=2;
item.moments=0;
item.axis=[0;0;1];
the_system.item{end+1}=item;

item.forces=0;
item.moments=2;
item.axis=[1;0;0];
the_system.item{end+1}=item;

item.name='LR Wheel spin lock';
item.body1='LR Wheel+hub';
item.body2='LR Upright';
item.location=[-1.3;0.9;0.3];
item.forces=0;
item.moments=1;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='LR Wheel bounce lock';
item.body1='LR Wheel+hub';
item.body2='ground';
item.location=[-1.3;0.9;0.0];
item.forces=1;
item.moments=0;
item.axis=[0;0;1];
the_system.item{end+1}=item;

item={};

the_system=mirror(the_system);



%% Add sensors and actuators
item.type='sensor';
item.name='Chassis bounce z';
item.body1='Chassis';
item.body2='ground';
item.location1=[-1.3;0;0.4];
item.location2=[-1.3;0;0.0];
the_system.item{end+1}=item;

item.name='Chassis roll $\\phi$';
item.location1=[-1.3;0;0.0];
item.location2=[-1.4;0;0.0];
item.twist=1;
the_system.item{end+1}=item;


item={};

item.type='actuator';
item.name='Chassis force Z';
item.body1='Chassis';
item.body2='ground';
item.location1=[-1.3;0;0];
item.location2=[-1.3;0;-0.15];
item.gain=1;
item.travel=0.05;
the_system.item{end+1}=item;

item.name='Chassis moment L';
item.location1=[-1.3;0;0];
item.location2=[-1.4;0;0];
item.gain=1;
item.twist=1;
item.travel=0.1;
the_system.item{end+1}=item;


end %% Leave

