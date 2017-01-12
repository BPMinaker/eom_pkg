function the_system=input_ex_four_bar(varargin)
the_system.name='Four Bar Linkage';
the_system.item={};

%% Copyright (C) 2016, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_four_bar.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_four_bar.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% Three bodies forming a four bar linkage, with a diagonal spring
%% An actuator connects the body to ground as well, to provide input forces.  Note that the ground body is pre-defined.


%% Define the default parameters of the system
params.k=25;
params.c=1;
params.l1=1;
params.l2=1;
params.l3=1;
params.l4=1;
params.m1=1;
params.m2=1;
params.m3=1;
params.phi=2.23433101898;

%% Check if the params variable is sent as input, with new values of the parameters 
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

%% Define the connection point of bodies 2 and 3
tmp=[params.l4+params.l3*cos(params.phi);params.l3*sin(params.phi);0];

%% An anonymous function to return the stretch in body 1 and 2, based on the location
%% of their connection
res=@(x) [norm(x)-params.l1; norm(x-tmp)-params.l2;x(3)];

%% Find the location of the connection of body 1 and 2, so that there is no stretch
options=optimset('TolFun',1e-9,'Display','off');
xy=fsolve(res,[0;params.l1;0],options);

g=[0;-9.81;0];

%% Now that preliminaries are out of the way, build the input file

%% Add the bodys
item=thin_rod([[0;0;0] xy],params.m1);
item.name='body 1';
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item=thin_rod([xy tmp],params.m2);
item.name='body 2';
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item=thin_rod([tmp [params.l4;0;0]],params.m3);
item.name='body 3';
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item={};  %% Clear the item

%% Constrain the bodies to rotation around the z-axis
item.type='rigid_point';
item.name='pin 1';
item.body1='body 1';
item.body2='ground';
item.location=[0;0;0];
item.forces=3;
item.moments=2;
item.axis=[0;0;1];
the_system.item{end+1}=item;

item.name='pin 2';
item.body1='body 1';
item.body2='body 2';
item.location=xy;
the_system.item{end+1}=item;

item.name='pin 3';
item.body1='body 2';
item.body2='body 3';
item.location=tmp;
the_system.item{end+1}=item;

item.name='pin 4';
item.body1='body 3';
item.body2='ground';
item.location=[params.l4;0;0];
item.forces=2;
item.moments=0;
the_system.item{end+1}=item;

item={};  %% Clear the item

%% Add the diagonal spring
item.type='spring';
item.name='spring 1';
item.body1='body 2';
item.body2='ground';
item.location1=tmp;
item.location2=[0;0;0];
item.stiffness=params.k;
item.damping=params.c;
the_system.item{end+1}=item;

item={};  %% Clear the item

item.type='actuator';
item.name='actuator 1';
item.body1='body 2';
item.body2='ground';
item.location1=tmp;
item.location2=[0;0;0];
item.gain=1;
item.travel=0.2;
the_system.item{end+1}=item;

item={};  %% Clear the item

item.type='sensor';
item.name='sensor 1';
item.body1='body 2';
item.body2='ground';
item.location1=tmp;
item.location2=[0;0;0];
the_system.item{end+1}=item;

%  %% Add the torsional actuator 
%  item.type='actuator';
%  item.name='actuator 1';
%  item.body1='body 3';
%  item.body2='ground';
%  item.location1=[params.l4;0;0];
%  item.location2=[params.l4;0;-0.1];
%  item.twist=1;
%  the_system.item{end+1}=item;
%  
%  %% The sensor is defined similarly, and can inherit properties of the actuator, no clear
%  item.type='sensor';
%  item.name='sensor 1';
%  the_system.item{end+1}=item;
