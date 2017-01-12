function the_system=input_ex_a_arm_pushrod(varargin)
the_systen.name='A-Arm Pushrod Suspension';
the_system.item={};

%% Copyright (C) 2011, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_a_arm_pushrod.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_a_arm_pushrod.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------


item.type='body';
item.name='upright';
item.mass=10;
item.momentsofinertia=[2;2;2];
item.productsofinertia=[0;0;0];
item.location=[0.5;0.8;0.3];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item);
item={};

item.type='body';
item.name='wheel';
item.mass=10;
item.momentsofinertia=[2;2;2];
item.productsofinertia=[0;0;0];
item.location=[0.5;0.9;0.3];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item);
item={};

item.type='body';
item.name='lower a-arm';
item.mass=10;
item.momentsofinertia=[2;2;2];
item.productsofinertia=[0;0;0];
item.location=[0.5;0.6;0.15];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item);
item={};

item.type='body';
item.name='bellcrank';
item.mass=1;
item.momentsofinertia=[0.2;0.2;0.2];
item.productsofinertia=[0;0;0];
item.location=[0.45;0.35;0.45];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item);
item={};

item.type='body';
item.name='chassis';
item.mass=250;
item.momentsofinertia=[20;20;20];
item.productsofinertia=[0;0;0];
item.location=[0.5;0;0.3];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item);
item={};



item.type='rigid_point';
item.name='bearing';
item.body1='wheel';
item.body2='upright';
item.location=[0.5;0.9;0.3];
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='lower balljoint';
item.body1='upright';
item.body2= 'lower a-arm';
item.location=[0.5;0.8;0.15];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='rear lower arm joint';
item.body1='lower a-arm';
item.body2='chassis';
item.location=[0.3;0.1;0.15];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='front lower arm joint';
item.body1='lower a-arm';
item.body2='chassis';
item.location=[0.7;0.1;0.1];
item.forces=2;
item.moments=0;
item.axis=[1;0;0;];
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='pivot';
item.body1='bellcrank';
item.body2='chassis';
item.location=[0.4;0.4;0.4];
item.forces=3;
item.moments=2;
item.axis=[0;1;1];
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='slider';
item.body1='chassis';
item.body2='ground';
item.location=[0.5;0;0.5];
item.forces=2;  %% bounce
item.moments=3;
item.axis=[0;0;1];
the_system.item{end+1}=item;
item={};



item.type='spring';
item.name='spring';
item.location1=[0.0;0.3;0.5];
item.location2=[0.45;0.3;0.5];
item.body1='chassis';
item.body2='bellcrank';
item.stiffness=20000;
item.damping=1000;
the_system.item{end+1}=item;
item={};



item.type='link';
item.name='push rod';
item.location1=[0.5;0.4;0.4];
item.location2=[0.5;0.7;0.2];
item.body1='bellcrank';
item.body2='lower a-arm';
the_system.item{end+1}=item;
item={};

item.type='link';
item.name='tie rod';
item.location1=[0.25;0.3;0.26];
item.location2=[0.43;0.8;0.3];
item.body1='chassis';
item.body2='upright';
the_system.item{end+1}=item;
item={};

item.type='link';
item.name='ra link';
item.location1=[0.3;0.3;0.35];
item.location2=[0.5;0.75;0.45];
item.body1='chassis';
item.body2='upright';
the_system.item{end+1}=item;
item={};

item.type='link';
item.name='fa link';
item.location1=[0.7;0.3;0.35];
item.location2=[0.5;0.75;0.45];
item.body1='chassis';
item.body2='upright';
the_system.item{end+1}=item;
item={};



item.type='flex_point';
item.name='tire';
item.body1='wheel';
item.body2='ground';
item.location=[0.5;0.9;0];
item.forces=1;
item.moments=0;
item.stiffness=[150000;0];
item.damping=[150;0];
item.axis=[0;0;1];
item.rolling_axis=[0;1;0];
the_system.item{end+1}=item;
item={};


item.type='actuator';
item.name='wheel actuator';
item.location1=[0.5;0.9;0];
item.location2=[0.5;0.9;-0.3];
item.body1='wheel';
item.body2='ground';
item.gain=150000;
item.rategain=150;
item.travel=0.1;
the_system.item{end+1}=item;

item.name='chassis actuator';
item.location1=[0.5;0;0.3];
item.location2=[0.5;0;0];
item.body1='chassis';
item.body2='ground';
item.gain=1;
item.rategain=0;
item.travel=0.1;
the_system.item{end+1}=item;

item.name='wheel torque';
item.location1=[0.5;0.9;0.3];
item.location2=[0.5;0.8;0.3];
item.body1='wheel';
item.body2='upright';
item.gain=1;
item.rategain=0;
item.travel=0.1;
item.twist=1;
the_system.item{end+1}=item;
item={};


item.type='sensor';
item.name='chassis sensor';
item.location1=[0.5;0;0.3];
item.location2=[0.5;0;0.2];
item.body1='chassis';
item.body2='ground';
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='spring deflection';
item.location1=[0.45;0.3;0.5];
item.location2=[0.0;0.3;0.5];
item.body1='bellcrank';
item.body2='chassis';
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='tire deflection';
item.location1=[0.5;0.9;0.1];
item.location2=[0.5;0.9;0];
item.body1='chassis';
item.body2='ground';
item.actuator='wheel actuator';
the_system.item{end+1}=item;
item={};


