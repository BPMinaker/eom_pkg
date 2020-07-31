function the_system=input_fsae(u,varargin)
the_system.name='UWindsor FSAE'; 
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
body.location=[-1.0;0;0.4]; %% Estimate based on weight dist.    %[-0.387;0;0.416];
body.mass=140;  %% Assuming total vehicle mass of 180, less 20 for engine, and 20 for rest of model   %%30.57;
body.momentsofinertia=[40,80,90];  %% Estimate based on weight, wheelbase  %[3.368;11.812;11.402]; 
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Engine';
body.location=[-1.170;0;0.258]; %precisely y=-0.041
body.mass=17.98;
body.momentsofinertia=[0.396;0.617;0.611]; 
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Driver';  
body.mass=81.786;
body.location=[-0.431;0;0.333];
body.momentsofinertia=[3.63;12.8;11.4];
body.productsofinertia=[0.012;-0.006;-3.440];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Front Suspension

body.type='body';
body.name='LF wheel+hub'; % Includes rotor, caliper
body.mass=6.19;
body.location=[-0.008;0.543;0.198];
body.momentsofinertia=[0.011;0.01;0.011];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='LF spindle'; 
body.mass=1.14;
body.location=[-0.008;0.499;0.197];
body.momentsofinertia=[0.003;0.001;0.003];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

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

body.name='LR wheel+hub'; % Includes rotor, caliper (wheel_m=0.964?)
body.mass=6.19;
body.location=[-1.550;0.543;0.198];
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
link.name='LF A-arm';
link.body1='Front axle tube';
link.body2='Chassis';
link.location1=[-0.044;0;0.045];
link.location2=[-0.255;0.152;0.065]; 
the_system.item{end+1}=link;

link.name='LF upper link';
link.body1='Front axle tube';
link.body2='Chassis';
link.location1=[-0.035;0.254;0.215];
link.location2=[-0.231;0.282;0.217]; 
the_system.item{end+1}=link;

link.name='LR lower A-arm';
link.body1='Rear axle tube';
link.body2='Chassis';
link.location1=[-1.555;0;0.043]; %precisely y=0.001
link.location2=[-1.408;0.191;0.063]; 
the_system.item{end+1}=link;

link.name='LR upper link';
link.body1='Rear axle tube';
link.body2='Chassis';
link.location1=[-1.600;0.335;0.229];
link.location2=[-1.138;0.284;0.224]; 
the_system.item{end+1}=link;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spring.type='spring';
spring.name='Front anti-roll bar';
spring.location1=[0;0.110;0.176];
spring.location2=[0;-0.110;0.176];
spring.body1='LF anti-roll bar';
spring.body2='RF anti-roll bar';
%spring.stiffness=871; %% GJ/L 0.5" dia, 22 cm long
%spring.stiffness=2126; %% GJ/L 5/8" dia, 22 cm long
%spring.stiffness=1395; %% GJ/L 9/16" dia, 22 cm long
d=0.375*0.0254;
G=75e9;
J=pi*d^4/32;
L=0.22;
spring.stiffness=G*J/L*4;
spring.damping=0;
spring.twist=1;
the_system.item{end+1}=spring;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.type='rigid_point';
point.name='LF anti-roll bar pivot';
point.body1='LF anti-roll bar';
point.body2='Chassis';
point.location=[0;0.110;0.176];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

body.type='body';
body.name='LF anti-roll bar';
body.mass=0;
body.location=[0;0.110;0.176];
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

link.type='link';
link.name='LF anti roll link';
link.body1='Front axle tube';
link.body2='LF anti-roll bar';
link.location1=[-0.115;0.110;0.146];
link.location2=[-0.115;0.110;0.176]; 
the_system.item{end+1}=link;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spring.type='spring';
spring.name='Rear anti-roll bar';
spring.location1=[-1.468;0.190;0.323];
spring.location2=[-1.468;-0.190;0.323];
spring.body1='LR anti-roll bar';
spring.body2='RR anti-roll bar';
d=0.375*0.0254;
G=75e9;
J=pi*d^4/32;
L=0.38;
spring.stiffness=G*J/L;
spring.damping=0;
spring.twist=1;
the_system.item{end+1}=spring;

