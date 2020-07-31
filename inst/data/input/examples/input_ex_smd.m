function the_system=input_ex_smd(varargin)
the_system.name='Spring Mass Damper';
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

params.k=100;
params.m=1;
params.c=2;

if(nargin()==2)  %% Are there two arguments? (ignore the first)
	if(isa(varargin{2},'struct'))  %% If so, is the second a struct?
		names=fieldnames(varargin{2});  %% If so, get the fieldnames
		for i=1:length(names)  %% For each fieldname
			if(isfield(params,names{i}))  %% Is this a field in our default?
				params.(names{i})=varargin{2}.(names{i});  %% If so, copy the field content to the default
			end
		end
	end
end

%% Add the body
item.type='body';
item.name='block';
item.mass=params.m;
item.momentsofinertia=[0;0;0];
item.productsofinertia=[0;0;0];
item.location=[0;0;1];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item);
item={};

%% Constrain the body to one translation in z, and no rotations
item.type='rigid_point';
item.name='slider 1';
item.body1='block';
item.body2='ground';
item.location=[0;0;1];
item.forces=2;
item.moments=3;
item.axis=[0;0;1];
the_system.item{end+1}=item;
item={};

%% Add a spring, with damping, to connect our body to ground, aligned with z-axis
item.type='flex_point';
item.name='spring 1';
item.body1='block';
item.body2='ground';
item.location=[0;0;0.5];
item.stiffness=[params.k;0]; %(AE/L)
item.damping=[params.c;0];
item.forces=1;
item.moments=0;
item.axis=[0;0;1];
the_system.item{end+1}=item;
item={};

%% The actuator is a 'line item' and defined by two locations, location1 attaches to body1, location2 to body2
item.type='actuator';
item.name='actuator 1';
item.body1='block';
item.body2='ground';
item.location1=[0.05;0;1];
item.location2=[0.05;0;0];
item.travel=0.25;
item.gain=params.k;
the_system.item{end+1}=item;
item={};

%% The actuator is a 'line item' and defined by two locations, location1 attaches to body1, location2 to body2
item.type='sensor';
item.name='sensor 1';
item.body1='block';
item.body2='ground';
item.location1=[0;0.05;1];
item.location2=[0;0.05;0];
the_system.item{end+1}=item;
