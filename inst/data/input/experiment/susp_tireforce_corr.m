function the_system=susp_tireforce_corr(g,varargin)
the_system.item={};

%% Copyright (C) 2011, Bruce Minaker
%% This file is intended for use with Octave.
%% a_arm_pushrod.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% a_arm_pushrod.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------
item.type='body';
item.name='Chassis';
item.mass=450;
item.momentsofinertia=[1;1;1];
item.productsofinertia=[0;0;0];
item.location=[0.5;0;0.5];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);
item={};

item.type='body';
item.name='Upright';
item.mass=5;
item.momentsofinertia=[0.1;0.1;0.1];
item.productsofinertia=[0;0;0];
item.location=[0.5;0.8;0.3];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);
item={};

item.type='body';
item.name='Wheel+hub';
item.mass=10;
item.momentsofinertia=[2;4;2];
item.productsofinertia=[0;0;0];
item.location=[0.5;0.9;0.3];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);
item={};

item.type='body';
item.name='Lower A-arm';
item.mass=5;
item.momentsofinertia=[1;1;2];
item.productsofinertia=[0;0;0];
item.location=[0.5;0.6;0.15];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);
item={};

item.type='body';
item.name='Upper A-arm';
item.mass=5;
item.momentsofinertia=[1;1;2];
item.productsofinertia=[0;0;0];
item.location=[0.5;0.6;0.42];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);
item={};

% item.type='body';
% item.name='Bell-crank';
% item.mass=1;
% item.momentsofinertia=[0.05;0.05;0.05];
% item.productsofinertia=[0;0;0];
% item.location=[0.45;0.35;0.45];
% the_system.item{end+1}=item;
% the_system.item{end+1}=weight(item,g);
% item={};

% upre=[0.5;0.4;0.4];
% lpre=[0.5;0.7;0.2];
% 
% item=thin_rod([upre lpre],1);
% item.name='Push-rod';
% the_system.item{end+1}=item;
% the_system.item{end+1}=weight(item,g);
% item={};

itre=[0.25;0.3;0.26];
otre=[0.43;0.8;0.3];

item=thin_rod([itre otre],1);
item.name='Tie-rod';
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);
item={};

item.type='rigid_point';
item.name='Wheel bearing';
item.body1='Wheel+hub';
item.body2='Upright';
item.location=[0.5;0.9;0.3];
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='Lower ball joint';
item.body1='Upright';
item.body2= 'Lower A-arm';
item.location=[0.5;0.8;0.15];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='Lower A-arm pivot, rear';
item.body1='Lower A-arm';
item.body2='Chassis';
item.location=[0.3;0.1;0.15];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='Lower A-arm pivot, front';
item.body1='Lower A-arm';
item.body2='Chassis';
item.location=[0.7;0.1;0.15];
item.forces=2;
item.moments=0;
item.axis=[1;0;0;];
the_system.item{end+1}=item;
item={};

% item.type='rigid_point';
% item.name='Bell-crank pivot';
% item.body1='Bell-crank';
% item.body2='Chassis';
% item.location=[0.4;0.4;0.4];
% item.forces=3;
% item.moments=2;
% item.axis=[0;2^-0.5;2^-0.5];
% the_system.item{end+1}=item;
% item={};

item.type='rigid_point';
item.name='Upper A-arm pivot, front';
item.body1='Upper A-arm';
item.body2='Chassis';
item.location=[0.7;0.3;0.40];
item.forces=2;
item.moments=0;
item.axis=[1;0;0];
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='Upper A-arm pivot, rear';
item.body1='Upper A-arm';
item.body2='Chassis';
item.location=[0.3;0.3;0.40];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='Upper ball joint';
item.body1='Upper A-arm';
item.body2='Upright';
item.location=[0.5;0.75;0.45];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;
item={};

% item.type='rigid_point';
% item.name='Lower push-rod end';
% item.body1='Lower A-arm';
% item.body2='Push-rod';
% item.location=lpre;
% item.forces=3;
% item.moments=1;
% item.axis=[upre-lpre]/norm([upre-lpre]);
% the_system.item{end+1}=item;
% item={};

