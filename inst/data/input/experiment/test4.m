function the_system=test4(varargin,dummy)
the_system.item={};

% Trailing arm (Rigid)
l1=0.25; % length, m
l2=0.35; % twist beam axis to spring, m
l3=0.40; % twist beam axis to wheel spindle, m
l4=0.45; % twist beam axis to damper, m, assume l4>l3>l2
m=90*(l1+l4); % mass, kg, density of steel = 7769 kg/m^3

% Twist beam
l5=1.40; % total length, m
D=0.12; % beam outer diameter, m
d=0.10; % beam inner diameter, m
G=79300000000; % Modulus of rigidity, Pa
E=180000000000; % Young's Modulus, Pa

% Tire stiffness
K_tire=150000;

% Coil spring and damper properties
C=1500; % N*s/m
K=18000; % N/m

% Coefficients of the equation of motion,
% F_w-K_FT*y-K_FB*y=(M1+M2)*d^2y/dt^2+C1*dy/dt+K1*y
% where F_w=K_tire*y
M1=m*(0.5*(l1+l4))/(l1+l3);
C1=C*(l1+l4)/(l1+l3);
K1=K*(l1+l2)/(l1+l3);
K_FT=pi*((D^4)-(d^4))*G/(32*l3*l5*(l1+l3))
K_FB=3*E*pi*((D^4)-(d^4))*l1/(64*(l5^3)*(l1+l3))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add the trailing arm
body.type='body';
body.name='unsprung';
body.mass=m;
body.momentsofinertia=[0.1;m*(l1+l4)^2/12;m*(l1+l4)^2/12];
body.location=[(l1+l4)/2;0;0.3];
the_system.item{end+1}=body;

% Add sprung mass
body.name='sprung';
body.mass=500;
body.momentsofinertia=[0;0;0];
body.location=[0;l5;0.6];  %% move the y location to vehicle centreline
the_system.item{end+1}=body;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add a spring, with no damping, to connect our unsprung mass to ground, aligned with z-axis
% Note only one point, no direction
% Note also that flex points have can have both linear and torsional stiffness
spring.type='flex_point';
spring.name='tire';
spring.body1='unsprung';
spring.body2='ground';
spring.stiffness=[K_tire;0]; %(AE/L)
spring.damping=[0;0];
spring.location=[l1+l3;0;0.15];
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
the_system.item{end+1}=spring;
spring={}; %% clear this 'spring' variable


% Add a coil spring - note two end points
% Note only one value of stiffness, assumed to be linear or torsional based on 'twist'
spring.type='spring';
spring.name='coil spring';
spring.body1='sprung';
spring.body2='unsprung';
spring.stiffness=K; %(AE/L)
spring.location1=[l1+l2;0;0.85];  %% Guessing at z coordinate here
spring.location2=[l1+l2;0;0.45];
the_system.item{end+1}=spring;

% Add a shock absorber
spring.name='shock absorber';
% same bodies
spring.stiffness=0;
spring.damping=C;
spring.location1=[l1+l4;0;0.85];  %% Guessing at z coordinate here
spring.location2=[l1+l4;0;0.45];
the_system.item{end+1}=spring;

% % Torsional stiffness of the twist beam
spring.name='twist beam torsion';
% same bodies
spring.location1=[l1;l5;0.3];
spring.location2=[l1;0;0.3];
spring.stiffness=pi*((D^4)-(d^4))*G/(32*l5); % JG/L
spring.damping=0;
spring.twist=1;  %% 0 for deflection, 1 for rotational spring
the_system.item{end+1}=spring;
spring={}; %% clear this 'spring' variable

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rotating point of trailing arm
point.type='rigid_point';
point.name='rotation 1';
point.body1='unsprung';
point.body2='sprung';
point.location=[0;0;0.3];
point.forces=3;
point.moments=1;
point.axis=[0;0;1];
the_system.item{end+1}=point;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bending stiffness of the twist beam
item.type='beam';
item.name='twist beam bending';
item.location1=[l1;l5;0.3];
item.location2=[l1;0;0.3];
item.body1='sprung';
item.body2='unsprung';
item.stiffness=E*pi*((D^4)-(d^4))/(64*l5); % EI/L
the_system.item{end+1}=item;
item={};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fix sprung mass
point.type='rigid_point';
point.name='nail 1';
point.body1='sprung';
point.body2='ground';
point.location=[0;l5;0.6];
point.forces=2;
point.moments=3;
point.axis=[0;0;1];  %% Allow only z translation of sprung mass
the_system.item{end+1}=point;

%% Add external force between unsprung mass and ground (represents ground motion)
item.type='actuator';
item.name='$z_0$';
item.body1='unsprung';
item.body2='ground';
item.gain=150000;
item.location1=[l1+l3+0.05;0;0.3];
item.location2=[l1+l3+0.05;0;0];
the_system.item{end+1}=item;

item={};
% %% Add measure between ground and sprung mass
% item.type='sensor';
% item.name='$z_2$';
% item.body1='sprung';
% item.body2='ground';
% item.location1=[l1+l3;0.05;0.6];
% item.location2=[l1+l3;0.05;0];
% item.gain=1;
% the_system.item{end+1}=item;
% 
% %% Add measure between sprung and unsprung mass
% item.name='$z_2-z_1$';
% item.body1='sprung';
% item.body2='unsprung';
% item.location1=[l1+l3+0.05;0.05;0.6];
% item.location2=[l1+l3+0.05;0.05;0.3];
% the_system.item{end+1}=item;
% 
% %% Add measure between ground and unsprung mass
% item.name='$z_1$';
% item.body1='unsprung';
% item.body2='ground';
% item.location1=[l1+l3;0.1;0.3];
% item.location2=[l1+l3;0.1;0];
% the_system.item{end+1}=item;
