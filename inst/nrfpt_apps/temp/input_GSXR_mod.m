function the_system=input_GSXR_mod(u,varargin)
the_system.name='GSXR 1100 multilink'; 
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_genta_bike.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_genta_bike.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------



bike;  %% call baseline script

p23=p6+[-0.3*sind(26.5);0;0.3*cosd(26.5)];
p24=p8+[0.3;0;-0.25];
p25=p24+[0.1;0;-0.03];
p26=p25+[0;0;-0.07];


body=thin_rod([p23+[0;0.1;0] p23+[0;-0.1;0]],0);
body.name='Fork rod';
body.velocity=[u;0;0];
the_system.item{end+1}=body;
%the_system.item{end+1}=weight(body,g);

%body=thin_rod([p6+[0;0.1;0] p23+[0;0.1;0]],0);
body.name='Left fork arm';
body.location=p6+[0;0.1;0];
body.mass=0;
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
%the_system.item{end+1}=weight(body,g);

%body=thin_rod([p6+[0;-0.1;0] p23+[0;-0.1;0]],0);
body.name='Right fork arm';
body.location=p6-[0;0.1;0];
body.mass=0;
body.momentsofinertia=[0;0;0];
body.productsofinertia=[0;0;0];
body.velocity=[u;0;0];
the_system.item{end+1}=body;
%the_system.item{end+1}=weight(body,g);


aa=[[1.240;0.1;0.2] [1.040;0.21248;0.2]]';
bb=[[1.240;0.1;0.3] [1.040;0.25;0.3]]';

cc=aa*diag([1 -1 1]);
dd=bb*diag([1 -1 1]);

