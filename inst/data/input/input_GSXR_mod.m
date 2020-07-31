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
point.body2='Lower fork';
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
point.body2='Lower fork';
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
point.body2='Lower fork';
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
point.body2='Lower fork';
point.forces=3;
point.moments=0;
point.axis=[0;0;0];
the_system.item{end+1}=point;


link.name='Steering shaft';
link.location1=p23;
link.location2=p3;
link.body1='Lower fork';
link.body2='Upper fork';
link.twist=1;
the_system.item{end+1}=link;



spring.type='spring';
spring.name='Right front spring';
spring.body1='Upper fork';
spring.body2='Lower fork';
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

