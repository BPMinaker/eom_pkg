function the_system=full_car_a_arm_pushrod_reduced(u,varargin)
the_system.item={};

%% Copyright (C) 2011, Bruce Minaker
%% This file is intended for use with Octave.
%% a_arm_pushrod.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% a_arm_pushrod.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

g=9.81;
velocity=[u;0;0];

item.type='body';
item.name='Chassis';
item.mass=1400;
item.momentsofinertia=[500;1200;1800];
item.productsofinertia=[0;0;0];
item.location=[0;0;0.5];
item.velocity=velocity;
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LF Upright';
item.mass=5;
item.momentsofinertia=[0.1;0.1;0.1];
item.productsofinertia=[0;0;0];
item.location=[1.2;0.8;0.3];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LF Wheel+hub';
item.mass=10;
item.momentsofinertia=[2;4;2];
item.productsofinertia=[0;0;0];
item.location=[1.2;0.9;0.3];
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
item.location=[1.15;0.35;0.45];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

fupre=[1.2;0.4;0.4];
flpre=[1.2;0.7;0.2];

% item=thin_rod([fupre flpre],1);
% item.velocity=velocity;
% item.name='LF Push-rod';
% the_system.item{end+1}=item;
% the_system.item{end+1}=weight(item,g);

fitre=[0.95;0.3;0.26];
fotre=[1.13;0.8;0.3];

