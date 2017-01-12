function xdot=lap_sim(t,x,flag_out)

%t
% flag_out is: 0 if solved with ode***, 1 if function is used to output
% accelerations, forces, etc. with a for loop

global params;  % get the parameters
%x

s=x(1);
u=x(2); % get info from input vector x(1)=distance, x(2)=speed,
wf=x(3); % x(3)=axle angular speed
slipf=x(4); % front axle slip
psi=x(5); % yaw angle
psidot=x(6); % yaw rate
y=x(7); % lateral position
v=x(8); % lateral velocity
X=x(9); % global X position
Y=x(10); % global Y position
delta_in=x(11); % inner wheel steer angle
wr=x(12); % rear axle angular speed
slipr=x(13); % rear axle slip
Z=x(14); % global Z position
Zdot=x(15); % global Z velocity
theta=x(16); % roll angle
thetadot=x(17); % roll rate
phi=x(18); % pitch angle
phidot=x(19); % pitch rate


if delta_in>params.delta_in_max % limit maximum steer angle
    delta_in=params.delta_in_max;
end
if delta_in<(-1*params.delta_in_max)
    delta_in=-1*params.delta_in_max;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rho=1/interp1(params.course(:,3),params.course(:,4),s,'linear','extrap');

if(rho<params.rho_limit)
%straightaway
	u_ref=interp1(params.course(:,3),params.course(:,6),s,'linear','extrap'); % find ref speed
	throttle=0.1*(u_ref-u);
	brake=0;
	if(throttle<0)
		brake=1;
		throttle=0;
	end
	state=1;
else
% corner
	u_ref=interp1(params.course(:,3),params.course(:,6),s,'linear','extrap'); % find ref speed
	% u_ref = u_ref - function of lateral offset
	throttle=0.1*(u_ref-u);
	brake=-throttle;
	state=2;
end



if(brake<0) % limit min and max brake application
	brake=0;
elseif brake>1
	brake=1;
end

if(throttle<0) % limit min and max throttle position
	throttle=0;
elseif throttle>1
	throttle=1;
end



% bang-bang controller for traction control
% if strcmp(params.drive,'RearWheelDrive') && slipr>params.slip1a && slipr>0
%     throttle=0;
% elseif slipf>params.slip1a && slipf>0
%     throttle=0;
% end

% if brakes are applied, throttle should be zero and vice-versa
if brake~=0
    throttle=0;
end
if throttle~=0
    brake=0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% compute outer wheel steer angle - trapezoidal steering mechanism
% driver controls inner steered tire
%if delta_in>=0 % for some reason, fzero, as used here, works better with positive steer angles than negative
%    delta_out=fzero(@(delta_out2) delta_out_f(delta_out2,delta_in,params.gamma,params.L1,params.L2),delta_in);
%else % manipulation of steer angles to only work with positive angles
%    delta_out=-1*fzero(@(delta_out2) delta_out_f(delta_out2,abs(delta_in),params.gamma,params.L1,params.L2),abs(delta_in));
%end

delta_out=delta_in;

% assign steer angles to front tires
if delta_in>=0
    delta_1=delta_in;
    delta_2=delta_out;
else
    delta_2=delta_in;
    delta_1=delta_out;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% not sure if setting these to zero by default is necessary
fa=0;
fr=0;

if u>0
    fa=0.5*1.23*params.cod*params.farea*u^2; % compute aero drag force
    fr=params.mass*9.81*(0.0136+5.2*10^-7*u^2); % compute rolling resistance force
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gear=1; %compute proper gear
while (u>params.vmax(gear) && gear<length(params.e))
	gear=gear+1;
end

if strcmp(params.drive,'RearWheelDrive') && wr>=0
    we=wr*params.ex*params.e(gear)*60/(2*pi()); % convert to rpm, find engine speed
elseif wf>=0 % assume front wheel speed and rear wheel speed are approx. the same for AWD
    we=wf*params.ex*params.e(gear)*60/(2*pi()); % convert to rpm, find engine speed
