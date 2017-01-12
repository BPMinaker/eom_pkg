function the_system=input_fsae3(varargin)
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


g=9.81;

%% Add the f-axle mass, along the z-axis
body.type='body';
body.name='f-axle';
body.mass=10;
body.momentsofinertia=[1/12*10*1.4^2;0;1/12*10*1.4^2];
body.productsofinertia=[0;0;0];
body.location=[0.762;0;0.1];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='lf-axle';
body.mass=0;
body.momentsofinertia=[0;0;0];
body.location=[0.762;0.55;0.2286];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='rf-axle';
body.mass=0;
body.momentsofinertia=[0;0;0];
body.location=[0.762;-0.55;0.2286];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


%% Add the r-axle mass, along the z-axis
body.type='body';
body.name='r-axle';
body.mass=10;
body.momentsofinertia=[1/12*10*1.4^2;0;1/12*10*1.4^2];
body.productsofinertia=[0;0;0];
body.location=[-0.762;0;0.2286];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='lr-axle';
body.mass=0;
body.momentsofinertia=[0;0;0];
body.location=[-0.762;0.55;0.2286];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='rr-axle';
body.mass=0;
body.momentsofinertia=[0;0;0];
body.location=[-0.762;-0.55;0.2286];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);




body.name='chassis';
body.mass=300;
body.momentsofinertia=[50;120;180];
body.location=[0;0;0.3];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


body.name='lf-wheel';
body.mass=10;
body.momentsofinertia=[0.5;1.0;0.5];
body.location=[0.762;0.6;0.2286];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='rf-wheel';
body.mass=10;
body.momentsofinertia=[0.5;1.0;0.5];
body.location=[0.762;-0.6;0.2286];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


body.name='lr-wheel';
body.mass=10;
body.momentsofinertia=[0.5;1.0;0.5];
body.location=[-0.762;0.6;0.2286];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='rr-wheel';
body.mass=10;
body.momentsofinertia=[0.5;1.0;0.5];
body.location=[-0.762;-0.6;0.2286];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%  body.name='left-bellcrank';
%  body.mass=1;
%  body.momentsofinertia=[0;0;0];
%  body.location=[0.662;0.2;0.2];
%  the_system.item{end+1}=body;
%  the_system.item{end+1}=weight(body,g);
%  
%  body.name='right-bellcrank';
%  body.mass=1;
%  body.momentsofinertia=[0;0;0];
%  body.location=[0.662;-0.2;0.2];
%  the_system.item{end+1}=body;
%  the_system.item{end+1}=weight(body,g);
%  
%  body.name='centre-bellcrank';
%  body.mass=1;
%  body.momentsofinertia=[0;0;0];
%  body.location=[0.562;0;0.1];
%  the_system.item{end+1}=body;
%  the_system.item{end+1}=weight(body,g);
%  
%  body.name='t-bar-v-bellcrank';
%  body.mass=1;
%  body.momentsofinertia=[0.01;0.01;0.01];
%  body.location=[0.462;0;0.2];
%  the_system.item{end+1}=body;
%  the_system.item{end+1}=weight(body,g);
%  
%  body.name='t-bar-h-bellcrank';
%  body.mass=1;
%  body.momentsofinertia=[0.01;0.01;0.01];
%  body.location=[0.462;0;0.3];
%  the_system.item{end+1}=body;
%  the_system.item{end+1}=weight(body,g);
%  
%  
%  body.name='left-rear-bellcrank';
%  body.mass=1;
%  body.momentsofinertia=[0;0;0];
%  body.location=[-0.662;0.2;0.2];
%  the_system.item{end+1}=body;
%  the_system.item{end+1}=weight(body,g);
%  
%  body.name='right-rear-bellcrank';
%  body.mass=1;
%  body.momentsofinertia=[0;0;0];
%  body.location=[-0.662;-0.2;0.2];
%  the_system.item{end+1}=body;
%  the_system.item{end+1}=weight(body,g);
%  
%  body.name='centre-rear-bellcrank';
%  body.mass=1;
%  body.momentsofinertia=[0;0;0];
%  body.location=[-0.562;0;0.1];
%  the_system.item{end+1}=body;
%  the_system.item{end+1}=weight(body,g);




