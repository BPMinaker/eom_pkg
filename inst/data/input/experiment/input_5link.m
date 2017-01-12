function the_system=input_5link(q,varargin)
the_system.item={};

% input_fivelink.m is for use with EOM
% Copyright R. Rieveley, 2009 GPL
% modified 2013 B. Minaker
%------------------------------------------------------------------------------------
% Defines a 5-link rear suspension for use in EOM


%-----------------------------------------------------------------------------------
% Conversion Factors
CF.length = 0.0254; % inches to meters
CF.mass = 0.4535; % pounds to kilograms

g=0;
%9.81;

%---------------------------------------------------------------------------------------
%///////////////////////////////////////////////////////////////////////////////////////
% Build the Model

%% Sprung chassis mass ----------------------------------------------------------------------
item.type='body';
item.group='chassis';
item.name='chassis';
item.location=CF.length*[0;0;30];
item.mass=1587/4;
item.momentsofinertia=[546;2470;2743];
item.productsofinertia=[0;0;0];
the_system.item{end+1} = item;
the_system.item{end+1} = weight(item,g);
item = {};

item.type='rigid_point';
item.group = 'chassis';
item.name='chassis mount';
item.body1='chassis';
item.body2='ground';
item.location=CF.length.*[0;0;30];
item.forces=2;
item.moments=3;
item.axis=[0;0;1];
the_system.item{end+1}=item;

item.forces=0;
item.moments=2;
item.axis=[1;0;0];
%the_system.item{end+1}=item;

item.forces=2;
item.moments=0;
item.axis=[0;1;0];
%the_system.item{end+1}=item;
item={};


% The Suspension -------------------------------------------------------------------------


item.type ='body';
item.group = 'suspension';
item.name= 'wheel';
item.location= CF.length.*[0;-30.0;12.1];
item.mass= CF.mass*83.5;
item.momentsofinertia=[2;2;2];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
item.productsofinertia=[0;0;0];
the_system.item{end+1} = item;
the_system.item{end+1} = weight(item,g);

item = {};

item.type ='body';
item.group = 'suspension';
item.name= 'spindle';
item.location= CF.length.*[2.4;-27.1;10.9];
item.mass= CF.mass*21.0;
item.momentsofinertia=[2;2;2];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
item.productsofinertia=[0;0;0];
the_system.item{end+1} = item;
the_system.item{end+1} = weight(item,g);
item = {};

item.type='rigid_point';
item.group = 'suspension';
item.name='wheel bearing';
item.body1='wheel';
item.body2='spindle';
item.location=CF.length*[0;-29.5;12.1];
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;
item={};


% Wishbone --------------------------------------------
loc1=[-2.0;-15.8;16.7];
loc2=[-0.4;-25.6;16.3];

item=thin_rod(CF.length*[loc1 loc2],CF.mass*2.4);
item.group='suspension';
item.name='wishbone';
the_system.item{end+1}=item;
the_system.item{end+1} = weight(item,g);
item={};

axis = loc1-loc2;
axis = axis/norm(axis);
item.type='rigid_point';
item.group='suspension';
item.name='wishbone inner';
item.body1='chassis';
item.body2='wishbone';
item.location=CF.length*loc1;
item.forces=3;
item.moments=1;
item.axis=axis;
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.group = 'suspension';
item.name='wishbone outer';
item.body1='wishbone';
item.body2='spindle';
item.location=CF.length*loc2;
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;
item={};

% Guide Link --------------------------------------------------------------
loc1=[5.9;-18.0;14.6];
loc2=[1.5;-25.6;14.7];

item=thin_rod(CF.length*[loc1 loc2],CF.mass*2.1);
item.group='suspension';
item.name='guide link';
the_system.item{end+1}=item;
the_system.item{end+1} = weight(item,g);
item={};

axis = loc1-loc2;
axis = axis/norm(axis);
item.type='rigid_point';
item.group = 'suspension';
item.name='guide link inner';
item.body1='chassis';
item.body2='guide link';
item.location=CF.length*loc1;
item.forces=3;
item.moments=1;
item.axis=axis;
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.group = 'suspension';
item.name='guide link outer';
item.body1='guide link';
item.body2='spindle';
item.location=CF.length*loc2;
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;
item={};

% Track Strut -------------------------------------------------------------
loc1=[-8.8;-10.2;10.5];
loc2=[-6.0;-25.9;10.3];

item=thin_rod(CF.length*[loc1 loc2],CF.mass*2.1);
item.group='suspension';
item.name='track strut';
the_system.item{end+1}=item;
the_system.item{end+1} = weight(item,g);
item={};

axis = loc1-loc2;
axis = axis/norm(axis);
item.type='rigid_point';
item.group = 'suspension';
item.name='track strut inner';
item.body1='chassis';
item.body2='track strut';
item.location=CF.length*loc1;
item.forces=3;
item.moments=1;
item.axis=axis;
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.group = 'suspension';
item.name='track strut outer';
item.body1='track strut';
item.body2='spindle';
item.location=CF.length*loc2;
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;
item={};


