function the_system=Baja_coupled(varargin)
the_system.item={};
g=9.81;

%  params.kf=1;
%  params.kr=1;
%  params.cf=1;
%  params.cr=1;
%  %params.tf=1;
%  %params.tr=1;
%  
%  if(nargin()==2)  %% Are there two arguments? (ignore the first)
%  	if(isa(varargin{2},'struct'))  %% If so, is the second a struct?
%  		names=fieldnames(varargin{2});  %% If so, get the fieldnames
%  		for i=1:length(names)  %% For each fieldname
%  			if(isfield(params,names{i}))  %% Is this a field in our default?
%  				params.(names{i})=varargin{2}.(names{i});  %% If so, copy the field content to the default
%  			end
%  		end
%  	end
%  end
%  
%  kf=26000*params.kf+2600*(1-params.kf);
%  kr=35000*params.kr+3500*(1-params.kr);
%  cf=1500*params.cf+150*(1-params.cf);
%  cr=1500*params.cr+150*(1-params.cr);

kf=9616;
kr=13137;
cf=701;
cr=100;


%Define all bodies%
item.type='body';
item.name='Chassis';
item.mass=200;
item.momentsofinertia=[22.331;51.266;56.038];
item.productsofinertia=[0;0;0];
item.location=[0.26;0;0.568];
item.velocity=[5;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Left upper A-arm';
item.mass=0.683;
item.momentsofinertia=[0.008;0.005;0.01];
item.productsofinertia=[0.001;-0.003;0];
item.location=[0.994;0.318;0.435];
item.velocity=[5;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Right upper A-arm';
item.mass=0.683;
item.momentsofinertia=[0.008;0.005;0.01];
item.productsofinertia=[-0.001;0.003;0];
item.location=[0.994;-0.318;0.435];
item.velocity=[5;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);



item.name='Left lower A-arm';
item.mass=1.538;
item.momentsofinertia=[0.036;0.014;0.039];
item.productsofinertia=[0.004;-0.012;0];
item.location=[1.041;0.378;0.268];
item.velocity=[5;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Right lower A-arm';
item.mass=1.538;
item.momentsofinertia=[0.036;0.014;0.03];
item.productsofinertia=[-0.004;0.012;0];
item.location=[1.041;-0.378;0.268];
item.velocity=[5;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.name='Left upright';
item.mass=0.64;
item.momentsofinertia=[0.001;0.001;0.0009];
item.productsofinertia=[0;0;0];
item.location=[1.039;0.578;0.279];
item.velocity=[5;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.name='Right upright';
item.mass=0.64;
item.momentsofinertia=[0.001;0.001;0.0009];
item.productsofinertia=[0;0;0];
item.location=[1.039;-0.578;0.279];
item.velocity=[5;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);



item.name='Left front wheel';
item.mass=5.556;
item.momentsofinertia=[0.134;0.236;0.134];
item.productsofinertia=[0;0;0];
item.location=[1.041;0.658;0.253];
item.velocity=[5;0;0];
item.angular_velocity=[0;5/0.134;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Right front wheel';
item.mass=5.556;
item.momentsofinertia=[0.134;0.236;0.134];
item.productsofinertia=[0;0;0];
item.location=[1.041;-0.658;0.253];
item.velocity=[5;0;0];
item.angular_velocity=[0;5/0.134;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.angular_velocity=[0;0;0];


item.name='Left trailing arm';
item.mass=3.1331;
item.momentsofinertia=[0.02;0.112;0.104];
item.productsofinertia=[-0.003;0;0.031];
item.location=[-0.321;0.434;0.291];
item.velocity=[5;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Right trailing arm';
item.mass=3.1331;
item.momentsofinertia=[0.02;0.112;0.104];
item.productsofinertia=[0.003;0;0.031];
item.location=[-0.321;-0.434;0.291];
item.velocity=[5;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.name='Left rear wheel';
item.mass=5.556;
item.momentsofinertia=[0.134;0.236;0.134];
item.productsofinertia=[0;0;0];
item.location=[-0.524;0.6;0.253];
item.velocity=[5;0;0];
item.angular_velocity=[0;5/0.134;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Right rear wheel';
item.mass=5.556;
item.momentsofinertia=[0.134;0.236;0.134];
item.productsofinertia=[0;0;0];
item.location=[-0.524;-0.6;0.253];
item.velocity=[5;0;0];
item.angular_velocity=[0;5/0.134;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Axle';
item.mass=5.0;
item.momentsofinertia=[0.81*5/12;0.01;0.81*5/12];
item.productsofinertia=[0;0;0];
item.location=[-0.524;0;0.253];
item.velocity=[5;0;0];
item.angular_velocity=[0;5/0.134;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.angular_velocity=[0;0;0];



item.name='Left arb rod';
item.mass=1;
item.momentsofinertia=[0.1;0.1;0.1];
item.location=[0.9;0.429;0.368];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Right arb rod';
item.mass=1;
item.momentsofinertia=[0.1;0.1;0.1];
item.location=[0.9;-0.429;0.368];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


item.name='Left front arb bellcrank';
item.mass=1;
item.momentsofinertia=[0.1;0.1;0.1];
item.location=[0.8;0.429;0.368];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='Right front arb bellcrank';
item.mass=1;
item.momentsofinertia=[0.1;0.1;0.1];
item.location=[0.8;-0.429;0.368];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);


%  item.name='Left rear arb bellcrank';
%  item.mass=1;
%  item.momentsofinertia=[0.1;0.1;0.1];
%  item.location=[-0.3;0.3;0.1];
%  the_system.item{end+1}=item;
%  the_system.item{end+1}=weight(item,g);
%  
%  item.name='Right rear arb bellcrank';
%  item.mass=1;
%  item.momentsofinertia=[0.1;0.1;0.1];
%  item.location=[-0.3;-0.3;0.1];
%  the_system.item{end+1}=item;
%  the_system.item{end+1}=weight(item,g);

item={};

%Define all rigid connections%

item.type='rigid_point';
item.name='Left CV';
item.location=[-0.524;0.45;0.253];
item.body1='Axle';
item.body2='Left rear wheel';
item.forces=2;
item.moments=1;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='Right CV';
item.location=[-0.524;-0.45;0.253];
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
item.location=[1.041;0.686;0.253];
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
item.location=[1.041;-0.686;0.253];
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
item.location=[-0.524;0.492;0.253];
item.body1='Left trailing arm';
item.body2='Left rear wheel';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='Right rear wheel bearing';
item.location=[-0.524;-0.492;0.253];
item.body1='Right trailing arm';
item.body2='Right rear wheel';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;
item={};




point.type='rigid_point';
point.name='Left arb mount';
point.body1='Left arb rod';
point.body2='Left front arb bellcrank';
point.location=[0.9;0.429;0.368];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.type='rigid_point';
point.name='Right arb mount';
point.body1='Right arb rod';
point.body2='Right front arb bellcrank';
point.location=[0.9;-0.429;0.368];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;


point.type='rigid_point';
point.name='Left front arb bellcrank mount';
point.body1='Left front arb bellcrank';
point.body2='Chassis';
point.location=[0.8;0.429;0.368];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.type='rigid_point';
point.name='Right front arb bellcrank mount';
point.body1='Right front arb bellcrank';
point.body2='Chassis';
point.location=[0.8;-0.429;0.368];
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;


%  point.type='rigid_point';
%  point.name='Left rear arb bellcrank mount';
%  point.body1='Left rear arb bellcrank';
%  point.body2='Chassis';
%  point.location=[-0.3;0.3;0.1];
%  point.forces=3;
%  point.moments=2;
%  point.axis=[0;1;0];
%  the_system.item{end+1}=point;
%  
%  point.type='rigid_point';
%  point.name='Right rear arb bellcrank mount';
%  point.body1='Right rear arb bellcrank';
%  point.body2='Chassis';
%  point.location=[-0.3;-0.3;0.1];
%  point.forces=3;
%  point.moments=2;
%  point.axis=[0;1;0];
%  the_system.item{end+1}=point;




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
link.name='Left front drop link';
link.body1='Left arb rod';
link.body2='Left lower A-arm ';
link.location1=[1.0;0.5;0.368];
link.location2=[1.0;0.5;0.268];
the_system.item{end+1}=link;

link.type='link';
link.name='Right front drop link';
link.body1='Right arb rod';
link.body2='Right lower A-arm';
link.location1=[1.0;-0.5;0.368];
link.location2=[1.0;-0.5;0.268];
the_system.item{end+1}=link;


link.type='link';
link.name='Left link';
link.body1='Left front arb bellcrank';
link.body2='Left trailing arm';
link.location1=[0.8;0.429;0.468];
link.location2=[-0.092;0.429;0.468];
the_system.item{end+1}=link;

link.type='link';
link.name='Right link';
link.body1='Right front arb bellcrank';
link.body2='Right trailing arm';
link.location1=[0.8;-0.429;0.468];
link.location2=[-0.092;-0.429;0.468];
the_system.item{end+1}=link;


%Define all springs%
item.type='spring';
item.name='Left rear shock';
item.location1=[-0.087;0.445;0.672];
item.location2=[-0.507;0.445;0.316];%*params.tr+[-0.159;0.445;0.375]*(1-params.tr);
item.body1='Chassis';
item.body2='Left trailing arm';
item.stiffness=kr;
item.damping=cr;
the_system.item{end+1}=item;

item.name='Right rear shock';
item.location1=[-0.087;-0.445;0.672];
item.location2=[-0.507;-0.445;0.316];%*params.tr+[-0.159;-0.445;0.375]*(1-params.tr);
item.body1='Chassis';
item.body2='Right trailing arm';
item.stiffness=kr;
item.damping=cr;
the_system.item{end+1}=item;

item.name='Left front shock';
item.location1=[0.947;0.252;0.652];
item.location2=[1.048;0.467;0.243];%*params.tf+[1.048;0.252;0.30]*(1-params.tf);
item.body1='Chassis';
item.body2='Left lower A-arm';
item.stiffness=kf;
item.damping=cf;
the_system.item{end+1}=item;

item.name='Right front shock';
item.location1=[0.947;-0.252;0.652];
item.location2=[1.048;-0.467;0.243];%*params.tf+[1.048;-0.252;0.30]*(1-params.tf);
item.body1='Chassis';
item.body2='Right lower A-arm';
item.stiffness=kf;
item.damping=cf;
the_system.item{end+1}=item;
item={};

%Define all flexible links%
%Treat the contacting points of tire and ground as flex points%
item.type='flex_point';
item.name='Left rear tire';
item.body1='Left rear wheel';
item.body2='ground';
item.location=[-0.524;0.6;0];
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
item.location=[-0.524;-0.6;0];
the_system.item{end+1}=item;

item.name='Left front tire';
item.body1='Left front wheel';
item.body2='ground';
item.location=[1.041;0.658;0];
the_system.item{end+1}=item;

item.name='Right front tire';
item.body1='Right front wheel';
item.body2='ground';
item.location=[1.041;-0.658;0];
the_system.item{end+1}=item;
item={};

%Add horizontal damping
item.type='flex_point';
item.name='Left rear tire';
item.body1='Left rear wheel';
item.body2='ground';
item.location=[-0.524;0.6;0];
item.forces=2;
item.moments=0;
item.axis=[0;1;0];
item.stiffness=[0;0];
item.damping=[10000/5;0];
the_system.item{end+1}=item;

item.name='Right rear tire';
item.body1='Right rear wheel';
item.body2='ground';
item.location=[-0.524;-0.6;0];
the_system.item{end+1}=item;

item.name='Left front tire';
item.body1='Left front wheel';
item.body2='ground';
item.location=[1.041;0.658;0];
the_system.item{end+1}=item;

item.name='Right front tire';
item.body1='Right front wheel';
item.body2='ground';
item.location=[1.041;-0.658;0];
the_system.item{end+1}=item;
item={};

spring.type='spring';
spring.name='Anti roll bar';
spring.body1='Left arb rod';
spring.body2='Right arb rod';
spring.location1=[0.9;0.429;0.368];
spring.location2=[0.9;-0.429;0.368];
spring.stiffness=50;
spring.damping=0;
spring.twist=1;
the_system.item{end+1}=spring;




%Define sensor%
item.type='sensor';
item.name='front bounce';
item.body1='Chassis';
item.body2='ground';
item.location1=[1.041;0;0.5];
item.location2=[1.041;0;0];
item.twist=0;
item.order=1;
the_system.item{end+1}=item;

item.type='sensor';
item.name='rear bounce';
item.body1='Chassis';
item.body2='ground';
item.location1=[-0.524;0;0.5];
item.location2=[-0.524;0;0];
item.twist=0;
item.order=1;
the_system.item{end+1}=item;

%  item.type='sensor';
%  item.name='bounce sensor';
%  item.body1='Chassis';
%  item.body2='ground';
%  item.location1=[0.48134;0;0.56831];
%  item.location2=[0.48134;0;0.46831];
%  item.twist=0;
%  item.order=1;
%  the_system.item{end+1}=item;
%  
%  item.name='pitch sensor';
%  item.body1='Chassis';
%  item.body2='ground';
%  item.location1=[0.48134;0.0;0.56831];
%  item.location2=[0.48134;0.1;0.56831];
%  item.twist=1;
%  item.order=1;
%  the_system.item{end+1}=item;

item.name='roll sensor';
item.body1='Chassis';
item.body2='ground';
item.location1=[0.48134;0.;0.56831];
item.location2=[0.58134;0;0.56831];
item.twist=1;
item.order=1;
the_system.item{end+1}=item;
item={};


item.type='actuator';
item.name='front wheel bump';
item.body1='Right front wheel';
item.body2='ground';
item.location1=[1.041;-0.658;0];
item.location2=[1.041;-0.658;-0.1];
item.twist=0;
item.gain=74939;
the_system.item{end+1}=item;
