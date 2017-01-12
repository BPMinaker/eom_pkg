function the_system=baja_revised(kr,varargin)
the_system.item={};
g=9.81;

m=200; % chassis mass
h=0.568; % chassis cg height

v=5; % forward speed
r=0.253; % wheel radius

a=1.041;  % front wheelbase
b=0.524;  % rear wheelbase

tf=0.658; % front trackwidth/2
tr=0.6;  % rear trackwidth/2

params.kf=20000; % front spring stiffness
params.kr=20000; % rear spring stiffness
params.cf=1000; % front damping
params.cr=1000; % rear damping
% kr is the roll bar stiffness

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


%Define all bodies%
item.type='body';
item.name='Chassis';
item.mass=m;
item.momentsofinertia=[22.331;51.266;56.038];
item.productsofinertia=[0;0;0];
item.location=[0.26;0;h];
item.velocity=[v;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Left upper A-arm';
item.mass=0.683;
item.momentsofinertia=[0.008;0.005;0.01];
item.productsofinertia=[0.001;-0.003;0];
item.location=[0.994;0.318;0.435];
item.velocity=[v;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Right upper A-arm';
item.mass=0.683;
item.momentsofinertia=[0.008;0.005;0.01];
item.productsofinertia=[-0.001;0.003;0];
item.location=[0.994;-0.318;0.435];
item.velocity=[v;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);



item.name='Left lower A-arm';
item.mass=1.538;
item.momentsofinertia=[0.036;0.014;0.039];
item.productsofinertia=[0.004;-0.012;0];
item.location=[1.041;0.378;0.268];
item.velocity=[v;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Right lower A-arm';
item.mass=1.538;
item.momentsofinertia=[0.036;0.014;0.03];
item.productsofinertia=[-0.004;0.012;0];
item.location=[1.041;-0.378;0.268];
item.velocity=[v;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.name='Left upright';
item.mass=0.64;
item.momentsofinertia=[0.001;0.001;0.0009];
item.productsofinertia=[0;0;0];
item.location=[1.039;0.578;0.279];
item.velocity=[v;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.name='Right upright';
item.mass=0.64;
item.momentsofinertia=[0.001;0.001;0.0009];
item.productsofinertia=[0;0;0];
item.location=[1.039;-0.578;0.279];
item.velocity=[v;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);



item.name='Left front wheel';
item.mass=5.556;
item.momentsofinertia=[0.134;0.236;0.134];
item.productsofinertia=[0;0;0];
item.location=[a;tf;r];
item.velocity=[v;0;0];
item.angular_velocity=[0;v/r;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Right front wheel';
item.mass=5.556;
item.momentsofinertia=[0.134;0.236;0.134];
item.productsofinertia=[0;0;0];
item.location=[a;-tf;r];
item.velocity=[v;0;0];
item.angular_velocity=[0;v/r;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.angular_velocity=[0;0;0];


item.name='Left trailing arm';
item.mass=3.1331;
item.momentsofinertia=[0.02;0.112;0.104];
item.productsofinertia=[-0.003;0;0.031];
item.location=[-0.321;0.434;0.291];
item.velocity=[v;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Right trailing arm';
item.mass=3.1331;
item.momentsofinertia=[0.02;0.112;0.104];
item.productsofinertia=[0.003;0;0.031];
item.location=[-0.321;-0.434;0.291];
item.velocity=[v;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.name='Left rear wheel';
item.mass=5.556;
item.momentsofinertia=[0.134;0.236;0.134];
item.productsofinertia=[0;0;0];
item.location=[-b;tr;r];
item.velocity=[v;0;0];
item.angular_velocity=[0;v/r;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Right rear wheel';
item.mass=5.556;
item.momentsofinertia=[0.134;0.236;0.134];
item.productsofinertia=[0;0;0];
item.location=[-b;-tr;r];
item.velocity=[v;0;0];
item.angular_velocity=[0;v/r;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Axle';
item.mass=5.0;
item.momentsofinertia=[0.81*5/12;0.01;0.81*5/12];
item.productsofinertia=[0;0;0];
item.location=[-b;0;r];
item.velocity=[v;0;0];
item.angular_velocity=[0;v/r;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.angular_velocity=[0;0;0];


item.name='Left front arb bellcrank';
item.mass=0.09;
item.momentsofinertia=[0.00007;0.0001;0.00006];
item.location=[0.651;0.255;0.279];
item.velocity=[v;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Right front arb bellcrank';
item.mass=0.09;
item.momentsofinertia=[0.00007;0.0001;0.00006];
item.location=[0.651;-0.255;0.279];
item.velocity=[v;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Left front bar';
item.mass=0.09;
item.momentsofinertia=[0.00007;0.0001;0.00006];
item.location=[0.700;0.255;0.240];
item.velocity=[v;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Right front bar';
item.mass=0.09;
item.momentsofinertia=[0.00007;0.0001;0.00006];
item.location=[0.700;-0.255;0.240];
item.velocity=[v;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Left rear arb bellcrank';
item.mass=0.09;
item.momentsofinertia=[0.00007;0.0001;0.00006];
item.location=[0.028;0.360;0.279];
item.velocity=[v;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Right rear arb bellcrank';
item.mass=0.09;
item.momentsofinertia=[0.00007;0.0001;0.00006];
item.location=[0.028;-0.360;0.279];
item.velocity=[v;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item={};

%Define all rigid connections%
item.type='nh_point';
item.name='Constant Speed';
item.location=[0.26;0;h];
item.body1='Chassis';
item.body2='ground';
item.forces=1;
item.moments=0;
item.axis=[1;0;0];
the_system.item{end+1}=item;

item={};

item.type='rigid_point';
item.name='Left CV';
item.location=[-b;0.45;r];
item.body1='Axle';
item.body2='Left rear wheel';
item.forces=2;
item.moments=1;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='Right CV';
item.location=[-b;-0.45;r];
item.body1='Axle';
item.body2='Right rear wheel';
item.forces=3;
item.moments=1;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='Left upper A-arm hinge';
item.location=[0.976;0.212;0.476];
item.body1='Chassis';
item.body2='Left upper A-arm';
item.forces=3;
item.moments=2;
item.axis=[1;0;0];
the_system.item{end+1}=item;

item.name='Left lower A-arm hinge';
item.location=[1.018;0.185;0.309];
item.body1='Chassis';
item.body2='Left lower A-arm';
item.forces=3;
item.moments=2;
item.axis=[1;0;0];
the_system.item{end+1}=item;

item.name='Left upper ball-joint';
item.location=[1.04;0.539;0.35];
item.body1='Left upper A-arm';
item.body2='Left upright';
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='Left lower ball-joint';
item.location=[1.06;0.568;0.207];
item.body1='Left lower A-arm';
item.body2='Left upright';
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='Left front wheel bearing';
item.location=[a;0.686;r];
item.body1='Left upright';
item.body2='Left front wheel';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='Right upper A-arm hinge';
item.location=[0.976;-0.212;0.476];
item.body1='Chassis';
item.body2='Right upper A-arm';
item.forces=3;
item.moments=2;
item.axis=[1;0;0];
the_system.item{end+1}=item;

item.name='Right lower A-arm hinge';
item.location=[1.018;-0.185;0.309];
item.body1='Chassis';
item.body2='Right lower A-arm';
item.forces=3;
item.moments=2;
item.axis=[1;0;0];
the_system.item{end+1}=item;

item.name='Right upper ball-joint';
item.location=[1.04;-0.539;0.35];
item.body1='Right upper A-arm';
item.body2='Right upright';
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='Right lower ball-joint';
item.location=[1.06;-0.568;0.207];
item.body1='Right lower A-arm';
item.body2='Right upright';
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='Right front wheel bearing';
item.location=[a;-0.686;r];
item.body1='Right upright';
item.body2='Right front wheel';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='Left trailing arm bearing';
item.location=[-0.092;0.429;0.368];
item.body1='Chassis';
item.body2='Left trailing arm';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='Right trailing arm bearing';
item.location=[-0.092;-0.429;0.368];
item.body1='Chassis';
item.body2='Right trailing arm';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='Left rear wheel bearing';
item.location=[-b;0.492;r];
item.body1='Left trailing arm';
item.body2='Left rear wheel';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='Right rear wheel bearing';
item.location=[-b;-0.492;r];
item.body1='Right trailing arm';
item.body2='Right rear wheel';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;
item={};


point.type='rigid_point';
point.name='Left front arb bellcrank mount';
point.body1='Left front arb bellcrank';
point.body2='Chassis';
point.location=[0.651;0.255;0.279];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.type='rigid_point';
point.name='Right front arb bellcrank mount';
point.body1='Right front arb bellcrank';
point.body2='Chassis';
point.location=[0.651;-0.255;0.279];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;


point.type='rigid_point';
point.name='Left rear arb bellcrank mount';
point.body1='Left rear arb bellcrank';
point.body2='Chassis';
point.location=[0.028;0.360;0.279];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;
  
point.type='rigid_point';
point.name='Right rear arb bellcrank mount';
point.body1='Right rear arb bellcrank';
point.body2='Chassis';
point.location=[0.028;-0.360;0.279];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

item.type='rigid_point';
item.name='Left bell crank and bell crank1';
item.location=[0.700;0.255;0.240];
item.body1='Left front arb bellcrank';
item.body2='Left front bar';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='Right bell crank and bell crank1';
item.location=[0.700;-0.255;0.240];
item.body1='Right front arb bellcrank';
item.body2='Right front bar';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;
item={};


%Define tie rods%
item.type='link';
item.name='Left tie-rod';
item.body1='Chassis';
item.body2='Left upright';
item.location1=[0.84;0.2064;0.376];
item.location2=[0.96;0.564;0.274];
the_system.item{end+1}=item;

item.name='Right tie-rod';
item.body1='Chassis';
item.body2='Right upright';
item.location1=[0.84;-0.2064;0.376];
item.location2=[0.96;-0.564;0.274];
the_system.item{end+1}=item;
item={};






link.type='link';
link.name='Left rear link';
link.body1='Left rear arb bellcrank';
link.body2='Left trailing arm';
link.location1=[-0.021;0.360;0.240];
link.location2=[-0.140;0.434;0.310]; %% small mod x co-ord
the_system.item{end+1}=link;

link.type='link';
link.name='Right rear link';
link.body1='Right rear arb bellcrank';
link.body2='Right trailing arm';
link.location1=[-0.021;-0.360;0.240];
link.location2=[-0.140;-0.434;0.310];
the_system.item{end+1}=link;

link.type='link';
link.name='Left link';
link.body1='Left front arb bellcrank';
link.body2='Left rear arb bellcrank';
link.location1=[0.651;0.255;0.328];
link.location2=[0.028;0.360;0.328];
the_system.item{end+1}=link;

link.type='link';
link.name='Right link';
link.body1='Right front arb bellcrank';
link.body2='Right rear arb bellcrank';
link.location1=[0.651;-0.255;0.328];
link.location2=[0.028;-0.360;0.328];
the_system.item{end+1}=link;


item.type='link';
item.name='Left front drop link';
item.body1='Left front bar';
item.body2='Left lower A-arm ';
item.location1=[0.970;0.270;0.304];
item.location2=[0.970;0.270;0.240];
the_system.item{end+1}=item;

item.name='Right front drop link';
item.body1='Right front bar';
item.body2='Right lower A-arm';
item.location1=[0.970;-0.270;0.304];
item.location2=[0.970;-0.270;0.240];
the_system.item{end+1}=item;

item={};



%Define all springs%
item.type='spring';
item.name='Left rear shock';
item.location1=[-0.087;0.445;0.672];
item.location2=[-0.507;0.445;0.316];
item.body1='Chassis';
item.body2='Left trailing arm';
item.stiffness=params.kr;
item.damping=params.cr;
the_system.item{end+1}=item;

item.name='Right rear shock';
item.location1=[-0.087;-0.445;0.672];
item.location2=[-0.507;-0.445;0.316];
item.body1='Chassis';
item.body2='Right trailing arm';
item.stiffness=params.kr;
item.damping=params.cr;
the_system.item{end+1}=item;

item.name='Left front shock';
item.location1=[0.947;0.252;0.652];
item.location2=[1.048;0.467;0.243];
item.body1='Chassis';
item.body2='Left lower A-arm';
item.stiffness=params.kf;
item.damping=params.cf;
the_system.item{end+1}=item;

item.name='Right front shock';
item.location1=[0.947;-0.252;0.652];
item.location2=[1.048;-0.467;0.243];
item.body1='Chassis';
item.body2='Right lower A-arm';
item.stiffness=params.kf;
item.damping=params.cf;
the_system.item{end+1}=item;
item={};

%Define all flexible links%
%Treat the contacting points of tire and ground as flex points%
item.type='flex_point';
item.name='Left rear tire';
item.body1='Left rear wheel';
item.body2='ground';
item.location=[-b;tr;0];
item.forces=1;
item.moments=0;
item.axis=[0;0;1];
item.rolling_axis=[0;1;0];
item.stiffness=[75000;0];
item.damping=[0;0];
the_system.item{end+1}=item;

item.name='Right rear tire';
item.body1='Right rear wheel';
item.body2='ground';
item.location=[-b;-tr;0];
the_system.item{end+1}=item;

item.name='Left front tire';
item.body1='Left front wheel';
item.body2='ground';
item.location=[a;tf;0];
the_system.item{end+1}=item;

item.name='Right front tire';
item.body1='Right front wheel';
item.body2='ground';
item.location=[a;-tf;0];
the_system.item{end+1}=item;
item={};

%Add horizontal damping
item.type='flex_point';
item.name='Left rear tire';
item.body1='Left rear wheel';
item.body2='ground';
item.location=[-b;tr;0];
item.forces=2;
item.moments=0;
item.axis=[0;0;1];
item.stiffness=[0;0];
item.damping=[10000/v;0];
the_system.item{end+1}=item;

item.name='Right rear tire';
item.body1='Right rear wheel';
item.body2='ground';
item.location=[-b;-tr;0];
the_system.item{end+1}=item;

item.name='Left front tire';
item.body1='Left front wheel';
item.body2='ground';
item.location=[a;tf;0];
the_system.item{end+1}=item;

item.name='Right front tire';
item.body1='Right front wheel';
item.body2='ground';
item.location=[a;-tf;0];
the_system.item{end+1}=item;
item={};

spring.type='spring';
spring.name='Anti roll bar';
spring.body1='Left front bar';
spring.body2='Right front bar';
spring.location1=[0.7;0.255;0.240];
spring.location2=[0.7;-0.255;0.240];
spring.stiffness=kr;
spring.damping=0;
spring.twist=1;
the_system.item{end+1}=spring;


%Define sensor%
%  item.type='sensor';
%  item.name='front bounce';
%  item.body1='Chassis';
%  item.body2='ground';
%  item.location1=[a;0;0.5];
%  item.location2=[a;0;0];
%  item.twist=0;
%  item.order=1;
%  the_system.item{end+1}=item;
%  
%  item.type='sensor';
%  item.name='rear bounce';
%  item.body1='Chassis';
%  item.body2='ground';
%  item.location1=[-b;0;0.5];
%  item.location2=[-b;0;0];
%  item.twist=0;
%  item.order=1;
%  the_system.item{end+1}=item;

%  item.type='sensor';
%  item.name='Bounce sensor';
%  item.body1='Chassis';
%  item.body2='ground';
%  item.location1=[0.48134;0;0.56831];
%  item.location2=[0.48134;0;0.46831];
%  item.twist=0;
%  item.order=1;
%  the_system.item{end+1}=item;


%  item.name='Front suspension travel';
%  item.name='Right front shock';
%  item.location1=[0.947;-0.252;0.652];
%  item.location2=[1.048;-0.467;0.243];
%  item.body1='Chassis';
%  item.body2='Right lower A-arm';
%  item.twist=0;
%  item.gain=1;
%  the_system.item{end+1}=item;

item.type='sensor';
item.name='Front chassis motion';
item.body1='Chassis';
item.body2='ground';
item.location1=[a;-tf;0.234];
item.location2=[a;-tf;0.134];
the_system.item{end+1}=item;

item.name='Front suspension travel';
item.body1='Right front wheel';
item.body2='Chassis';
item.location1=[a;-tf;0.134];
item.location2=[a;-tf;0.234];
the_system.item{end+1}=item;

item.name='Front tire compression';
item.body1='Right front wheel';
item.body2='ground';
item.location1=[a;-tf;0];
item.location2=[a;-tf;-0.1];
item.actuator='Front wheel bump';
the_system.item{end+1}=item;
item={};
item.type='sensor';

%  
%  item.name='Pitch sensor';
%  item.body1='Chassis';
%  item.body2='ground';
%  item.location1=[0.48134;0.0;0.56831];
%  item.location2=[0.48134;0.1;0.56831];
%  item.twist=1;
%  item.order=1;
%  the_system.item{end+1}=item;
%  

item.name='Rear tire compression';
item.body1='Right rear wheel';
item.body2='ground';
item.location1=[-b;-tr;0];
item.location2=[-b;-tr;-0.1];
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

item.type='actuator';
item.name='Front wheel bump';
item.body1='Right front wheel';
item.body2='ground';
item.location1=[a;-tf;0];
item.location2=[a;-tf;-0.1];
item.twist=0;
item.gain=75000;
the_system.item{end+1}=item;

item.name='Roll moment';
item.body1='Chassis';
item.body2='ground';
item.location1=[0.48134;0.;0.56831];
item.location2=[0.58134;0;0.56831];
item.twist=1;
item.gain=m*g*h;
the_system.item{end+1}=item;

%  item.name='Right front shock load';
%  item.location1=[0.947;-0.252;0.652];
%  item.location2=[1.048;-0.467;0.243];
%  item.body1='Chassis';
%  item.body2='Right lower A-arm';
%  item.twist=0;
%  item.gain=params.kf;
%  the_system.item{end+1}=item;


item={};