% Trailing Arm ---------------------------------------------------------
loc1=[8.8;-16.2;9.0];
loc2=[1.2;-25.8;6.5];

item=thin_rod(CF.length*[loc1 loc2],CF.mass*4.88);
item.group='suspension';
item.name= 'trailing arm' ;
the_system.item{end+1}=item;
the_system.item{end+1} = weight(item,g);
item={};

axis = loc1-loc2;
axis = axis/norm(axis);
item.type='rigid_point';
item.group = 'suspension';
item.name='trailing arm inner';
item.body1='chassis';
item.body2='trailing arm';
item.location=CF.length*loc1;
item.forces=3;
item.moments=1;
item.axis=axis;
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.group = 'suspension';
item.name='trailing arm outer';
item.body1='trailing arm';
item.body2='spindle';
item.location=CF.length*loc2;
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;
item={};

% Rollover Strut ---------------------------------------------------------
loc1=[-7.00;-10.20;7.20];
loc2=[-2.60;-24.90;7.70];

item=thin_rod(CF.length*[loc1 loc2],CF.mass*4.51);
item.group='suspension';
item.name='rollover strut';
the_system.item{end+1}=item;
the_system.item{end+1} = weight(item,g);
item={};

axis = loc1-loc2;
axis = axis/norm(axis);
item.type='rigid_point';
item.group = 'suspension';
item.name='rollover strut inner';
item.body1='chassis';
item.body2='rollover strut';
item.location=CF.length*loc1;
item.forces=3;
item.moments=1;
item.axis=axis;
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.group = 'suspension';
item.name='rollover strut outer';
item.body1='rollover strut';
item.body2='spindle';
item.location=CF.length*loc2;
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;
item={};

% Tire Contact ------------------------------------------------------------
contact_point = CF.length.*[0;-29.5;0];

item.type='flex_point';
item.group = 'tire';
item.name='tire contact vert';
item.body1='wheel';
item.body2='ground';
item.location= contact_point;
item.forces=1;
item.moments=0;
item.stiffness=[150000;0];
item.axis=[0;0;1];
item.rolling_axis=[0;1;0];
the_system.item{end+1}=item;
item={};


item.type='flex_point';
item.group = 'tire';
item.name='tire contact horiz';
item.body1='wheel';
item.body2='ground';
item.location= contact_point;
item.damping=[100;0];
item.forces=2;
item.moments=0;
item.axis=[0;1;0];
the_system.item{end+1}=item;
item={};




item.type='load';
item.name='latacc';
item.body='wheel';
item.location=contact_point;
item.force=[0;9.81*1587/4/2;0];
item.moment=[0;0;0];
%the_system.item{end+1}=item;
item = {};


% Suspension Spring ----------------------------------------------------

loc1 = CF.length*[-4.4;-18.4;5.2];
loc2 = CF.length*[-4.9;-17.6;16.0];
axis = loc1-loc2;

%loc2=loc2 + axis*(q-0.5);

item.type='spring';
item.group = 'suspension';
item.name='spring';
item.body1='rollover strut';
item.body2='chassis';
item.location1 = loc1;
item.location2 = loc2;
item.stiffness=109000;
the_system.item{end+1}=item;
item = {};
% neglected mass_spring = 5.8 lbs

% Suspension Damper -----------------------------------------------------
item.type='spring';
item.group = 'suspension';
item.name='damper';
item.body2='chassis';
item.body1='rollover strut';
item.location2 = CF.length*[-3.9;-20.0;26.5];
item.location1 = CF.length*[-3.3;-22.2;7.1];
item.damping=4900;
the_system.item{end+1}=item;
item = {};
% neglected mass_damper = 3.9 lbs

item.type='actuator';
item.name='chassis actuator';
item.location1=CF.length*[0;0;30];
item.location2=CF.length*[0;0;29];
item.body1='chassis';
item.body2='ground';
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='chassis sensor';
item.location1=CF.length*[0;0;30];
item.location2=CF.length*[0;0;29];
item.body1='chassis';
item.body2='ground';
the_system.item{end+1}=item;
item={};

% ---------------------------------------------------------------------------------------
% Neglected components to date
%vehicle.chassis.rear.item{}.name "prop_shaft" []
%vehicle.chassis.rear.item{}.type "link" []
%vehicle.chassis.rear.item{}.points "0,-8.00,-12.10;0,-22.90,-12.10" [in]
%vehicle.chassis.rear.item{}.mass "11.1" [lb]


%  vehicle.chassis.rear.item{}.name "anti-rollbar" []
%  vehicle.chassis.rear.item{}.location "0,0,0" [in]
%  vehicle.chassis.rear.item{}.stiffness "602.1" [Nm/deg]
%  // overall rollstiffness 776.3 Nm/deg