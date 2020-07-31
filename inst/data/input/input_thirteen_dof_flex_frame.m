function the_system=input_thirteen_dof_flex_frame(varargin)
the_system.item={};

% add rigid body Msf
body.type='body';
body.name='Msf';
body.location=[2.655;0;1.0];
body.mass=800;
body.momentsofinertia=[211;1900;0];
body.productsofinertia=[0;0;0];
the_system.item{end+1}=body;

% add rigid body Msb along z-axis
body.name='Msb';
body.location=[0.45;0;1.0];
body.mass=5280;
body.momentsofinertia=[1393;12545;0];
body.productsofinertia=[0;0;0];
the_system.item{end+1}=body;

% add rigid body Msr 
body.name='Msr';
body.location=[-3;0;1.0];
body.mass=1500;
body.momentsofinertia=[395;3564;0];
body.productsofinertia=[0;0;0];
the_system.item{end+1}=body;

% add rigid body Mufl
body.name='Mufl';
body.location=[2.655;0.9725;0.5];
body.mass=870;
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
the_system.item{end+1}=body;

% add rigid body Mufr
body.name='Mufr';
body.location=[2.655;-0.9725;0.5];
body.mass=870;
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
the_system.item{end+1}=body;

% add rigid body Murl
body.name='Murl';
body.location=[-3;0.9725;0.5];
body.mass=1550;
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
the_system.item{end+1}=body;

% add rigid body Murr
body.name='Murr';
body.location=[-3;-0.9725;0.5];
body.mass=1550;
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
the_system.item{end+1}=body;

% add beam to connect Msf to Msb
item.type='beam';
item.name='beam1';
item.location1=[2.655;0;1.0];
item.location2=[0.45;0;1.0];
item.body1='Msf';
item.body2='Msb';
item.stiffness=15e6/2.205;
the_system.item{end+1}=item;

% add beam to connect Msb to Msr
item.name='beam2';
item.location1=[0.45;0;1.0];
item.location2=[-3;0;1.0];
item.body1='Msb';
item.body2='Msr';
item.stiffness=15e6/3.45;
the_system.item{end+1}=item;
item={};


% add spring to connect Mufl to the ground
spring.type='flex_point';
spring.name='spring 1';
spring.location=[2.655;0.9725;0.25];
spring.body1='Mufl';
spring.body2='ground';
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
spring.stiffness=[2800000;0]; %(AE/L)
spring.damping=[0;0];
the_system.item{end+1}=spring;

% add spring to connect Mufl to Msf
spring.type='flex_point';
spring.name='spring 2';
spring.location=[2.655;0.9725;0.75];
spring.body1='Mufl';
spring.body2='Msf';
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
spring.stiffness=[374000;0]; %(AE/L)
spring.damping=[128500;0];
the_system.item{end+1}=spring;

% add spring to connect Mufr to the ground
spring.type='flex_point';
spring.name='spring 3';
spring.location=[2.655;-0.9725;0.25];
spring.body1='Mufr';
spring.body2='ground';
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
spring.stiffness=[2800000;0]; %(AE/L)
spring.damping=[0;0];
the_system.item{end+1}=spring;

% add spring to connect Mufr to Msf
spring.type='flex_point';
spring.name='spring 4';
spring.location=[2.655;-0.9725;0.75];
spring.body1='Mufr';
spring.body2='Msf';
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
spring.stiffness=[374000;0]; %(AE/L)
spring.damping=[128500;0];
the_system.item{end+1}=spring;

% add spring to connect Murl to the ground
spring.type='flex_point';
spring.name='spring 5';
spring.location=[-3;0.9725;0.25];
spring.body1='Murl';
spring.body2='ground';
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
spring.stiffness=[5400000;0];
spring.damping=[0;0];
the_system.item{end+1}=spring;

% add spring to connect Murl to Msr
spring.type='flex_point';
spring.name='spring 6';
spring.location=[-3;0.9725;0.75];
spring.body1='Murl';
spring.body2='Msr';
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
spring.stiffness=[870000;0];
spring.damping=[128500;0];
the_system.item{end+1}=spring;

% add spring to connect Murr to the ground
spring.type='flex_point';
spring.name='spring 7';
spring.location=[-3;-0.9725;0.25];
spring.body1='Murr';
spring.body2='ground';
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
spring.stiffness=[5400000;0];
spring.damping=[0;0];
the_system.item{end+1}=spring;