else
    we=0;
end

if we>params.redline
    we=params.redline;
end

ct=0;
if(gear==1 && we<params.launchrpm)  % launch control
	ct=(params.launchrpm-we)*0.05;
	we=params.launchrpm;
end

tq=ct+interp2(params.revs,params.throttle_vec,params.torque,we,throttle,'linear',0); % compute engine torque from curve fit

% cap max and min engine torques
if tq>max(params.torque_max)
    tq=max(params.torque_max);
elseif tq<0
    tq=0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% front and rear axle slip time derivatives
slipdotf=-u/params.rexlen*slipf+(wf*params.rad-u)/params.rexlen;
slipdotr=-u/params.rexlen*slipr+(wr*params.rad-u)/params.rexlen;

% braking torques
bf=params.max_brake_torque*brake;
tqfb=params.fbf*bf;
tqrb=(1-params.fbf)*bf;

% ABS bang bang controllers
if(slipf<params.slip1b && slipf<0)
    tqfb=0;
end
if(slipr<params.slip1b && slipr<0)
    tqrb=0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% tire 1 = left front
% tire 2 = right front
% tire 3 = left rear
% tire 4 = right rear

% normal tire forces
% +ve Z up
% +ve phi (pitch) nose down
% +ve theta (roll) right down
% N should be positive


N(1)=(-Z-params.tw/2*theta+params.wb*(1-params.fwf)*phi)*params.k_f;  % spring force
N(1)=N(1)+(-Zdot-params.tw/2*thetadot+params.wb*(1-params.fwf)*phidot)*params.c_f;  % damper force
%N(1)=N(1)+(-params.tw/2*theta)*params.k_roll;  % anti-roll bar

N(2)=(-Z+params.tw/2*theta+params.wb*(1-params.fwf)*phi)*params.k_f;
N(2)=N(2)+(-Zdot+params.tw/2*thetadot+params.wb*(1-params.fwf)*phidot)*params.c_f;
%N(2)=N(2)+(params.tw/2*theta)*params.k_roll;

N(3)=(-Z-params.tw/2*theta-params.wb*(params.fwf)*phi)*params.k_r;
N(3)=N(3)+(-Zdot-params.tw/2*thetadot-params.wb*(params.fwf)*phidot)*params.c_r;

N(4)=(-Z+params.tw/2*theta-params.wb*(params.fwf)*phi)*params.k_r;
N(4)=N(4)+(-Zdot+params.tw/2*thetadot-params.wb*(params.fwf)*phidot)*params.c_r;

az=sum(N(1):N(4))/params.mass;

N(1)=N(1)+params.mass*params.g*(params.fwf)*0.5;  % weight
N(2)=N(2)+params.mass*params.g*(params.fwf)*0.5;
N(3)=N(3)+params.mass*params.g*(1-params.fwf)*0.5;
N(4)=N(4)+params.mass*params.g*(1-params.fwf)*0.5;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sideslip angles
sideslip(1:4)=[0 0 0 0];
if(u>1)
	sideslip(1)=atan2((v+psidot*params.wb*(1-params.fwf)),(u-psidot*params.tw/2))-delta_1;
	sideslip(2)=atan2((v+psidot*params.wb*(1-params.fwf)),(u+psidot*params.tw/2))-delta_2;
	sideslip(3)=atan2((v-psidot*params.wb*params.fwf),(u-psidot*params.tw/2));
	sideslip(4)=atan2((v-psidot*params.wb*params.fwf),(u+psidot*params.tw/2));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% compute sin and cos of steer angles once
sind1=sin(delta_1);
cosd1=cos(delta_1);
sind2=sin(delta_2);
cosd2=cos(delta_2);

F_x=[0 0 0 0];
F_y=[0 0 0 0];
for tire=1:4 % compute longitudinal tire forces with magic tire model
	if(tire==1 || tire==2)
	    slip=slipf;
	else
		slip=slipr;
	end
	
	F_x(tire)=tire_long(slip,N(tire));
	F_y(tire)=tire_lat(sideslip(tire),N(tire),params.camber(tire)); % lateral forces
