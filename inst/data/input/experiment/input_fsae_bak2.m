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

g=9.81; % set gravity on

body.type='body';
body.name='Chassis';
body.mass=300;
%body.mass=27.851;  %% Frame alone
body.momentsofinertia=[41.6;90.7;123];
body.location=[-0.777;0.0;0.330];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

body.type='body';
body.name='Left front upright';
body.mass=0.274;
body.momentsofinertia=[0.002;0.002;0.000185];
body.productsofinertia=[0;0;0];
body.location=[-0.007;0.599;0.253];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right front upright';
body.location=[-0.007;-0.599;0.253];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Left rear upright';
body.location=[-1.58;0.587;0.26];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right rear upright';
body.location=[-1.58;-0.587;0.26];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

body.name='Left front wheel+hub';
body.mass=20.5;
body.momentsofinertia=[0.582;0.943;0.523];
body.productsofinertia=[0;0;0];
body.location=[0;0.641;0.260];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right front wheel+hub';
body.location=[0;-0.641;0.260];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Left rear wheel+hub';
body.location=[-1.590;0.629;0.260];% Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right rear wheel+hub';
body.location=[-1.590;-0.629;0.260];% Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

body.name='Left front lower A-arm';
body.mass=0.052;
body.momentsofinertia=[0.000955;0.000521;0.001];
body.productsofinertia=[0;0;0];
body.location=[-0.073;0.379;0.112]; % Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right front lower A-arm';
body.location=[-0.073;-0.379;0.112]; % Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Left rear lower A-arm';
body.location=[-1.488;0.394;0.125]; % Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right rear lower A-arm';
body.location=[-1.488;-0.394;0.125]; % Confirmed
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

body.name='Left front upper A-arm';
body.mass=0.037;
body.momentsofinertia=[.000372;.000368;.00068]; % Confirmed
body.productsofinertia=[0;0;0]; % Confirmed
body.location=[-0.084;0.431;0.331]; % Confirmed 
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right front upper A-arm';
body.location=[-0.084;-0.431;0.331];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Left rear upper A-arm';
body.location=[-1.464;0.407;0.354]; 
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right rear upper A-arm';
body.location=[-1.464;-0.407;0.354];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

