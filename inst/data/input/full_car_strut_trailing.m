function the_system=full_car_strut_trailing(u,varargin)
the_system.name='Full Car Strut & Trailing Arm';
the_system.item={};

%% Copyright (C) 2011, Bruce Minaker
%% This file is intended for use with Octave.
%% full_car_a_arm_pushrod.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% full_car_a_arm_pushrod.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% Set linear or nonlinear flag
%% 1 for nonlinear, 0 for linear
nonlinear=1;

if(u==0 && nonlinear==0) 
	error('Non zero speed needed for tire model.');
end

g=9.81;

velocity=[u;0;0];
angular_velocity=[0;u/0.3;0];

item.type='body';
item.name='Chassis';
item.mass=1116;
item.momentsofinertia=[800;2000;2200];
item.productsofinertia=[0;0;0];
item.location=[1.596;0;.54];
item.velocity=velocity;
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item={};

the_system=mac_strut(the_system,u,g);
the_system=trailing(the_system,u,g);

d=0.5*0.0254;
G=75e9;
J=pi*d^4/32;
L=0.265*2;

item.type='spring';
item.name='Anti-roll bar';
item.body1='LF Anti-roll arm';
item.body2='RF Anti-roll arm';
item.location1=[2.41;0.265;0.2];                %Links both antiroll arm MOUNTS together
item.location2=[2.41;-0.265;0.2];
item.stiffness=G*J/L;          %%13808 ??;
item.damping=0;
item.twist=1;
the_system.item{end+1}=item;

d=0.375*0.0254;
G=75e9;
J=pi*d^4/32;
L=0.265*2;

item.name='Rear Anti-roll bar';
item.body1='LR Anti-roll arm';
item.body2='RR Anti-roll arm';                 %%Rear sway bar added here
item.location1=[-0.175;0.21;0.24];
item.location2=[-0.175;-0.21;0.24];
item.stiffness=G*J/L;          %%8234  ???;
item.damping=0;
item.twist=1;
the_system.item{end+1}=item;

item={};

%% If not nonlinear, add linear tire models

if (~nonlinear)
item.type='body';
item.name='LF Contact patch';
item.mass=0;
item.momentsofinertia=[0;0;0];
item.productsofinertia=[0;0;0];              %Y
item.location=[2.62;0.74;0.0];
item.velocity=[0;0;0];
item.angular_velocity=[0;0;0];
the_system.item{end+1}=item;

item.name='LR Contact patch';
item.location=[0;0.74;0.0];                   %Y
the_system.item{end+1}=item;
item={};

item.type='rigid_point';
item.name='LF Contact patch constraint';
item.body1='LF Contact patch';
item.body2='LF Wheel+hub';
item.location=[2.62;0.74;0.0];             %Y
item.forces=2;
item.moments=3;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='LR Contact patch constraint';
item.body1='LR Contact patch';
item.body2='LR Wheel+hub';
item.location=[0;0.74;0.0];             %Y
the_system.item{end+1}=item;
item={};

item.type='flex_point';
item.name='LF Tire, sidewall';
item.body1='LF Wheel+hub';
item.body2='LF Contact patch';
item.location=[2.62;0.74;0];
item.stiffness=[150000,0];
item.damping=[0;0];
item.forces=1;
item.moments=0;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='LR Tire, sidewall';
item.body1='LR Wheel+hub';
item.body2='LR Contact patch';
item.location=[0;0.74;0];                  %Y
the_system.item{end+1}=item;

item.name='LF Tire, horizontal';
item.body1='LF Contact patch';
item.body2='ground';
item.location=[2.62;0.74;0];               %Y
item.stiffness=[0;0];
item.damping=[40000/u;0];
item.forces=2;
item.moments=0;
item.axis=[0;0;1];
the_system.item{end+1}=item;

item.name='LR Tire, horizontal';
item.body1='LR Contact patch';
item.location=[0;0.74;0];                  %Y
the_system.item{end+1}=item;
item={};

end

%%%%% Reflect all LF or LR items in y axis
the_system=mirror(the_system);

if (nonlinear)
item.type='tire';
item.name='LF Tire';
item.body1='LF Wheel+hub';
item.body2='ground';
item.location=[2.62;0.74;0];
item.stiffness=150000;
the_system=add_tire(the_system,item);

item.name='LR Tire';
item.body1='LR Wheel+hub';
item.location=[0;0.74;0];
the_system=add_tire(the_system,item);

