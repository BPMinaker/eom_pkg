function the_system=input_ex_wings_r2(varargin)
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_yaw_plane.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_yaw_plane.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

u=64.5396;
alpha=-014.55*pi/180;

%% xcg=0.02463 zcg=0.2239

%% Add one rigid body, along the x-axis
item.mass=0.1773;
item.momentsofinertia=[1.35;0.7509;2.095];
item.productsofinertia=[0;0;0];
item.location=[0;0;0];
item.name='chassis';
item.type='body';
item.velocity=[u*cos(alpha);0;u*sin(alpha)];
the_system.item{end+1}=item;
item={};


item.type='load';
item.body='chassis';
item.location=[0;0;0];
item.force=[0;0;0.1773*32.18];
item.moment=[0;0;0];
the_system.item{end+1}=item;
item={};


%% Add a damping, to connect our body to ground, aligned with y-axis (front tire)
item.name='sample wing';
item.type='wing';
item.body1='chassis';
item.body2='ground';
item.location=[0;0;0];
item.span=15;
item.chord=1;
item.area=12;
item.airspeed=u;
item.density=0.5846e-3;

item.cxu=-0.023318;
item.cxw=0.289517;
item.cxq=-0.177433;
item.cyv=-0.117534;
item.cyp=-0.124538;
item.cyr=0.097184;
item.czu=-0.796867;
item.czw=-6.262563;
item.czq=-12.039856;
item.clv=-0.094597;
item.clp=-0.721958;
item.clr=0.110946;
item.cmu=-0.006878;
item.cmw=-2.708392;
item.cmq=-42.266597;
item.cnv=0.031228;
item.cnp=-0.036110;
item.cnr=-0.030716;

item.a_mass=[0;7.889735e-5;5.239973e-3];
item.a_mass_products=[0;0;0];
item.a_momentsofinertia=[7.887554e-2;8.677874e-3;2.100213e-3];
item.a_productsofinertia=[0;0;-5.546915e-4];
the_system.item{end+1}=item;
item={};

item.name='aileron';
item.type='surf';
item.body='chassis';
item.span=15;
item.chord=1;
item.area=12;
item.airspeed=u;
item.density=0.5846e-3;
item.cy=-0.004827;
item.cl=-0.020206;
item.cn=-0.000061;
the_system.item{end+1}=item;
item={};

item.name='elevator';
item.type='surf';
item.body='chassis';
item.span=15;
item.chord=1;
item.area=12;
item.airspeed=u;
item.density=0.5846e-3;
item.cx=-0.000162;
item.cz=-0.010586;
item.cm=-0.061135;
the_system.item{end+1}=item;
item={};

item.name='rudder';
item.type='surf';
item.body='chassis';
item.span=15;
item.chord=1;
item.area=12;
item.airspeed=u;
item.density=0.5846e-3;
item.cy=-0.001584;
item.cl=-0.000059;
item.cn=0.000631;
the_system.item{end+1}=item;
item={};


item.name='$\\delta$';
item.type='actuator';
item.body1='chassis';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[0;0.1;0];
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='$r$';
item.body1='chassis';
item.body2='ground';
item.location1=[0;0;0];
item.location2=[0;0;0.1];
item.order=2;
item.twist=1;
the_system.item{end+1}=item;

