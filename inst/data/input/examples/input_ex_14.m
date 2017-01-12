function the_system=input_ex_14(v,varargin)
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_14.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_14.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

% vcrit=sqrt(gr/3);

params.m1=4;
params.m2=4;
params.r=0.5;
params.l=0.8;
params.theta=0;
params.x=0;
params.z=0.5*params.r;

i1=params.m1*params.r^2;
i2=(1/12)*params.m2*params.l^2;
ct=cos(params.theta*pi/180);
st=sin(params.theta*pi/180);


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

item.type='body';
item.name='wheel';
item.mass=params.m1;
item.momentsofinertia=[0.5*i1;i1;0.5*i1];
item.productsofinertia=[0;0;0];
item.location=[0;0;params.r];
item.velocity=[v;0;0];
item.angular_velocity=[0;v/params.r;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,9.81);
item={};


item.type='body';
item.name='chassis';
item.mass=params.m2;
item.momentsofinertia=[ct^2*i2;i2; st^2*i2];
item.productsofinertia=[0;0;-ct*st*i2];
item.location=[params.x;0;params.z];
item.velocity=[v;0;0];
item.angular_velocity=[0;0;0];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,9.81);
item={};

item.type='rigid_point';
item.name='axle';
item.body1='wheel';
item.body2='chassis';
item.location=[0;0;params.r];
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;
item={};

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

item.type='rigid_point';
item.name='contact';
item.body1='chassis';
item.body2='ground';
item.location=[-1;0;0];
item.forces=1;
item.moments=0;
item.axis=[0;0;1];
the_system.item{end+1}=item;
item={};

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
