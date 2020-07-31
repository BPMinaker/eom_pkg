function the_system=input_ex_wings(u,varargin)
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


%% Add one rigid body, along the x-axis
item.mass=5;
item.momentsofinertia=[10;10;10];
item.productsofinertia=[0;0;0];
item.location=[0;0;0];
item.name='chassis';
item.type='body';
item.velocity=[u;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,9.81);
item={};

%% Add a damping, to connect our body to ground, aligned with y-axis (front tire)
item.name='sample wing';
item.type='wing';
item.body1='chassis';
item.body2='ground';
item.location=[0;0;0];
item.span=1;
item.chord=0.5;
item.airspeed=u;

item.cxu=0;
item.cxa=0;
item.cxq=0;
item.cyb=0;
item.cyp=0;
item.cyr=0;
item.czu=0;
item.cza=0;
item.czq=0;
item.clb=0;
item.clp=0;
item.clr=0;
item.cmu=0;
item.cma=0;
item.cmq=0;
item.cnb=0;
item.cnp=0;
item.cnr=0;
item.cxadot=0;
item.czadot=0;
item.cmadot=0;

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

