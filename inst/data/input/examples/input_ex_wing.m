function the_system=input_ex_wing(v,varargin)
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_smd.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_smd.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% A single body, constrained to ground, allowing translation in the z axis only, with a point spring connecting them.
%% The point spring has stiffness and damping defined in translation along the z axis only.
%% An actuator connects the body to ground as well, to provide input forces.  Note that the ground body is pre-defined.


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

%% Add the body
item.type='body';
item.name='block';
item.mass=1;
item.momentsofinertia=[1;1;1];
item.productsofinertia=[0;0;0];
item.location=[0;0;0];
item.velocity=[v;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,9.81);
item={};

item.type='wing';
item.name='wing 1';
item.body1='block';
item.location=[0;0;0.5];
item.airspeed=v;
item.chord=0.1;
item.span=3;
item.cl0=10;
item.cd0=1;
item.cm0=2;
item.cla=1;
item.cda=1;
item.cma=1;
item.clu=1;
item.cdu=1;
item.cmu=1;
item.cmq=1;
the_system.item{end+1}=item;
item={};

item.type='actuator';
item.name='actuator 1';
item.body1='block';
item.body2='ground';
item.location1=[0.05;0;1];
item.location2=[0.05;0;0];
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='sensor 1';
item.body1='block';
item.body2='ground';
item.location1=[0;0.05;1];
item.location2=[0;0.05;0];
the_system.item{end+1}=item;
