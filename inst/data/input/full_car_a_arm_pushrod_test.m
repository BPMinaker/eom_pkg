function the_system=full_car_a_arm_pushrod_test(u,varargin)
the_system.name='Full Car A-Arm Pushrod';
the_system.item={};

%% Copyright (C) 2011, Bruce Minaker
%% This file is intended for use with Octave.
%% full_car_a_arm_pushrod.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% full_car_a_arm_pushrod.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------



if(u==0) 
	error('Non zero speed needed for tire model.');
end

g=9.81;

velocity=[u;0;0];

item.type='body';
item.name='Chassis';
item.mass=1400;
item.momentsofinertia=[800;2000;2200];
item.productsofinertia=[0;0;0];
item.location=[0;0;0.5];
item.velocity=velocity;
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item={};

the_system=front_susp(the_system,0,g);
the_system=rear_susp(the_system,0,g);

item.type='spring';
item.name='Anti-roll bar';
item.body1='LF Anti-roll arm';
item.body2='RF Anti-roll arm';
item.location1=[1.3;0.3;0.35];
item.location2=[1.3;-0.3;0.35];
item.stiffness=100;
item.damping=0;
item.twist=1;
the_system.item{end+1}=item;

item={};

item.type='rigid_point';
item.name='Hinge';
item.body1='Chassis';
item.body2='ground';
item.location=[0.0;0.0;0.0];
item.forces=3;
item.moments=1;
item.axis=[0;0;1];
the_system.item{end+1}=item;


item={};


item.type='body';
item.name='LF Contact patch';
item.mass=0;
item.momentsofinertia=[0;0;0];
item.productsofinertia=[0;0;0];
item.location=[1.2;0.9;0.0];
item.velocity=[0;0;0];
item.angular_velocity=[0;0;0];;
the_system.item{end+1}=item;

% item.name='LR Contact patch';
% item.location=[-1.3;0.9;0.0];
% the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='LF Contact patch constraint';
item.body1='LF Contact patch';
item.body2='LF Wheel+hub';
item.location=[1.2;0.9;0.0];
item.forces=2;
item.moments=3;
item.axis=[0;1;0];
the_system.item{end+1}=item;

% item.name='LR Contact patch constraint';
% item.body1='LR Contact patch';
% item.body2='LR Wheel+hub';
% item.location=[-1.3;0.9;0.0];
% the_system.item{end+1}=item;
item={};

item.type='flex_point';
item.name='LF Tire, sidewall';
item.body1='LF Wheel+hub';
item.body2='LF Contact patch';
item.location=[1.2;0.9;0];
item.stiffness=[135000,0];
item.damping=[0;0];
item.forces=1;
item.moments=0;
item.axis=[0;1;0];
the_system.item{end+1}=item;

% item.name='LR Tire, sidewall';
% item.body1='LR Wheel+hub';
% item.body2='LR Contact patch';
% item.location=[-1.3;0.9;0];
% the_system.item{end+1}=item;

item.name='LF Tire, horizontal';
item.body1='LF Contact patch';
item.body2='ground';
item.location=[1.2;0.9;0];
item.stiffness=[0;0];
item.damping=[40000/u;0];
item.forces=2;
item.moments=0;
item.axis=[0;0;1];
the_system.item{end+1}=item;

% item.name='LR Tire, horizontal';
% item.body1='LR Contact patch';
% item.location=[-1.3;0.9;0];
% the_system.item{end+1}=item;
item={};


%%%%% Reflect all LF or LR items in y axis
the_system=mirror(the_system);


%% Add sensors and actuators
item.type='sensor';
item.name='F Chassis bounce';
item.body1='Chassis';
item.body2='ground';
item.location1=[1.2;0.9;0.4];
item.location2=[1.2;0.9;0.0];
item.twist=0;
item.order=1;
the_system.item{end+1}=item;

item.name='F Susp travel';
item.body1='Chassis';
item.body2='LF Wheel+hub';
item.location1=[1.2;0.9;0.4];
item.location2=[1.2;0.9;0.3];
the_system.item{end+1}=item;

item.name='F Tire squish';
item.body1='LF Wheel+hub';
item.body2='ground';
item.location1=[1.2;0.9;0.3];
item.location2=[1.2;0.9;0.0];
item.actuator='LF Wheel bump';
the_system.item{end+1}=item;

item={};

item.type='actuator';
item.name='LF Wheel bump';
item.body1='LF Wheel+hub';
item.body2='ground';
item.location1=[1.2;0.9;0.0];
item.location2=[1.2;0.9;-0.25];
item.gain=150000;
item.twist=0;
the_system.item{end+1}=item;


end %% Leave

