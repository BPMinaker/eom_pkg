function the_system=input_fsae(u,varargin)
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

g=9.81;

body.type='body';
body.name='Chassis';
body.location=[-0.604;0;0.336];
body.mass=40;
body.momentsofinertia=[3.368;11.812;11.402];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Engine';
body.location=[-1.170;-0.0411;0.258];
body.mass=11.033;
body.momentsofinertia=[0.167;0.198;0.106];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Driver';
body.mass=80;
body.location=[-0.415;0;0.409];
body.momentsofinertia=[3.57;12.8;11.4];
body.productsofinertia=[0.012;-0.006;-3.440];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Front Suspension
body.type='body';
body.name='Left front wheel+hub'; % Includes rotor, caliper
body.mass=2.126;
body.location=[-0.008;0.543;0.198];
body.momentsofinertia=[0.011;0.01;0.011];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.type='body';
body.name='Right front wheel+hub'; % Includes rotor, caliper
body.mass=2.126;
body.location=[-0.008;-0.543;0.198];
body.momentsofinertia=[0.011;0.01;0.011];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.type='body';
body.name='Left front spindle'; 
body.mass=1.14;
body.location=[-0.008;0.499;0.197];
body.momentsofinertia=[0.003;0.001;0.003];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.type='body';
body.name='Right front spindle'; 
body.mass=1.14;
body.location=[-0.008;-0.499;0.197];
body.momentsofinertia=[0.003;0.001;0.003];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


body.type='body';
body.name='Front axle tube';
body.mass=3.667;
body.location=[-0.008;0;0.140];
body.momentsofinertia=[0.371;0.02;0.354];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Rear Suspension

body.name='Left rear wheel+hub'; % Includes rotor, caliper (wheel_m=0.964?)
body.mass=2.126;
body.location=[-1.550;0.543;0.198];
body.momentsofinertia=[0.011;0.01;0.011];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right rear wheel+hub'; % Includes rotor, caliper
body.mass=2.126;
body.location=[-1.550;-0.541;0.198];
body.momentsofinertia=[0.011;0.01;0.011];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Rear axle tube'; 
body.mass=3.141;
body.location=[-1.581;0.001;0.121];
body.momentsofinertia=[0.344;0.012;0.338];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

link.type='link';
link.name='Left front lower A-arm';
link.body1='Front axle tube';
link.body2='Chassis';
link.location1=[-0.010;0;0.116];
link.location2=[-0.141;0.213;0.116]; 
the_system.item{end+1}=link;

link.type='link';
link.name='Right front lower A-arm';
link.body1='Front axle tube';
link.body2='Chassis';
link.location1=[-0.010;0;0.116];
link.location2=[-0.141;-0.213;0.116]; 
the_system.item{end+1}=link;

link.type='link';
link.name='Front upper left';
link.body1='Front axle tube';
link.body2='Chassis';
link.location1=[-0.010;0.3;0.3];
link.location2=[-0.241;0.3;0.3]; 
the_system.item{end+1}=link;

link.type='link';
link.name='Front upper right';
link.body1='Front axle tube';
link.body2='Chassis';
link.location1=[-0.010;-0.3;0.3];
link.location2=[-0.241;-0.3;0.3]; 
the_system.item{end+1}=link;


link.type='link';
link.name='Left rear lower A-arm';
link.body1='Rear axle tube';
link.body2='Chassis';
link.location1=[-1.58;0;0.116];
link.location2=[-1.4;0.213;0.116]; 
the_system.item{end+1}=link;

link.type='link';
link.name='Right rear lower A-arm';
link.body1='Rear axle tube';
link.body2='Chassis';
link.location1=[-1.58;0;0.116];
link.location2=[-1.4;-0.213;0.116]; 
the_system.item{end+1}=link;

link.type='link';
link.name='Rear upper left';
link.body1='Rear axle tube';
link.body2='Chassis';
link.location1=[-1.58;0.3;0.3];
link.location2=[-1.3;0.3;0.3]; 
the_system.item{end+1}=link;

