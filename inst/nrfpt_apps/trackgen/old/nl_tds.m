function nl_tds()

[~,syst]=run_eom('input_3_yaw_plane_mod','quiet',10);

syst=syst{1};

%warning('off','Octave:load-file-in-path');
%track=load('track.txt');  %% Load the real track centreline
%track=track(:,2:4);  %% Trim 's' column

track = [5,0;
       10,0;
       10,10;
       0,10;
       0,0;
       4.5,0];
%         20,10;
%         30,30;
%         30,50;
%         20,60;
%         0,60;
%        -20,30];


%  trackx=(0:10:250)';
%  tracky=zeros(size(trackx));
%  for i=1:length(trackx)
%  	tracky(i)=mod(i+1,2);
%  	%-0.2*round(i/50);
%  	%cos(track(i)/10);
%  end
%  track=[trackx tracky];

track=track(:,1:2);  %% Trim z column

figure(15);  %% Plot the track
plot(track(:,1),track(:,2),'*','markersize',2,'color','red');
axis equal;
hold on

rtrack=track_mesher(track,3);  %% Mesh the track to find edges

plot(rtrack(1,:),rtrack(2,:),'*','markersize',2,'color','blue');

track=track_path(rtrack,[zeros(1,size(rtrack,2));zeros(1,size(rtrack,2))]);  %% Find a smooth path on the track
track=[track;zeros(1,size(track,2))]';  %% Add zeros for z coordinate
plot(track(:,1),track(:,2),'*','markersize',2,'color','green');

hold off

params.rads=[syst.data.bodys.location];
params.mass=[syst.data.bodys.mass];
params.inertia=[syst.data.bodys.inertia];

names={syst.data.bodys.name};
params.chassnum=find(ismember(names,'chassis'));

if(params.chassnum==0)
	error(sprintf('Missing chassis.'));
end

init_vel=[syst.data.bodys.velocity];
init_angvel=[syst.data.bodys.angular_velocity];

[q,r]=size(syst.eom.rigid.cnsrt_mtx);  %% q = the number of rows in the constraint matrix

if(q>0)
	params.r_orth=null(syst.eom.rigid.cnsrt_mtx);
else
	params.r_orth=eye(r);
end
params.l_orth=params.r_orth';


params.m_mtx=params.l_orth*syst.eom.mass.mtx*params.r_orth;
params.c_mtx=params.l_orth*syst.eom.elastic.dmpng_mtx*params.r_orth;
params.k_mtx=params.l_orth*syst.eom.elastic.k_defln*params.r_orth;


n=size(params.l_orth,1);
z0=zeros(2*n,1); % set initial condition

% find the correct initial conditions

v=zeros(r,1);
for i=1:r/6
	v(i*6-5:i*6-3)=init_vel(:,i);
	v(i*6-2:i*6)=init_angvel(:,i);
end

z0(end/2+1:end,1)=params.l_orth*v;

z0=[0;0;0;1;0;0;0;0;0;0;0;0;0.1;z0];%0;0];  %% Set initial conditions for frame and system

tf=2;
tspan=[0,tf]; % set the simulation interval
vopt=odeset('RelTol',1e-5,'AbsTol',1e-5,'InitialStep',1e-5,'MaxStep',1);
handle=@(t,z) eqn_of_motion(t,z,params,track);
[t,z]=ode45(handle,tspan,z0,vopt);  % simulate

frame=z(:,1:13);  %% Pull out frame motions
z=z(:,14:end);

%offset=z(end,end-1)
%theta=z(end,end)
%z=z(:,1:end-2);

x=z(:,1:end/2)*params.l_orth;  %% Convert locations back to physical coordinates

for i=1:size(x,1)  %% For each output point
	for j=1:syst.data.nbodys-1  %% Over each body except ground
		x(i,6*j+[-5:-3])=x(i,6*j+[-5:-3])+params.rads(:,j)';  %% Add constant offsets
	end
end  
xd=z(:,end/2+1:end)*params.l_orth;  %% Convert velocities back to physical coordinates

figure(1);  %% Plot the relative motion of the chassis
plot(t,x(:,1:3))
axis([0 tf -5 5]);
  
figure(2);  %% Plot the relative orientation of the chassis 
plot(t,x(:,4:6))
axis([0 tf -0.5 0.5]);
  
%  figure(3);
%  plot(t,xd(:,1:3))
%  
%  figure(4);
%  plot(t,xd(:,4:6))





figure(5);  %% Plot the track
plot(track(:,1),track(:,2),'*','markersize',2,'color','red');
hold on
temp=2*atan2(frame(:,7),frame(:,4));  %% only when we know rotation is only about z

plot([frame(:,1) frame(:,1)+cos(temp)],[frame(:,2) frame(:,2)+sin(temp)],'*','markersize',2);  %% Plot the frame global coordinate
plot(frame(:,1)+cos(temp).*x(:,1)-sin(temp).*x(:,2),frame(:,2)+cos(temp).*x(:,2)+sin(temp).*x(:,1),'*','markersize',2);

hold off

figure(6)
plot(t,temp);  %% Plot the frame orientation angle of the frame

%  figure(7)
%  plot(t,temp+x(:,6));  %% Plot the frame orientation angle of the frame

%figure(7)
%axis([0 200 -5 5]);

%vrml_track(rtrack,t',frame',syst.config.dir.vrml);


end


