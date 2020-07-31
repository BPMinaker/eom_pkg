function zdot=eqn_of_motion(t,z,flag)

global params;

t
%pause()
% 

frm=z(1:13);

pos=frm(1:3);  %% Unload frame location and velocities from state
e0=frm(4);
e=frm(5:7);
vel=frm(8:10);
ang_vel=frm(11:13);

s=z(14);
delta=z(15);
ie=z(16);

rot_mtx=(2*e0^2-1)*eye(3)+2*(e*e')-2*e0*skew(e);
glbl_vel=rot_mtx'*vel;

E=[-e e0*eye(3)-skew(e)];
edot=0.5*E'*ang_vel;

z=z(17:end);  %% Unload the system from the state vector

pmin=z(1:end/2);
wmin=z(end/2+1:end);

p=params.r_orth*pmin;  %% Convert to physical coordinates to add non-inertial terms
%p=z(1:6*params.nbods);
%wmin=z(6*params.nbods+1:end);
w=params.r_orth*wmin;

% for now, only rotate about z, so e0 gives theta
[offset,theta]=track_offset(pos(1:2),2*atan2(e(3),e0),s);  %% Using location of reference frame, find offset from track
%offset=0;
%theta=0;

% Accelerate frame in x to chase vehicle, in y toward track, in z toward ground with some damping
%acc=[2*(w(6*params.chassnum-5)-vel(1))+2*p(6*params.chassnum-5);5*offset-3*vel(2)+3*vel(1)*theta;-pos(3)-0.5*vel(3)];
acc=[2*(w(6*params.chassnum-5)-vel(1))+2*p(6*params.chassnum-5);50*offset-10*vel(2)+10*vel(1)*theta-vel(1)*ang_vel(3);-pos(3)-0.5*vel(3)];

%ang_acc=[0;0;10*theta-2.5*ang_vel(3)];  %% Accelerate frame to orient with road

n=size(p,1);  %% Number of coordinates
fi=zeros(n,1);
pdot=zeros(n,1);

for i=1:n/6  %% Loop over bodies
	lin=6*i+(-5:-3);
	rot=6*i+(-2:0);

	fi(lin)=-params.mass(i)*skew(w(rot))*w(lin);
	fi(rot)=-skew(w(rot))*params.inertia(:,3*i+(-2:0))*(w(rot));
	
	pdot(lin)=w(lin)-vel-skew(ang_vel)*(p(lin)+params.rads(:,i));%+skew(p(rot))*w(lin);
	pdot(rot)=w(rot)-ang_vel;%+skew(p(rot))*w(rot);
	
%error('stop')
end
ang_acc=[0;0;50*p(6*params.chassnum)+10*pdot(6*params.chassnum)]; 

fnlmin=params.l_orth*fi;  %% Convert non-inertial forces from physical to reduced coordinates
pmindot=params.l_orth*pdot;

%fi
%pdot
%error('stop')

path_error=offset-p(6*params.chassnum-4); %% y distance from vehicle to track
heading_error=theta-p(6*params.chassnum);

chass_vx=w(6*params.chassnum-5);
d_ahead=5+0.5*chass_vx;  %% look ahead distance
tau=0.1;  %% driver time constant
kp=1;  %% error gain
ki=0.05;  %% integral gain
kd=0.1;
errd=-w(6*params.chassnum-4)-d_ahead*w(6*params.chassnum);
err=path_error+d_ahead*heading_error;  %% offset error at look ahead distance
deltadot=(-delta+kd*errd+kp*err+ki*ie)/tau;  %% driver model

%deltadot=0.05*cos(3*t);
% deltadot=0;
% deltadot=-0.02;
% if(t>1)
%  	deltadot=0;
% end

wheel_vel=zeros(3,length(params.wheelnum));
for i=1:length(params.wheelnum)
	wheel_vel(:,i)=w(6*params.wheelnum(i)+(-5:-3));
end

%wheel_vel
v_lat=params.g_mtx(params.lat_sen_num,:)*wmin;

%error('stop');


slip=atan2(v_lat',wheel_vel(1,:))';  %% get tire slip angles
slip([1 3])=slip([1 3])-delta;  %% include steer to slip  %% how to know 1,3 are front wheels???

n=params.preload'-params.g_mtx(params.vert_sen_num,:)*pmin;  %% compute normal forces
lat_frc=tire_lat(slip,n,[0;0;0;0]);  %% tire model

% lat_frc=[1.3*5;1.2*5;1.3*5;1.2*5];
% if (t>1)
% 	lat_frc=lat_frc*0;
% end

femin=params.f_mtx(:,params.lat_act_num)*lat_frc;  %% treat lateral tire force as external

fimin=-params.k_mtx*pmin-params.c_mtx*pmindot;  %% internal stiffness and damping

fk=-params.r_orth*params.k_mtx*pmin;
fc=-params.r_orth*params.c_mtx*pmindot;  %% internal stiffness and damping
% 
% fkcmin=params.l_orth*(fk);

%% we should be transforming f into the body fixed frames by multipying by R^T here!!!

%error('stop')

wmindot=(params.m_mtx)\(fnlmin+femin+fimin);  %% Find accelerations in reduced coordinates

zdot=[glbl_vel;edot;acc;ang_acc; vel(1);deltadot;err; pmindot;wmindot];  %% Integrate

if(flag)
	zdot=[zdot;fi(6*params.chassnum+(-5:0));path_error;heading_error;slip;n;lat_frc;fk(6*params.chassnum+(-5:0));fc(6*params.chassnum+(-5:0))];  %% extra outputs
end

end %% Leave


%omega=skew(ang_vel);
%alpha=skew(ang_acc);


%	r(lin)=r(lin)+params.rads(:,i);  %% Add fixed radius to deflection
%	wt=rdot(rot)+ang_vel;  %% Add rotation speed of body to rotation speed of frame

%	vd(lin,1)=vel+omega*r(lin)+rdot(lin);  %% Find speed due to rotation of frame
%	vd(rot,1)=ang_vel;  %% Find angular speed due to rotation of frame

%	fi(lin)=params.mass(i)*(alpha*r(lin)+omega*omega*r(lin)+2*omega*rdot(lin)+omega*vel+acc);  %% Find non-inertial forces
%	fi(rot)=params.inertia(:,3*i+[-2:0])*(omega*rdot(rot)+ang_acc)+skew(wt)*params.inertia(:,3*i+[-2:0])*wt;  %% Non-inertial moments

%xddot=(params.m_mtx)\(f-fi+fe);  %% Find accelerations in reduced coordinates

%zdot=[glbl_vel;edot;acc;ang_acc; vel(1);deltadot;xdot;xddot];%offset^2;theta^2];  %% Integrate


