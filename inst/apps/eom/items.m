function default=items()
%% Copyright (C) 2009, Bruce Minaker
%% This file is intended for use with Octave.
%% items.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or {at your option}
%% any later version.
%%
%% items.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

default.body.name='body';
default.body.group='body';
default.body.location=[0;0;0];
default.body.orientation=[0;0;0];
default.body.mass=0;
default.body.momentsofinertia=[0;0;0];
default.body.productsofinertia=[0;0;0]; % xy, yz, zx
default.body.velocity=[0;0;0];
default.body.angular_velocity=[0;0;0];
default.body.x3d='';
default.body.vrml='';

default.spring.name='spring';
default.spring.group='spring';
default.spring.location(:,1)=[0;0;0];
default.spring.location(:,2)=[0;0;0];
default.spring.body{1}='ground';
default.spring.body{2}='ground';
default.spring.stiffness=0;
default.spring.damping=0;
default.spring.preload=[];
default.spring.inertia=0;
default.spring.forces=1;
default.spring.moments=0;
default.spring.twist=0;  %% 0 for deflection, 1 for rotational spring
default.spring.b1=[];
default.spring.b2=[];

default.link.name='link';
default.link.group='link';
default.link.location(:,1)=[0;0;0];
default.link.location(:,2) =[0;0;0];
default.link.body{1}='ground';
default.link.body{2}='ground';
default.link.forces=1;
default.link.moments=0;
default.link.twist=0;  %% 0 for tension, 1 for torsion
default.link.b1=[];
default.link.b2=[];

default.flex_point.name='flex_point';
default.flex_point.group='flex_point';
default.flex_point.location=[0;0;0];
default.flex_point.body{1}='ground';
default.flex_point.body{2}='ground';
default.flex_point.stiffness=[0;0];
default.flex_point.damping=[0;0];
default.flex_point.forces=0;
default.flex_point.moments=0;
default.flex_point.axis=[0;0;0];
default.flex_point.b1=[];
default.flex_point.b2=[];
default.flex_point.rolling_axis=[0;0;0];

default.rigid_point.name='rigid_point';
default.rigid_point.group='rigid_point';
default.rigid_point.location=[0;0;0];
default.rigid_point.body{1}='ground';
default.rigid_point.body{2}='ground';
default.rigid_point.forces=0;
default.rigid_point.moments=0;
default.rigid_point.axis=[0;0;0];
default.rigid_point.b1=[];
default.rigid_point.b2=[];
default.rigid_point.rolling_axis=[0;0;0];

default.nh_point.name='nh_point';
default.nh_point.group='nh_point';
default.nh_point.location=[0;0;0];
default.nh_point.body{1}='ground';
default.nh_point.body{2}='ground';
default.nh_point.forces=0;
default.nh_point.moments=0;
default.nh_point.axis=[0;0;0];
default.nh_point.b1=[];
default.nh_point.b2=[];

default.beam.name='beam';
default.beam.group='beam';
default.beam.location(:,1)=[0;0;0];
default.beam.location(:,2)=[0;0;0];
default.beam.body{1}='ground';
default.beam.body{2}='ground';
default.beam.stiffness=0;
default.beam.forces=2;
default.beam.moments=2;

default.load.name='load';
default.load.group='load';
default.load.location=[0;0;0];
default.load.body{1}='ground';
default.load.force=[0;0;0];
default.load.moment=[0;0;0];
default.load.frame='ground';

default.actuator.type='actuator';
default.actuator.name='actuator';
default.actuator.group='actuator';
default.actuator.location(:,1)=[0;0;0];
default.actuator.location(:,2)=[0;0;0];
default.actuator.body{1}='ground';
default.actuator.body{2}='ground';
default.actuator.twist=0;  %% 0 for deflection, 1 for rotational actuator
default.actuator.gain=1;
default.actuator.rategain=0;
default.actuator.travel=[];
default.actuator.forces=0;
default.actuator.moments=0;

default.sensor.name='sensor';
default.sensor.group='sensor';
default.sensor.location(:,1)=[0;0;0];
default.sensor.location(:,2)=[0;0;0];
default.sensor.body{1}='ground';
default.sensor.body{2}='ground';
default.sensor.twist=0;  %% 0 for deflection, 1 for rotational sensor
default.sensor.gain=1;
default.sensor.order=1;  %% [1 - position, 2- velocity, 3- acceleration ]
default.sensor.frame=1;  %% [ 0 - local, 1 - global]
default.sensor.actuator{1}='ground';