point.type='rigid_point';
point.name='LR anti-roll bar pivot';
point.body1='LR anti-roll bar';
point.body2='Chassis';
point.location=[-1.468;0.19;0.323];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

body.type='body';
body.name='LR anti-roll bar';
body.mass=0;
body.location=[-1.468;0.190;0.323];
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

link.type='link';
link.name='LR anti roll link';
link.body1='Rear axle tube';
link.body2='LR anti-roll bar';
link.location1=[-1.583;0.190;0.093];
link.location2=[-1.583;0.190;0.323]; 
the_system.item{end+1}=link;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.type='rigid_point';
point.name='LF king pin';
point.body1='LF spindle';
point.body2='Front axle tube';
point.location=[-0.008;0.460;0.198];
point.forces=3;
point.moments=3;  %% Make this back to 2 to allow steering motion
point.axis=[0;-0.05;1];
the_system.item{end+1}=point;

point.name='LF wheel bearing';
point.body1='LF wheel+hub';
point.body2='LF spindle';
point.location=[-0.008;0.461;0.198];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='LR wheel bearing';
point.body1='LR wheel+hub';
point.body2='Rear axle tube';
point.location=[-1.550;0.461;0.198];
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
point.location=[-0.431;0;0.333];
point.forces=3; 
point.moments=3;
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spring.type='spring';
spring.name='LF suspension spring';
spring.body1='Front axle tube';
spring.body2='Chassis';
spring.location1=[-0.008;0.317;0.174];
spring.location2=[-0.008;0.302;0.350];
spring.stiffness=17513/2;  %% 100/2 lbs/in
spring.damping=250;
spring.twist=0;
the_system.item{end+1}=spring;

spring.name='LR suspension spring';
spring.body1='Rear axle tube';
spring.body2='Chassis';
spring.location1=[-1.581;0.270;0.121];
spring.location2=[-1.581;0.270;0.298];
spring.stiffness=17513/2; 
spring.damping=250;
the_system.item{end+1}=spring;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.type='flex_point';
point.name='LF tire, vertical';
point.body1='LF wheel+hub';
point.body2='ground';
point.location=[-0.008;0.543;0];
point.forces=1;
point.moments=0;
point.stiffness=[150000;0];
point.axis=[0;0;1];
point.rolling_axis=[0;1;0];
the_system.item{end+1}=point;

point.name='LR tire, vertical';
point.body1='LR wheel+hub';
point.body2='ground';
point.location=[-1.550;0.543;0];
the_system.item{end+1}=point;

point={};
point.type='flex_point';
point.name='LF tire, horizontal';
point.body1='LF wheel+hub';
point.body2='ground';
point.location=[-0.008;0.543;0];
point.moments=0;
point.stiffness=[0;0];
point.forces=1;
point.damping=[30000/u;0];  %% cornering stiffness / forward speed
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='LR tire, horizontal';
point.body1='LR wheel+hub';
point.body2='ground';
point.location=[-1.550;0.543;0];
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Mirror all FF item to RF, LR to RR
the_system=mirror(the_system);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

item.type='sensor';
item.name='Roll sensor';
item.body1='Chassis';
item.body2='ground';
item.twist=1;
item.gain=180/pi;
item.location1=[-0.8;0;0.4];
item.location2=[-0.9;0;0.4];
the_system.item{end+1}=item;

item.name='Pitch sensor';
item.body1='Chassis';
item.body2='ground';
item.twist=1;
item.gain=180/pi;
item.location1=[-0.8;0;0.4];
item.location2=[-0.8;-0.1;0.4];
the_system.item{end+1}=item;

item.name='LF normal force sensor';
item.body1='LF wheel+hub';
item.body2='ground';
item.twist=0;
item.gain=150000;
item.location1=[-0.008;0.543;0.0];
item.location2=[-0.008;0.543;-0.1];
the_system.item{end+1}=item;

