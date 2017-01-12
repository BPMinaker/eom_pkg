function the_system=input_ex_half_car_test(u,varargin)
the_system.item={};
params.a=1.4;
params.b=1.7;
params.kf=35000;
params.kr=38000;
params.cf=0;
params.cr=0;
params.m=1500;
params.I=2100;
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
body.mass=params.m;
body.momentsofinertia=[0;params.I;0];  %% Only the Iy term matters here
body.productsofinertia=[0;0;0];
body.location=[0;0;0.25];  %% Put cg at origin, but offset vertically to make animation more clear 
body.velocity=[u;0;0];
body.name='truck';
body.type='body';
the_system.item{end+1}=body;

body.name='unsprung_f';
body.mass=50;
body.location=[params.a;0;0.1];
the_system.item{end+1}=body;

body.name='unsprung_r';
body.mass=40;
body.location=[-params.b;0;0.1];
the_system.item{end+1}=body;

spring.name='front susp';
spring.type='flex_point';
spring.body1='truck';
spring.body2='unsprung_f';
spring.location=[params.a;0;0.25];  %% Front axle 'a' m ahead of cg
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];  %% Spring acts in z direction
spring.stiffness=[params.kf;0];  %% Linear stiffness 'kf' N/m; (torsional stiffness zero, not a torsion spring so has no effect
spring.damping=[params.cf;0];
the_system.item{end+1}=spring;
spring.name='rear susp';  %% We reset location and stiffness, but other properties are the same
spring.body1='truck';
spring.body2='unsprung_r';
spring.location=[-params.b;0;0.25];  %% Rear axle 'b' m behind cg
spring.stiffness=[params.kr;0];
spring.damping=[params.cr;0];
the_system.item{end+1}=spring;

spring.type='flex_point';
spring.name='tire';
spring.body1='unsprung_f';
spring.body2='ground';
spring.stiffness=[300000;0];
spring.damping=[0;0];
spring.location=[params.a;0;0.15];
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
the_system.item{end+1}=spring;

spring.type='flex_point';
spring.name='tire';
spring.body1='unsprung_r';
spring.body2='ground';
spring.stiffness=[300000;0];
spring.damping=[0;0];
spring.location=[-params.b;0;0.15];
spring.forces=1;
spring.moments=0;
spring.axis=[0;0;1];
the_system.item{end+1}=spring;

point.type='rigid_point';
point.name='slider front';
point.body1='unsprung_f';
point.body2='ground';
point.location=[params.a;0;0.1];
point.forces=2;
point.moments=3;
point.axis=[0;0;1];
the_system.item{end+1}=point;

point.type='rigid_point';
point.name='slider rear';
point.body1='unsprung_r';
point.body2='ground';
point.location=[-params.b;0;0.1];
point.forces=2;
point.moments=3;
point.axis=[0;0;1];
the_system.item{end+1}=point;
point.type='rigid_point';
point.name='road';
point.body1='truck';
point.body2='ground';
point.location=[0;0;0.25];
point.forces=2;
point.moments=0;
point.axis=[0;0;1];
the_system.item{end+1}=point;

point.forces=0;  %% Constrain to rotational motion around y axis (pitch)
point.moments=2;  %% Reset forces, moments axis, all other properties are the same
point.axis=[0;1;0];
the_system.item{end+1}=point;

item.type='sensor';
item.name='$z_G$';
item.body1='truck';
item.body2='ground';
item.location1=[0;0;0.25];
item.location2=[0;0;0];
item.gain=1;
the_system.item{end+1}=item;

item.name='$\\theta$';
item.location2=[0;0.25;0.25];
item.gain=180/pi;  %% deg/rad
item.twist=1;
the_system.item{end+1}=item;

item.type='actuator';
item.name='$front f_z$';
item.location1=[params.a;0;0.25];
item.location2=[params.a;0;0];
item.twist=0;
item.gain=params.kf;
the_system.item{end+1}=item;

item.name='$rear f_z$';
item.location1=[-params.b;0;0.25];
item.location2=[-params.b;0;0];
item.gain=params.kr;
the_system.item{end+1}=item;
