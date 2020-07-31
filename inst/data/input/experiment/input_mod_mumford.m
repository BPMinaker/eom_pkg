function the_system=input_mod_mumford(varargin)
the_system.item={};

%% Copyright (C) 2014, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_full_car.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_mod_mumford.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------


%% Add the f-axle mass, along the z-axis
body.type='body';
body.name='f-axle';
body.mass=10;
body.momentsofinertia=[1/12*10*1.4^2;0;1/12*10*1.4^2];
body.productsofinertia=[0;0;0];
body.location=[1.2;0;0.1];
the_system.item{end+1}=body;

body.name='lf-axle';
body.mass=0;
body.momentsofinertia=[0;0;0];
body.location=[1.2;0.65;0.25];
the_system.item{end+1}=body;

body.name='rf-axle';
body.mass=0;
body.momentsofinertia=[0;0;0];
body.location=[1.2;-0.65;0.25];
the_system.item{end+1}=body;


%% Add the r-axle mass, along the z-axis
body.type='body';
body.name='r-axle';
body.mass=10;
body.momentsofinertia=[1/12*10*1.4^2;0;1/12*10*1.4^2];
body.productsofinertia=[0;0;0];
body.location=[-1.0;0;0.25];
the_system.item{end+1}=body;

body.name='lr-axle';
body.mass=0;
body.momentsofinertia=[0;0;0];
body.location=[-1.0;0.65;0.25];
the_system.item{end+1}=body;

body.name='rr-axle';
body.mass=0;
body.momentsofinertia=[0;0;0];
body.location=[-1.0;-0.65;0.25];
the_system.item{end+1}=body;







body.name='chassis';
body.mass=300;
body.momentsofinertia=[50;120;180];
body.location=[0;0;0.5];
the_system.item{end+1}=body;


body.name='lf-wheel';
body.mass=10;
body.momentsofinertia=[0.5;1.0;0.5];
body.location=[1.2;0.7;0.25];
the_system.item{end+1}=body;

body.name='rf-wheel';
body.mass=10;
body.momentsofinertia=[0.5;1.0;0.5];
body.location=[1.2;-0.7;0.25];
the_system.item{end+1}=body;



body.name='lr-wheel';
body.mass=10;
body.momentsofinertia=[0.5;1.0;0.5];
body.location=[-1.0;0.7;0.25];
the_system.item{end+1}=body;

body.name='rr-wheel';
body.mass=10;
body.momentsofinertia=[0.5;1.0;0.5];
body.location=[-1.0;-0.7;0.25];
the_system.item{end+1}=body;






body.name='left-bellcrank';
body.mass=1;
body.momentsofinertia=[0.1;0.1;0.2];
body.location=[1.1;0.2;0.2];
the_system.item{end+1}=body;

body.name='right-bellcrank';
body.mass=1;
body.momentsofinertia=[0.1;0.1;0.2];
body.location=[1.1;-0.2;0.2];
the_system.item{end+1}=body;

body.name='centre-bellcrank';
body.mass=1;
body.momentsofinertia=[0.1;0.1;0.1];
body.location=[1.0;0;0.1];
the_system.item{end+1}=body;




body.name='left-rear-bellcrank';
body.mass=1;
body.momentsofinertia=[0.1;0.1;0.2];
body.location=[-1.1;0.2;0.2];
the_system.item{end+1}=body;

body.name='right-rear-bellcrank';
body.mass=1;
body.momentsofinertia=[0.1;0.1;0.2];
body.location=[-1.1;-0.2;0.2];
the_system.item{end+1}=body;

body.name='centre-rear-bellcrank';
body.mass=1;
body.momentsofinertia=[0.1;0.1;0.1];
body.location=[-0.9;0;0.1];
the_system.item{end+1}=body;





body.name='left-bellcrank-b';
body.mass=1;
body.momentsofinertia=[0.1;0.1;0.1];
body.location=[0.9;0.5;0.1];
the_system.item{end+1}=body;

body.name='right-bellcrank-b';
body.mass=1;
body.momentsofinertia=[0.1;0.1;0.1];
body.location=[0.9;-0.5;0.1];
the_system.item{end+1}=body;



