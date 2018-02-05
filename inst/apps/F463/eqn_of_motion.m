function zdot=eqn_of_motion(t,z,flag)

global params;

t
params.ncalls=params.ncalls+1;  %% Record number of function calls
%pause()
% 

frm=z(1:13);

pos=frm(1:3);  %% Unload reference frame location and velocities from state
e0=frm(4);  %% Euler parameters
e=frm(5:7);
vel=frm(8:10);  %% Linear velocity
ang_vel=frm(11:13);  %% Angular velocity

s=z(14);  %% Distance travelled by reference frame
psi=z(15);  %% Approx heading, from integral of w, can be larger than 2pi, to prevent curve fit issue in discontinuities
%delta=z(16);  %% Steer angle
err_i=z(16);  %% Error integral

rot_mtx=(2*e0^2-1)*eye(3)+2*(e*e')-2*e0*skew(e);  %% Find rotation matrix of reference frame from Euler params
glbl_vel=rot_mtx'*vel;  %% Find global velocity of reference frame, integrate this for global location

E=[-e e0*eye(3)-skew(e)];  %% Find rate of change of Euler parameters from angular velocities
edot=0.5*E'*ang_vel;

z=z(17:end);  %% Unload the system state from the rest of the state vector

pmin=z(1:end/2);  %% Positions, minimal coordinates
wmin=z(end/2+1:end);  %% Velocities, minimal coordindates
p=params.r_orth*pmin;  %% Convert minimal coordinates to physical coordinates to compute nonlinear inertial acceleration terms
w=params.r_orth*wmin;

%2*atan2(e(3),e0)
%psi

% Using location, angle of reference frame, find offset from track,
% use s distance to find approximate closest point, speed for lookahead distance
[offset,theta,u_ref,curv]=track_offset(pos(1:2),psi,s,vel(1));
chass_vx=w(6*params.chassnum-5);  %% Record chassis speed


path_error=offset-p(6*params.chassnum-4); %% y distance from vehicle to track
heading_error=theta-p(6*params.chassnum);

k=[10 10 6 2 0.8 0.16 0.04 0.01]/15.5135;  %% Weights of preview points, normalized
k=k/4;  %%  Fixed gain
k=k*1.5/(chass_vx+0.5);  % yaw rate to steer ratio is a function of vx, so adjust gain
err=20*k*heading_error+k*path_error;  %% Driver model
delta=err+0.5*err_i;  %% 2.5 is wheelbase, how to know, fix me...
%2.5*curv

% nonlinear inertial forces and moments to each body
% and kinematics
n=size(p,1);  %% Number of coordinates
fi=zeros(n,1);  %% Preallocate space, faster
pdot=zeros(n,1);

for i=1:n/6  %% Loop over bodies
	lin=6*i+(-5:-3);
	rot=6*i+(-2:0);

	fi(lin)=-(params.mass(i)*skew(w(rot))*w(lin));
	fi(rot)=-(skew(w(rot))*params.inertia(:,3*i+(-2:0))*(w(rot)));
	
	pdot(lin)=w(lin)-vel-skew(ang_vel)*(p(lin)+params.rads(:,i));
	pdot(rot)=w(rot)-ang_vel;
	
%error('stop')
end

% 50*offset(1)
% -10*vel(2)
% +10*vel(1)*theta(1)
% -vel(1)*ang_vel(3)
% disp('---');

% Accelerate frame in x to chase vehicle, in y toward track, in z toward ground with some damping
acc=[4*(chass_vx-vel(1))+8*p(6*params.chassnum-5);8*offset(1)-4*vel(2)+4*vel(1)*theta(1)-vel(1)*ang_vel(3);-pos(3)-0.5*vel(3)];
%  Angular acceleration of reference frame to align with chassis
ang_acc=[0;0;8*p(6*params.chassnum)+4*pdot(6*params.chassnum)];

% preallocate for speed
wheel_vel=zeros(3,length(params.wheelnum));  %% Calculate slip angles from wheel speeds
wheel_angvel=zeros(3,length(params.wheelnum));  %% Calculate slip ratios from wheel ang speeds
for i=1:length(params.wheelnum)
	wheel_vel(:,i)=w(6*params.wheelnum(i)+(-5:-3));
	wheel_angvel(:,i)=w(6*params.wheelnum(i)+(-2:0));
end
%wheel_vel
%wheel_angvel

% Because we don't want the reference frame of the wheel to rotate with it, subtract the spin in the y-axis
camber=[0;0;0;0];
for i=1:length(params.wheelnum)
	lin=6*params.wheelnum(i)+(-5:-3);
	rot=6*params.wheelnum(i)+(-2:0);
	spn=[0;wheel_angvel(2,i);0];

	camber(i)=p(rot(1));
	fi(lin)=fi(lin)+params.mass(params.wheelnum(i))*skew(spn)*w(lin);
	fi(rot)=fi(rot)+skew(spn)*params.inertia(:,3*params.wheelnum(i)+(-2:0))*(w(rot));

	pdot(rot)=pdot(rot)-spn;
end

fnlmin=params.l_orth*fi;  %% Convert non-inertial forces from physical to reduced coordinates
pmindot=params.l_orth*pdot;  %% Convert velocities relative to frame to reduced coordinates

nrm_frc=params.preload'-params.g_mtx(params.vert_sen_num,:)*pmin;  %% Compute normal forces
camber(1:2)=-camber(1:2);  %% how to know 1,2 are always left side? fix me...

v_lat=params.g_mtx(params.lat_sen_num,:)*wmin;  %% Calculate slip angles from lateral speed sensors
v_long=params.g_mtx(params.long_sen_num,:)*wmin;  %% Calculate slip ratios from long speed sensors

%slip=atan2(v_lat,wheel_vel(1,:)');  %% Get tire slip angles
%slip([1 3])=slip([1 3])-delta;  %% Add steer to slip  %% how to know 1,3 are front wheels???  fix me...
%slip_r=-v_long./(wheel_vel(1,:)'+0.1);  %% Add small delta to prevent inf result - huge slip ratio at low speeds - fix me...

v_lat=v_lat-wheel_vel(1,:)'.*[sin(delta); 0; sin(delta); 0];  %% Add steer to slip  %% how to know 1,3 are front wheels???  fix me...

v_slip=(v_lat.^2+v_long.^2).^0.5+eps;  %% Find magnitude of slip
slip=v_slip./(wheel_vel(1,:)'+0.1); %% Add small delta to prevent inf result - huge slip ratio at low speeds - fix me...
ratio=(v_lat./v_slip).^2;  %% Compute ratio of lateral to long, 1=lateral, 0=long

tire_frc=tire_comb(slip,nrm_frc,ratio,camber);  %% Tire model
tire_frc_pus=tire_frc./v_slip;

lat_frc=-v_lat.*tire_frc_pus;
long_frc=-v_long.*tire_frc_pus;

%lat_frc=tire_lat(slip,nrm_frc,camber);  %% Tire model
%long_frc=tire_long(slip_r,nrm_frc);  %% Tire model

faero=0;
froll=[0;0;0;0];
if(chass_vx>0)
    faero=0.5*1.23*params.cod*params.farea*chass_vx^2; %% Aero drag force
    froll=nrm_frc*(0.0136+5.2*10^-7*chass_vx^2); %% Rolling resistance force
end

long_frc=long_frc-froll;

% Longitudinal speed control
% tanh function smooths out on/off behavour of throttle
% gentle slope around zero, much steeper away from zero
% smoothly limited to +/- 1
throttle=tanh(0.2*(u_ref-chass_vx)^3); 
brake=-throttle;

if(throttle<0)  %% Limit min throttle position
	throttle=0;
end
if(brake<0)  %% Limit min brake position
	brake=0;
end

gear=1;  %% Compute proper gear
while(chass_vx>params.vmax(gear) && gear<length(params.e))
	gear=gear+1;
end

% average wheel speed
wf=(wheel_angvel(2,1)+wheel_angvel(2,3))/2;
wr=(wheel_angvel(2,2)+wheel_angvel(2,4))/2;
% convert to rpm, find engine speed
if(params.wtf==1 && wr>=0)
    we=wr*params.ex*params.e(gear)*30/pi;
elseif(params.wtf==-1 && wf>=0) 
	we=wf*params.ex*params.e(gear)*30/pi;
else
    we=(wf+wr)*params.ex*params.e(gear)*15/pi;
end

ct=0;  %% Clutch torque
if(gear==1 && we<params.launchrpm)  %% Launch control
	ct=(params.launchrpm-we)*0.05;
	we=params.launchrpm;
end

if(we>params.redline)  %% Limit engine speed
	throttle=throttle-(we-params.redline)/500;  %% Close throttle at 500 rpm above redline
	if(throttle<0)
		throttle=0;
	end
end

tq=ct+throttle*interp1(params.revs,params.torque,we,'pchip','extrap');  %% Engine torque from curve fit
ax_tq=tq*params.eff*params.ex*params.e(gear);  %% Axle torque 

brake_m=1.5*params.mass(params.chassnum)*params.g*params.rad*brake;  %% Brake torque

% reduce all the forces to minimal coordinates
femin=params.f_mtx(:,params.lat_act_num)*lat_frc;  %% Treat tire forces as external
ftracmin=params.f_mtx(:,params.long_act_num)*long_frc;
fimin=-params.k_mtx*pmin-params.c_mtx*pmindot;  %% Internal stiffness and damping
fdmin=params.f_mtx(:,params.torque_act_num)*[0.5;0.5]*(ax_tq);  %% Apply torque to drive axles, 50/50
fbrakemin=params.f_mtx(:,params.brake_act_num)*([params.fbf/2;(1-params.fbf)/2;params.fbf/2;(1-params.fbf)/2].*(tanh(3*wheel_angvel(2,:))'))*brake_m;
fres=params.f_mtx(:,params.aero_act_num)*(-faero);

%pause();

% Find accelerations in reduced coordinates
wmindot=(params.m_mtx)\(fnlmin+femin+fimin+fres+fdmin+ftracmin+fbrakemin);

% driver model
%path_error=offset-p(6*params.chassnum-4); %% y distance from vehicle to track
%heading_error=theta-p(6*params.chassnum);
% deltadot=driver_model(delta,path_error,heading_error,chass_vx);
% if(abs(delta)>0.5 && deltadot*delta>0)  %%  If steer is big and increasing, stop it 
% 	deltadot=0;
% end

% return slopes to ODE solver
zdot=[glbl_vel;edot;acc;ang_acc;vel(1);ang_vel(3);k*path_error;pmindot;wmindot];

% return extra data after ODE solved
if(flag)
	fk=-params.r_orth*(params.k_mtx*pmin);
	fc=-params.r_orth*(params.c_mtx*pmindot);  %% internal stiffness and damping
	zdot=[zdot;fi(6*params.chassnum+(-5:0));path_error(1);heading_error(1);slip;ratio;nrm_frc;lat_frc;long_frc;fk(6*params.chassnum+(-5:0));fc(6*params.chassnum+(-5:0));u_ref;throttle;brake;we;gear;wheel_angvel(2,:)';camber];  %% extra outputs
end

end %% Leave



%	r(lin)=r(lin)+params.rads(:,i);  %% Add fixed radius to deflection
%	wt=rdot(rot)+ang_vel;  %% Add rotation speed of body to rotation speed of frame

%	vd(lin,1)=vel+omega*r(lin)+rdot(lin);  %% Find speed due to rotation of frame
%	vd(rot,1)=ang_vel;  %% Find angular speed due to rotation of frame

%	fi(lin)=params.mass(i)*(alpha*r(lin)+omega*omega*r(lin)+2*omega*rdot(lin)+omega*vel+acc);  %% Find non-inertial forces
%	fi(rot)=params.inertia(:,3*i+[-2:0])*(omega*rdot(rot)+ang_acc)+skew(wt)*params.inertia(:,3*i+[-2:0])*wt;  %% Non-inertial moments

%xddot=(params.m_mtx)\(f-fi+fe);  %% Find accelerations in reduced coordinates

%zdot=[glbl_vel;edot;acc;ang_acc; vel(1);deltadot;xdot;xddot];%offset^2;theta^2];  %% Integrate

%	fi(lin)=-(params.mass(i)*skew(w(rot))*w(lin));%*(eye(3)+skew(p(rot)))
%	fi(rot)=-(skew(w(rot))*params.inertia(:,3*i+(-2:0))*(w(rot)));%*(eye(3)+skew(p(rot)))
%	
%	pdot(lin)=w(lin)-vel-skew(ang_vel)*(p(lin)+params.rads(:,i));%+skew(p(rot))*w(lin);
%	pdot(rot)=w(rot)-ang_vel;%+skew(p(rot))*w(rot);

