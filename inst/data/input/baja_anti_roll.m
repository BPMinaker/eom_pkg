function the_system=baja_anti_roll(varargin)
the_system.item={};
g=9.81;

%% Set defaults in case none are sent
params.kf=20000;  %% suspension stiffness
params.kr=20000;

params.kt=75000; %% tire stiffness
params.ct=10000; %% cornering stiffness

params.cf=100; %% suspension damping
params.cr=100;

params.krb=1000; %% anti-roll stiffness

params.r=0.253; %% tire radius

u=5; %% forward speed

%% Replace the defaults with the inputs
if(nargin()==2)  %% Are there two arguments? (ignore the first)
	if(isa(varargin{1},'struct'))  %% If so, is the second a struct?
		names=fieldnames(varargin{1});  %% If so, get the fieldnames
		for i=1:length(names)  %% For each fieldname
			if(isfield(params,names{i}))  %% Is this a field in our default?
				params.(names{i})=varargin{1}.(names{i});  %% If so, copy the field content to the default
			end
		end
	end
end


%% Define all bodies
item.type='body';
item.name='Chassis';
item.mass=200;
item.momentsofinertia=[22.331;51.266;56.038];
item.productsofinertia=[0;0;0];
item.location=[0.26;0;0.568];
item.velocity=[u;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.name='LF upper A-arm';
item.mass=0.683;
item.momentsofinertia=[0.008;0.005;0.01];
item.productsofinertia=[0.001;-0.003;0];
item.location=[0.994;0.318;0.435];
item.velocity=[u;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.name='LF lower A-arm';
item.mass=1.538;
item.momentsofinertia=[0.036;0.014;0.039];
item.productsofinertia=[0.004;-0.012;0];
item.location=[1.041;0.378;0.268];
item.velocity=[u;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.name='LF upright';
item.mass=0.64;
item.momentsofinertia=[0.001;0.001;0.0009];
item.productsofinertia=[0;0;0];
item.location=[1.039;0.578;0.279];
item.velocity=[u;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.name='LF wheel';
item.mass=5.556;
item.momentsofinertia=[0.134;0.236;0.134];
item.productsofinertia=[0;0;0];
item.location=[1.041;0.658;params.r];
item.velocity=[u;0;0];
item.angular_velocity=[0;u/params.r;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.name='LR trailing arm';
item.mass=3.1331;
item.momentsofinertia=[0.02;0.112;0.104];
item.productsofinertia=[-0.003;0;0.031];
item.location=[-0.321;0.434;0.291];
item.velocity=[u;0;0];
item.angular_velocity=[0;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.name='LR wheel';
item.mass=5.556;
item.momentsofinertia=[0.134;0.236;0.134];
item.productsofinertia=[0;0;0];
item.location=[-0.524;0.6;params.r];
item.velocity=[u;0;0];
item.angular_velocity=[0;u/params.r;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.name='LR arb arm';
item.mass=0.09;
item.momentsofinertia=[0.00007;0.0001;0.00006];
item.location=[-0.400;0.40;0.540];
item.velocity=[u;0;0];
item.angular_velocity=[0;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.name='Axle';
item.mass=5.0;
item.momentsofinertia=[0.81*5/12;0.01;0.81*5/12];
item.productsofinertia=[0;0;0];
item.location=[-0.524;0;params.r];
item.velocity=[u;0;0];
item.angular_velocity=[0;u/params.r;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item={};  %% Reset item properties before changing item type

%% Define all rigid connections
item.type='rigid_point';
item.name='LF upper A-arm front hinge';
item.location=[1.076;0.212;0.476];
item.body1='Chassis';
item.body2='LF upper A-arm';
item.forces=3;
item.moments=0;
item.axis=[1;0;0];
the_system.item{end+1}=item;


item.name='LF upper A-arm rear hinge';
item.location=[0.876;0.212;0.476];
item.body1='Chassis';
item.body2='LF upper A-arm';
item.forces=2;
item.moments=0;
item.axis=[1;0;0];
the_system.item{end+1}=item;


item.name='LF lower A-arm front hinge';
item.location=[1.118;0.185;0.309];
item.body1='Chassis';
item.body2='LF lower A-arm';
item.forces=3;
item.moments=0;
item.axis=[1;0;0];
the_system.item{end+1}=item;


item.name='LF lower A-arm rear hinge';
item.location=[0.918;0.185;0.309];
item.body1='Chassis';
item.body2='LF lower A-arm';
item.forces=2;
item.moments=0;
item.axis=[1;0;0];
the_system.item{end+1}=item;


item.name='LF upper ball-joint';
item.location=[1.04;0.539;0.35];
item.body1='LF upper A-arm';
item.body2='LF upright';
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;


item.name='LF lower ball-joint';
item.location=[1.06;0.568;0.207];
item.body1='LF lower A-arm';
item.body2='LF upright';
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;


item.name='LF wheel bearing';
item.location=[1.041;0.686;params.r];
item.body1='LF upright';
item.body2='LF wheel';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;


item.name='LR trailing arm bearing';
item.location=[-0.092;0.429;0.368];
item.body1='Chassis';
item.body2='LR trailing arm';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;


item.name='LR wheel bearing';
item.location=[-0.524;0.492;params.r];
item.body1='LR trailing arm';
item.body2='LR wheel';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;


item.name='LR arb mount';
item.location=[-0.400;0.4;0.540];
item.body1='Chassis';
item.body2='LR arb arm';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item={};

%% Define all links
item.type='link';
item.name='LF tie-rod';
item.body1='Chassis';
item.body2='LF upright';
item.location1=[0.84;0.2064;0.376];
item.location2=[0.96;0.564;0.274];
the_system.item{end+1}=item;


item.name='LR drop link';
item.body1='LR arb arm';
item.body2='LR trailing arm';
item.location1=[-0.5;0.434;0.540];
item.location2=[-0.5;0.434;0.310];
the_system.item{end+1}=item;

item={};

%% Define all springs
item.type='spring';
item.name='LF shock';
item.location1=[0.947;0.252;0.652];
item.location2=[1.048;0.467;0.243];
item.body1='Chassis';
item.body2='LF lower A-arm';
item.stiffness=params.kf;
item.damping=params.cf;
the_system.item{end+1}=item;


item.name='LR shock';
item.location1=[-0.087;0.445;0.672];
item.location2=[-0.507;0.445;0.316];
item.body1='Chassis';
item.body2='LR trailing arm';
item.stiffness=params.kr;
item.damping=params.cr;
the_system.item{end+1}=item;

item={};

%% Define all bushings
%% Treat the contacting points of tire and ground as bushing
%% Vertical stiffness first
item.type='flex_point';
item.name='LF tire, vert';
item.body1='LF wheel';
item.body2='ground';
item.location=[1.041;0.658;0];
item.forces=1;
item.moments=0;
item.axis=[0;0;1];
item.rolling_axis=[0;1;0];
item.stiffness=[params.kt;0];
item.damping=[0;0];
the_system.item{end+1}=item;


item.name='LR tire, vert';
item.body1='LR wheel';
item.body2='ground';
item.location=[-0.524;0.6;0];
the_system.item{end+1}=item;


%% Add horizontal damping
item.name='LF tire, horiz';
item.body1='LF wheel';
item.body2='ground';
item.location=[1.041;0.658;0];
item.forces=2;
item.moments=0;
item.axis=[0;0;1];
item.stiffness=[0;0];
item.damping=[params.ct/u;0];
the_system.item{end+1}=item;


item.name='LR tire, horiz';
item.body1='LR wheel';
item.body2='ground';
item.location=[-0.524;0.6;0];
the_system.item{end+1}=item;

item={};

%% Add anti-roll bar
spring.type='spring';
spring.name='Anti roll bar';
spring.body1='LR arb arm';
spring.body2='RR arb arm';
spring.location1=[-0.4;0.4;0.540];
spring.location2=[-0.4;-0.4;0.540];
spring.stiffness=params.krb;
spring.damping=0;
spring.twist=1;
the_system.item{end+1}=spring;

item={};

%% Mirror all FF item to RF, LR to RR
the_system=mirror(the_system);

%% Add CV after mirror as not symmetric due to constraint
item.type='rigid_point';
item.name='LR CV';
item.location=[-0.524;0.45;params.r];
item.body1='Axle';
item.body2='LR wheel';
item.forces=3;
item.moments=1;
item.axis=[0;1;0];
the_system.item{end+1}=item;


item.name='RR CV';
item.location=[-0.524;-0.45;params.r];
item.body1='Axle';
item.body2='RR wheel';
item.forces=2;
item.moments=1;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item={};

%% Define outputs
item.type='sensor';
item.name='Front chassis motion';
item.body1='Chassis';
item.body2='ground';
item.location1=[1.041;-0.658;params.r];
item.location2=[1.041;-0.658;0.243];
the_system.item{end+1}=item;


item.name='Front suspension travel';
item.body1='RF wheel';
item.body2='Chassis';
item.location1=[1.041;-0.658;params.r];
item.location2=[1.041;-0.658;0.263];
the_system.item{end+1}=item;


item.name='Front tire compression';
item.body1='RF wheel';
item.body2='ground';
item.location1=[1.041;-0.658;0];
item.location2=[1.041;-0.658;-0.1];
item.actuator='Front wheel bump';
the_system.item{end+1}=item;


item.name='Rear tire compression';
item.body1='RR wheel';
item.body2='ground';
item.location1=[-0.524;-0.658;0];
item.location2=[-0.524;-0.658;-0.1];
item.twist=0;
item.gain=1;
the_system.item{end+1}=item;


item.name='Roll sensor';
item.body1='Chassis';
item.body2='ground';
item.location1=[0.48134;0.;0.56831];
item.location2=[0.58134;0;0.56831];
item.twist=1;
item.order=1;
the_system.item{end+1}=item;

item={};

%% Define inputs
item.type='actuator';
item.name='Front wheel bump';
item.body1='RF wheel';
item.body2='ground';
item.location1=[1.041;-0.658;0];
item.location2=[1.041;-0.658;-0.1];
item.twist=0;
item.gain=params.kt;
the_system.item{end+1}=item;


item.name='Roll moment';
item.body1='Chassis';
item.body2='ground';
item.location1=[0.48134;0.;0.56831];
item.location2=[0.58134;0;0.56831];
item.twist=1;
item.gain=1;
the_system.item{end+1}=item;