body.name='left-bellcrank-c';
body.mass=1;
body.momentsofinertia=[0.1;0.1;0.1];
body.location=[0.8;0.5;0.1];
the_system.item{end+1}=body;

body.name='right-bellcrank-c';
body.mass=1;
body.momentsofinertia=[0.1;0.1;0.1];
body.location=[0.8;-0.5;0.1];
the_system.item{end+1}=body;




body.name='left-bellcrank-d';
body.mass=1;
body.momentsofinertia=[0.1;0.1;0.1];
body.location=[-0.9;0.5;0.1];
the_system.item{end+1}=body;

body.name='right-bellcrank-d';
body.mass=1;
body.momentsofinertia=[0.1;0.1;0.1];
body.location=[-0.9;-0.5;0.1];
the_system.item{end+1}=body;



%% Add gravity
load.name='weight';
load.type='load';
load.body='chassis';
load.location=[0;0;0.5];
load.force=[0;0;-9.8*300];
load.moment=[0;0;0];
the_system.item{end+1}=load;

%% Add a spring, with no damping, to connect our f-axle mass to ground, aligned with z-axis
spring.type='flex_point';
spring.name='lf-tire';
spring.body1='lf-wheel';
spring.body2='ground';
spring.stiffness=[100000;0]; %(AE/L)
spring.damping=[0;0];
spring.location=[1.2;0.7;0];
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
spring.rolling_axis=[0;1;0];
the_system.item{end+1}=spring;

spring.name='rf-tire';
spring.body1='rf-wheel';
spring.location=[1.2;-0.7;0];
the_system.item{end+1}=spring;

spring.name='rr-tire';
spring.body1='rr-wheel';
spring.location=[-1.0;-0.7;0];
the_system.item{end+1}=spring;


spring.name='lr-tire';
spring.body1='lr-wheel';
spring.location=[-1.0;0.7;0];
the_system.item{end+1}=spring;





point.type='rigid_point';
point.name='lf-wb';
point.body1='lf-wheel';
point.body2='lf-axle';
point.location=[1.2;0.7;0.25];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.type='rigid_point';
point.name='rf-wb';
point.body1='rf-wheel';
point.body2='rf-axle';
point.location=[1.2;-0.7;0.25];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;


point.type='rigid_point';
point.name='lr-wb';
point.body1='lr-wheel';
point.body2='lr-axle';
point.location=[-1.0;0.7;0.25];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.type='rigid_point';
point.name='rr-wb';
point.body1='rr-wheel';
point.body2='rr-axle';
point.location=[-1.0;-0.7;0.25];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;





point.type='rigid_point';
point.name='lf';
point.body1='f-axle';
point.body2='lf-axle';
point.location=[1.2;0.65;0.25];
point.forces=3;
point.moments=3;
the_system.item{end+1}=point;

point.type='rigid_point';
point.name='rf';
point.body1='f-axle';
point.body2='rf-axle';
point.location=[1.2;-0.65;0.25];
point.forces=3;
point.moments=3;
the_system.item{end+1}=point;





point.type='rigid_point';
point.name='lr';
point.body1='r-axle';
point.body2='lr-axle';
point.location=[-1.0;0.65;0.25];
point.forces=3;
point.moments=3;
the_system.item{end+1}=point;

point.type='rigid_point';
point.name='rr';
point.body1='r-axle';
point.body2='rr-axle';
point.location=[-1.0;-0.65;0.25];
point.forces=3;
point.moments=3;
the_system.item{end+1}=point;





point.type='rigid_point';
point.name='lf-pin';
point.body1='left-bellcrank';
point.body2='chassis';
point.location=[1.1;0.2;0.2];
point.forces=3;
point.moments=2;
point.axis=[1;0;0];
the_system.item{end+1}=point;

point.type='rigid_point';
point.name='rf-pin';
point.body1='right-bellcrank';
point.body2='chassis';
point.location=[1.1;-0.2;0.2];
point.forces=3;
point.moments=2;
point.axis=[1;0;0];
the_system.item{end+1}=point;



point.type='rigid_point';
point.name='lf-pin';
point.body1='left-rear-bellcrank';
point.body2='chassis';
point.location=[-1.1;0.2;0.2];
point.forces=3;
point.moments=2;
point.axis=[1;0;0];
the_system.item{end+1}=point;