end

ft=sum(F_x(1:4));
% lateral acceleration
a_y=(F_x(1)*sind1+F_x(2)*sind2+F_y(1)*cosd1+F_y(2)*cosd2+sum(F_y(3:4)))/params.mass;
a_x=(ft-fa-fr)/params.mass;  % find longitudinal acceleration

phidotdot=(-(N(1)+N(2))*params.wb*(1-params.fwf)+(N(3)+N(4))*params.wb*(params.fwf) - params.mass*a_x*params.cgh)/params.Iyy; % sum of moments about axis parallel to the y-axis & on road surface
thetadotdot=((N(1)+N(3)-N(2)-N(4))*params.tw/2 + params.mass*a_y*params.cgh)/params.Ixx; % sum of moments about axis parallel to x-axis & on road surface

psidot2=(F_x(1)*sind1*(1-params.fwf)*params.wb+F_x(2)*sind2*(1-params.fwf)*params.wb-F_x(1)*cosd1*params.tw/2-F_x(2)*cosd2*-params.tw/2.... % front axle longitudinal force moments
-F_x(3)*params.tw/2-F_x(4)*-params.tw/2.... % rear axle longitudinal force moments
+F_y(1)*cosd1*(1-params.fwf)*params.wb+F_y(2)*cosd2*(1-params.fwf)*params.wb+F_y(1)*sind1*params.tw/2+F_y(2)*sind2*-params.tw/2.... % front axle lateral force moments
+F_y(3)*-params.fwf*params.wb+F_y(4)*-params.fwf*params.wb)/params.Izz; % rear axle lateral force moments
% +sum(tire_rest_moments))/params.Jz; % restoring moments % if this is
% uncommented, note that the division by moment of inertia must be removed
% from above

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% compute derivatives of longitudinal and lateral velocity in a rotating
% reference frame
udot=a_x+v*psidot;
vdot=a_y-u*psidot;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% compute axle alphas if brakes are not applied
tot_in=params.axle_in+params.eng_in*(params.ex*params.e(gear))^2; % drivetrain inertia

tqfb=tqfb*sign(wf);
tqrb=tqrb*sign(wr);

if strcmp(params.drive,'FrontWheelDrive')
    alphaf=(tq*params.eff*params.ex*params.e(gear)-tqfb-sum(F_x(1:2))*params.rad) / tot_in;
    alphar=(-tqrb-sum(F_x(3:4))*params.rad)/params.axle_in;
elseif strcmp(params.drive,'RearWheelDrive')
	alphaf=(-tqfb-sum(F_x(1:2))*params.rad) / tot_in;
	alphar=(tq*params.eff*params.ex*params.e(gear)-tqrb-sum(F_x(3:4))*params.rad)/params.axle_in;
elseif strcmp(params.drive,'AllWheelDrive')
    alphaf=(0.5*tq*params.eff*params.ex*params.e(gear)-tqfb-sum(F_x(1:2))*params.rad) / tot_in;
    alphar=(0.5*tq*params.eff*params.ex*params.e(gear)-tqrb-sum(F_x(3:4))*params.rad) / tot_in;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% assign outputs
xdot(1)=u;  % rate of change of distance is just speed, easy
xdot(2)=udot;  % rate of change of speed is acceleration
xdot(3)=alphaf; % front axle alpha
xdot(4)=slipdotf; % time derivative of front axle slip
xdot(5)=psidot; % yaw rate = yaw rate
xdot(6)=psidot2; % derivative of yaw rate
xdot(7)=v; % derivative of lateral position
xdot(8)=vdot; % derivative of lateral velocity
xdot(9)=u*cos(psi)-v*sin(psi);  % ISO system, y +ve left
xdot(10)=v*cos(psi)+u*sin(psi);


% lateral driver model
params.d_lat=u*params.t_lat;
if params.d_lat<params.d_lat_min
    params.d_lat=params.d_lat_min;
