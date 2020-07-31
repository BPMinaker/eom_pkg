
p2=[1.173;0;0.749];  %% steering head
p3=[1.164;0;0.77];  %% cg upper fork
p4=[1.342;0;0.426];
p5=[1.365;0;0.324];  %% cg lower fork
p6=[1.410;0;0.282];  %% cg front wheel
p7=[0;0;0.297];  %% cg rear wheel
p8=[0.6779;0;0.4724];  %% cg bike main body
p9=[0.364;0;0.8438];
p10=[0.415;0;1.14];  %% cg upper torso body
p11=[0.549;0;0.3608];

p13=[0.487;0;0.4888];  %% spring mount
p14=[0.196;0;0.3113];  %% cg swing arm

p19=[0.539;0;0.1878];  %% bell crank
p20=[0.4946;0;0.1522];  %% bell crank
p21=[0.4443;0;0.1782];  %% bell crank
p22=[0.3722;0;0.2748];  %% pull rod


m_ff_u=9.99;  %% upper fork
m_ff_l=7.25;  %% lower fork
m_m=165.13;  %% chassis + rider lower
m_rw=14.7;  %% rear wheel
m_fw=11.9;  %% front wheel
m_ub=33.68;  %% rider upper body
m_sa=8;  %% swing arm



I_ff_u=[1.341;1.548;0.4125];  %% inertia upper fork
I_m=[11.085;22.013;14.982];  %% inertia main frame
P_m=[0;0;3.691];  %% products inertia main
I_ub=[1.428;1.347;0.916];  %% inertia upper body
P_ub=[0;0;-0.443];  %% products upper body
I_fw=[0.27;0.484;0.27];  %% inertia front wheel
I_rw=[0.383;0.638;0.383];  %% inertia rear wheel
I_sa=[0.02;0.259;0.259];  %% inertia swing arm


kf=25000;
kr=58570;
ktf=130000;
ktr=141000;
%cd=6.944;  %% steering damper, rotation
cr=11650;
cf=2134;
E=0.4189;  %% caster (radians)

g=9.81;

trail_b=p2(1)+p2(3)*tan(E)-p6(1)

body.type='body';
body.name='Frame';
body.location=p8;
body.mass=m_m;
body.momentsofinertia=I_m;
body.productsofinertia=P_m;
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


body.name='Upper body';
body.location=p10;
body.mass=m_ub;
body.momentsofinertia=I_ub;
body.productsofinertia=P_ub;
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