item.name='RF Tire';
item.body1='RF Wheel+hub';
item.location=[2.62;-0.74;0];
the_system=add_tire(the_system,item);

item.name='RR Tire';
item.body1='RR Wheel+hub';
item.location=[0;-0.74;0];
the_system=add_tire(the_system,item);           %Y
item={};

%% Add sensors and actuators
%item.type='actuator';
%item.name='LR torque';                          %Does this not mean it is RWD?
%item.body1='Chassis';
%item.body2='LR Wheel+hub';
%item.location1=[0;0;0.28];
%item.location2=[0;-.74;0.28];                   
%item.twist=1;                                   
%the_system.item{end+1}=item;

%item.name='RR torque';
%item.body1='Chassis';
%item.body2='RR Wheel+hub';
%item.location1=[0;0;0.28];
%item.location2=[0;.74;0.28];
%item.twist=1;
%item.gain=-1;
%the_system.item{end+1}=item;


item.type='actuator';
item.name='LF torque';                                        %For FWD?
item.body1='Chassis';
item.body2='LF Wheel+hub';
item.location1=[2.62;0;0.28];
item.location2=[2.62;0.74;0.28];
item.twist=1;
the_system.item{end+1}=item;

item.name='RF torque';
item.body1='Chassis';
item.body2='RF Wheel+hub';
item.location1=[2.62;0;0.28];
item.location2=[2.62;-0.74;0.28];
item.twist=1;
item.gain=-1;
the_system.item{end+1}=item;


item.type='actuator';
item.name='LF brake';
item.body1='LF Upright';
item.body2='LF Wheel+hub';
item.location1=[2.62;0.64;0.28];
item.location2=[2.62;0.74;0.28];
item.twist=1;
item.gain=-1;
the_system.item{end+1}=item;

item.name='LR brake';
item.body1='LR Upright';
item.body2='LR Wheel+hub';
item.location1=[0;0.64;0.28];
item.location2=[0;0.74;0.28];
item.twist=1;
item.gain=-1;
the_system.item{end+1}=item;

item.name='RF brake';
item.body1='RF Upright';
item.body2='RF Wheel+hub';
item.location1=[2.62;-0.64;0.28];
item.location2=[2.62;-0.74;0.28];
item.twist=1;
item.gain=1;
the_system.item{end+1}=item;

item.name='RR brake';
item.body1='RR Upright';
item.body2='RR Wheel+hub';
item.location1=[0;-0.64;0.28];
item.location2=[0;-0.74;0.28];
item.twist=1;
item.gain=1;
the_system.item{end+1}=item;
item={};

item.type='sensor';
item.name='$z_G$';
item.body1='Chassis';
item.body2='ground';
item.location1=[1.596;0;0.54];
item.location2=[1.496;0;0.54];
the_system.item{end+1}=item;

item.type='actuator';
item.name='Aero forces';
the_system.item{end+1}=item;
item={};

else

%% Add sensors and actuators
item.type='sensor';
item.name='F Chassis bounce';
item.body1='Chassis';
item.body2='ground';
item.location1=[2.62;0.74;0.4];
item.location2=[2.62;0.74;0.0];
item.twist=0;
item.order=1;
the_system.item{end+1}=item;

item.name='F Susp travel';
item.body1='Chassis';
item.body2='LF Wheel+hub';
item.location1=[2.62;0.74;0.4];
item.location2=[2.62;0.74;0.28];
the_system.item{end+1}=item;

item.name='F Tire squish';
item.body1='LF Wheel+hub';
item.body2='ground';
item.location1=[2.62;0.74;0.28];
item.location2=[2.62;0.74;0.0];
item.actuator='LF Wheel bump';
the_system.item{end+1}=item;

item={};

item.type='actuator';
item.name='LF Wheel bump';
item.body1='LF Wheel+hub';
item.body2='ground';
item.location1=[2.62;0.74;0.0];
item.location2=[2.62;0.74;-0.25];
item.gain=150000;
item.twist=0;
the_system.item{end+1}=item;

end

for i=1:length(the_system.item)
	if(isfield(the_system.item{i},'location'))
		the_system.item{i}.location=the_system.item{i}.location-[1.596;0;0];
	elseif(isfield(the_system.item{i},'location1'))
		the_system.item{i}.location1=the_system.item{i}.location1-[1.596;0;0];
		the_system.item{i}.location2=the_system.item{i}.location2-[1.596;0;0];
	end
end


end %% Leave