end

[offset,dpsi]=track_offset([X;Y],psi,s);

xdot(11)=-delta_in/params.tau-params.Kg/params.tau*(-dpsi)+params.Kg2/params.tau*offset/params.d_lat; % proportional control driver model
% xdot(11) is the time rate of change of the inner steered tire

% rear axle
xdot(12)=alphar; % rear axle alpha
xdot(13)=slipdotr; % rear axle slip time derivative

xdot(14)=Zdot;
xdot(15)=az;
xdot(16)=thetadot;
xdot(17)=thetadotdot;
xdot(18)=phidot;
xdot(19)=phidotdot;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% misc additional output data if this function is run through a for loop with the outputs of
% ode*** as inputs
if(flag_out==1) % outputs if this function is run with a for loop rather than ode45
    xdot(20)=we; % output engine speed
    xdot(21)=N(1); % output load on tire 1
    xdot(22)=N(2); % output load on tire 2
    xdot(23)=N(3); % output load on tire 3
    xdot(24)=N(4); % output load on tire 4
    xdot(25)=ft; % output traction force
    xdot(26)=gear; % current gear
    xdot(27)=throttle; % throttle position
    xdot(28)=brake; % brake application
    xdot(29)=state; % finite state machine (longitudinal driver model) state
    xdot(30)=tq; % engine torque
    xdot(31)=0; % front axle braking torque
    xdot(32)=0; % rear axle braking torque
    xdot(33)=0; % front axle braking force
    xdot(34)=0; % rear axle braking force
    xdot(35)=ft; % sum of longitudinal forces
    xdot(36)=params.t_long; % longitudinal drive model (FSM) preview time [s]
    xdot(37)=a_y; % lateral acceleration
    xdot(38)=offset; % offset error
end
xdot=xdot'; % must return column vector, so take transpose of row
end











% longitudinal driver model - finite state machine
% convert preview time to preview distance
%d_long=u*params.t_long;
%  if d_long<=0
%      d_long=params.d_long_min; % meters
%  end
%  % find track radius at current and longitudinal preview distances
%  rho=1/interp1(params.course(:,3),params.course(:,4),s,'linear','extrap');
%  rho2=1/interp1(params.course(:,3),params.course(:,4),s+d_long,'linear','extrap');
%  % check if the vehicle is on a straightaway or in a corner
%  if rho>=params.rho_limit  && rho2>=params.rho_limit % straightaway
%      state=1; % straightaway state
%  elseif rho>=params.rho_limit && rho2<params.rho_limit  % approaching corner state
%      state=2; % approaching corner state
%  elseif rho<params.rho_limit && rho2>=params.rho_limit % corner exit state
%      state=4; % corner exit state
%  else % curve
%      state=3; % cornering state
%  end






