function the_system=input_fsae(varargin)
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

g=9.81; % set gravity on

body.type='body';
body.name='Chassis';
body.mass=300;
body.momentsofinertia=[50;120;180];
body.location=[0;0;0.3];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

body.type='body';
body.name='Left front upright';
body.mass=5;
body.momentsofinertia=[0.1;0.1;0.1];
body.productsofinertia=[0;0;0];
body.location=[0.75;0.7;0.25];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right front upright';
body.location=[0.75;-0.7;0.25];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Left rear upright';
body.location=[-0.75;0.7;0.25];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right rear upright';
body.location=[-0.75;-0.7;0.25];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

body.name='Left front wheel+hub';
body.mass=10;
body.momentsofinertia=[2;4;2];
body.productsofinertia=[0;0;0];
body.location=[0.75;0.75;0.25];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right front wheel+hub';
body.location=[0.75;-0.75;0.25];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Left rear wheel+hub';
body.location=[-0.75;0.75;0.25];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right rear wheel+hub';
body.location=[-0.75;-0.75;0.25];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

body.name='Left front lower A-arm';
body.mass=2;
body.momentsofinertia=[0.1;0.1;0.1];
body.productsofinertia=[0;0;0];
body.location=[0.75;0.4;0.15];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right front lower A-arm';
body.location=[0.75;-0.4;0.15];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Left rear lower A-arm';
body.location=[-0.75;0.4;0.15];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right rear lower A-arm';
body.location=[-0.75;-0.4;0.15];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

body.name='Left front upper A-arm';
body.mass=2;
body.momentsofinertia=[0.1;0.1;0.1];
body.productsofinertia=[0;0;0];
body.location=[0.75;0.35;0.4];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right front upper A-arm';
body.location=[0.75;-0.35;0.4];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Left rear upper A-arm';
body.location=[-0.75;0.35;0.4];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right rear upper A-arm';
body.location=[-0.75;-0.35;0.4];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

body.name='Left front bell-crank';
body.mass=1;
body.momentsofinertia=[0.05;0.05;0.05];
body.productsofinertia=[0;0;0];
body.location=[0.45;0.35;0.15];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right front bell-crank';
body.location=[0.45;-0.35;0.15];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Left rear bell-crank';
body.location=[-0.45;0.35;0.15];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right rear bell-crank';
body.location=[-0.45;-0.35;0.15];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

body.name='Left front anti-roll bar';
body.mass=0;
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
body.location=[0.3;0.35;0.1];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right front anti-roll bar';
body.location=[0.3;-0.35;0.1];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

link.type='link';
link.name='Left front pull rod';
link.body1='Left front upper A-arm';
link.body2='Left front bell-crank';
link.location1=[0.75;0.55;0.4];
link.location2=[0.5;0.3;0.1];
the_system.item{end+1}=link;

link.name='Right front pull rod';
link.body1='Right front upper A-arm';
link.body2='Right front bell-crank';
link.location1=[0.75;-0.55;0.4];
link.location2=[0.5;-0.3;0.1];
the_system.item{end+1}=link;

link.name='Left rear pull rod';
link.body1='Left rear upper A-arm';
link.body2='Left rear bell-crank';
link.location1=[-0.75;0.55;0.4];
link.location2=[-0.5;0.3;0.1];
the_system.item{end+1}=link;

link.name='Right rear pull rod';
link.body1='Right rear upper A-arm';
link.body2='Right rear bell-crank';
link.location1=[-0.75;-0.55;0.4];
link.location2=[-0.5;-0.3;0.1];
the_system.item{end+1}=link;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

link.name='Left front tie rod';
link.body1='Left front upright';
link.body2='Chassis';
link.location1=[0.7;0.65;0.2];
link.location2=[0.7;0.2;0.2];
the_system.item{end+1}=link;

link.name='Right front tie rod';
link.body1='Right front upright';
link.body2='Chassis';
link.location1=[0.7;-0.65;0.2];
link.location2=[0.7;-0.2;0.2];
the_system.item{end+1}=link;

