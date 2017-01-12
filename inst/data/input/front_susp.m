function the_system=front_susp(the_system,u,g,varargin)
%% Copyright (C) 2017, Bruce Minaker
%% This file is intended for use with Octave.
%% front_susp.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% front_susp.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

velocity=[u;0;0];
angular_velocity=[0;u/0.3;0];

%%%%% LF Suspension bodys

item.type='body';
item.name='LF Upright';
item.mass=5;
item.momentsofinertia=[0.1;0.1;0.1];
item.productsofinertia=[0;0;0];
item.location=[1.2;0.8;0.3];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LF Lower A-arm';
item.mass=5;
item.momentsofinertia=[1;1;2];
item.productsofinertia=[0;0;0];
item.location=[1.2;0.6;0.15];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LF Upper A-arm';
item.mass=5;
item.momentsofinertia=[1;1;2];
item.productsofinertia=[0;0;0];
item.location=[1.2;0.6;0.4];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LF Bell-crank';
item.mass=1;
item.momentsofinertia=[0.05;0.05;0.05];
item.productsofinertia=[0;0;0];
item.location=[1.14;0.34;0.46];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LF Anti-roll arm';
item.mass=1;
item.momentsofinertia=[0.05;0.05;0.05];
item.productsofinertia=[0;0;0];
item.location=[1.3;0.3;0.4];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

fupre=[1.2;0.4;0.4];  %% upper push-rod end
flpre=[1.2;0.7;0.2];  %% lower push-rod end

item=thin_rod([fupre flpre],1);
item.velocity=velocity;
item.name='LF Push-rod';
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

fitre=[0.95;0.3;0.26];  %% inner tie-rod end
fotre=[1.13;0.8;0.3];  %% outer tie-rod end

item=thin_rod([fitre fotre],1);
item.name='LF Tie-rod';
item.velocity=velocity;
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LF Wheel+hub';
item.mass=10;
item.momentsofinertia=[2;4;2];
item.productsofinertia=[0;0;0];
item.location=[1.2;0.9;0.3];
item.velocity=velocity;
item.angular_velocity=angular_velocity;
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item={};  %% clear item

%%%%% LF Suspension constraints

item.type='rigid_point';
item.name='LF Wheel bearing';
item.body1='LF Wheel+hub';
item.body2='LF Upright';
item.location=[1.2;0.9;0.3];
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='LF Lower ball joint';
item.body1='LF Upright';
item.body2= 'LF Lower A-arm';
item.location=[1.2;0.8;0.15];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LF Lower A-arm pivot, rear';
item.body1='LF Lower A-arm';
item.body2='Chassis';
item.location=[1.0;0.1;0.15];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LF Lower A-arm pivot, front';
item.body1='LF Lower A-arm';
item.body2='Chassis';
item.location=[1.4;0.1;0.1];
item.forces=2;
item.moments=0;
item.axis=[1;0;0;];
the_system.item{end+1}=item;

item.name='LF Bell-crank pivot';
item.body1='LF Bell-crank';
item.body2='Chassis';
item.location=[1.1;0.4;0.4];
item.forces=3;
item.moments=2;
item.axis=[0;2^-0.5;2^-0.5];
the_system.item{end+1}=item;

item.name='LF Upper A-arm pivot, front';
item.body1='LF Upper A-arm';
item.body2='Chassis';
item.location=[1.4;0.3;0.35];
item.forces=2;
item.moments=0;
item.axis=[1;0;0];
the_system.item{end+1}=item;

item.name='LF Upper A-arm pivot, rear';
item.body1='LF Upper A-arm';
item.body2='Chassis';
item.location=[1.0;0.3;0.35];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LF Upper ball joint';
item.body1='LF Upper A-arm';
item.body2='LF Upright';
item.location=[1.2;0.75;0.45];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LF Lower push-rod end';
item.body1='LF Lower A-arm';
item.body2='LF Push-rod';
item.location=flpre;
item.forces=3;
item.moments=1;
item.axis=(fupre-flpre)/norm(fupre-flpre);
the_system.item{end+1}=item;

item.name='LF Upper push-rod end';
item.body1='LF Bell-crank';
item.body2='LF Push-rod';
item.location=fupre;
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LF Inner tie-rod end';
item.body1='Chassis';
item.body2='LF Tie-rod';
item.location=fitre;
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LF Outer tie-rod end';
item.body1='LF Upright';
item.body2='LF Tie-rod';
item.location=fotre;
item.forces=3;
item.moments=1;
item.axis=(fotre-fitre)/norm(fotre-fitre);
the_system.item{end+1}=item;

item.name='LF Anti-roll mount';
item.body1='LF Anti-roll arm';
item.body2='Chassis';
item.location=[1.3;0.3;0.35];
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item={};

item.type='link';
item.name='LF Drop link';
item.body1='LF Bell-crank';
item.body2='LF Anti-roll arm';
item.location1=[1.14;0.3;0.5];
item.location2=[1.3;0.3;0.5];
the_system.item{end+1}=item;

item={};

%%%%% Springs

item.type='spring';
item.name='LF Suspension spring';
item.location1=[1.1;0.3;0.5];
item.location2=[0.7;0.3;0.5];
item.body1='LF Bell-crank';
item.body2='Chassis';
item.stiffness=20000;
item.damping=2000;
the_system.item{end+1}=item;

item={};

%%%%% Tires (flex_points)

item.type='flex_point';
item.name='LF Tire, vertical';
item.body1='LF Wheel+hub';
item.body2='ground';
item.location=[1.2;0.9;0];
item.stiffness=[150000,0];
item.damping=[0;0];
item.forces=1;
item.moments=0;
item.axis=[0;0;1];
item.rolling_axis=[0;1;0];
the_system.item{end+1}=item;

end %% Leave

