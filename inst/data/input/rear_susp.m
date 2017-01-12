function the_system=rear_susp(the_system,u,g,varargin)
%% Copyright (C) 2017, Bruce Minaker
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

velocity=[u;0;0];
angular_velocity=[0;u/0.3;0];

%%%%% LR Suspension bodys

item.type='body';
item.name='LR Upright';
item.mass=5;
item.momentsofinertia=[0.1;0.1;0.1];
item.productsofinertia=[0;0;0];
item.location=[-1.3;0.8;0.3];
item.velocity=velocity;
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LR Lower A-arm';
item.mass=5;
item.momentsofinertia=[1;1;2];
item.productsofinertia=[0;0;0];
item.location=[-1.3;0.6;0.15];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LR Upper A-arm';
item.mass=5;
item.momentsofinertia=[1;1;2];
item.productsofinertia=[0;0;0];
item.location=[-1.3;0.6;0.4];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LR Bell-crank';
item.mass=1;
item.momentsofinertia=[0.05;0.05;0.05];
item.productsofinertia=[0;0;0];
item.location=[-1.25;0.35;0.45];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

rupre=[-1.3;0.4;0.4];  %% upper push-rod end
rlpre=[-1.3;0.7;0.2];  %% lower push-rod end

item=thin_rod([rupre rlpre],1);
item.velocity=velocity;
item.name='LR Push-rod';
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

ritre=[-1.05;0.1;0.1];
rotre=[-1.23;0.8;0.15];

item=thin_rod([ritre rotre],1);
item.name='LR Tie-rod';
item.velocity=velocity;
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LR Wheel+hub';
item.mass=10;
item.momentsofinertia=[2;4;2];
item.productsofinertia=[0;0;0];
item.location=[-1.3;0.9;0.3];
item.velocity=velocity;
item.angular_velocity=angular_velocity;
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item={};  %% clear item

%%%%% LR Suspension constraints

item.type='rigid_point';
item.name='LR Wheel bearing';
item.body1='LR Wheel+hub';
item.body2='LR Upright';
item.location=[-1.3;0.9;0.3];
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='LR Lower ball joint';
item.body1='LR Upright';
item.body2= 'LR Lower A-arm';
item.location=[-1.3;0.8;0.15];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LR Lower A-arm pivot, front';
item.body1='LR Lower A-arm';
item.body2='Chassis';
item.location=[-1.1;0.1;0.1];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LR Lower A-arm pivot, rear';
item.body1='LR Lower A-arm';
item.body2='Chassis';
item.location=[-1.5;0.1;0.1];
item.forces=2;
item.moments=0;
item.axis=[1;0;0;];
the_system.item{end+1}=item;

item.name='LR Bell-crank pivot';
item.body1='LR Bell-crank';
item.body2='Chassis';
item.location=[-1.2;0.4;0.4];
item.forces=3;
item.moments=2;
item.axis=[0;2^-0.5;2^-0.5];
the_system.item{end+1}=item;

item.name='LR Upper A-arm pivot, rear';
item.body1='LR Upper A-arm';
item.body2='Chassis';
item.location=[-1.5;0.3;0.35];
item.forces=2;
item.moments=0;
item.axis=[1;0;0];
the_system.item{end+1}=item;

item.name='LR Upper A-arm pivot, front';
item.body1='LR Upper A-arm';
item.body2='Chassis';
item.location=[-1.1;0.3;0.35];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LR Upper ball joint';
item.body1='LR Upper A-arm';
item.body2='LR Upright';
item.location=[-1.3;0.75;0.45];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LR Lower push-rod end';
item.body1='LR Lower A-arm';
item.body2='LR Push-rod';
item.location=rlpre;
item.forces=3;
item.moments=1;
item.axis=(rupre-rlpre)/norm(rupre-rlpre);
the_system.item{end+1}=item;

item.name='LR Upper push-rod end';
item.body1='LR Bell-crank';
item.body2='LR Push-rod';
item.location=rupre;
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LR Inner tie-rod end';
item.body1='Chassis';
item.body2='LR Tie-rod';
item.location=ritre;
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LR Outer tie-rod end';
item.body1='LR Upright';
item.body2='LR Tie-rod';
item.location=rotre;
item.forces=3;
item.moments=1;
item.axis=(rotre-ritre)/norm(rotre-ritre);
the_system.item{end+1}=item;

item={};

%%%%% Springs

item.type='spring';
item.name='LR Suspension spring';
item.location1=[-1.2;0.3;0.5];
item.location2=[-0.8;0.3;0.5];
item.body1='LR Bell-crank';
item.body2='Chassis';
item.stiffness=20000;
item.damping=2000;
the_system.item{end+1}=item;

item={};

%%%%% Tires (flex_points)

item.type='flex_point';
item.name='LR Tire, vertical';
item.body1='LR Wheel+hub';
item.location=[-1.3;0.9;0];
item.stiffness=[150000,0];
item.damping=[0;0];
item.forces=1;
item.moments=0;
item.axis=[0;0;1];
item.rolling_axis=[0;1;0];
the_system.item{end+1}=item;
item={};


end  %% Leave