link.name='Left rear tie rod';
link.body1='Left rear upright';
link.body2='Left rear lower A-arm';
link.location1=[-0.7;0.65;0.1];
link.location2=[-0.7;0.2;0.1];
the_system.item{end+1}=link;

link.name='Right rear tie rod';
link.body1='Right rear upright';
link.body2='Right rear lower A-arm';
link.location1=[-0.7;-0.65;0.1];
link.location2=[-0.7;-0.2;0.1];
the_system.item{end+1}=link;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

link.name='Left front drop link';
link.body1='Left front anti-roll bar';
link.body2='Left front bell-crank';
link.location1=[0.3;0.35;0.15];
link.location2=[0.4;0.35;0.15];
the_system.item{end+1}=link;

link.name='Right front drop link';
link.body1='Right front anti-roll bar';
link.body2='Right front bell-crank';
link.location1=[0.3;-0.35;0.15];
link.location2=[0.4;-0.35;0.15];
the_system.item{end+1}=link;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.type='rigid_point';
point.name='Left front wheel bearing';
point.body1='Left front wheel+hub';
point.body2='Left front upright';
point.location=[0.75;0.75;0.25];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='Right front wheel bearing';
point.body1='Right front wheel+hub';
point.body2='Right front upright';
point.location=[0.75;-0.75;0.25];
the_system.item{end+1}=point;

point.name='Left rear wheel bearing';
point.body1='Left rear wheel+hub';
point.body2='Left rear upright';
point.location=[-0.75;0.75;0.25];
the_system.item{end+1}=point;

point.name='Right rear wheel bearing';
point.body1='Right rear wheel+hub';
point.body2='Right rear upright';
point.location=[-0.75;-0.75;0.25];
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front lower ball joint';
point.body1='Left front upright';
point.body2= 'Left front lower A-arm';
point.location=[0.75;0.7;0.15];
point.forces=3;
point.moments=0;
the_system.item{end+1}=point;

point.name='Right front lower ball joint';
point.body1='Right front upright';
point.body2= 'Right front lower A-arm';
point.location=[0.75;-0.7;0.15];
the_system.item{end+1}=point;

point.name='Left rear lower ball joint';
point.body1='Left rear upright';
point.body2= 'Left rear lower A-arm';
point.location=[-0.75;0.7;0.15];
the_system.item{end+1}=point;

point.name='Right rear lower ball joint';
point.body1='Right rear upright';
point.body2= 'Right rear lower A-arm';
point.location=[-0.75;-0.7;0.15];
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front upper ball joint';
point.body1='Left front upright';
point.body2= 'Left front upper A-arm';
point.location=[0.75;0.6;0.45];
point.forces=3;
point.moments=0;
the_system.item{end+1}=point;

point.name='Right front upper ball joint';
point.body1='Right front upright';
point.body2= 'Right front upper A-arm';
point.location=[0.75;-0.6;0.45];
the_system.item{end+1}=point;

point.name='Left rear upper ball joint';
point.body1='Left rear upright';
point.body2= 'Left rear upper A-arm';
point.location=[-0.75;0.6;0.45];
the_system.item{end+1}=point;

point.name='Right rear upper ball joint';
point.body1='Right rear upright';
point.body2= 'Right rear upper A-arm';
point.location=[-0.75;-0.6;0.45];
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front lower A-arm pivot, rear';
point.body1='Left front lower A-arm';
point.body2='Chassis';
point.location=[0.65;0.1;0.15];
point.forces=3;
point.moments=0;
the_system.item{end+1}=point;

point.name='Right front lower A-arm pivot, rear';
point.body1='Right front lower A-arm';
point.body2='Chassis';
point.location=[0.65;-0.1;0.15];
the_system.item{end+1}=point;

point.name='Left rear lower A-arm pivot, rear';
point.body1='Left rear lower A-arm';
point.body2='Chassis';
point.location=[-0.85;0.1;0.15];
the_system.item{end+1}=point;

