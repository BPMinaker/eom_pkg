function the_system=Baja2013a(dummy,dummy2)
the_system.item={};

%Define all bodies%
item.type='body';
item.name='vehicle body';
item.mass=200; %mass including driver%
item.momentsofinertia=[22.331;51.266;56.038];
item.productsofinertia=[3.594;5.231;-0.6];
item.location=[0.48;0;0.57];
item.velocity=[0;0;0];
the_system.item{end+1}=item;

item.name='left upper A-arm';
item.mass=0.683;
item.momentsofinertia=[0.008;0.005;0.01];
item.productsofinertia=[-0.001;0;0.003];
item.location=[0.994;0.318;0.435];
item.velocity=[0;0;0];
the_system.item{end+1}=item;

item.name='left lower A-arm';
item.mass=1.538;
item.momentsofinertia=[0.036;0.014;0.03];
item.productsofinertia=[-0.004;0;0.012];
item.location=[1.041;0.378;0.347];
item.velocity=[0;0;0];
the_system.item{end+1}=item;

item.name='left upright';
item.mass=0.64;
item.momentsofinertia=[0.001;0.001;0.0009];
item.productsofinertia=[0;0;0.0002];
item.location=[1.039;0.578;0.279];
item.velocity=[0;0;0];
the_system.item{end+1}=item;

item.name='left front wheel';
item.mass=5.556;
item.momentsofinertia=[0.134;0.236;0.134];
item.productsofinertia=[0;0;0];
item.location=[1.041;0.658;0.253];
item.velocity=[0;0;0];
the_system.item{end+1}=item;

item.name='right upper A-arm';
item.mass=0.683;
item.momentsofinertia=[0.008;0.005;0.01];
item.productsofinertia=[0.001;0;0.003];
item.location=[0.994;-0.318;0.435];
item.velocity=[0;0;0];
the_system.item{end+1}=item;

item.name='right lower A-arm';
item.mass=1.538;
item.momentsofinertia=[0.036;0.014;0.03];
item.productsofinertia=[0.004;0;0.012];
item.location=[1.041;-0.378;0.347];
item.velocity=[0;0;0];
the_system.item{end+1}=item;

item.name='right upright';
item.mass=0.64;
item.momentsofinertia=[0.001;0.001;0.0009];
item.productsofinertia=[0;0;0.0002];
item.location=[1.039;-0.578;0.279];
item.velocity=[0;0;0];
the_system.item{end+1}=item;

item.name='right front wheel';
item.mass=5.556;
item.momentsofinertia=[0.134;0.236;0.134];
item.productsofinertia=[0;0;0];
item.location=[1.041;-0.658;0.253];
item.velocity=[0;0;0];
the_system.item{end+1}=item;

item.name='left rear swing arm';
item.mass=3.1331;
item.momentsofinertia=[0.02;0.112;0.104];
item.productsofinertia=[0.003;-0.031;0];
item.location=[-0.321;0.434;0.291];
item.velocity=[0;0;0];
the_system.item{end+1}=item;

item.name='right rear swing arm';
item.mass=3.1331;
item.momentsofinertia=[0.02;0.112;0.104];
item.productsofinertia=[-0.003;0.031;0];
item.location=[-0.321;-0.434;0.291];
item.velocity=[0;0;0];
the_system.item{end+1}=item;

item.name='left rear wheel';
item.mass=5.556;
item.momentsofinertia=[0.134;0.236;0.134];
item.productsofinertia=[0;0;0];
item.location=[-0.524;0.6;0.253];
item.velocity=[0;0;0];
the_system.item{end+1}=item;

item.name='right rear wheel';
item.mass=5.556;
item.momentsofinertia=[0.134;0.236;0.134];
item.productsofinertia=[0;0;0];
item.location=[-0.524;-0.6;0.253];
item.velocity=[0;0;0];
the_system.item{end+1}=item;
item={};

%Define all rigid links%
item.type='rigid_point';
item.name='left upper A-arm link';
item.location=[0.976;0.212;0.476];
item.body1='vehicle body';
item.body2='left upper A-arm';
item.forces=3;
item.moments=2;
item.axis=[1;0;0];
the_system.item{end+1}=item;

item.name='left lower A-arm link';
item.location=[1.018;0.185;0.347];
item.body1='vehicle body';
item.body2='left lower A-arm';
item.forces=3;
item.moments=2;
item.axis=[1;0;0];
the_system.item{end+1}=item;

item.name='left upright link top';
item.location=[1.04;0.539;0.35];
item.body1='left upper A-arm';
item.body2='left upright';
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='left upright link bottom';
item.location=[1.06;0.568;0.207];
item.body1='left lower A-arm';
item.body2='left upright';
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='left front wheel link';
item.location=[1.041;0.658;0.253];
item.body1='left upright';
item.body2='left front wheel';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='right upper A-arm link';
item.location=[0.976;-0.212;0.476];
item.body1='vehicle body';
item.body2='right upper A-arm';
item.forces=3;
item.moments=2;
item.axis=[1;0;0];
the_system.item{end+1}=item;

