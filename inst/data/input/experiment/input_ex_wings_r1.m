function the_system=input_ex_wings_r2(u,varargin)
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

if(u==0)
	error(sprintf('Speed must be non-zero'));
end

%% u=1045;


%% Add one rigid body, along the x-axis
item.mass=50;
item.momentsofinertia=[1.35;0.751;2.10];
item.productsofinertia=[0;0;0];
item.location=[0.02463;0;0.2239];
item.name='chassis';
item.type='body';
item.velocity=[u;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,-32.18);
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

item.cxu=-0.021634;
item.cxw=0.344768;
item.cxq=-0.126831;
item.cyv=-0.117594;
item.cyp=-0.122530;
item.cyr=0.098115;
item.czu=-0.823817;
item.czw=-6.257488;
item.czq=-12.037213;
item.clv=-0.095620;
item.clp=-0.721489;
item.clr=0.114990;
item.cmu=0.007032;
item.cmw=-2.708918;
item.cmq=-42.282883;
item.cnv=0.030544;
item.cnp=-0.042580;
item.cnr=-0.030558;
item.cxwdot=0;
item.czwdot=0;
item.cmwdot=0;


%1 -207.589
%2,3 -3.32781 +/- 31.3707
%4,5 -51.2434 +/- 105.244
%6,7 -0.8786647e-3 +/- 0.434738e-1


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
the_system.item{end+1}=item;