point.name='Right rear lower A-arm pivot, rear';
point.body1='Right rear lower A-arm';
point.body2='Chassis';
point.location=[-0.85;-0.1;0.15];
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front lower A-arm pivot, front';
point.body1='Left front lower A-arm';
point.body2='Chassis';
point.location=[0.85;0.1;0.15];
point.forces=3;
point.moments=0;
the_system.item{end+1}=point;

point.name='Right front lower A-arm pivot, front';
point.body1='Right front lower A-arm';
point.body2='Chassis';
point.location=[0.85;-0.1;0.15];
the_system.item{end+1}=point;

point.name='Left rear lower A-arm pivot, front';
point.body1='Left rear lower A-arm';
point.body2='Chassis';
point.location=[-0.65;0.1;0.15];
the_system.item{end+1}=point;

point.name='Right rear lower A-arm pivot, front';
point.body1='Right rear lower A-arm';
point.body2='Chassis';
point.location=[-0.65;-0.1;0.15];
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front upper A-arm pivot, rear';
point.body1='Left front upper A-arm';
point.body2='Chassis';
point.location=[0.65;0.2;0.35];
point.forces=3;
point.moments=0;
the_system.item{end+1}=point;

point.name='Right front upper A-arm pivot, rear';
point.body1='Right front upper A-arm';
point.body2='Chassis';
point.location=[0.65;-0.2;0.35];
the_system.item{end+1}=point;

point.name='Left rear upper A-arm pivot, rear';
point.body1='Left rear upper A-arm';
point.body2='Chassis';
point.location=[-0.85;0.2;0.35];
the_system.item{end+1}=point;

point.name='Right rear upper A-arm pivot, rear';
point.body1='Right rear upper A-arm';
point.body2='Chassis';
point.location=[-0.85;-0.2;0.35];
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front upper A-arm pivot, front';
point.body1='Left front upper A-arm';
point.body2='Chassis';
point.location=[0.85;0.2;0.35];
point.forces=3;
point.moments=0;
the_system.item{end+1}=point;

point.name='Right front upper A-arm pivot, front';
point.body1='Right front upper A-arm';
point.body2='Chassis';
point.location=[0.85;-0.2;0.35];
the_system.item{end+1}=point;

point.name='Left rear upper A-arm pivot, front';
point.body1='Left rear upper A-arm';
point.body2='Chassis';
point.location=[-0.65;0.2;0.35];
the_system.item{end+1}=point;

point.name='Right rear upper A-arm pivot, front';
point.body1='Right rear upper A-arm';
point.body2='Chassis';
point.location=[-0.65;-0.2;0.35];
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front bell-crank pivot';
point.body1='Left front bell-crank';
point.body2='Chassis';
point.location=[0.4;0.4;0.2];
point.forces=3;
point.moments=2;
point.axis=[0;-1;1]/norm([0;1;1]);
the_system.item{end+1}=point;

point.name='Right front bell-crank pivot';
point.body1='Right front bell-crank';
point.body2='Chassis';
point.location=[0.4;-0.4;0.2];
point.axis=[0;1;1]/norm([0;1;1]);
the_system.item{end+1}=point;

point.name='Left rear bell-crank pivot';
point.body1='Left rear bell-crank';
point.body2='Chassis';
point.location=[-0.4;0.4;0.2];
point.axis=[0;-1;1]/norm([0;1;1]);
the_system.item{end+1}=point;

point.name='Right rear bell-crank pivot';
point.body1='Right rear bell-crank';
point.body2='Chassis';
point.location=[-0.4;-0.4;0.2];
point.axis=[0;1;1]/norm([0;1;1]);
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front anti-roll bar pivot';
point.body1='Left front anti-roll bar';
point.body2='Chassis';
point.location=[0.3;0.3;0.1];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='Right front anti-roll bar pivot';
point.body1='Right front anti-roll bar';
point.body2='Chassis';
point.location=[0.3;-0.3;0.1];
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spring.type='spring';
spring.name='Left front suspension spring';
spring.location1=[0.4;0.45;0.3];
spring.location2=[0.2;0.45;0.3];
spring.body1='Left front bell-crank';
spring.body2='Chassis';
spring.stiffness=40000;
spring.damping=1000;
the_system.item{end+1}=spring;