% add spring to connect Murr to Msr
spring.type='flex_point';
spring.name='spring 8';
spring.location=[-3;-0.9725;0.75];
spring.body1='Murr';
spring.body2='Msr';
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
spring.stiffness=[870000;0];
spring.damping=[128500;0];
the_system.item{end+1}=spring;

% add spring to connect Msf to Msb
spring.type='flex_point';
spring.name='spring 9';
spring.location=[1.3275;0;1.0];
spring.body1='Msf';
spring.body2='Msb';
spring.forces=0;
spring.moments=1;
spring.axis=[1;0;0];
spring.stiffness=[0;2204133];
spring.damping=[0;0];
the_system.item{end+1}=spring;

% add spring to connect Msb to Msr
spring.type='flex_point';
spring.name='spring 10';
spring.location=[-1.5;0;1.0];
spring.body1='Msb';
spring.body2='Msr';
spring.forces=0;
spring.moments=1;
spring.axis=[1;0;0];
spring.stiffness=[0;1408728];
spring.damping=[0;0];
the_system.item{end+1}=spring;

% constrain Mufl to translation in z-axis, no rotation
point.type='rigid_point';
point.name='slider 1';
point.body1='Mufl';
point.body2='ground';
point.location=[2.655;0.9725;0.5];
point.forces=2;
point.moments=3;
point.axis=[0;0;1];
the_system.item{end+1}=point;

% constrain Mufr to translation in z-axis, no rotation
point.name='slider 2';
point.body1='Mufr';
point.body2='ground';
point.location=[2.655;-0.9725;0.5];
the_system.item{end+1}=point;

% constrain Murl to translation in z-axis, no rotation
point.name='slider 3';
point.body1='Murl';
point.body2='ground';
point.location=[-3;0.9725;0.5];
the_system.item{end+1}=point;

% constrain Murr to translation in z-axis, no rotation
point.name='slider 4';
point.body1='Murr';
point.body2='ground';
point.location=[-3;-0.9725;0.5];
the_system.item{end+1}=point;

% constrain Msf
point.name='slider 5';
point.body1='Msf';
point.body2='ground';
point.location=[2.655;0;1.0];
point.forces=2;
point.moments=1;
point.axis=[0;0;1];
the_system.item{end+1}=point;

% constrain Msb
point.name='slider 6';
point.body1='Msb';
point.body2='ground';
point.location=[0.45;0;1.0];
point.forces=2;
point.moments=1;
point.axis=[0;0;1];
the_system.item{end+1}=point;

% constrain Msr
point.name='slider 7';
point.body1='Msr';
point.body2='ground';
point.location=[-3;0;1.0];
point.forces=2;
point.moments=1;
point.axis=[0;0;1];
the_system.item{end+1}=point;

%% Add external force between unsprung mass and ground (represents ground motion)
item.type='actuator';
item.name='front bump';
item.body1='Mufl';
item.body2='ground';
item.gain=2800000;
item.rategain=3000;
item.location1=[2.655;0.9725;0.5];
item.location2=[2.655;0.9725;0];
the_system.item{end+1}=item;
item={};

%% Add measure between ground and sprung mass
item.type='sensor';
item.name='front bounce';
item.body1='Msf';
item.body2='ground';
item.location1=[2.655;0.1;1.0];
item.location2=[2.655;0.1;0];
the_system.item{end+1}=item;

link.type='link';
link.name='Msf body';
link.body1='Msf';
link.body2='Msf';
link.location1=[2.655;0.9725;1];
link.location2=[2.655;-0.9725;1];
the_system.item{end+1}=link;

link.type='link';
link.name='Msb body';
link.body1='Msb';
link.body2='Msb';
link.location1=[0.45;0.9725;1];
link.location2=[0.45;-0.9725;1];
the_system.item{end+1}=link;

link.type='link';
link.name='Msr body';
link.body1='Msr';
link.body2='Msr';
link.location1=[-3;0.9725;1];
link.location2=[-3;-0.9725;1];
the_system.item{end+1}=link;

link.type='link';
link.name='beam_1 body';
link.body1='Msf';
link.body2='Msb';
link.location1=[2.655;0;1];
link.location2=[0.45;0;1];
the_system.item{end+1}=link;

link.type='link';
link.name='beam_2 body';
link.body1='Msb';
link.body2='Msr';
link.location1=[0.45;0;1];
link.location2=[-3;0;1];
the_system.item{end+1}=link;