%  switch(state)
%  
%  	case 1 % straightaway state
%  		u_ref=interp1(params.course(:,3),params.course(:,6),s,'linear','extrap'); % find ref speed
%  		throttle=0.1*(u_ref-u);
%  		brake=-throttle;
%  			
%  	case 2 % approaching corner state
%  		u_ref=interp1(params.course(:,3),params.course(:,6),s,'linear','extrap'); % find ref speed
%  		throttle=0.1*(u_ref-u);
%  		brake=-throttle;
%  
%  		
% 	    u_ref_corner=interp1(params.course(:,3),params.course(:,6),s+d_long,'linear','extrap'); % find corner speed
% 	    if(u>u_ref_corner) % vehicle may need to brake
% 		    d_long_new=(u^2-u_ref_corner^2)/2/params.acc_brake_max/params.g; % find minimum braking distance
% % 			if(d_long_new>d_long) % there is excess distance to brake for the corner
% % 	            throttle=1; % maintain WOT
% % 	            brake=0;
% % 	        else % start full braking immediately
% % 				throttle=0;
% % 				brake=1;
% % 			end    
% 		else % vehicle is not yet at corner speed
% 	        throttle=1;
% 	        brake=0;
% 		end
%  	case 3 % cornering state
%  	    u_ref_corner=interp1(params.course(:,3),params.course(:,6),s+d_long,'linear','extrap'); % find corner speed
%  	    if u<=u_ref_corner % increase vehicle speed
%  	        throttle=0.5*(u_ref_corner-u)/u_ref_corner; % throttle response is a linear function of speed relative to change state reference speed
%  	        brake=0;
%  		else % decrease vehicle speed
%  		    brake=0.1*(u-u_ref_corner)/u_ref_corner; % braking is a linear function of speed relative reference speed
%  			throttle=0;
%  		end
%  	case 4 % exit corner state
%  		u_ref=interp1(params.course(:,3),params.course(:,6),s,'linear','extrap'); % find ref speed
%  		throttle=0.1*(u_ref-u);
%  		brake=-throttle;
%  
%  		
%  % 	    u_ref_corner=interp1(params.course(:,3),params.course(:,6),s,'linear','extrap'); % find corner speed
% 		if u<=u_ref_corner % increase vehicle speed
% 			throttle=0.8*(u_ref_corner-u)/u_ref_corner;
% 	    else % decrease vehicle speed
% 			throttle=0.5*(u_ref_corner-u)/u_ref_corner;
% 		end
%		brake=0;
%end


%beta=atan2(v,u); % sideslip angle
%xdot(9)=u*(cos(psi)*cos(beta)-sin(psi)*sin(beta));
%xdot(10)=u*(sin(psi)*cos(beta)+cos(psi)*sin(beta));




% iterative calculation of accelerations and tire forces
% loops=1;
% F_x=[0 0 0 0];
% F_y=[0 0 0 0];
% while(err>0.05)
%     loops=loops+1;
%     for tire=1:4 % compute longitudinal tire forces with magic tire model
%         if tire==1 || tire==2
%             slip=slipf;
%         else
%             slip=slipr;
% 		end
% %		slip
% %		N_x_old(tire)
%         F_x(tire)=tire_long(slip,N_x_old(tire));
%         F_y(tire)=tire_lat(sideslip(tire),N_x_old(tire),params.camber(tire)); % lateral forces
%     end
%     
%     % lateral acceleration
%     a_y=(F_x(1)*sind1+F_x(2)*sind2+F_y(1)*cosd1+F_y(2)*cosd2+sum(F_y(3:4)))/params.mass;
%     
%     % tire forces (braking)
%     if brake~=0
%         bff=sum(F_x(1:2)); % get tire force
%         bfr=sum(F_x(3:4)); % get tire force
%     else
%         bff=0;
%         bfr=0;
%     end
%     
%     if strcmp(params.drive,'RearWheelDrive')
%         ft=sum(F_x(3:4)); % get tire force
%     elseif strcmp(params.drive,'FrontWheelDrive')
%         ft=F_x(1)*cosd1+F_x(2)*cosd2; % get tire force
%     elseif strcmp(params.drive,'AllWheelDrive')
%         ft=F_x(1)*cosd1+F_x(2)*cosd2+sum(F_x(3:4)); % get tire force
%     end
% 
%     if brake~=0
%         f=bff+bfr-fa-fr;  % sum of forces
%     else
%         f=ft-fa-fr;  % sum of forces
%     end
% 	a_x=f/params.mass;  % find longitudinal acceleration
%     b_N_x(2)=params.mass*a_x*params.cgh; % sum of moments about axis parallel to the y-axis & on road surface
%     b_N_x(3)=-params.mass*a_y*params.cgh; % sum of moments about axis parallel to x-axis & on road surface
%     N_x=A_N_x\b_N_x'; % solve for wheel loads and suspension displacements
% 	err=sum(abs((N_x-N_x_old)./N_x));
%     if loops>100
%         disp('Calculation of accelerations and tire forces is not converging or is converging very slowly.')
%         disp('Relative error: ')
%         err
%         disp('Loop number: ')
%         loops
%     end
%     N_x_old=N_x;
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % re-calculate tire forces with the latest tire loads
% for tire=1:4 % compute longitudinal tire forces with magic tire model
%     if tire==1 || tire==2
%         slip=slipf;
%     else
%         slip=slipr;
%     end
%     F_x(tire)=tire_long(slip,N_x(tire));
%     % computer lateral tire forces with magic tire model
%     F_y(tire)=tire_lat(sideslip(tire),N_x(tire),params.camber(tire)); % lateral forces
% end