spring.name='Right front suspension spring';
spring.location1=[0.4;-0.45;0.3];
spring.location2=[0.2;-0.45;0.3];
spring.body1='Right front bell-crank';
spring.body2='Chassis';
the_system.item{end+1}=spring;

spring.name='Left rear suspension spring';
spring.location1=[-0.4;0.45;0.3];
spring.location2=[-0.2;0.45;0.3];
spring.body1='Left rear bell-crank';
spring.body2='Chassis';
spring.stiffness=20000;
spring.damping=1000;
the_system.item{end+1}=spring;

spring.name='Right rear suspension spring';
spring.location1=[-0.4;-0.45;0.3];
spring.location2=[-0.2;-0.45;0.3];
spring.body1='Right rear bell-crank';
spring.body2='Chassis';
the_system.item{end+1}=spring;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spring.name='Front anti-roll bar';
spring.location1=[0.3;0.35;0.1];
spring.location2=[0.3;-0.35;0.1];
spring.body1='Left front anti-roll bar';
spring.body2='Right front anti-roll bar';
spring.stiffness=100;
spring.damping=0;
spring.twist=1;
the_system.item{end+1}=spring;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point={};
%item.type='flex_point';
point.type='rigid_point';  % only for finding roll centre
point.name='Left front tire, vertical';
point.body1='Left front wheel+hub';
point.body2='ground';
point.location=[0.75;0.75;0];
point.forces=2;
point.moments=0;
%item.stiffness=[150000;0];
point.axis=[0;1;0];
point.rolling_axis=[0;1;0];
the_system.item{end+1}=point;

point.name='Right front tire, vertical';
point.body1='Right front wheel+hub';
point.body2='ground';
point.location=[0.75;-0.75;0];
the_system.item{end+1}=point;

point.name='Left rear tire, vertical';
point.body1='Left rear wheel+hub';
point.body2='ground';
point.location=[-0.75;0.75;0];
the_system.item{end+1}=point;

point.name='Right rear tire, vertical';
point.body1='Right rear wheel+hub';
point.body2='ground';
point.location=[-0.75;-0.75;0];
the_system.item{end+1}=point;



%  item.type='flex_point';
%  %item.type='rigid_point';  % only for finding roll centre
%  item.name='Tire, horizontal';
%  item.body1='Wheel+hub';
%  item.body2='ground';
%  item.location=[0.5;0.9;0];
%  item.forces=2;
%  item.moments=0;
%  item.stiffness=[0;0];
%  item.damping=[100;0];
%  item.axis=[0;0;1];
%  the_system.item{end+1}=item;
%  item={};

%  item.type='load';
%  item.name='Inertia load';
%  item.body='Wheel+hub';
%  item.location=[0.5;0.9;0];
%  item.force=[0;-0.5*9.81*250;0];
%  item.moment=[0;0;0];
%  %the_system.item{end+1}=item; % to add lateral loads at the tire
%  item={};

%  item.type='actuator';
%  item.name='wheel actuator';
%  item.location1=[0.5;0.9;0];
%  item.location2=[0.5;0.9;-0.1];
%  item.body1='Left front wheel+hub';
%  item.body2='ground';
%  item.gain=150000;
%  item.travel=0;
%  the_system.item{end+1}=item;
%  item={};
%  

item.type='actuator';
item.name='chassis actuator';
item.location1=[0.0;0;0.3];
item.location2=[0.0;0;0.2];
item.body1='Chassis';
item.body2='ground';
the_system.item{end+1}=item;
item={};


item.type='sensor';
item.name='chassis sensor';
item.location1=[0.0;0;0.3];
item.location2=[0.0;0;0.2];
item.body1='Chassis';
item.body2='ground';
the_system.item{end+1}=item;
item={};