body=thin_rod(aa',2);
body.name='Lower left arm';
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


plx=polyfit(aa(:,2),aa(:,1),1);
plz=polyfit(aa(:,2),aa(:,3),1);

lx=polyval(plx,0);
lz=polyval(plz,0);


body=thin_rod(bb',2);
body.name='Upper left arm';
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


pux=polyfit(bb(:,2),bb(:,1),1);
puz=polyfit(bb(:,2),bb(:,3),1);

ux=polyval(pux,0);
uz=polyval(puz,0);

pa=polyfit([uz;lz],[ux;lx],1);

rake=atan2(lx-ux,uz-lz)
raked=rake*180/pi
trail=polyval(pa,0)-p6(1)


body=thin_rod(cc',2);
body.name='Lower right arm';
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);

body=thin_rod(dd',2);
body.name='Upper right arm';
body.velocity=[u;0;0];
the_system.item{end+1}=body;
the_system.item{end+1}=weight(body,g);


point={};

point.type='rigid_point';
point.name='Left fork joint';
point.location=p23+[0;0.1;0];
point.body1='Left fork arm';
point.body2='Fork rod';
point.forces=3;
point.moments=3;
the_system.item{end+1}=point;

point.name='Right fork joint';
point.location=p23+[0;-0.1;0];
point.body1='Right fork arm';
point.body2='Fork rod';
point.forces=3;
point.moments=3;
the_system.item{end+1}=point;

point.name='Lower left rear joint';
point.location=aa(2,:)';
point.body1='Lower left arm';
point.body2='Frame';
point.forces=3;
point.moments=1;
point.axis=[1;0;0];
the_system.item{end+1}=point;

point.name='Lower left front joint';
point.location=aa(1,:)';
point.body1='Lower left arm';
point.body2='Left fork arm';
point.forces=3;
point.moments=0;
point.axis=[0;0;0];
the_system.item{end+1}=point;

point.name='Upper left rear joint';
point.location=bb(2,:)';
point.body1='Upper left arm';
point.body2='Frame';
point.forces=3;
point.moments=1;
point.axis=[1;0;0];
the_system.item{end+1}=point;

point.name='Upper left front joint';
point.location=bb(1,:)';
point.body1='Upper left arm';
point.body2='Left fork arm';
point.forces=3;
point.moments=0;
point.axis=[0;0;0];
the_system.item{end+1}=point;


point.name='Lower right rear joint';
point.location=cc(2,:)';
point.body1='Lower right arm';
point.body2='Frame';
point.forces=3;
point.moments=1;
point.axis=[1;0;0];
the_system.item{end+1}=point;

point.name='Lower right front joint';
point.location=cc(1,:)';
point.body1='Lower right arm';
point.body2='Right fork arm';
point.forces=3;
point.moments=0;
point.axis=[0;0;0];
the_system.item{end+1}=point;

point.name='Upper right rear joint';
point.location=dd(2,:)';
point.body1='Upper right arm';
point.body2='Frame';
point.forces=3;
point.moments=1;
point.axis=[1;0;0];
the_system.item{end+1}=point;

point.name='Upper right front joint';
point.location=dd(1,:)';
point.body1='Upper right arm';
point.body2='Right fork arm';
point.forces=3;
point.moments=0;
point.axis=[0;0;0];
the_system.item{end+1}=point;


link.name='Steering shaft';
link.location1=p23;
link.location2=p3;
link.body1='Fork rod';
link.body2='Upper fork';
link.twist=1;
the_system.item{end+1}=link;

point.name='Right axle';
point.location=p6;
point.body1='Right fork arm';
point.body2='Lower fork';
point.forces=3;
point.moments=3;
the_system.item{end+1}=point;

point.name='Left axle';
point.location=p6;
point.body1='Left fork arm';
point.body2='Lower fork';
point.forces=3;
point.moments=3;
the_system.item{end+1}=point;



spring.type='spring';
spring.name='Right front spring';
spring.body1='Upper fork';
spring.body2='Fork rod';
axis=p4-p6;
spring.location1=p6+3.0*axis-[0;0.1;0];
spring.location2=p23-[0;0.1;0];
spring.stiffness=14970; %/1.67;
spring.damping=1278; %cf/1.67;
the_system.item{end+1}=spring;

spring.name='Left front spring';
spring.location1=p6+3.0*axis+[0;0.1;0];
spring.location2=p23+[0;0.1;0];
the_system.item{end+1}=spring;

%  item={};
%  item.type='load';
%  item.body='Frame'
%  point.location=[0.678;0;0.472];
%  item.force=[2500;0;0];
%  item.moment=[0;0;0];
%  the_system.item{end+1}=item;

%%%%%%

%spring.type='spring';
%spring.name='front spring';
%spring.body1='front bell crank';
%spring.body2='bike';
%spring.location1=p26;
%spring.location2=p26+[-0.3;0;0];
%spring.stiffness=kf;
%spring.damping=cf;
%the_system.item{end+1}=spring;


%link.type='link';
%link.name='front pu11 rod';
%link.body1='fork rod';
%link.body2='front bell crank';
%link.location1=p23+[-0.05;0;0.04];
%link.location2=p24;
%the_system.item{end+1}=link;


%bbs=[0.2 0.8]*bb;
%dds=[0.2 0.8]*dd;

%  spring.name='left front spring';
%  spring.body1='upper left arm';
%  spring.body2='';
%  spring.location1=bbs';
%  spring.location2=[1.0;0.2;0.6];
%  spring.stiffness=kf/2;
%  spring.damping=cf/2;
%  the_system.item{end+1}=spring;
%  
%  spring.name='right front spring';
%  spring.body1='upper right arm';
%  spring.body2='';
%  spring.location1=dds';
%  spring.location2=[1.0;-0.2;0.6];
%  spring.stiffness=kf/2;
%  spring.damping=cf/2;
%  the_system.item{end+1}=spring;




%  point.name='front bell crank pivot';
%  point.location=p25;
%  point.body1='front bell crank';
%  point.body2='bike';
%  point.forces=3;
%  point.moments=2;
%  point.axis=[0;1;0];
%  the_system.item{end+1}=point;
%  
%  point.name='steering head';
%  point.location=p3;
%  point.body1='handle bar';
%  point.body2='bike';
%  point.forces=3;
%  point.moments=2;
%  point.axis=[-1;0;2];
%  the_system.item{end+1}=point;


%  point.type='rigid_point';
%  point.name='left front axle';
%  point.location=p6+[0;0.1;0];
%  point.body1='left fork arm';
%  point.body2='front wheel, bike';
%  point.forces=3;
%  point.moments=0;
%  point.axis=[0;1;0];
%  the_system.item{end+1}=point;
%  
%  point.name='front axle';
%  point.location=p6+[0;-0.1;0];
%  point.body1='right fork arm';
%  point.body2='front wheel, bike';
%  point.forces=2;
%  point.moments=0;
%  point.axis=[0;1;0];
%  the_system.item{end+1}=point;
%  point={};