%% Add a spring, with no damping, to connect our f-axle mass to ground, aligned with z-axis
spring.type='flex_point';
spring.name='lf-tire';
spring.body1='lf-wheel';
spring.body2='ground';
spring.stiffness=[100000;0]; %(AE/L)
spring.damping=[0;0];
spring.location=[0.762;0.6;0];
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
spring.rolling_axis=[0;1;0];
the_system.item{end+1}=spring;

spring.name='rf-tire';
spring.body1='rf-wheel';
spring.location=[0.762;-0.6;0];
the_system.item{end+1}=spring;

spring.name='rr-tire';
spring.body1='rr-wheel';
spring.location=[-0.762;-0.6;0];
the_system.item{end+1}=spring;


spring.name='lr-tire';
spring.body1='lr-wheel';
spring.location=[-0.762;0.6;0];
the_system.item{end+1}=spring;





point.type='rigid_point';
point.name='lf-tire';
point.body1='lf-wheel';
point.body2='ground';
point.location=[0.762;0.6;0];
point.forces=2;
point.moments=0;
point.axis=[0;0;1];
the_system.item{end+1}=point;

point.name='rf-tire';
point.body1='rf-wheel';
point.location=[0.762;-0.6;0];
point.forces=1;
point.moments=0;
point.axis=[1;0;0];
the_system.item{end+1}=point;

point.name='rr-tire';
point.body1='rr-wheel';
point.location=[-0.762;-0.6;0];
point.forces=2;
point.moments=0;
point.axis=[0;0;1];
the_system.item{end+1}=point;


point.name='lr-tire';
point.body1='lr-wheel';
point.location=[-0.762;0.6;0];
point.forces=1;
point.moments=0;
point.axis=[1;0;0];
the_system.item{end+1}=point;





point.type='rigid_point';
point.name='lf-wb';
point.body1='lf-wheel';
point.body2='lf-axle';
point.location=[0.762;0.6;0.2286];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.type='rigid_point';
point.name='rf-wb';
point.body1='rf-wheel';
point.body2='rf-axle';
point.location=[0.762;-0.6;0.2286];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;


point.type='rigid_point';
point.name='lr-wb';
point.body1='lr-wheel';
point.body2='lr-axle';
point.location=[-0.762;0.6;0.2286];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.type='rigid_point';
point.name='rr-wb';
point.body1='rr-wheel';
point.body2='rr-axle';
point.location=[-0.762;-0.6;0.2286];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;





point.type='rigid_point';
point.name='lf';
point.body1='f-axle';
point.body2='lf-axle';
point.location=[0.762;0.55;0.2286];
point.forces=3;
point.moments=2;
point.axis=[-0.17;-0.17;0.97];
the_system.item{end+1}=point;

point.type='rigid_point';
point.name='rf';
point.body1='f-axle';
point.body2='rf-axle';
point.location=[0.762;-0.55;0.2286];
point.forces=3;
point.moments=2;
point.axis=[-0.17;0.17;0.97];
the_system.item{end+1}=point;


point.type='rigid_point';
point.name='lr';
point.body1='r-axle';
point.body2='lr-axle';
point.location=[-0.762;0.55;0.2286];
point.forces=3;
point.moments=3;
the_system.item{end+1}=point;

point.type='rigid_point';
point.name='rr';
point.body1='r-axle';
point.body2='rr-axle';
point.location=[-0.762;-0.55;0.2286];
point.forces=3;
point.moments=3;
the_system.item{end+1}=point;




link.type='link';
link.name='right-b';
link.body1='f-axle';
link.body2='chassis';
link.location1=[0.762;0;0.1];
link.location2=[0.462;-0.4;0.1];
the_system.item{end+1}=link;