link.type='link';
link.name='Rear upper right';
link.body1='Rear axle tube';
link.body2='Chassis';
link.location1=[-1.58;-0.3;0.3];
link.location2=[-1.3;-0.3;0.3]; 
the_system.item{end+1}=link;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spring.type='spring';
spring.name='Front anti-roll bar';
spring.location1=[-0.008;0.150;0.260];
spring.location2=[-0.008;-0.150;0.260];
spring.body1='Left front anti-roll bar';
spring.body2='Right front anti-roll bar';
spring.stiffness=110; %% GJ/L
spring.damping=0;
spring.twist=1;
the_system.item{end+1}=spring;


point.type='rigid_point';
point.name='Left front anti-roll bar pivot';
point.body1='Left front anti-roll bar';
point.body2='Chassis';
point.location=[-0.008;0.14;0.260];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='Right front anti-roll bar pivot';
point.body1='Right front anti-roll bar';
point.body2='Chassis';
point.location=[-0.008;-0.14;0.260];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

body.type='body';
body.name='Left front anti-roll bar';
body.mass=0;
body.location=[-0.008;0.150;0.260];
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


body.type='body';
body.name='Right front anti-roll bar';
body.mass=0;
body.location=[-0.008;-0.150;0.260];
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


link.type='link';
link.name='Left front anti roll';
link.body1='Front axle tube';
link.body2='Left front anti-roll bar';
link.location1=[-0.038;0.150;0.160];
link.location2=[-0.038;0.150;0.260]; 
the_system.item{end+1}=link;

link.type='link';
link.name='Right front anti roll';
link.body1='Front axle tube';
link.body2='Right front anti-roll bar';
link.location1=[-0.038;-0.150;0.160];
link.location2=[-0.038;-0.150;0.260]; 
the_system.item{end+1}=link;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spring.type='spring';
spring.name='Rear anti-roll bar';
spring.location1=[-1.550;0.150;0.260];
spring.location2=[-1.550;-0.150;0.260];
spring.body1='Left rear anti-roll bar';
spring.body2='Right rear anti-roll bar';
spring.stiffness=110; %% GJ/L
spring.damping=0;
spring.twist=1;
the_system.item{end+1}=spring;


point.type='rigid_point';
point.name='Left rear anti-roll bar pivot';
point.body1='Left rear anti-roll bar';
point.body2='Chassis';
point.location=[-1.550;0.14;0.260];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='Right rear anti-roll bar pivot';
point.body1='Right rear anti-roll bar';
point.body2='Chassis';
point.location=[-1.550;-0.14;0.260];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

body.type='body';
body.name='Left rear anti-roll bar';
body.mass=0;
body.location=[-1.550;0.150;0.260];
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


body.type='body';
body.name='Right rear anti-roll bar';
body.mass=0;
body.location=[-1.550;-0.150;0.260];
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


link.type='link';
link.name='Left rear anti roll';
link.body1='Rear axle tube';
link.body2='Left rear anti-roll bar';
link.location1=[-1.520;0.150;0.160];
link.location2=[-1.520;0.150;0.260]; 
the_system.item{end+1}=link;

link.type='link';
link.name='Right rear anti roll';
link.body1='Rear axle tube';
link.body2='Right rear anti-roll bar';
link.location1=[-1.520;-0.150;0.160];
link.location2=[-1.520;-0.150;0.260]; 
the_system.item{end+1}=link;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
point.type='rigid_point';
point.name='Left front king pin';
point.body1='Left front spindle';
point.body2='Front axle tube';
point.location=[-0.008;0.460;0.198];
point.forces=3;
point.moments=3;  %% Make this back to 2 to allow steering motion
point.axis=[0;-0.05;1];
the_system.item{end+1}=point;

point.name='Right front king pin';
point.body1='Right front spindle';
point.body2='Front axle tube';
point.location=[-0.008;-0.460;0.198];
point.forces=3;
point.moments=3;  %% Make this back to 2 to allow steering motion
point.axis=[0;0.05;1];
the_system.item{end+1}=point;