% if strcmp(params.drive,'RearWheelDrive')
%     ft=sum(F_x(3:4)); % get tire force
% elseif strcmp(params.drive,'FrontWheelDrive')
%     ft=F_x(1)*cosd1+F_x(2)*cosd2; % get tire force
% elseif strcmp(params.drive,'AllWheelDrive')
%     ft=F_x(1)*cosd1+F_x(2)*cosd2+sum(F_x(3:4)); % get tire force
% end
% 
% % tire forces (braking)
% if brake~=0
%     bff=sum(F_x(1:2)); % get tire force
%     bfr=sum(F_x(3:4)); % get tire force
% else
%     bff=0;
%     bfr=0;
% end

% re-calculate longitudinal and lateral acceleration with updated tire forces
% tire forces (braking)
%ft
%fa
%fr
%bff
%bfr
% if brake~=0
%     f=bff+bfr-fa-fr;  % sum of forces
% else
%     f=ft-fa-fr;  % sum of forces
% end
% a_x=f/params.mass;  % find longitudinal acceleration
% 
% % lateral acceleration
% a_y=(F_x(1)*sind1+F_x(2)*sind2+F_y(1)*cosd1+F_y(2)*cosd2+sum(F_y(3:4)))/params.mass;

%     for tire=1:4 % compute tire restoring moments
%         tire_rest_moments(tire)=-tire_rest_moment(sideslip(tire),N_x(tire),params.camber(tire));
%     end
   

% % tire forces, initial estimate
% a_x=0;
% a_y=0;
% A_N_x(1,:)=[1 1 1 1 0 0 0 0]; % sum of vertical tire loads
% b_N_x(1)=params.mass*params.g;
% A_N_x(2,:)=params.wb*[-(1-params.fwf) -(1-params.fwf) params.fwf params.fwf 0 0 0 0]; % sum of moments about axis parallel to the y-axis & on road surface
% b_N_x(2)=params.mass*a_x*params.cgh;
% A_N_x(3,:)=[params.tw/2 -params.tw/2 params.tw/2 -params.tw/2 0 0 0 0]; % sum of moments about axis parallel to x-axis & on road surface
% b_N_x(3)=-params.mass*a_y*params.cgh;
% A_N_x(4,:)=[1 0 0 0 -params.k_f-params.k_roll params.k_roll 0 0]; % front driver side suspension
% b_N_x(4)=0;
% A_N_x(5,:)=[0 1 0 0 params.k_roll -params.k_f-params.k_roll 0 0]; % front passenger side suspension
% b_N_x(5)=0;
% A_N_x(6,:)=[0 0 1 0 0 0 -params.k_r 0]; % rear driver side suspension
% b_N_x(6)=0;
% A_N_x(7,:)=[0 0 0 1 0 0 0 -params.k_r]; % rear driver side suspension
% b_N_x(7)=0;
% A_N_x(8,:)=[0 0 0 0 1 -1 -1 1]; % suspension kinematics constraint
% b_N_x(8)=0;
% N_x_old=A_N_x\b_N_x';
% err=1;
 % else
 
% vehicle is braking
%     if wf>0
%         alphaf=(-tqfb-bff*params.rad)/params.axle_in;
%     else
%         alphaf=(tqfb-bff*params.rad)/params.axle_in;
%     end
%     if wr>0
%         alphar=(-tqrb-bfr*params.rad)/params.axle_in;
%     else
%         alphar=(tqrb-bfr*params.rad)/params.axle_in;
%     end