body.name='Upper fork';
body.location=p3;
body.mass=m_ff_u;
body.momentsofinertia=I_ff_u;
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
body.angular_velocity=[0;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Lower fork';
body.location=p5;
body.mass=m_ff_l;
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
body.angular_velocity=[0;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Swing arm';
body.location=p14;
body.mass=m_sa;
body.momentsofinertia=I_sa;
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Bell crank';
body.location=(p19+p20+p21)/3;
body.mass=0;
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


body.name='Front wheel, bike';
body.location=p6;
body.mass=m_fw;
body.momentsofinertia=I_fw;
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
body.angular_velocity=[0;u/p6(3);0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body.name='Rear wheel, bike';
body.location=p7;
body.mass=m_rw;
body.momentsofinertia=I_rw;
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
body.angular_velocity=[0;u/p7(3);0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

%trail=polyval(pa,0)-p6(1)

link.type='link';
link.name='Pull rod (dogbone)';
link.body1='Swing arm';
link.body2='Bell crank';
link.location1=p22;
link.location2=p20;
the_system.item{end+1}=link;

spring.type='spring';
spring.name='Rear spring';
spring.body1='Frame';
spring.body2='Bell crank';
spring.location1=p13;
spring.location2=p21;
spring.stiffness=kr;
spring.damping=cr;
the_system.item{end+1}=spring;


point.type='rigid_point';
point.name='Rear axle';
point.location=p7;
point.body1='Swing arm';
point.body2='Rear wheel, bike';
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;


point.name='Swing arm pivot';
point.location=p11;
point.body1='Swing arm';
point.body2='Frame';
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='Bell crank pivot';
point.location=p19;
point.body1='Bell crank';
point.body2='Frame';
point.forces=3;
point.moments=2;
point.axis=[0;1;0];
the_system.item{end+1}=point;


point.name='Seat ';
point.location=p9;
point.body1='Upper body';
point.body2='Frame';
point.forces=3;
point.moments=3;
the_system.item{end+1}=point;

point.name='Steering head';
point.location=p2;
point.body1='Upper fork';
point.body2='Frame';
point.forces=3;
point.moments=2;
point.axis=[sin(E);0;-cos(E)];
the_system.item{end+1}=point;

point.name='Front axle';
point.location=p6;
point.body1='Lower fork';
point.body2='Front wheel, bike';
point.forces=3;
point.moments=3;
point.axis=[0;1;0];
the_system.item{end+1}=point;



point.type='flex_point';
point.name='Front tire, lateral';
point.location=[p6(1);0;0];
point.body1='Front wheel, bike';
point.body2='ground';
point.damping=[20000/u;0];
point.forces=1;
point.moments=0;
point.axis=[0;1;0];
the_system.item{end+1}=point;

point.name='Rear tire, lateral';
point.location=[0;0;0];
point.body1='Rear wheel, bike';
point.damping=[20000/u;0];
the_system.item{end+1}=point;


point.name='Front tire, longitudinal';
point.location=[p6(1);0;0];
point.body1='Front wheel, bike';
point.body2='ground';
point.damping=[60000/u;0];
point.forces=1;
point.moments=0;
point.axis=[1;0;0];
the_system.item{end+1}=point;

point.name='Rear tire, longitudinal';
point.location=[0;0;0];
point.body1='Rear wheel, bike';
point.damping=[60000/u;0];
the_system.item{end+1}=point;


% Turn on or off tire vertical flex
point={};
point.type='rigid_point';
point.name='Front tire, vertical';
point.location=[p6(1);0;0];
point.body1='Front wheel, bike';
%point.stiffness=[ktf,0];
%point.damping=[0;0];
point.forces=1;
point.moments=0;
point.axis=[0;0;1];
point.rolling_axis=[0;1;0];
the_system.item{end+1}=point;

point.name='Rear tire, vertical';
point.location=[0;0;0];
point.body1='Rear wheel, bike';
%point.stiffness=[ktr,0];
the_system.item{end+1}=point;



point.type='rigid_point';
point.name='Front tire fix';
point.location=[p6(1);0;0];
point.body1='Front wheel, bike';
point.body2='ground';
point.forces=3;
point.moments=0;
the_system.item{end+1}=point;

point.name='Rear tire fix';
point.location=[0;0;0];
point.body1='Rear wheel, bike';
point.forces=2;
point.moments=0;
point.axis=[1;0;0];
the_system.item{end+1}=point;


item.type='sensor';
item.name='Yaw rate';
item.body1='Frame';
item.body2='ground';
item.location1=p8;
item.location2=p8-[0;0;0.1];
item.order=2;
item.twist=1;
the_system.item{end+1}=item;

item.name='Roll angle';
item.location2=p8-[0.1;0;0];
item.order=1;
item.twist=1;
the_system.item{end+1}=item;

item.name='Pitch angle';
item.location2=p8-[0;0.1;0];
item.order=1;
item.twist=1;
%the_system.item{end+1}=item;

item.name='Long accln';
item.location2=p8-[0.1;0;0];
item.order=3;
item.twist=0;
%the_system.item{end+1}=item;

item.name='Bump';
item.location2=p8-[0;0;0.1];
item.order=1;
item.twist=0;
%the_system.item{end+1}=item;




item={};
item.type='actuator';
item.name='Steer torque';
item.body1='Upper fork';
item.body2='Frame';
item.twist=1;
item.location1=p2;
item.location2=item.location1-0.1*[sin(E);0;-cos(E)];
the_system.item{end+1}=item;

item.name='Front brake';
item.body1='Front wheel, bike';
item.body2='Lower fork';
item.twist=1;
item.location1=p6;
item.location2=p6+[0;0.1;0];
%the_system.item{end+1}=item;


item.name='Front bump';
item.body1='Front wheel, bike';
item.body2='ground';
item.twist=0;
item.gain=ktf;
item.location1=[p6(1);0;0];
item.location2=[p6(1);0;-0.1];
%the_system.item{end+1}=item;