% item=thin_rod([fitre fotre],1);
% item.name='LF Tie-rod';
% item.velocity=velocity;
% the_system.item{end+1}=item;
% the_system.item{end+1}=weight(item,g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

item.name='LR Upright';
item.mass=5;
item.momentsofinertia=[0.1;0.1;0.1];
item.productsofinertia=[0;0;0];
item.location=[-1.3;0.8;0.3];
item.velocity=velocity;
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LR Wheel+hub';
item.mass=10;
item.momentsofinertia=[2;4;2];
item.productsofinertia=[0;0;0];
item.location=[-1.3;0.9;0.3];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LR Lower A-arm';
item.mass=5;
item.momentsofinertia=[1;1;2];
item.productsofinertia=[0;0;0];
item.location=[-1.3;0.6;0.15];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LR Upper A-arm';
item.mass=5;
item.momentsofinertia=[1;1;2];
item.productsofinertia=[0;0;0];
item.location=[-1.3;0.6;0.4];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

item.name='LR Bell-crank';
item.mass=1;
item.momentsofinertia=[0.05;0.05;0.05];
item.productsofinertia=[0;0;0];
item.location=[-1.25;0.35;0.45];
the_system.item{end+1}=item;
the_system.item{end+1}=weight(item,g);

rupre=[-1.3;0.4;0.4];
rlpre=[-1.3;0.7;0.2];

% item=thin_rod([rupre rlpre],1);
% item.velocity=velocity;
% item.name='LR Push-rod';
% the_system.item{end+1}=item;
% the_system.item{end+1}=weight(item,g);

ritre=[-1.05;0.1;0.1];
rotre=[-1.23;0.8;0.15];

% item=thin_rod([ritre rotre],1);
% item.name='LR Tie-rod';
% item.velocity=velocity;
% the_system.item{end+1}=item;
% the_system.item{end+1}=weight(item,g);
item={};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% item.name='LF Lower push-rod end';
% item.body1='LF Lower A-arm';
% item.body2='LF Push-rod';
% item.location=flpre;
% item.forces=3;
% item.moments=1;
% item.axis=(fupre-flpre)/norm(fupre-flpre);
% the_system.item{end+1}=item;

% item.name='LF Upper push-rod end';
% item.body1='LF Bell-crank';
% item.body2='LF Push-rod';
% item.location=fupre;
% item.forces=3;
% item.moments=0;
% the_system.item{end+1}=item;

% item.name='LF Inner tie-rod end';
% item.body1='Chassis';
% item.body2='LF Tie-rod';
% item.location=fitre;
% item.forces=3;
% item.moments=0;
% the_system.item{end+1}=item;

% item.name='LF Outer tie-rod end';
% item.body1='LF Upright';
% item.body2='LF Tie-rod';
% item.location=fotre;
% item.forces=3;
% item.moments=1;
% item.axis=(fotre-fitre)/norm(fotre-fitre);
% the_system.item{end+1}=item;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

item.name='LR Wheel bearing';
item.body1='LR Wheel+hub';
item.body2='LR Upright';
item.location=[-1.3;0.9;0.3];
item.forces=3;
item.moments=2;
item.axis=[0;1;0];
the_system.item{end+1}=item;

item.name='LR Lower ball joint';
item.body1='LR Upright';
item.body2= 'LR Lower A-arm';
item.location=[-1.3;0.8;0.15];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LR Lower A-arm pivot, front';
item.body1='LR Lower A-arm';
item.body2='Chassis';
item.location=[-1.1;0.1;0.1];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LR Lower A-arm pivot, rear';
item.body1='LR Lower A-arm';
item.body2='Chassis';
item.location=[-1.5;0.1;0.1];
item.forces=2;
item.moments=0;
item.axis=[1;0;0;];
the_system.item{end+1}=item;

item.name='LR Bell-crank pivot';
item.body1='LR Bell-crank';
item.body2='Chassis';
item.location=[-1.2;0.4;0.4];
item.forces=3;
item.moments=2;
item.axis=[0;2^-0.5;2^-0.5];
the_system.item{end+1}=item;

item.name='LR Upper A-arm pivot, rear';
item.body1='LR Upper A-arm';
item.body2='Chassis';
item.location=[-1.5;0.3;0.35];
item.forces=2;
item.moments=0;
item.axis=[1;0;0];
the_system.item{end+1}=item;

item.name='LR Upper A-arm pivot, front';
item.body1='LR Upper A-arm';
item.body2='Chassis';
item.location=[-1.1;0.3;0.35];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

item.name='LR Upper ball joint';
item.body1='LR Upper A-arm';
item.body2='LR Upright';
item.location=[-1.3;0.75;0.45];
item.forces=3;
item.moments=0;
the_system.item{end+1}=item;

% item.name='LR Lower push-rod end';
% item.body1='LR Lower A-arm';
% item.body2='LR Push-rod';
% item.location=rlpre;
% item.forces=3;
% item.moments=1;
% item.axis=(rupre-rlpre)/norm(rupre-rlpre);
% the_system.item{end+1}=item;

% item.name='LR Upper push-rod end';
% item.body1='LR Bell-crank';
% item.body2='LR Push-rod';
% item.location=rupre;
% item.forces=3;
% item.moments=0;
% the_system.item{end+1}=item;

% item.name='LR Inner tie-rod end';
% item.body1='Chassis';
% item.body2='LR Tie-rod';
% item.location=ritre;
% item.forces=3;
% item.moments=0;
% the_system.item{end+1}=item;

% item.name='LR Outer tie-rod end';
% item.body1='LR Upright';
% item.body2='LR Tie-rod';
% item.location=rotre;
% item.forces=3;
% item.moments=1;
% item.axis=(rotre-ritre)/norm(rotre-ritre);
% the_system.item{end+1}=item;
item={};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

item.type='spring';
item.name='LF Suspension spring';
item.location1=[1.1;0.3;0.5];
item.location2=[0.7;0.3;0.5];
item.body1='LF Bell-crank';
item.body2='Chassis';
item.stiffness=20000;
item.damping=1000;
the_system.item{end+1}=item;

item.name='LR Suspension spring';
item.location1=[-1.2;0.3;0.5];
item.location2=[-0.8;0.3;0.5];
item.body1='LR Bell-crank';
item.body2='Chassis';
item.stiffness=20000;
item.damping=1000;
the_system.item{end+1}=item;
item={};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

item.type='link';
item.name='LF Tie Rod';
item.body1='LF Upright';
item.body2='Chassis';
item.location1=fotre;
item.location2=fitre;
the_system.item{end+1}=item;

item.name='LF Push Rod';
item.body1='LF Lower A-arm';
item.body2='LF Bell-crank';
item.location1=flpre;
item.location2=fupre;
the_system.item{end+1}=item;

item.name='LR Tie Rod';
item.body1='LR Upright';
item.body2='Chassis';
item.location1=rotre;
item.location2=ritre;
the_system.item{end+1}=item;

item.name='LR Push Rod';
item.body1='LR Lower A-arm';
item.body2='LR Bell-crank';
item.location1=rlpre;
item.location2=rupre;
the_system.item{end+1}=item;
item={};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% item.type='flex_point';
% item.name='LF Fire, horz';
% item.body1='LF Wheel+hub';
% item.body2='ground';
% item.location=[1.2;0.9;0];
% item.stiffness=[0;0];
% item.damping=[20000/u;0];
% item.forces=1;
% item.moments=0;
% item.axis=[0;1;0];
% the_system.item{end+1}=item;
% 
% item.name='LR Fire, horz';
% item.body1='LR Wheel+hub';
% item.location=[-1.3;0.9;0];
% the_system.item{end+1}=item;
% item={};

%% Reflect, but not chassis
for i=3:length(the_system.item)
	item=the_system.item{i};
	switch item.type
	
		case 'body'
	
			item.name=strrep(item.name,'LF','RF');
			item.name=strrep(item.name,'LR','RR');
			item.location(2)=-item.location(2);
			item.productsofinertia(1)=-item.productsofinertia(1);
			item.productsofinertia(2)=-item.productsofinertia(2);
			the_system.item{end+1}=item;
			
		case 'rigid_point'

			item.name=strrep(item.name,'LF','RF');
			item.name=strrep(item.name,'LR','RR');
			item.body1=strrep(item.body1,'LF','RF');
			item.body1=strrep(item.body1,'LR','RR');
			item.body2=strrep(item.body2,'LF','RF');
			item.body2=strrep(item.body2,'LR','RR');
			item.location(2)=-item.location(2);
			if(isfield(item,'axis'))
				item.axis(2)=-item.axis(2);
			end
			if(isfield(item,'rolling_axis'))
				item.rolling_axis(2)=-item.rolling_axis(2);
			end
			the_system.item{end+1}=item;
			
		case 'flex_point'

			item.name=strrep(item.name,'LF','RF');
			item.name=strrep(item.name,'LR','RR');
			item.body1=strrep(item.body1,'LF','RF');
			item.body1=strrep(item.body1,'LR','RR');
			item.body2=strrep(item.body2,'LF','RF');
			item.body2=strrep(item.body2,'LR','RR');
			item.location(2)=-item.location(2);
			if(isfield(item,'axis'))
				item.axis(2)=-item.axis(2);
			end
			if(isfield(item,'rolling_axis'))
				item.rolling_axis(2)=-item.rolling_axis(2);
			end
			the_system.item{end+1}=item;

		case 'link'
			
			item.name=strrep(item.name,'LF','RF');
			item.name=strrep(item.name,'LR','RR');
			item.body1=strrep(item.body1,'LF','RF');
			item.body1=strrep(item.body1,'LR','RR');
			item.body2=strrep(item.body2,'LF','RF');
			item.body2=strrep(item.body2,'LR','RR');
			item.location1(2)=-item.location1(2);
			item.location2(2)=-item.location2(2);
			the_system.item{end+1}=item;

		case 'spring'

			item.name=strrep(item.name,'LF','RF');
			item.name=strrep(item.name,'LR','RR');
			item.body1=strrep(item.body1,'LF','RF');
			item.body1=strrep(item.body1,'LR','RR');
			item.body2=strrep(item.body2,'LF','RF');
			item.body2=strrep(item.body2,'LR','RR');
			item.location1(2)=-item.location1(2);
			item.location2(2)=-item.location2(2);
			the_system.item{end+1}=item;

		case 'load'

			item.name=strrep(item.name,'LF','RF');
			item.name=strrep(item.name,'LR','RR');
			item.body=strrep(item.body,'LF','RF');
			item.body=strrep(item.body,'LR','RR');
			item.location(2)=-item.location(2);
			item.force(2)=-item.force(2);
			item.moment(2)=-item.moment(2);
			the_system.item{end+1}=item;
			
		case 'sensor'
			
			item.name=strrep(item.name,'LF','RF');
			item.name=strrep(item.name,'LR','RR');
			item.body1=strrep(item.body1,'LF','RF');
			item.body1=strrep(item.body1,'LR','RR');
			item.body2=strrep(item.body2,'LF','RF');
			item.body2=strrep(item.body2,'LR','RR');
			item.location1(2)=-item.location1(2);
			item.location2(2)=-item.location2(2);
			the_system.item{end+1}=item;	
			
		case 'actuator'
			
			item.name=strrep(item.name,'LF','RF');
			item.name=strrep(item.name,'LR','RR');
			item.body1=strrep(item.body1,'LF','RF');
			item.body1=strrep(item.body1,'LR','RR');
			item.body2=strrep(item.body2,'LF','RF');
			item.body2=strrep(item.body2,'LR','RR');
			item.location1(2)=-item.location1(2);
			item.location2(2)=-item.location2(2);
			the_system.item{end+1}=item;
	end
end
item={};

item.type='tire';
item.name='LF Tire';
item.body1='LF Wheel+hub';
item.body2='ground';
item.location=[1.2;0.9;0];
item.stiffness=150000;
the_system=add_tire(the_system,item);

item.name='LR Tire';
item.body1='LR Wheel+hub';
item.location=[-1.3;0.9;0];
the_system=add_tire(the_system,item);

item.name='RF Tire';
item.body1='RF Wheel+hub';
item.location=[1.2;-0.9;0];
the_system=add_tire(the_system,item);

item.name='RR Tire';
item.body1='RR Wheel+hub';
item.location=[-1.3;-0.9;0];
the_system=add_tire(the_system,item);

item={};
item.type='sensor';
item.name='$z_G$';
item.body1='Chassis';
item.body2='ground';
item.location1=[0;0;0.5];
item.location2=[-0.1;0;0.5];
the_system.item{end+1}=item;

item.type='actuator';
item.name='Aero forces';
the_system.item{end+1}=item;

end %% Leave
