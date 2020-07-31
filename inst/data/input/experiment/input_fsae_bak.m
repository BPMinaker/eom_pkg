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
body.momentsofinertia=[41.606;90.738;122.521]; % Confirmed 67.606;172.738;221.521
body.location=[-0.777161;-0.001323;.330324];    %Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

body.type='body';
body.name='Left front upright';
body.mass=0.274;  
body.momentsofinertia=[0.002;0.002;0.0001853];      % Ixx, Iyy, Izz
body.productsofinertia=[0;0;0];           %Ixy, Ixz, Iyz under 10^-6
body.location=[-0.006531;0.598523;0.253034];  % Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right front upright';
body.location=[-0.006531;-0.598523;0.253034];  % Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Left rear upright';
body.location=[-1.579516;0.587406;0.259608];% Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right rear upright';
body.location=[-1.579516;-0.587406;0.259608]; %Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


body.name='Left front wheel+hub';
body.mass=20.487;
body.momentsofinertia=[0.582;0.943;0.523]; % Confirmed
%body.productsofinertia=[0.00009312;0.00000379;0.15]; % Confirmed
body.productsofinertia=[0.0;0.0;0.0]; % Above is wrong
body.location=[-0.000087;0.641114;0.255039]; % Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right front wheel+hub';
body.location=[-0.000087;-0.641114;0.255039];% Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Left rear wheel+hub';
body.location=[-1.589806;0.628762;0.263108];% Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right rear wheel+hub';
body.location=[-1.589806;-0.628762;0.263108];% Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

body.name='Left front lower A-arm';
body.mass=0.052;
body.momentsofinertia=[0.0009553;0.0005209;0.001];  % Confirmed
%body.productsofinertia=[-0.0002898;-0.000005626;-0.00003747];  % Confirmed
body.location=[-0.072926;0.379491;0.112346]; % Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right front lower A-arm';
body.location=[-0.072926;-0.379491;0.112346]; % Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Left rear lower A-arm';
body.location=[-1.48772;0.394437;0.125204]; % Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right rear lower A-arm';
body.location=[-1.48772;-0.394437;0.125204]; % Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

body.name='Left front upper A-arm';
body.mass=0.037;
body.momentsofinertia=[.0003719;.0003677;.0006803]; % Confirmed
%body.productsofinertia=[-0.0001861;-.00005352;-.0000998]; % Confirmed
body.location=[-0.08384;0.431327;0.33119]; % Confirmed 
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right front upper A-arm';
body.location=[-0.08384;-0.431327;0.33119]; % Confirmed 
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Left rear upper A-arm';
body.location=[-1.463401;0.407384;0.353886];% Confirmed 
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right rear upper A-arm';
body.location=[-1.463835;-0.407384;0.353886];% Confirmed 
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

body.name='Left front bell-crank';
body.mass=0.025;
body.momentsofinertia=[0.000008546;0.00000645;0.000008504];% Confirmed 
body.productsofinertia=[0;0;0]; % 10^-7
body.location=[-0.088601;0.20332;0.121897]; % Confirmed 
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right front bell-crank';
body.location=[-0.088601;-0.20332;0.121897]; % Confirmed 
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Left rear bell-crank';
body.location=[-1.507426;0.240222;0.146069];% Confirmed 
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right rear bell-crank';
body.location=[-1.507426;-0.240222;0.146069];% Confirmed 
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

body.name='Left front anti-roll bar';
body.mass=0.126;
body.momentsofinertia=[0.0003975;0;.0003975];
body.productsofinertia=[0;0;0];
%body.location=[-.114226;.134088;.081531]; %Confirmed
body.location=[-0.112182;0.199871;0.076421]; % Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right front anti-roll bar';
%body.location=[-.114226;-.134088;.081531]; % Confirmed
body.location=[-0.112182;-0.199871;0.076421]; % Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

link.type='link';
link.name='Left front pull rod';
link.body1='Left front upper A-arm';
link.body2='Left front bell-crank';         
link.location1=[-0.010;0.579;0.3745];  % Confirmed
link.location2=[-0.0413165;0.2126025;0.1157]; 
the_system.item{end+1}=link;

link.name='Right front pull rod';
link.body1='Right front upper A-arm';
link.body2='Right front bell-crank';
link.location1=[-0.010;-0.579;0.3745];  % Confirmed
link.location2=[-0.0413165;-0.2126025;0.1157];
the_system.item{end+1}=link;

