%function semi_lin_tds()
clear all
global params;

%[~,syst]=run_eom('input_3_yaw_plane_mod','quiet',10);
%[~,syst]=run_eom('input_ex_full_car_mod_2','quiet',12);
%[~,syst]=run_eom('input_fsae','quiet',12);
[~,syst]=run_eom('full_car_a_arm_pushrod_reduced','quiet',5);

syst=syst{1};

%error('stop');

params.a_mtm=[1.6929 -55.2084 1271.28 1601.8 6.4946 4.7966E-3 -0.3875 1 -4.5399E-2 4.2832E-3 8.6536E-2 -7.973 -0.2231 7.668 45.8764]; % magic tire model (lateral), Genta pg 510

params.course=track();
%size(params.course)

% phi=0;
% dphi=2*asin(0.025);
% ds=0;
% for i=1:round(2*pi/dphi)
% 	params.course(i,1:4)=[-100*sin(phi),100-100*cos(phi),ds,0.01];
% 	phi=phi+dphi;
% 	ds=ds+5;
% end
%size(params.course)

%figure(1);  %% Plot the track
%plot(params.course(:,1),params.course(:,2),'k:');
%axis equal;

params.rads=[syst.data.bodys.location];
params.mass=[syst.data.bodys.mass];
params.inertia=[syst.data.bodys.inertia];

names=lower({syst.data.bodys.name});
  
params.chassnum=[];
for i=1:length(names)    %% Loop over each body
	if(~isempty(strfind(names{i},'chassis')))
		params.chassnum=[params.chassnum i];
	end
end

params.wheelnum=[];
for i=1:length(names)    %% Loop over each body
	if(~isempty(strfind(names{i},'wheel')))
		params.wheelnum=[params.wheelnum i];
	end
end

%params.wheelnum
%error('stop');

if(params.chassnum==0)
	error(sprintf('Missing chassis.'));
end

params.tirenum=[];
names=lower({syst.data.flex_points.name});
for i=1:length(names)    %% Loop over each body
	if(~isempty(strfind(names{i},'tire'))  && isempty(strfind(names{i},'horz')))
		params.tirenum=[params.tirenum i];
	end
end
%params.tirenum
params.preload=[syst.data.flex_points(params.tirenum).preload];
%params.preload

%error('stop')

params.lat_sen_num=[];
names=lower({syst.data.sensors.name});
for i=1:length(names)    %% Loop over each body
	if(~isempty(strfind(lower(names{i}),'tire')) && ~isempty(strfind(lower(names{i}),'lateral')))
		params.lat_sen_num=[params.lat_sen_num i];
	end
end
%params.lat_sen_num

params.vert_sen_num=[];
names=lower({syst.data.sensors.name});
for i=1:length(names)    %% Loop over each body
	if(~isempty(strfind(lower(names{i}),'tire')) && ~isempty(strfind(lower(names{i}),'vertical')))
		params.vert_sen_num=[params.vert_sen_num i];
	end
end
%params.vert_sen_num

params.lat_act_num=[];
names=lower({syst.data.actuators.name});
for i=1:length(names)    %% Loop over each body
	if(~isempty(strfind(lower(names{i}),'tire')) && ~isempty(strfind(lower(names{i}),'lateral')))
		params.lat_act_num=[params.lat_act_num i];
	end
end
%params.lat_act_num


init_vel=[syst.data.bodys.velocity];
init_angvel=[syst.data.bodys.angular_velocity];
vfi=[syst.data.bodys(params.chassnum).velocity(1); 0;0;0;0;syst.data.bodys(params.chassnum).angular_velocity(3)];
% frame initial speed

[q,r]=size(syst.eom.rigid.cnsrt_mtx);  %% q = the number of rows in the constraint matrix
params.nbods=r/6;

if(q>0)
	params.r_orth=null(syst.eom.rigid.cnsrt_mtx);
else
	params.r_orth=eye(r);