item.name='right lower A-arm link';
item.location=[1.018;-0.185;0.347];
item.body1='vehicle body';
item.body2='right lower A-arm';
item.forces=3;
item.moments=2;
item.axis=[1;0;0];
the_system.item{end+1}=item;

item.name='right upright link top';
item.location=[1.04;-0.539;0.35];
item.body1='right upper A-arm';
item.body2='right upright';
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='right upright link bottom';
item.location=[1.06;-0.568;0.207];
item.body1='right lower A-arm';
item.body2='right upright';
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='right front wheel link';
item.location=[1.041;-0.658;0.253];
item.body1='right upright';
item.body2='right front wheel';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='left rear swing arm link';
item.location=[-0.092;0.429;0.368];
item.body1='vehicle body';
item.body2='left rear swing arm';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='right rear swing arm link';
item.location=[-0.092;-0.429;0.368];
item.body1='vehicle body';
item.body2='right rear swing arm';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='left rear wheel link';
item.location=[-0.524;0.6;0.253];
item.body1='left rear swing arm';
item.body2='left rear wheel';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='right rear wheel link';
item.location=[-0.524;-0.6;0.253];
item.body1='right rear swing arm';
item.body2='right rear wheel';
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;
item={};

item.type='link';
item.name='left tie rod';
item.body1='vehicle body';
item.body2='left upright';
item.location1=[0.84;0.2064;0.376];
item.location2=[0.96;0.564;0.274];
the_system.item{end+1}=item;

item.name='right tie rod';
item.body1='vehicle body';
item.body2='right upright';
item.location1=[0.84;-0.2064;0.376];
item.location2=[0.96;-0.564;0.274];
the_system.item{end+1}=item;
item={};

%Define all springs%
item.type='spring';
item.name='left front shock';
item.location1=[0.947;0.252;0.652];
item.location2=[1.048;0.467;0.243];
item.body1='vehicle body';
item.body2='left lower A-arm';
item.stiffness=26000;
item.damping=1500;
the_system.item{end+1}=item;

item.name='right front shock';
item.location1=[0.947;-0.252;0.652];
item.location2=[1.048;-0.467;0.243];
item.body1='vehicle body';
item.body2='right lower A-arm';
item.stiffness=26000;
item.damping=1500;
the_system.item{end+1}=item;

item.name='left rear shock';
item.location1=[-0.087;0.445;0.672];
item.location2=[-0.507;0.445;0.316];
item.body1='vehicle body';
item.body2='left rear swing arm';
item.stiffness=10000;
item.damping=1000;
the_system.item{end+1}=item;

item.name='right rear shock';
item.location1=[-0.087;-0.445;0.672];
item.location2=[-0.507;-0.445;0.316];
item.body1='vehicle body';
item.body2='right rear swing arm';
item.stiffness=10000;
item.damping=1000;
the_system.item{end+1}=item;
item={};

%Define all flexible links%
%Treat the contacting points of tire and  ground as flex points%
item.type='flex_point';
item.name='left front tire';
item.body1='left front wheel';
item.body2='ground';
item.location=[1.041;0.658;0];
item.forces=2;
item.moments=0;
item.axis=[0;1;0];
item.rolling_axis=[0;1;0];
item.stiffness=74939;
item.damping=[200;0];
the_system.item{end+1}=item;

item.name='right front tire';
item.body1='right front wheel';
item.body2='ground';
item.location=[1.041;-0.658;0];
item.forces=2;
item.moments=0;
item.axis=[0;1;0];
item.rolling_axis=[0;1;0];
item.stiffness=74939;
item.damping=[200;0];
the_system.item{end+1}=item;

item.name='left rear tire';
item.body1='left rear wheel';
item.body2='ground';
item.location=[-0.524;0.6;0];
item.forces=2;
item.moments=0;
item.axis=[0;1;0];
item.rolling_axis=[0;1;0];
item.stiffness=74939;
item.damping=[200;0];
the_system.item{end+1}=item;

item.name='right rear tire';
item.body1='right rear wheel';
item.body2='ground';
item.location=[-0.524;-0.6;0];
item.forces=2;
item.moments=0;
item.axis=[0;1;0];
item.rolling_axis=[0;1;0];
item.stiffness=74939;
item.damping=[200;0];
the_system.item{end+1}=item;
item={};

%Add Load%
item.type='load';
item.name='gravity';
item.body='vehicle body';
item.location=[0.48;0;0.57];
item.force=[0;0;-200*9.81];
item.moment=[0;0;0];
the_system.item{end+1}=item;
item={};

%Define sensor%
item.type='sensor';
item.name='bounce sensor';
item.body1='vehicle body';
item.body2='ground';
item.location1=[0.48;0;0.57];
item.location2=[0;0;0.1];
item.twist=0;
item.order=1;
the_system.item{end+1}=item;

item.name='pitch sensor';
item.body1='vehicle body';
item.body2='ground';
item.location1=[0.48;0;0.57];
item.location2=[0;0.1;0];
item.twist=1;
item.order=1;
the_system.item{end+1}=item;
item={};