link.name='Left rear pull rod';
link.body1='Left rear upper A-arm';
link.body2='Left rear bell-crank';
link.location1=[-1.560;0.556;0.387];  % Confirmed
link.location2=[-1.531875;0.23715;0.146774];
the_system.item{end+1}=link;

link.name='Right rear pull rod';
link.body1='Right rear upper A-arm';
link.body2='Right rear bell-crank';
link.location1=[-1.560;-0.556;0.387];  % Confirmed
link.location2=[-1.531875;-0.23715;0.146774];
the_system.item{end+1}=link;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

link.name='Left front tie rod';
link.body1='Left front upright';
link.body2='Chassis';
link.location1=[0.065;0.580;0.183];  % Confirmed
link.location2=[0.06;0.228;0.146];       
the_system.item{end+1}=link;

link.name='Right front tie rod';
link.body1='Right front upright';
link.body2='Chassis';
link.location1=[0.065;-0.580;0.183];  % Confirmed
link.location2=[0.06;-0.228;0.146];
the_system.item{end+1}=link;

link.name='Left rear tie rod';
link.body1='Left rear upright';
link.body2='Chassis';
link.location1=[-1.690;.580;.167]; % Confirmed
link.location2=[-1.590;0.190;0.146];
the_system.item{end+1}=link;

link.name='Right rear tie rod';
link.body1='Right rear upright';
link.body2='Chassis';
link.location1=[-1.690;-0.580;0.167]; % Confirmed
link.location2=[-1.590;-0.190;0.146];
the_system.item{end+1}=link;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

link.name='Left front drop link';
link.body1='Left front anti-roll bar';
link.body2='Left front bell-crank';
link.location1=[-0.138584;0.199871; 0.115307];      %Confirmed[-.112182;.199871; .076421]pivot point
link.location2=[-0.090767;0.212616;0.128304];  %Confirmed 
the_system.item{end+1}=link;

link.name='Right front drop link';
link.body1='Right front anti-roll bar';
link.body2='Right front bell-crank';
link.location1=[-0.138584;-0.199871;0.115307];  %Confirmed [-.112182;-.199871; .076421]pivot
link.location2=[-0.090767;-0.212616;0.128304];  %Confirmed 
the_system.item{end+1}=link;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.type='rigid_point';
point.name='Left front wheel bearing';
point.body1='Left front wheel+hub';
point.body2='Left front upright';
point.location=[-0.0000;0.598057;0.253566];  % Bearing middle point Confirmed
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='Right front wheel bearing';
point.body1='Right front wheel+hub';
point.body2='Right front upright';
point.location=[-0.0000;-0.598057;0.253566];  % Middle point Confirmed
the_system.item{end+1}=point;

point.name='Left rear wheel bearing';
point.body1='Left rear wheel+hub';
point.body2='Left rear upright';
point.location=[-1.589982;.579286;0.26154];  %Confirmed middle point
the_system.item{end+1}=point;

point.name='Right rear wheel bearing';
point.body1='Right rear wheel+hub';
point.body2='Right rear upright';
point.location=[-1.589982;-0.579286;0.26154];  %Confirmed middle point
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                               

point.name='Left front lower ball joint';
point.body1='Left front upright';
point.body2= 'Left front lower A-arm';
point.location=[0.002;0.600;0.121]; % Confirmed
point.forces=3;  % NS 
point.moments=0;  % NS
the_system.item{end+1}=point;

point.name='Right front lower ball joint';
point.body1='Right front upright';
point.body2= 'Right front lower A-arm';
point.location=[0.002;-0.600;0.121]; % Confirmed
the_system.item{end+1}=point;

point.name='Left rear lower ball joint';
point.body1='Left rear upright';
point.body2= 'Left rear lower A-arm';
point.location=[-1.590;.595;.125]; % Confirmed
the_system.item{end+1}=point;

point.name='Right rear lower ball joint';
point.body1='Right rear upright';
point.body2= 'Right rear lower A-arm';
point.location=[-1.590;-.595;.125]; % Confirmed
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front upper ball joint';
point.body1='Left front upright';
point.body2= 'Left front upper A-arm';
point.location=[-.010;.579;.374]; % Confirmed
point.forces=3; % NS
point.moments=0; % NS
the_system.item{end+1}=point;

point.name='Right front upper ball joint';
point.body1='Right front upright';
point.body2= 'Right front upper A-arm';
point.location=[-.010;-.579;.374]; % Confirmed
the_system.item{end+1}=point;