end
params.l_orth=params.r_orth';

params.m_mtx=params.l_orth*syst.eom.mass.mtx*params.r_orth;
params.c_mtx=params.l_orth*syst.eom.elastic.dmpng_mtx*params.r_orth;
params.k_mtx=params.l_orth*syst.eom.eqn_of_mtn.stiff_mtx*params.r_orth;

%params.c_mtx=syst.eom.elastic.dmpng_mtx;
%params.k_mtx=syst.eom.eqn_of_mtn.stiff_mtx;

params.g_mtx=syst.eom.outputs.g_mtx*params.r_orth;
params.f_mtx=params.l_orth*syst.eom.forced.f_mtx;

%params.m_mtx
%params.c_mtx
%params.k_mtx
%eig(params.m_mtx\params.k_mtx)
%error('stopped');

n=size(params.l_orth,1);
z0=zeros(2*n,1); % set initial condition

% find the correct initial conditions
v=zeros(r,1);

for i=1:params.nbods
	v(6*i+(-5:-3))=init_vel(:,i);
	v(6*i+(-2:0))=init_angvel(:,i);
end

z0(end-n+1:end,1)=params.l_orth*v;

z0=[0;0;0;0;0;0;1;vfi;0;0;0;z0];  %% Set initial conditions for frame and system
tf=3*145;

%z0=[-161.88;-137.05;0;sqrt(0.5);0;0;sqrt(0.5) ;vfi; 1495 ;0;z0];

if(exist('OCTAVE_VERSION','builtin'))
    tspan=[0 tf];
    solver=@ode54;
else
    tspan=0:tf/600:tf; % set the simulation interval
    solver=@ode45;
end

vopt=odeset('RelTol',1e-5,'AbsTol',1e-5,'InitialStep',1e-5);
handle=@(t,z) eqn_of_motion(t,z,0);
[t,z]=solver(handle,tspan,z0,vopt);  % simulate

