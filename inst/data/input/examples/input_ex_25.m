function the_system=input_ex_25(varargin)
the_system.item={};

%% Copyright (C) 2005, Bruce Minaker
%% This file is intended for use with Octave.
%% input.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

body.type='body';
body.name='body one';
body.mass=15;
body.momentsofinertia=[2;2;2];
body.productsofinertia=[0;0;0];
body.location=[0.5;0;0.5];
the_system.item{end+1}=body;

body.type='body';
body.name='body two';
body.mass=5;
body.momentsofinertia=[2;2;2];
body.productsofinertia=[0;0;0];
body.location=[-0.5;0;0.5];
the_system.item{end+1}=body;

item.type='spring';
item.name='spring one';
item.body1='body one';
item.body2='body two';
item.location1=[0.5;0;0.5];
item.location2=[-0.5;0;0.5];
item.stiffness=200; %%AE/L
the_system.item{end+1}=item;

item.name='shaft one';
item.body1='body one';
item.body2='body two';
item.location1=[0.5;0;0.5];
item.location2=[-0.5;0;0.5];
item.stiffness=150; %%GJ/L
item.twist=1;
the_system.item{end+1}=item;
item={};

item.type='beam';
item.name='beam one';
item.body1='body one';
item.body2='body two';
item.location1=[0.5;0;0.5];
item.location2=[-0.5;0;0.5];
item.stiffness=100; %%EI/L
the_system.item{end+1}=item;
item={};

item.type='actuator';
item.name='servo one';
item.body1='body one';
item.body2='body two';
item.location1=[0.5;0;0.5];
item.location2=[-0.5;0;0.5];
item.twist=1;
item.gain=1;
the_system.item{end+1}=item;


item.type='sensor';
item.name='sensor one';
item.body1='body one';
item.body2='body two';
item.location1=[0.5;0;0.5];
item.location2=[-0.5;0;0.5];
item.twist=1;
item.gain=1;
the_system.item{end+1}=item;

