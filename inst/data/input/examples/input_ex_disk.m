function the_system=input_ex_disk(v,varargin)
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_disk.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_disk.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% The classic rolling disk problem
%%  Schwab,A.L., Meijaard,J.P., Dynamics Of Flexible Multibody Systems With Non-Holonomic Constraints: A Finite Element Approach, Multibody System Dynamics 10: (2003) pp. 107-123


% vcrit=sqrt(gr/3);

params.m=4;
params.r=0.5;

if(nargin()==2)  %% Are there two arguments?
	if(isa(varargin{1},'struct'))  %% If so, is the second a struct?
		names=fieldnames(varargin{1});  %% If so, get the fieldnames
		for i=1:length(names)  %% For each fieldname
			if(isfield(params,names{i}))  %% Is this a field in our default?
				params.(names{i})=varargin{1}.(names{i});  %% If so, copy the field content to the default
			end
		end
	end
end

%% Add the wheel
item.type='body';
item.name='wheel';
item.mass=params.m;
item.momentsofinertia=[0.25*params.m*params.r^2;0.5*params.m*params.r^2;0.25*params.m*params.r^2];
item.productsofinertia=[0;0;0];
item.location=[0;0;params.r];
item.velocity=[v;0;0];
item.angular_velocity=[0;v/params.r;0];
the_system.item{end+1}=item;
item={};

%% Add external force (weight)
item.type='load';
item.name='weight';
item.body='wheel';
item.location=[0;0;params.r];
item.force=[0;0;-9.8*params.m];
item.moment=[0;0;0];
the_system.item{end+1}=item;
item={};

%% Add ground contact, vertical and longitudinal forces
item.type='rigid_point';
item.name='contact';
item.body1='wheel';
item.body2='ground';
item.location=[0;0;0];
item.forces=2;
item.moments=0;
item.axis=[0;1;0];
item.rolling_axis=[0;1;0];
the_system.item{end+1}=item;
item={};

%% Add ground contact, lateral
item.type='nh_point';
item.name='rolling';
item.body1='wheel';
item.body2='ground';
item.location=[0;0;0];
item.forces=1;
item.moments=0;
item.axis=[0;1;0];
the_system.item{end+1}=item;
item={};

%% Add some inputs and outputs
item.type='sensor';
item.name='sensor';
item.body1='wheel';
item.body2='ground';
item.location1=[0;0;params.r];
item.location2=[0.1;0;params.r];
item.twist=1;
item.order=2;
item.frame=1;
the_system.item{end+1}=item;
item={};

item.type='actuator';
item.name='servo';
item.body1='wheel';
item.body2='ground';
item.location1=[0;0;params.r];
item.location2=[0;0;0];
item.twist=1;
item.gain=1;
the_system.item{end+1}=item;
item={};

end