point.type='rigid_point';
point.name='rf-pin';
point.body1='right-rear-bellcrank';
point.body2='chassis';
point.location=[-1.1;-0.2;0.2];
point.forces=3;
point.moments=2;
point.axis=[1;0;0];
the_system.item{end+1}=point;




point.type='rigid_point';
point.name='lf-pin-b';
point.body1='left-bellcrank-b';
point.body2='left-bellcrank-c';
point.location=[0.9;0.5;0.1];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.type='rigid_point';
point.name='rf-pin-b';
point.body1='right-bellcrank-b';
point.body2='right-bellcrank-c';
point.location=[0.9;-0.5;0.1];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;




point.type='rigid_point';
point.name='lf-pin-b';
point.body1='left-bellcrank-c';
point.body2='chassis';
point.location=[0.8;0.5;0.1];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.type='rigid_point';
point.name='rf-pin-b';
point.body1='right-bellcrank-c';
point.body2='chassis';
point.location=[0.8;-0.5;0.1];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;






point.type='rigid_point';
point.name='lf-pin-b';
point.body1='left-bellcrank-d';
point.body2='chassis';
point.location=[-0.9;0.5;0.1];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.type='rigid_point';
point.name='rf-pin-b';
point.body1='right-bellcrank-d';
point.body2='chassis';
point.location=[-0.9;-0.5;0.1];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;


point.name='spring hinge';
point.body1='chassis';
point.body2='centre-bellcrank';
point.location=[1.0;0;0.1];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='rear spring hinge';
point.body1='chassis';
point.body2='centre-rear-bellcrank';
point.location=[-1.0;0;0.1];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;



link.type='link';
link.name='lf-link';
link.body1='left-bellcrank';
link.body2='lf-axle';
link.location1=[1.15;0.25;0.1];
link.location2=[1.15;0.6;0.3];
the_system.item{end+1}=link;

link.type='link';
link.name='rf-link';
link.body1='right-bellcrank';
link.body2='rf-axle';
link.location1=[1.15;-0.25;0.1];
link.location2=[1.15;-0.6;0.3];
the_system.item{end+1}=link;


link.type='link';
link.name='lr-link';
link.body1='left-rear-bellcrank';
link.body2='lr-axle';
link.location1=[-1.15;0.25;0.1];
link.location2=[-1.15;0.6;0.3];
the_system.item{end+1}=link;

link.type='link';
link.name='rr-link';
link.body1='right-rear-bellcrank';
link.body2='rr-axle';
link.location1=[-1.15;-0.25;0.1];
link.location2=[-1.15;-0.6;0.3];
the_system.item{end+1}=link;



link.type='link';
link.name='lf-link-b';
link.body1='left-bellcrank-b';
link.body2='lf-axle';
link.location1=[1.2;0.6;0.1];
link.location2=[1.2;0.6;0.2];
the_system.item{end+1}=link;

link.type='link';
link.name='rf-link-b';
link.body1='right-bellcrank-b';
link.body2='rf-axle';
link.location1=[1.2;-0.6;0.1];
link.location2=[1.2;-0.6;0.2];
the_system.item{end+1}=link;




link.type='link';
link.name='lr-link-c';
link.body1='left-bellcrank-d';
link.body2='lr-axle';
link.location1=[-1.0;0.6;0.1];
link.location2=[-1.0;0.6;0.2];
the_system.item{end+1}=link;

link.type='link';
link.name='rr-link-c';
link.body1='right-bellcrank-d';
link.body2='rr-axle';
link.location1=[-1.0;-0.6;0.1];
link.location2=[-1.0;-0.6;0.2];
the_system.item{end+1}=link;





% Front to rear connection

link.type='link';
link.name='lf-link-d';
link.body1='left-bellcrank-c';
link.body2='left-bellcrank-d';
link.location1=[0.8;0.5;0.2];
link.location2=[-0.9;0.5;0.2];
the_system.item{end+1}=link;