if(exist('OCTAVE_VERSION','builtin'))
    z=interp1(t,z,[0:tf/300:tf]','pchip');
	t=[0:tf/300:tf]';
end

%error('stop')
zdot=zeros(length(t),size(z,2)+32);
for i=1:length(t)
	zdot(i,:)=eqn_of_motion(t(i),z(i,:)',1)';
end



frame=z(:,1:13);  %% Pull out frame motions
s=z(:,14);
delta=z(:,15);
ie=z(:,16);
err=zdot(:,16);
frm_acc=zdot(:,1:13);
extra=zdot(:,end-31:end);

z=z(:,17:end);
zdot=zdot(:,17:end-20);

x=z(:,1:n)*params.l_orth;  %% Convert locations back to physical coordinates
xd=z(:,n+1:end)*params.l_orth;  %% Convert velocities back to physical coordinates
%x=z(:,1:r);  %% Convert locations back to physical coordinates
for i=1:size(x,1)  %% For each output point
	for j=1:syst.data.nbodys-1  %% Over each body except ground
		x(i,6*j+[-5:-3])=x(i,6*j+[-5:-3])+params.rads(:,j)';  %% Add constant offsets
	end
end  

%vrml_track(rtrack,t',frame',syst.config.dir.vrml);


figure(1);
plot(t,x(:,1:3))
title('Relative motion of the chassis');
axis([0 tf -5 5]);
  
figure(2);
plot(t,x(:,4:6))
title('Relative orientation of the chassis');
axis([0 tf -0.5 0.5]);


figure(3);
plot(t,s)
title('Distance travelled');

figure(4);
plot(params.course(:,1),params.course(:,2),'k:');
hold on
temp=2*atan2(frame(:,7),frame(:,4));  %% only when we know rotation is only about z
plot([frame(:,1) frame(:,1)+cos(temp)],[frame(:,2) frame(:,2)+sin(temp)],'*','markersize',2);  %% Plot the frame global coordinate
title('Track, and 0,0 and 1,0 of moving frame');
axis equal
hold off


figure(5)
plot(params.course(:,1),params.course(:,2),'k:');
hold on
plot(frame(:,1)+cos(temp).*x(:,6*params.chassnum-5)-sin(temp).*x(:,6*params.chassnum-4),frame(:,2)+cos(temp).*x(:,6*params.chassnum-4)+sin(temp).*x(:,6*params.chassnum-5),'*','markersize',2);
plot(frame(:,1)+cos(temp).*x(:,6*params.wheelnum(1)-5)-sin(temp).*x(:,6*params.wheelnum(1)-4),frame(:,2)+cos(temp).*x(:,6*params.wheelnum(1)-4)+sin(temp).*x(:,6*params.wheelnum(1)-5));
plot(frame(:,1)+cos(temp).*x(:,6*params.wheelnum(2)-5)-sin(temp).*x(:,6*params.wheelnum(2)-4),frame(:,2)+cos(temp).*x(:,6*params.wheelnum(2)-4)+sin(temp).*x(:,6*params.wheelnum(2)-5));
plot(frame(:,1)+cos(temp).*x(:,6*params.wheelnum(3)-5)-sin(temp).*x(:,6*params.wheelnum(3)-4),frame(:,2)+cos(temp).*x(:,6*params.wheelnum(3)-4)+sin(temp).*x(:,6*params.wheelnum(3)-5));
plot(frame(:,1)+cos(temp).*x(:,6*params.wheelnum(4)-5)-sin(temp).*x(:,6*params.wheelnum(4)-4),frame(:,2)+cos(temp).*x(:,6*params.wheelnum(4)-4)+sin(temp).*x(:,6*params.wheelnum(4)-5));

title('Track, and CG of chassis, next bodies');
axis equal
hold off

figure(6)
plot(t,temp);  %% Plot the orientation angle of the frame
title('Orientation angle of the moving reference frame');

figure(7)
plot(t,frame(:,11:13));
title('Angular speeds of the reference frame');

figure(8)
plot(t,frm_acc(:,9)+frame(:,8).*frame(:,13));
title('Lateral acceleration of reference frame');
axis([0 tf -8 8]);

figure(9)
plot(t,delta);
title('Steer angle');
axis([0 tf -0.1 0.1]);

figure(10)
plot(t,extra(:,1:3));
title('Inertial forces');
axis([0 tf -10000 10000]);

figure(11)
plot(t,extra(:,4:6));
title('Inertial moments');

figure(12)
plot(t,extra(:,7));
title('Path error');
axis([0 tf -2 2]);


figure(13)
plot(t,extra(:,8)); 
title('Heading error');
axis([0 tf -0.1 0.1]);


figure(14)
plot(t,extra(:,9:12));
title('Slip angles');
axis([0 tf -0.1 0.1]);

figure(15)
plot(t,extra(:,13:16));
title('Normal forces');
axis([0 tf 0 7000]);

figure(16)
%plot(t,extra(:,17)+extra(:,18)+extra(:,19)+extra(:,20));
plot(t,extra(:,17:20));
title('Lateral forces');
axis([0 tf -6000 6000]);

figure(17)
plot(t,xd(:,6*params.chassnum+(-5:-3)));
title('Chassis velocity');

figure(18)
plot(t,xd(:,6*params.chassnum+(-2:0)));
title('Chassis angular velocity');

figure(19)
plot(t,extra(:,21:23));
title('Chassis stiffness force');

figure(20)
plot(t,extra(:,24:26));
title('Chassis stiffness moment');

figure(21)
plot(t,extra(:,27:29));
title('Chassis damping force');

figure(22)
plot(t,extra(:,30:32));
title('Chassis damping moment');

% for i=7:3:size(x,2)
% figure(22+i)
% plot(t,x(:,i:i+2));
% title('all locations');
% axis([0 tf -2 2]);
% end

figure(23)
plot(t,err,t,ie);
title('Steer error, error int');