body.name='Left front bell-crank';
% body.mass=0.025;
body.mass=0.052;
body.momentsofinertia=[0.00000855;0.00000645;0.0000085];
body.productsofinertia=[0;0;0];
body.location=[-0.089;0.203;0.122]; 
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right front bell-crank';
body.location=[-0.087;-0.203;0.122]; 
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Left rear bell-crank';
body.location=[-1.507;0.240;0.146]; 
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Right rear bell-crank';
body.location=[-1.507;-0.240;0.146]; 
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% body.name='Left front anti-roll bar';
% body.mass=0.126;
% body.momentsofinertia=[0.0003975;0;.0003975];
% body.productsofinertia=[0;0;0];
% %body.location=[-.114226;.134088;.081531]; %Confirmed
% body.location=[-0.112182;0.199871;0.076421]; % Confirmed
% the_system.item{end+1}=body;
% the_system.item{end+1}=weight(body,g);
% 
% body.name='Right front anti-roll bar';
% %body.location=[-.114226;-.134088;.081531]; % Confirmed
% body.location=[-0.112182;-0.199871;0.076421]; % Confirmed
% the_system.item{end+1}=body;
% the_system.item{end+1}=weight(body,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

link.type='link';
link.name='Left front pull rod';
link.body1='Left front upper A-arm';
link.body2='Left front bell-crank';
link.location1=[-0.010;0.579;0.375];
link.location2=[-0.041;0.213;0.116]; 
the_system.item{end+1}=link;

link.name='Right front pull rod';
link.body1='Right front upper A-arm';
link.body2='Right front bell-crank';
link.location1=[-0.010;-0.579;0.375];
link.location2=[-0.041;-0.213;0.116];
the_system.item{end+1}=link;

link.name='Left rear pull rod';
link.body1='Left rear upper A-arm';
link.body2='Left rear bell-crank';
link.location1=[-1.560;0.556;0.387];
link.location2=[-1.532;0.237;0.147];
the_system.item{end+1}=link;

link.name='Right rear pull rod';
link.body1='Right rear upper A-arm';
link.body2='Right rear bell-crank';
link.location1=[-1.560;-0.556;0.387];
link.location2=[-1.532;-0.237;0.147];
the_system.item{end+1}=link;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

link.name='Left front tie rod';
link.body1='Left front upright';
link.body2='Chassis';
link.location1=[0.065;0.580;0.183];
link.location2=[0.060;0.228;0.146];
the_system.item{end+1}=link;

link.name='Right front tie rod';
link.body1='Right front upright';
link.body2='Chassis';
link.location1=[0.065;-0.580;0.183];
link.location2=[0.060;-0.228;0.146];
the_system.item{end+1}=link;

link.name='Left rear tie rod';
link.body1='Left rear upright';
link.body2='Chassis';
link.location1=[-1.690;0.580;0.167];
link.location2=[-1.590;0.190;0.146];
the_system.item{end+1}=link;

link.name='Right rear tie rod';
link.body1='Right rear upright';
link.body2='Chassis';
link.location1=[-1.690;-0.580;0.167];
link.location2=[-1.590;-0.190;0.146];
the_system.item{end+1}=link;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% link.name='Left front drop link';
% link.body1='Left front anti-roll bar';
% link.body2='Left front bell-crank';
% link.location1=[-0.139;0.200;0.115];
% link.location2=[-0.091;0.213;0.128];
% the_system.item{end+1}=link;
% 
% link.name='Right front drop link';
% link.body1='Right front anti-roll bar';
% link.body2='Right front bell-crank';
% link.location1=[-0.139;-0.200;0.115];
% link.location2=[-0.091;-0.213;0.128]; 
% the_system.item{end+1}=link;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.type='rigid_point';
point.name='Left front hub bearing';
point.body1='Left front wheel+hub';
point.body2='Left front upright';
point.location=[0;0.598;0.260];
point.forces=3;
point.moments=3; %%%%%%%%%%%%%%%%%%%%%%5
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='Right front hub bearing';
point.body1='Right front wheel+hub';
point.body2='Right front upright';
point.location=[0;-0.598;0.260];
the_system.item{end+1}=point;

point.name='Left rear hub bearing';
point.body1='Left rear wheel+hub';
point.body2='Left rear upright';
point.location=[-1.590;0.579;0.260];
the_system.item{end+1}=point;

point.name='Right rear hub bearing';
point.body1='Right rear wheel+hub';
point.body2='Right rear upright';
point.location=[-1.590;-0.579;0.260];
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front lower ball joint';
point.body1='Left front upright';
point.body2= 'Left front lower A-arm';
point.location=[0.002;0.600;0.121];
point.forces=3; 
point.moments=0;
the_system.item{end+1}=point;

point.name='Right front lower ball joint';
point.body1='Right front upright';
point.body2= 'Right front lower A-arm';
point.location=[0.002;-0.600;0.121];
the_system.item{end+1}=point;

point.name='Left rear lower ball joint';
point.body1='Left rear upright';
point.body2= 'Left rear lower A-arm';
point.location=[-1.590;0.595;0.125];
the_system.item{end+1}=point;

point.name='Right rear lower ball joint';
point.body1='Right rear upright';
point.body2= 'Right rear lower A-arm';
point.location=[-1.590;-0.595;0.125];
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front upper ball joint';
point.body1='Left front upright';
point.body2= 'Left front upper A-arm';
point.location=[-0.010;0.579;0.374];
point.forces=3;
point.moments=0;
the_system.item{end+1}=point;

point.name='Right front upper ball joint';
point.body1='Right front upright';
point.body2= 'Right front upper A-arm';
point.location=[-0.010;-0.579;0.374];
the_system.item{end+1}=point;

point.name='Left rear upper ball joint';
point.body1='Left rear upright';
point.body2= 'Left rear upper A-arm';
point.location=[-1.560;0.556;0.387];
the_system.item{end+1}=point;

point.name='Right rear upper ball joint';
point.body1='Right rear upright';
point.body2= 'Right rear upper A-arm';
point.location=[-1.560;-0.556;0.387];
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front lower A-arm pivot, rear';
point.body1='Left front lower A-arm';
point.body2='Chassis';
point.location=[-0.275;0.210;0.108];
point.forces=3;
point.moments=0;
the_system.item{end+1}=point;

point.name='Right front lower A-arm pivot, rear';
point.body1='Right front lower A-arm';
point.body2='Chassis';
point.location=[-0.275;-0.210;0.108];
the_system.item{end+1}=point;

point.name='Left rear lower A-arm pivot, rear';
point.body1='Left rear lower A-arm';
point.body2='Chassis';
point.location=[-1.590;0.160;0.105];
the_system.item{end+1}=point;

point.name='Right rear lower A-arm pivot, rear';
point.body1='Right rear lower A-arm';
point.body2='Chassis';
point.location=[-1.590;-0.160;0.105];
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front lower A-arm pivot, front';
point.body1='Left front lower A-arm';
point.body2='Chassis';
point.location=[0.002;0.185;0.103];
point.forces=3;
point.moments=0;
the_system.item{end+1}=point;

point.name='Right front lower A-arm pivot, front';
point.body1='Right front lower A-arm';
point.body2='Chassis';
point.location=[0.002;-0.185;0.103];
the_system.item{end+1}=point;

point.name='Left rear lower A-arm pivot, front';
point.body1='Left rear lower A-arm';
point.body2='Chassis';
point.location=[-1.225;0.285;0.145];
the_system.item{end+1}=point;

point.name='Right rear lower A-arm pivot, front';
point.body1='Right rear lower A-arm';
point.body2='Chassis';
point.location=[-1.225;-0.285;0.145];
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front upper A-arm pivot, rear';
point.body1='Left front upper A-arm';
point.body2='Chassis';
point.location=[-0.260;0.305;0.295];
point.forces=3;
point.moments=0;
the_system.item{end+1}=point;

point.name='Right front upper A-arm pivot, rear';
point.body1='Right front upper A-arm';
point.body2='Chassis';
point.location=[-0.260;-0.305;0.295];
the_system.item{end+1}=point;

point.name='Left rear upper A-arm pivot, rear';
point.body1='Left rear upper A-arm';
point.body2='Chassis';
point.location=[-1.560;0.275;0.305];
the_system.item{end+1}=point;

point.name='Right rear upper A-arm pivot, rear';
point.body1='Right rear upper A-arm';
point.body2='Chassis';
point.location=[-1.560;-0.275;0.305];
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front upper A-arm pivot, front';
point.body1='Left front upper A-arm';
point.body2='Chassis';
point.location=[-0.100;0.325;0.300];
point.forces=3;
point.moments=0;
the_system.item{end+1}=point;

point.name='Right front upper A-arm pivot, front';
point.body1='Right front upper A-arm';
point.body2='Chassis';
point.location=[-0.100;-0.325;0.300];
the_system.item{end+1}=point;

point.name='Left rear upper A-arm pivot, front';
point.body1='Left rear upper A-arm';
point.body2='Chassis';
point.location=[-1.245;0.295;0.345];
the_system.item{end+1}=point;

point.name='Right rear upper A-arm pivot, front';
point.body1='Right rear upper A-arm';
point.body2='Chassis';
point.location=[-1.245;-0.295;0.345];
the_system.item{end+1}=point;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

point.name='Left front bell-crank pivot';
point.body1='Left front bell-crank';
point.body2='Chassis';
% point.location=[-0.093;0.190;0.113];
point.location=[-0.092;0.183;0.124];
point.forces=3;
point.moments=2;
% point.axis=[0;-1;1]/norm([0;1;1]);
point.axis=[0.436;-2.757;4.148]/norm([0.436;-2.757;4.148]);
the_system.item{end+1}=point;

point.name='Right front bell-crank pivot';
point.body1='Right front bell-crank';
point.body2='Chassis';
% point.location=[-0.093;-0.190;0.113];
point.location=[-0.092;-0.183;0.124];
% point.axis=[0;1;1]/norm([0;1;1]);
point.axis=[0.436;2.757;4.148]/norm([0.436;2.757;4.148]);
the_system.item{end+1}=point;

point.name='Left rear bell-crank pivot';
point.body1='Left rear bell-crank';
point.body2='Chassis';
% point.location=[-1.504;0.229;0.137];
point.location=[-1.503;0.221;0.147];
% point.axis=[0;-1;1]/norm([0;1;1]);
point.axis=[0.37;-3.166;3.852]/norm([0.37;-3.166;3.852]);
the_system.item{end+1}=point;

point.name='Right rear bell-crank pivot';
point.body1='Right rear bell-crank';
point.body2='Chassis';
% point.location=[-1.504; -0.229;0.137];
point.location=[-1.503;-0.221;0.147];
% point.axis=[0;1;1]/norm([0;1;1]);
point.axis=[0.37;3.166;3.852]/norm([0.37;3.166;3.852]);
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% point.name='Left front anti-roll bar pivot';
% point.body1='Left front anti-roll bar';
% point.body2='Chassis';
% point.location=[-0.114;0.134;0.082];
% point.forces=3;
% point.moments=2;
% point.axis=[0;1;0];
% the_system.item{end+1}=point;
% 
% point.name='Right front anti-roll bar pivot';
% point.body1='Right front anti-roll bar';
% point.body2='Chassis';
% point.location=[-0.114;-0.134;0.082];
% the_system.item{end+1}=point;

point={};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spring.type='spring';
spring.name='Left front suspension spring';
spring.location1=[-0.117;0.273;0.157];
spring.location2=[-0.282;0.219;0.152];
spring.body1='Left front bell-crank';
spring.body2='Chassis';
spring.stiffness=17513*2;  %% (200 lb/in ???? guess!)
spring.damping=1500;
the_system.item{end+1}=spring;

spring.name='Right front suspension spring';
spring.location1=[-0.117;-0.273;0.157];
spring.location2=[-0.282;-0.219;0.152];
spring.body1='Right front bell-crank';
spring.body2='Chassis';
the_system.item{end+1}=spring;

spring.name='Left rear suspension spring';
spring.location1=[-1.491;0.266;0.167];
spring.location2=[-1.313;0.281;0.162];
spring.body1='Left rear bell-crank';
spring.body2='Chassis';
spring.stiffness=17513;  %% (100 lb/in)
spring.damping=1500;
the_system.item{end+1}=spring;

spring.name='Right rear suspension spring';
spring.location1=[-1.491;-0.266;0.167];
spring.location2=[-1.313;-0.281;0.162];
spring.body1='Right rear bell-crank';
spring.body2='Chassis';
the_system.item{end+1}=spring;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% spring.name='Front anti-roll bar';
% spring.location1=[-0.112;0.200;0.076];
% spring.location2=[-0.112;-0.200;0.076];
% spring.body1='Left front anti-roll bar';
% spring.body2='Right front anti-roll bar';
% spring.stiffness=110;
% spring.damping=0;
% spring.twist=1;
% the_system.item{end+1}=spring;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


point.type='flex_point';
point.name='Left front tire, vertical';
point.body1='Left front wheel+hub';
point.body2='ground';
point.location=[0;0.64;0];
point.forces=1;
point.moments=0;
point.stiffness=[150000;0];
point.axis=[0;0;1];
point.rolling_axis=[0;1;0];
the_system.item{end+1}=point;

point.name='Left rear tire, vertical';
point.body1='Left rear wheel+hub';
point.body2='ground';
point.location=[-1.590;0.64;0];
the_system.item{end+1}=point;

point.name='Right front tire, vertical';
point.body1='Right front wheel+hub';
point.body2='ground';
point.location=[0;-0.64;0];
the_system.item{end+1}=point;

point.name='Right rear tire, vertical';
point.body1='Right rear wheel+hub';
point.body2='ground';
point.location=[-1.590;-0.64;0];
the_system.item{end+1}=point;




%% Add external force between unsprung mass and sprung mass
item.type='actuator';
item.name='lf tire, lateral';
item.body1='Left front wheel+hub';
item.body2='ground';
item.gain=1;
item.location1=[0;0.640;0];
item.location2=[0;0.640-0.1;0];
the_system.item{end+1}=item;

item.name='lr tire, lateral';
item.body1='Left rear wheel+hub';
item.body2='ground';
item.gain=1;
item.location1=[-1.590;0.640;0];
item.location2=[-1.590;0.640-0.1;0];
the_system.item{end+1}=item;

item.name='rf tire, lateral';
item.body1='Right front wheel+hub';
item.body2='ground';
item.gain=1;
item.location1=[0;-0.640;0];
item.location2=[0;-0.640-0.1;0];
the_system.item{end+1}=item;

item.name='rr tire, lateral';
item.body1='Right rear wheel+hub';
item.body2='ground';
item.gain=1;
item.location1=[-1.590;-0.640;0];
item.location2=[-1.590;-0.640-0.1;0];
the_system.item{end+1}=item;

item={};

%% Add measure between sprung mass and ground
item.type='sensor';
item.name='lf tire, vertical';
item.body1='Left front wheel+hub';
item.body2='ground';
item.location1=[0;0.640;0.260];
item.location2=[0;0.640;0];
item.gain=150000;
the_system.item{end+1}=item;

item.name='lr tire, vertical';
item.body1='Left rear wheel+hub';
item.body2='ground';
item.location1=[-1.590;0.640;0.260];
item.location2=[-1.590;0.640;0];
item.gain=150000;
the_system.item{end+1}=item;

item.name='rf tire, vertical';
item.body1='Right front wheel+hub';
item.body2='ground';
item.location1=[0;-0.640;0.260];
item.location2=[0;-0.640;0];
item.gain=150000;
the_system.item{end+1}=item;

item.name='rr tire, vertical';
item.body1='Right rear wheel+hub';
item.body2='ground';
item.location1=[-1.590;-0.640;0.260];
item.location2=[-1.590;-0.640;0];
item.gain=150000;
the_system.item{end+1}=item;

item={};

item.type='sensor';
item.name='lf tire, lateral';
item.body1='Left front wheel+hub';
item.body2='ground';
item.gain=1;
item.location1=[0;0.640;0];
item.location2=[0;0.640-0.1;0];
the_system.item{end+1}=item;

item.name='lr tire, lateral';
item.body1='Left rear wheel+hub';
item.body2='ground';
item.gain=1;
item.location1=[-1.590;0.640;0];
item.location2=[-1.590;0.640-0.1;0];
the_system.item{end+1}=item;

item.name='rf tire, lateral';
item.body1='Right front wheel+hub';
item.body2='ground';
item.gain=1;
item.location1=[0;-0.640;0];
item.location2=[0;-0.640-0.1;0];
the_system.item{end+1}=item;

item.name='rr tire, lateral';
item.body1='Right rear wheel+hub';
item.body2='ground';
item.gain=1;
item.location1=[-1.590;-0.640;0];
item.location2=[-1.590;-0.640-0.1;0];
the_system.item{end+1}=item;

item={};
item.type='sensor';
item.name='$z_G$';
item.body1='Chassis';
item.body2='ground';
item.location1=[-0.777;0;0.33];
item.location2=[-0.877;0;0.33];
the_system.item{end+1}=item;

item.type='actuator';
item.name='Aero forces';
the_system.item{end+1}=item;

for i=1:length(the_system.item)
	if(isfield(the_system.item{i},'location'))
		the_system.item{i}.location=the_system.item{i}.location+[0.777;0;0];
	end
	if(isfield(the_system.item{i},'location1'))
		the_system.item{i}.location1=the_system.item{i}.location1+[0.777;0;0];
	end
	if(isfield(the_system.item{i},'location2'))
		the_system.item{i}.location2=the_system.item{i}.location2+[0.777;0;0];
	end
end


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



