function the_system=tuks_qc(varargin)
the_system.item={};

%% Copyright (C) 2011, Bruce Minaker
%% This file is intended for use with Octave.
%% tuks_qc.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% tuks_qc.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

g=9.81;

item.type='body';
item.name='Chassis';
item.mass=250*0.6*0.5;
item.momentsofinertia=[0;0;0];
item.productsofinertia=[0;0;0];
item.location=[0;0;0.3];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);
item={};

item.type='body';
item.name='Wheel';
item.mass=15;
item.momentsofinertia=[0;0;0];
item.productsofinertia=[0;0;0];
item.location=[0;0.6;0.25];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);
item={};


item.type='body';
item.name='Lower A-arm';
item.mass=0;
item.momentsofinertia=[0;0;0];
item.productsofinertia=[0;0;0];
item.location=[0;0.3;0.08];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);
item={};

item.type='body';
item.name='Upper A-arm';
item.mass=0;
item.momentsofinertia=[0;0;0];
item.productsofinertia=[0;0;0];
item.location=[0;0.3;0.4];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);
item={};

item.type='rigid_point';
item.name='Lower ball joint';
item.body1='Wheel';
item.body2= 'Lower A-arm';
item.location=[0;0.5;0.05];
item.forces=3;
item.moments=2;
item.axis=[1;0;0;];
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='Lower A-arm pivot';
item.body1='Lower A-arm';
item.body2='Chassis';
item.location=[0;0.15;0.1];
item.forces=3;
item.moments=2;
item.axis=[1;0;0;];
the_system.item{end+1}=item;
item={};


item.type='rigid_point';
item.name='Upper A-arm pivot';
item.body1='Upper A-arm';
item.body2='Chassis';
item.location=[0;0.15;0.4];
item.forces=3;
item.moments=2;
item.axis=[1;0;0];
the_system.item{end+1}=item;
item={};



item.type='rigid_point';
item.name='Upper ball joint';
item.body1='Upper A-arm';
item.body2='Wheel';
item.location=[0;0.46;0.4];
item.forces=2;
item.moments=0;
item.axis=[1;0;0];
the_system.item{end+1}=item;
item={};


item.type='rigid_point';
item.name='Chassis slider';
item.body1='Chassis';
item.body2='ground';
item.location=[0;0;0.45];
item.forces=2;
item.moments=3;
item.axis=[0;0;1];
the_system.item{end+1}=item;
item={};


item.type='spring';
item.name='Suspension spring';
item.location1=[0.1;0.15;0.57];
item.location2=[0.1;0.43;0.06];
item.body1='Chassis';
item.body2='Lower A-arm';
item.stiffness=6100;
item.damping=1100;
the_system.item{end+1}=item;
item={};

item.type='flex_point';
item.name='Tire, vertical';
item.body1='Wheel';
item.body2='ground';
item.location=[0;0.6;0];
item.forces=1;
item.moments=0;
item.stiffness=[40000;0];
item.axis=[0;0;1];
the_system.item{end+1}=item;
item={};


item.type='actuator';
item.name='$z_0$';
item.location1=[0;0.6;0];
item.location2=[0;0.6;-0.05];
item.body1='Wheel';
item.body2='ground';
item.gain=40000;
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='$z_1$';
item.location1=[0;0;0.3];
item.location2=[0;0;0.2];
item.body1='Chassis';
item.body2='ground';
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='$(z_1-z_2)$';
item.location1=[0;0.6;0.35];
item.location2=[0;0.6;0.25];
item.body1='Chassis';
item.body2='Wheel';
the_system.item{end+1}=item;
item={};