% item.type='rigid_point';
% item.name='Upper push-rod end';
% item.body1='Bell-crank';
% item.body2='Push-rod';
% item.location=upre;
% item.forces=3;
% item.moments=0;
% the_system.item{end+1}=item;
% item={};

item.type='rigid_point';
item.name='Inner tie-rod end';
item.body1='Chassis';
item.body2='Tie-rod';
item.location=itre;
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='Outer tie-rod end';
item.body1='Upright';
item.body2='Tie-rod';
item.location=otre;
item.forces=3;
item.moments=1;
item.axis=[otre-itre]/norm([otre-itre]);
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='Chassis slider';
item.body1='Chassis';
item.body2='ground';
item.location=[0.5;0;0.5];
item.forces=2;
item.moments=3;
item.axis=[0;0;1];
the_system.item{end+1}=item;
item={};

% Only necessary for finding the roll centre
%  item.forces=2;
%  item.moments=0;
%  item.axis=[0;1;0];
%  %the_system.item{end+1}=item;
%  
%  item.forces=0;
%  item.moments=2;
%  item.axis=[1;0;0];
%  %the_system.item{end+1}=item;
%  
%  item={};

% upre=[0.5;0.4;0.4];
% lpre=[0.5;0.7;0.2];

item.type='spring';
item.name='Suspension spring';
item.location1=[0.5;0.6;0.7];
item.location2=[0.5;0.75;0.2];
item.body1='Chassis';
item.body2='Lower A-arm';
item.stiffness=30000;
item.damping=1000;
item.inertia=65.67;
the_system.item{end+1}=item;
item={};

item.type='flex_point';
%item.type='rigid_point';  % only for finding roll centre
item.name='Tire, vertical';
item.body1='Wheel+hub';
item.body2='ground';
item.location=[0.5;0.9;0];
item.forces=1;
item.moments=0;
item.stiffness=[150000;0];
item.axis=[0;0;1];
item.rolling_axis=[0;1;0];
the_system.item{end+1}=item;
item={};

item.type='flex_point';
%item.type='rigid_point';  % only for finding roll centre
item.name='Tire, horizontal';
item.body1='Wheel+hub';
item.body2='ground';
item.location=[0.5;0.9;0];
item.forces=2;
item.moments=0;
item.stiffness=[0;0];
item.damping=[100;0];
item.axis=[0;0;1];
the_system.item{end+1}=item;
item={};

item.type='load';
item.name='Inertia load';
item.body='Wheel+hub';
item.location=[0.5;0.9;0];
item.force=[0;-0.5*9.81*450;0];
item.moment=[0;0;0];
%the_system.item{end+1}=item; % to add lateral loads at the tire
item={};

item.type='actuator';
item.name='wheel actuator';
item.location1=[0.5;0.9;0];
item.location2=[0.5;0.9;-0.1];
item.body1='Wheel+hub';
item.body2='ground';
item.gain=150000;
item.travel=0;
the_system.item{end+1}=item;
item={};

item.type='actuator';
item.name='damper';
item.location1=[0.5;0.6;0.7];
item.location2=[0.5;0.75;0.2];
item.body1='Chassis';
item.body2='Lower A-arm';
item.gain=1;
item.travel=0;
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.order=3;
item.name='body sensor-acc';
item.location1=[0.5;0;0.5];
item.location2=[0.5;0;0];
item.body1='Chassis';
item.body2='ground';
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.order=1;
item.name='tire sensor';
item.location1=[0.5;0.9;0.3];
item.location2=[0.5;0.9;0];
item.body1='Wheel+hub';
item.body2='ground';
item.actuator='wheel actuator';
item.gain=150000;
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.order=1;
item.name='body sensor-displ';
item.location1=[0.5;0;0.5];
item.location2=[0.5;0;0];
item.body1='Chassis';
item.body2='ground';
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.order=1;
item.name='damper sensor-displ';
item.location1=[0.5;0.6;0.7];
item.location2=[0.5;0.75;0.2];
item.body1='Chassis';
item.body2='Lower A-arm';
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.order=2;
item.name='damper sensor-vel';
item.location1=[0.5;0.6;0.7];
item.location2=[0.5;0.75;0.2];
item.body1='Chassis';
item.body2='Lower A-arm';
the_system.item{end+1}=item;
item={};