link.type='link';
link.name='rf-link-d';
link.body1='right-bellcrank-c';
link.body2='right-bellcrank-d';
link.location1=[0.8;-0.5;0.2];
link.location2=[-0.9;-0.5;0.2];
the_system.item{end+1}=link;





link.type='link';
link.name='lf-link-c';
link.body1='left-bellcrank';
link.body2='centre-bellcrank';
link.location1=[1.1;0.1;0.2];
link.location2=[1.1;0.1;0.1];
the_system.item{end+1}=link;

link.type='link';
link.name='rf-link-c';
link.body1='right-bellcrank';
link.body2='centre-bellcrank';
link.location1=[1.1;-0.1;0.2];
link.location2=[1.1;-0.1;0.1];
the_system.item{end+1}=link;




link.type='link';
link.name='lr-link-c';
link.body1='left-rear-bellcrank';
link.body2='centre-rear-bellcrank';
link.location1=[-1.1;0.1;0.2];
link.location2=[-1.1;0.1;0.1];
the_system.item{end+1}=link;

link.type='link';
link.name='rr-link-c';
link.body1='right-rear-bellcrank';
link.body2='centre-rear-bellcrank';
link.location1=[-1.1;-0.1;0.2];
link.location2=[-1.1;-0.1;0.1];
the_system.item{end+1}=link;





link.type='link';
link.name='right-b';
link.body1='rf-axle';
link.body2='chassis';
link.location1=[1.1;-0.6;0.1];
link.location2=[0.8;-0.6;0.1];
the_system.item{end+1}=link;


link.type='link';
link.name='left-b';
link.body1='lf-axle';
link.body2='chassis';
link.location1=[1.1;0.6;0.1];
link.location2=[0.8;0.6;0.1];
the_system.item{end+1}=link;


link.type='link';
link.name='centre';
link.body1='f-axle';
link.body2='chassis';
link.location1=[1.2;0;0.2];
link.location2=[1.1;0;0.2];
the_system.item{end+1}=link;






link.type='link';
link.name='right rear lower';
link.body1='rr-axle';
link.body2='chassis';
link.location1=[-0.9;-0.6;0.1];
link.location2=[-0.5;-0.3;0.2];
the_system.item{end+1}=link;


link.type='link';
link.name='left rear lower';
link.body1='lr-axle';
link.body2='chassis';
link.location1=[-0.9;0.6;0.1];
link.location2=[-0.5;0.3;0.2];
the_system.item{end+1}=link;


link.type='link';
link.name='rear centre';
link.body1='r-axle';
link.body2='chassis';
link.location1=[-1.2;0;0.2];
link.location2=[-1.1;0;0.2];
the_system.item{end+1}=link;



spring={};
spring.type='spring';
spring.name='front';
spring.body1='left-bellcrank';
spring.body2='right-bellcrank';
spring.location1=[1.1;0.2;0.3];
spring.location2=[1.1;-0.2;0.3];
spring.stiffness=20000;
spring.damping=500;
the_system.item{end+1}=spring;


spring.type='spring';
spring.name='rear';
spring.body1='left-rear-bellcrank';
spring.body2='right-rear-bellcrank';
spring.location1=[-1.0;0.2;0.3];
spring.location2=[-1.0;-0.2;0.3];
spring.stiffness=20000;
spring.damping=500;
the_system.item{end+1}=spring;



spring.type='spring';
spring.name='roll';
spring.body1='left-bellcrank-b';
spring.body2='right-bellcrank-b';
spring.location1=[0.9;0.5;0.1];
spring.location2=[0.9;-0.5;0.1];
spring.stiffness=500;
spring.damping=0;
spring.twist=1;
the_system.item{end+1}=spring;





%% Add external force between f-axle mass and chassis mass
item.type='actuator';
item.name='actuator';
item.body1='f-axle';
item.body2='ground';
item.gain=100000;
item.location1=[1.2;0.7;0.1];
item.location2=[1.2;0.7;0];
the_system.item{end+1}=item;
item={};

%% Add measure between chassis mass and ground
item.type='sensor';
item.name='sensor';
item.body1='chassis';
item.body2='ground';
item.location1=[0;0;0.5];
item.location2=[0;0;0.2];
item.gain=1;
the_system.item{end+1}=item;