default.triangle_3.name='triangle_3';
default.triangle_3.group='triangle_3';
default.triangle_3.body{1}='ground';
default.triangle_3.body{2}='ground';
default.triangle_3.body{3}='ground';
default.triangle_3.location(:,1)=[0;0;0];
default.triangle_3.location(:,2)=[0;0;0];
default.triangle_3.location(:,3)=[0;0;0];
default.triangle_3.thickness=1;
default.triangle_3.modulus=0;
default.triangle_3.psn_ratio=0.5;

default.triangle_5.name='triangle_5';
default.triangle_5.group='triangle_5';
default.triangle_5.body{1}='ground';
default.triangle_5.body{2}='ground';
default.triangle_5.body{3}='ground';
default.triangle_5.location(:,1)=[0;0;0];
default.triangle_5.location(:,2)=[0;0;0];
default.triangle_5.location(:,3)=[0;0;0];
default.triangle_5.thickness=1;
default.triangle_5.modulus=0;
default.triangle_5.psn_ratio=0.5;

%%% These are items that are implemented in the current version of EoM, but are likely to have bugs

default.wing.name='wing';
default.wing.group='wing';
default.wing.location=[0;0;0];
default.wing.body{1}='ground';
default.wing.body{2}='ground';
default.wing.span=0;
default.wing.chord=0;
default.wing.area=0;
default.wing.airspeed=0;
default.wing.density=1.23;
default.wing.forces=3;
default.wing.moments=3;

default.wing.cxu=0;
default.wing.cxw=0;
default.wing.cxq=0;
default.wing.cyv=0;
default.wing.cyp=0;
default.wing.cyr=0;
default.wing.czu=0;
default.wing.czw=0;
default.wing.czq=0;
default.wing.clv=0;
default.wing.clp=0;
default.wing.clr=0;
default.wing.cmu=0;
default.wing.cmw=0;
default.wing.cmq=0;
default.wing.cnv=0;
default.wing.cnp=0;
default.wing.cnr=0;

% apparent mass, inertia
default.wing.a_mass=[0;0;0];
default.wing.a_mass_products=[0;0;0];
default.wing.a_momentsofinertia=[0;0;0];
default.wing.a_productsofinertia=[0;0;0]; % xy, yz, zx

default.surf.name='surf';
default.surf.group='surf';
default.surf.body{1}='ground';
default.surf.location=[0;0;0];
default.surf.span=0;
default.surf.chord=0;
default.surf.area=0;
default.surf.airspeed=0;
default.surf.density=1.23;
default.surf.cx=0;
default.surf.cy=0;
default.surf.cz=0;
default.surf.cl=0;
default.surf.cm=0;
default.surf.cn=0;


%  default.tire.name='tire';
%  default.tire.group='tire';
%  default.tire.location=[0;0;0];
%  default.tire.body{1}='ground';
%  default.tire.body{2}='ground';
%  default.tire.stiffness=0;
%  default.tire.forces=3;
%  default.tire.moments=0;

end  %% Leave


%% Old code


%  default.marker.name='marker';
%  default.marker.group='marker';
%  default.marker.location=[0;0;0];
%  default.marker.body{1}='ground';
%  default.marker.body{2}='ground';
%  default.marker.forces=0;
%  default.marker.moments=0;
%  default.marker.axis=[0;0;0];
%  default.marker.b1=[];
%  default.marker.b2=[];

%  default.actuator.pltgain=1;
%  default.actuator.pltylabel='value []';
%  default.actuator.label='';
%  default.actuator.penalty=1;

%  default.sensor.active=1; % 1 = active, 0 = passive
%  default.sensor.measured = 1; % 1=measured, 0= observed
%  default.sensor.feedback = 0; % 1=control feedback state, 0 = not control feedback state
%  default.sensor.pltgain=1;
%  default.sensor.pltylabel='value []';
%  default.sensor.label='';
%  default.sensor.threshold=0;
%  default.sensor.penalty=1;


