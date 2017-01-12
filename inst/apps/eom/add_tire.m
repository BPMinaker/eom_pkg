function the_system=add_tire(the_system,tire)

%% Copyright (C) 2015, Bruce Minaker
%% This file is intended for use with Octave.
%% add_tire.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% add_tire.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

% A funtion to ease creation of interface of nonlinear tire elements
% Adds a spring, three actuators and three sensors

if(~isfield(tire,'name') || ~isfield(tire,'location') || ~isfield(tire,'stiffness'))
	error('Tire properties are missing.');
end

item.type='sensor';
item.name=[tire.name ', vertical'];
item.body1=tire.body1;
item.body2=tire.body2;
item.location1=tire.location;
item.location2=tire.location-[0;0;0.1];
item.gain=tire.stiffness;
the_system.item{end+1}=item;

item.type='actuator';
item.name=[tire.name ', lateral'];
item.location2=tire.location-[0;0.1;0];
item.gain=1;
the_system.item{end+1}=item;

item.type='sensor';
the_system.item{end+1}=item;

item.type='actuator';
item.name=[tire.name ', longitudinal'];
item.location2=tire.location-[0.1;0;0];
the_system.item{end+1}=item;

item.type='sensor';
the_system.item{end+1}=item;

end %% Leave










%  item=tire;  %% Make a copy of tire info
%  
%  item.type='flex_point';
%  item.stiffness=[item.stiffness;0];
%  item.forces=1;
%  item.moments=0;
%  item.axis=[0;0;1];
%  item.rolling_axis=[0;1;0];
%  the_system.item{end+1}=item;

%  item=tire;  %% Reset
%  
%  item.type='actuator';
%  item.name=[tire.name ', vertical'];
%  item.location1=tire.location;
%  item.location2=tire.location-[0;0;0.1];
%  item=rmfield(item,'location');
%  item.gain=tire.stiffness;
%  item=rmfield(item,'stiffness');
%the_system.item{end+1}=item;