link.type='link';
link.name='left-b';
link.body1='f-axle';
link.body2='chassis';
link.location1=[0.762;0;0.1];
link.location2=[0.462;0.4;0.1];
the_system.item{end+1}=link;



link.type='link';
link.name='right-b';
link.body1='f-axle';
link.body2='chassis';
link.location1=[0.762;-0.5;0.3];
link.location2=[0.462;-0.5;0.3];
the_system.item{end+1}=link;


link.type='link';
link.name='left-b';
link.body1='f-axle';
link.body2='chassis';
link.location1=[0.762;0.5;0.3];
link.location2=[0.462;0.5;0.3];
the_system.item{end+1}=link;


  

link.type='link';
link.name='lf-tie-rod';
link.body1='lf-axle';
link.body2='chassis';
link.location1=[0.662;0.5;0.15];
link.location2=[0.662;0.1;0.15];
the_system.item{end+1}=link;

link.type='link';
link.name='rf-tie-rod';
link.body1='rf-axle';
link.body2='chassis';
link.location1=[0.662;-0.5;0.15];
link.location2=[0.662;-0.1;0.15];
the_system.item{end+1}=link;


link.type='link';
link.name='right rear lower';
link.body1='r-axle';
link.body2='chassis';
link.location1=[-0.762;0;0.1];
link.location2=[-0.462;-0.5;0.1];
the_system.item{end+1}=link;

link.type='link';
link.name='left rear lower';
link.body1='r-axle';
link.body2='chassis';
link.location1=[-0.762;0;0.1];
link.location2=[-0.462;0.5;0.1];
the_system.item{end+1}=link;

link.type='link';
link.name='right rear upper';
link.body1='rr-axle';
link.body2='chassis';
link.location1=[-0.762;-0.5;0.3];
link.location2=[-0.462;-0.5;0.3];
the_system.item{end+1}=link;


link.type='link';
link.name='left rear upper';
link.body1='lr-axle';
link.body2='chassis';
link.location1=[-0.762;0.5;0.3];
link.location2=[-0.462;0.5;0.3];
the_system.item{end+1}=link;



spring={};
spring.type='spring';
spring.name='front left';
spring.body1='f-axle';
spring.body2='chassis';
spring.location1=[0.8;0.5;0.1];
spring.location2=[0.9;0.4;0.3];
spring.stiffness=5000;
spring.damping=200;
the_system.item{end+1}=spring;


spring.name='front right';
spring.location1=[0.8;-0.5;0.1];
spring.location2=[0.9;-0.4;0.3];
the_system.item{end+1}=spring;

spring.body1='lr-axle';
spring.name='rear left';
spring.location1=[-0.7;0.5;0.1];
spring.location2=[-0.6;0.4;0.3];
the_system.item{end+1}=spring;

spring.body1='rr-axle';
spring.name=' rear right';
spring.location1=[-0.7;-0.5;0.1];
spring.location2=[-0.6;-0.4;0.3];
the_system.item{end+1}=spring;




%% Add external force between f-axle mass and chassis mass
item.type='actuator';
item.name='actuator';
item.body1='f-axle';
item.body2='ground';
item.gain=100000;
item.location1=[0.762;0.6;0.1];
item.location2=[0.762;0.6;0];
the_system.item{end+1}=item;

item.name='twist actuator';
item.body1='chassis';
item.body2='ground';
item.gain=1000;
item.twist=1;
item.location1=[0;0;0.3];
item.location2=[0.1;0;0.3];
the_system.item{end+1}=item;
item={};



%% Add measure between chassis mass and ground
item.type='sensor';
item.name='sensor';
item.body1='chassis';
item.body2='ground';
item.location1=[0;0;0.3];
item.location2=[0;0;0];
the_system.item{end+1}=item;

item.name='twist sensor';
item.body1='chassis';
item.body2='ground';
item.twist=1;
item.location1=[0;0;0.3];
item.location2=[0.1;0;0.3];
the_system.item{end+1}=item;
item={};