point.name='Left rear upper ball joint';
point.body1='Left rear upright';
point.body2= 'Left rear upper A-arm';
point.location=[-1.560;0.556;0.387]; % Confirmed
the_system.item{end+1}=point;

point.name='Right rear upper ball joint';
point.body1='Right rear upright';
point.body2= 'Right rear upper A-arm';
point.location=[-1.560;-0.556;0.387]; % Confirmed
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front lower A-arm pivot, rear';
point.body1='Left front lower A-arm';
point.body2='Chassis';
point.location=[-.275;0.210;0.108]; % Confirmed
point.forces=3; % NS
point.moments=0; % NS
the_system.item{end+1}=point;

point.name='Right front lower A-arm pivot, rear';
point.body1='Right front lower A-arm';
point.body2='Chassis';
point.location=[-.275;-0.210;0.108]; % Confirmed
the_system.item{end+1}=point;

point.name='Left rear lower A-arm pivot, rear';
point.body1='Left rear lower A-arm';
point.body2='Chassis';
point.location=[-1.590;0.160;0.105]; % Confirmed
the_system.item{end+1}=point;

point.name='Right rear lower A-arm pivot, rear';
point.body1='Right rear lower A-arm';
point.body2='Chassis';
point.location=[-1.590;-0.160;0.105]; % Confirmed
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front lower A-arm pivot, front';
point.body1='Left front lower A-arm';
point.body2='Chassis';
point.location=[0.002;0.185;0.103]; % Confirmed
point.forces=3; % NS
point.moments=0; % NS
the_system.item{end+1}=point;

point.name='Right front lower A-arm pivot, front';
point.body1='Right front lower A-arm';
point.body2='Chassis';
point.location=[0.002;-0.185;0.103]; % Confirmed
the_system.item{end+1}=point;

point.name='Left rear lower A-arm pivot, front';
point.body1='Left rear lower A-arm';
point.body2='Chassis';
point.location=[-1.225;0.285;0.145]; % Confirmed
the_system.item{end+1}=point;

point.name='Right rear lower A-arm pivot, front';
point.body1='Right rear lower A-arm';
point.body2='Chassis';
point.location=[-1.225;-0.285;0.145]; % Confirmed
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front upper A-arm pivot, rear';
point.body1='Left front upper A-arm';
point.body2='Chassis';
point.location=[-0.260;0.305;0.295]; % Confirmed
point.forces=3; % ns
point.moments=0;% ns
the_system.item{end+1}=point;

point.name='Right front upper A-arm pivot, rear';
point.body1='Right front upper A-arm';
point.body2='Chassis';
point.location=[-0.260;-0.305;0.295]; % Confirmed
the_system.item{end+1}=point;

point.name='Left rear upper A-arm pivot, rear';
point.body1='Left rear upper A-arm';
point.body2='Chassis';
point.location=[-1.560;0.275;0.305]; % Confirmed
the_system.item{end+1}=point;

point.name='Right rear upper A-arm pivot, rear';
point.body1='Right rear upper A-arm';
point.body2='Chassis';
point.location=[-1.560;-0.275;0.305]; % Confirmed
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front upper A-arm pivot, front';
point.body1='Left front upper A-arm';
point.body2='Chassis';
point.location=[-0.10;0.325;0.300]; % Confirmed
point.forces=3; % NS
point.moments=0;% NS
the_system.item{end+1}=point;

point.name='Right front upper A-arm pivot, front';
point.body1='Right front upper A-arm';
point.body2='Chassis';
point.location=[-0.10;-0.325;0.300]; % Confirmed
the_system.item{end+1}=point;

point.name='Left rear upper A-arm pivot, front';
point.body1='Left rear upper A-arm';
point.body2='Chassis';
point.location=[-1.245;0.295;0.345]; % Confirmed
the_system.item{end+1}=point;

point.name='Right rear upper A-arm pivot, front';
point.body1='Right rear upper A-arm';
point.body2='Chassis';
point.location=[-1.245;-0.295;0.345]; % Confirmed
the_system.item{end+1}=point;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front bell-crank pivot';
point.body1='Left front bell-crank';
point.body2='Chassis';
point.location=[-0.093188;0.189554;0.113231]; % Confirmed
point.forces=3;
point.moments=2;
point.axis=[0;-1;1]/norm([0;1;1]);
the_system.item{end+1}=point;

point.name='Right front bell-crank pivot';
point.body1='Right front bell-crank';
point.body2='Chassis';
point.location=[-0.093188;-0.189554;0.113231]; % Confirmed
point.axis=[0;1;1]/norm([0;1;1]);
the_system.item{end+1}=point;