point.name='Left front hub';
point.body1='Left front wheel+hub';
point.body2='Left front spindle';
point.location=[-0.008;0.461;0.198];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='Right front hub';
point.body1='Right front wheel+hub';
point.body2='Right front spindle';
point.location=[-0.008;-0.461;0.198];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='Left rear bearing hub';
point.body1='Left rear wheel+hub';
point.body2='Rear axle tube';
point.location=[-1.550;0.461;0.198];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='Right rear bearing hub';
point.body1='Right rear wheel+hub';
point.body2='Rear axle tube';
point.location=[-1.550;-0.460;0.198];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Engine mount';
point.body1='Engine';
point.body2='Chassis';
point.location=[-1.185;0.032;0.302];
point.forces=3; 
point.moments=3;
the_system.item{end+1}=point;


point.name='Driver mount';
point.body1='Driver';
point.body2='Chassis';
pont.location=[0.415;0;0.409];
point.forces=3; 
point.moments=3;
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spring={};
spring.type='spring';
spring.name='Left front suspension spring';
spring.body1='Front axle tube';
spring.body2='Chassis';
spring.location1=[-0.008;0.3;0.157];
spring.location2=[-0.008;0.3;0.357];
spring.stiffness=17513/2;  %% 100/2 lbs/in
spring.damping=250;
the_system.item{end+1}=spring;

spring.name='Right front suspension spring';
spring.body1='Front axle tube';
spring.body2='Chassis';
spring.location1=[-0.008;-0.3;0.157];
spring.location2=[-0.008;-0.3;0.357];
the_system.item{end+1}=spring;

spring.name='Left rear suspension spring';
spring.body1='Rear axle tube';
spring.body2='Chassis';
spring.location1=[-1.581;0.3;0.167];
spring.location2=[-1.581;0.3;0.367];
spring.stiffness=17513/2; 
spring.damping=250;
the_system.item{end+1}=spring;

spring.name='Right rear suspension spring';
spring.body1='Rear axle tube';
spring.body2='Chassis';
spring.location1=[-1.581;-0.3;0.167];
spring.location2=[-1.581;-0.3;0.367];
the_system.item{end+1}=spring;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point={};
point.type='flex_point';
point.name='Left front tire, vertical';
point.body1='Left front wheel+hub';
point.body2='ground';
point.location=[-0.008;0.543;0];
point.forces=1;
point.moments=0;
point.stiffness=[150000;0];
point.axis=[0;0;1];
point.rolling_axis=[0;1;0];
the_system.item{end+1}=point;

point.name='Left rear tire, vertical';
point.body1='Left rear wheel+hub';
point.body2='ground';
point.location=[-1.550;0.543;0];
the_system.item{end+1}=point;


point.name='Right front tire, vertical';
point.body1='Right front wheel+hub';
point.body2='ground';
point.location=[-0.008;-0.543;0];
the_system.item{end+1}=point;

point.name='Right rear tire, vertical';
point.body1='Right rear wheel+hub';
point.body2='ground';
point.location=[-1.550;-0.543;0];
the_system.item{end+1}=point;


point.type='flex_point';
point.name='Left front tire, horizontal';
point.body1='Left front wheel+hub';
point.body2='ground';
point.location=[-0.008;0.543;0];
point.forces=2;
point.moments=0;
point.stiffness=[0;0];
point.damping=[30000/u;0];  %% cornering stiffness / forward speed
point.axis=[0;0;1];
point.rolling_axis=[0;1;0];
the_system.item{end+1}=point;

point.name='Left rear tire, horizontal';
point.body1='Left rear wheel+hub';
point.body2='ground';
point.location=[-1.550;0.543;0];
the_system.item{end+1}=point;


point.name='Right front tire, horizontal';
point.body1='Right front wheel+hub';
point.body2='ground';
point.location=[-0.008;-0.543;0];
the_system.item{end+1}=point;

point.name='Right rear tire, horizontal';
point.body1='Right rear wheel+hub';
point.body2='ground';
point.location=[-1.550;-0.543;0];
the_system.item{end+1}=point;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
item={};
item.type='sensor';
item.name='roll sensor';
item.body1='Chassis';
item.body2='ground';
item.twist=1;
item.location1=[-0.777;0;0.33];
item.location2=[-0.877;0;0.33];
the_system.item{end+1}=item;

item={};
item.type='actuator';
item.name='roll moment';
item.body1='Chassis';
item.body2='ground';
item.twist=1;
item.location1=[-0.777;0;0.33];
item.location2=[-0.877;0;0.33];
the_system.item{end+1}=item;

