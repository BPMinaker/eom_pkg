function the_system=input_ex_rotor(v,varargin)
the_system.item={};

%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_ex_rotor.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_ex_rotor.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% Implement the rotor with flex bushings from ADAMS paper
%% Negrut,D., Ortiz, J.L., A Practical Approach for the linearisation of the Constrained Multibody Dynamics Equations, Journal of Computational and Nonlinear Dynamics, Volume 1, 2006

body.type='body';
body.name='rotor';
body.mass=1300;
body.momentsofinertia=[500;500;1000];
body.productsofinertia=[0;0;0];
body.location=[0;0;0.75];
body.velocity=[0;0;0];
body.angular_velocity=[0;0;2*pi*v];
the_system.item{end+1}=body;

body.type='body';
body.name='stator';
body.mass=200;
body.momentsofinertia=[50;50;10];
body.productsofinertia=[0;0;0];
body.location=[0;0;0];
body.velocity=[0;0;0];
body.angular_velocity=[0;0;0];
the_system.item{end+1}=body;

point.type='rigid_point';
point.name='bearing';
point.body1='rotor';
point.body2='stator';
point.location=[0;0;0];
point.forces=3;
point.moments=2;
point.axis=[0;0;1];
the_system.item{end+1}=point;

point.type='flex_point';
point.name='bushing';
point.body1='ground';
point.body2='stator';
point.location=[0;0;0];
point.forces=3;
point.moments=0;
point.axis=[0;0;0];
point.stiffness=[1000;0];
point.damping=[1;0];
the_system.item{end+1}=point;


point.type='flex_point';
point.name='bushing2';
point.body1='ground';
point.body2='stator';
point.location=[0;0;0];
point.forces=0;
point.moments=2;
point.axis=[0;0;1];
point.stiffness=[0;10000];
point.damping=[0;10];
the_system.item{end+1}=point;


point.type='flex_point';
point.name='bushing3';
point.body1='ground';
point.body2='stator';
point.location=[0;0;0];
point.forces=0;
point.moments=1;
point.axis=[0;0;1];
point.stiffness=[0;100000];
point.damping=[0;100];
the_system.item{end+1}=point;



