function the_system=input_eight_dof_flex_frame(varargin)
the_system.item={};

% add rigid body Mur along z-axis
body.type='body';
body.name='Mur';
body.location=[0;0;0.5];
body.mass=1550;
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
the_system.item{end+1}=body;

% add rigid body Msr along z-axis
body.name='Msr';
body.location=[0;0;1.0];
body.mass=1500;
body.momentsofinertia=[3364;3364;3364];
body.productsofinertia=[0;0;0];
the_system.item{end+1}=body;

% add rigid body Msb 
body.name='Msb';
body.location=[3.45;0;1.0];
body.mass=5280;
body.momentsofinertia=[12545;12545;12545];
body.productsofinertia=[0;0;0];
the_system.item{end+1}=body;

% add rigid body Msf 
body.name='Msf';
body.location=[5.655;0;1.0];
body.mass=800;
body.momentsofinertia=[1900;1900;1900];
body.productsofinertia=[0;0;0];
the_system.item{end+1}=body;

% add rigid body Muf 
body.name='Muf';
body.location=[5.655;0;0.5];
body.mass=870;
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
the_system.item{end+1}=body;

% add spring to connect Mur to the ground
spring.type='flex_point';
spring.name='spring_1';
spring.location=[0;0;0.25];
spring.body1='Mur';
spring.body2='ground';
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
spring.stiffness=[5400000;0]; %(AE/L)
spring.damping=[0;0];
the_system.item{end+1}=spring;

% add another spring to connect rigid bodies Mur and Msr
spring.name='spring_2';
spring.location=[0;0;0.75];
spring.body1='Mur';
spring.body2='Msr';
spring.stiffness=[870000;0]; %(AE/L)
spring.damping=[128500;0];
the_system.item{end+1}=spring;

% add another spring to connect rigid bodies Msf and Muf
spring.name='spring_3';
spring.location=[5.655;0;0.75];
spring.body1='Msf';
spring.body2='Muf';
spring.stiffness=[374000;0]; %(AE/L)
spring.damping=[128500;0];
the_system.item{end+1}=spring;

% add another spring to connect rigid bodies Muf and ground
spring.name='spring_4';
spring.location=[5.655;0;0.25];
spring.body1='ground';
spring.body2='Muf';
spring.stiffness=[2800000;0]; %(AE/L)
spring.damping=[3000;0];
the_system.item{end+1}=spring;

% add beam to connect Msr to Msb
item.type='beam';
item.name='beam_1';
item.location1=[0;0;1.0];
item.location2=[3.45;0;1.0];
item.body1='Msr';
item.body2='Msb';
item.stiffness=9e6/3.45;
the_system.item{end+1}=item;

% add another beam to connect Msb to Msf
item.name='beam_2';
item.location1=[3.45;0;1.0];
item.location2=[5.655;0;1.0];
item.body1='Msb';
item.body2='Msf';
item.stiffness=9e6/(5.655-3.45);
the_system.item{end+1}=item;

% constrain Mur to translation in z-axis, no rotation
point.type='rigid_point';
point.name='slider 1';
point.body1='Mur';
point.body2='ground';
point.location=[0;0;0.5];
point.forces=2;
point.moments=3;
point.axis=[0;0;1];
the_system.item{end+1}=point;

% constrain Muf to translation in z-axis, no rotation
point.name='slider 2';
point.body1='Muf';
point.body2='ground';
point.location=[5.655;0;0.5];
the_system.item{end+1}=point;

% constrain Msr
point.name='slider 3';
point.body1='Msr';
point.body2='ground';
point.location=[0;0;1.0];
point.forces=2;
point.moments=0;
point.axis=[0;0;1];
the_system.item{end+1}=point;

point.name='slider 4';
point.body1='Msr';
point.body2='ground';
point.location=[0;0;1.0];
point.forces=0;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

% constrain Msb
point.name='slider 5';
point.body1='Msb';
point.body2='ground';
point.location=[3.45;0;1.0];
point.forces=2;
point.moments=0;
point.axis=[0;0;1];
the_system.item{end+1}=point;

point.name='slider 6';
point.body1='Msb';
point.body2='ground';
point.location=[3.45;0;1.0];
point.forces=0;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

%constrain Msf
point.name='slider 7';
point.body1='Msf';
point.body2='ground';
point.location=[5.655;0;1.0];
point.forces=2;
point.moments=0;
point.axis=[0;0;1];
the_system.item{end+1}=point;

point.name='slider 8';
point.body1='Msf';
point.body2='ground';
point.location=[5.655;0;1.0];
point.forces=0;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;


%% Add external force between unsprung mass and ground (represents ground motion)
item.type='actuator';
item.name='front bump';
item.body1='Muf';
item.body2='ground';
item.gain=2800000;
item.rategain=3000;
item.location1=[5.655;0;0.5];
item.location2=[5.655;0;0];
the_system.item{end+1}=item;
item={};

%% Add measure between ground and sprung mass
item.type='sensor';
item.name='front bounce';
item.body1='Msf';
item.body2='ground';
item.location1=[5.655;0.1;1.0];
item.location2=[5.655;0.1;0];
the_system.item{end+1}=item;

