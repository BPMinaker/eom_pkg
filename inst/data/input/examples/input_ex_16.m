function the_system=input_ex_16(varargin)
the_system.item={};

%% Copyright (C) 2013, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_16.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_16.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

params.m=0.75;
params.r=0.3;
params.l=0.5;
params.i1=0.6;
params.i2=0.15;
g=9.8;

item.type='body';
item.name='whl right';
item.mass=params.m;
item.momentsofinertia=[params.i2;params.i2;params.i2];
item.productsofinertia=[0;0;0];
item.location=[params.l;params.r;0];
item.velocity=[0;0;0];
item.angular_velocity=[0;0;0];
the_system.item{end+1}=item;
item={};


item.type='body';
item.name='whl left';
item.mass=params.m;
item.momentsofinertia=[params.i2;params.i2;params.i2];
item.productsofinertia=[0;0;0];
item.location=[-params.l;params.r;0];
item.velocity=[0;0;0];
item.angular_velocity=[0;0;0];
the_system.item{end+1}=item;
item={};


item.type='body';
item.name='platform';
item.mass=params.m;
item.momentsofinertia=[params.i1;params.i1;params.i1];
item.productsofinertia=[0;0;0];
item.location=[0;0;0];
item.velocity=[0;0;0];
item.angular_velocity=[0;0;0];
the_system.item{end+1}=item;
item={};


%% Add external force
item.type='load';
item.name='weight';
item.body='whl right';
item.location=[params.l;params.r;0];
item.force=[0;-g*params.m;0];
item.moment=[0;0;0];
the_system.item{end+1}=item;
item={};


%% Add external force
item.type='load';
item.name='weight';
item.body='whl left';
item.location=[-params.l;params.r;0];
item.force=[0;-g*params.m;0];
item.moment=[0;0;0];
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='pin';
item.body1='platform';
item.body2='ground';
item.location=[0;0;0];
item.forces=3;
item.moments=2;
item.axis=[0;0;1];
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='roll contact';
item.body1='whl right';
item.body2='platform';
item.location=[params.l;0;0];
item.forces=2;
item.moments=0;
item.axis=[0;0;1];
item.rolling_axis=[0;0;1];
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='planar contact';
item.body1='whl right';
item.body2='ground';
item.location=[params.l;params.r;0];
item.forces=1;
item.moments=2;
item.axis=[0;0;1];
the_system.item{end+1}=item;
item={};


item.type='rigid_point';
item.name='contact fixed';
item.body1='whl left';
item.body2='platform';
item.location=[-params.l;0;0];;
item.forces=3;
item.moments=3;
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='sensor';
item.body1='platform';
item.body2='whl right';
item.location1=[0;params.r;0];
item.location2=[params.l;params.r;0];
the_system.item{end+1}=item;
item={};

item.type='actuator';
item.name='actuator';
item.body1='platform';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[0;0;-1];
item.twist=1;
the_system.item{end+1}=item;
item={};