point.name='Left rear bell-crank pivot';
point.body1='Left rear bell-crank';
point.body2='Chassis';
point.location=[-1.503582;0.229334;0.136753]; % Confirmed
point.axis=[0;-1;1]/norm([0;1;1]);
the_system.item{end+1}=point;

point.name='Right rear bell-crank pivot';
point.body1='Right rear bell-crank';
point.body2='Chassis';
point.location=[-1.503582; -0.229334;0.136753]; % Confirmed
point.axis=[0;1;1]/norm([0;1;1]);
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front anti-roll bar pivot';
point.body1='Left front anti-roll bar';
point.body2='Chassis';
%point.location=[-0.112182;0.199871;0.076421]; % Confirmed
point.location=[-0.114226;0.134088;0.081531]; % Confirmed
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='Right front anti-roll bar pivot';       
point.body1='Right front anti-roll bar';
point.body2='Chassis';
%point.location=[-0.112182;-0.199871;0.076421]; % Confirmed
point.location=[-0.114226;-0.134088;0.081531]; %Confirmed
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spring.type='spring';
spring.name='Left front suspension spring';
spring.location1=[-0.11709;0.272811;0.1574408]; % Confirmed
spring.location2=[-0.282485;0.218547;0.152439]; % Confirmed                      
spring.body1='Left front bell-crank';
spring.body2='Chassis';
spring.stiffness=30000;%
spring.damping=500;
the_system.item{end+1}=spring;

spring.name='Right front suspension spring';
spring.location1=[-0.11709;-0.272811;0.1574408]; % Confirmed
spring.location2=[-0.282485;-0.218547;0.152439]; % Confirmed   
spring.body1='Right front bell-crank';
spring.body2='Chassis';
the_system.item{end+1}=spring;

spring.name='Left rear suspension spring';
spring.location1=[-1.490944;0.266089;0.166599];     % Confirmed  
spring.location2=[-1.313152;0.281263;0.161913];    % Confirmed                  
spring.body1='Left rear bell-crank';
spring.body2='Chassis';
spring.stiffness=17513; %N/m (100 lb/in)
spring.damping=500;
the_system.item{end+1}=spring;

spring.name='Right rear suspension spring';
spring.location1=[-1.490944;-0.266089;0.166599];     % Confirmed  
spring.location2=[-1.313152;-0.281263;0.161913];    % Confirmed                 
spring.body1='Right rear bell-crank';
spring.body2='Chassis';
the_system.item{end+1}=spring;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spring.name='Front anti-roll bar';
spring.location1=[-0.112182;0.199871;0.076421];     % Confirmed
spring.location2=[-0.112182;-0.199871;0.076421];    % Confirmed
spring.body1='Left front anti-roll bar';
spring.body2='Right front anti-roll bar';
spring.stiffness=11;
spring.damping=1;
spring.twist=1;
the_system.item{end+1}=spring;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point={};
%item.type='flex_point';
point.type='rigid_point';  % only for finding roll centre
point.name='Left front tire, vertical';
point.body1='Left front wheel+hub';
point.body2='ground';
point.location=[-0.00005;0.64;0];   %%%% Need to ask
point.forces=2;
point.moments=0;
item.stiffness=[150000;0];
point.axis=[0;1;0];
point.rolling_axis=[0;1;0];
the_system.item{end+1}=point;

point.name='Right front tire, vertical';
point.body1='Right front wheel+hub';
point.body2='ground';
point.location=[-.00005;-0.64;0];
the_system.item{end+1}=point;

point.name='Left rear tire, vertical';
point.body1='Left rear wheel+hub';
point.body2='ground';
point.location=[-1.589982;0.64;0];
the_system.item{end+1}=point;

point.name='Right rear tire, vertical';
point.body1='Right rear wheel+hub';
point.body2='ground';
point.location=[-1.589982;-0.64;0];
the_system.item{end+1}=point;










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
%  
%  item.type='actuator';
%  item.name='chassis actuator';
%  item.location1=[0.0;0;0.3];
%  item.location2=[0.0;0;0.2];
%  item.body1='Chassis';
%  item.body2='ground';
%  the_system.item{end+1}=item;
%  item={};
%  
%  
%  item.type='sensor';
%  item.name='chassis sensor';
%  item.location1=[0.0;0;0.3];
%  item.location2=[0.0;0;0.2];
%  item.body1='Chassis';
%  item.body2='ground';
%  the_system.item{end+1}=item;
%  item={};