item.name='LR normal force sensor';
item.body1='LR wheel+hub';
item.body2='ground';
item.twist=0;
item.gain=150000;
item.location1=[-1.550;0.543;0.0];
item.location2=[-1.550;0.543;-0.1];
the_system.item{end+1}=item;


item.name='LF suspension spring travel';
item.body1='Front axle tube';
item.body2='Chassis';
item.gain=1;
item.location1=[-0.008;0.317;0.174];
item.location2=[-0.008;0.302;0.350];
the_system.item{end+1}=item;


item.name='LR suspension spring travel';
item.body1='Rear axle tube';
item.body2='Chassis';
item.location1=[-1.581;0.270;0.121];
item.location2=[-1.581;0.270;0.298];
the_system.item{end+1}=item;


item.name='Roll bar twist';
item.location1=[0;0.110;0.176];
item.location2=[0;-0.110;0.176];
item.body1='LF anti-roll bar';
item.body2='RF anti-roll bar';
item.twist=1;
item.gain=180/pi;
the_system.item{end+1}=item;


item.name='Rear bar twist';
item.location1=[-1.468;0.190;0.323];
item.location2=[-1.468;-0.190;0.323];
item.body1='LR anti-roll bar';
item.body2='RR anti-roll bar';
item.twist=1;
item.gain=180/pi;
the_system.item{end+1}=item;



%  item.name='acc-x sensor';
%  item.body1='Chassis';
%  item.body2='ground';
%  item.twist=0;
%  item.gain=1;
%  item.order=3;
%  item.location1=[-0.8;0;0.4];
%  item.location2=[-0.9;0;0.4];
%  the_system.item{end+1}=item;
%  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

item={};
item.type='actuator';
item.name='Roll moment';
item.body1='Chassis';
item.body2='ground';
item.twist=1;
item.gain=0.4*260*9.81;
item.location1=[-0.8;0;0.4];
item.location2=[-0.9;0;0.4];
the_system.item{end+1}=item;

item.name='Pitch moment';
item.body1='Chassis';
item.body2='ground';
item.twist=1;
item.gain=0.4*260*9.81;
item.location1=[-0.8;0;0.4];
item.location2=[-0.8;-0.1;0.4];
the_system.item{end+1}=item;


%  item.type='actuator';
%  item.name='LR torque';
%  item.body1='Chassis';
%  item.body2='Left rear wheel+hub';
%  item.location1=[-1.55;0;0.198];
%  item.location2=[-1.55;0.543;0.198];
%  item.twist=1;
%  the_system.item{end+1}=item;
%  
%  item.name='RR torque';
%  item.body1='Chassis';
%  item.body2='Right rear wheel+hub';
%  item.location1=[-1.55;0;0.198];
%  item.location2=[-1.55;-0.543;0.198];
%  item.twist=1;
%  item.gain=-1;
%  the_system.item{end+1}=item;
%  
%  
%  item.name='LR brake';
%  item.body1='Rear axle tube';
%  item.body2='Left rear wheel+hub';
%  item.location1=[-1.55;0;0.198];
%  item.location2=[-1.55;0.543;0.198];
%  item.gain=-1;
%  item.twist=1;
%  the_system.item{end+1}=item;
%  
%  item.name='RR brake';
%  item.body1='Rear axle tube';
%  item.body2='Right rear wheel+hub';
%  item.location1=[-1.55;0;0.198];
%  item.location2=[-1.55;-0.543;0.198];
%  item.twist=1;
%  item.gain=1;
%  the_system.item{end+1}=item;
%  
%  
%  item.name='LF brake';
%  item.body1='Front axle tube';
%  item.body2='Left front wheel+hub';
%  item.location1=[-1.55;0;0.198];
%  item.location2=[-1.55;0.543;0.198];
%  item.twist=1;
%  item.gain=-1;
%  the_system.item{end+1}=item;
%  
%  item.name='RF brake';
%  item.body1='Front axle tube';
%  item.body2='Right front wheel+hub';
%  item.location1=[-0.008;0;0.198];
%  item.location2=[-0.008;-0.543;0.198];
%  item.twist=1;
%  item.gain=1;
%  the_system.item{end+1}=item;








