function out = ud_longls(writepath)

global params;

% add estimated max. corner speed to track data
for i=1:length(params.course)
%    if params.course(i,4)>1/params.rho_limit % if this is a corner, compute speed using max lat acceleration

	params.course(i,6)=sqrt(params.acc_lat_max*params.g/params.course(i,4));
	if(params.course(i,6)>params.maxv)  % straightaway, use maximum vehicle speed, not really used
		params.course(i,6)=params.maxv;
	end
end

% max driver side front wheel steer angle, if student tries to set an unreasonably high
% value
if(params.delta_in_max>60*pi/180)
	params.delta_in_max=60*pi/180;
end

% minimum driver reaction time of 0.1 seconds
if(params.tau<0.1)
	params.tau=0.1;
end

% backup longitudinal preview time
params.t_long2=params.t_long;

disp('Computing shift speeds...');

if(strcmp(params.drive,'RearWheelDrive'))
	params.drv_load=9.81*params.mass*(1-params.fwf);
	params.wtf=1;
elseif(strcmp(params.drive,'FrontWheelDrive'))
	params.drv_load=9.81*params.mass*params.fwf;
	params.wtf=-1;
else
	params.drv_load=9.81*params.mass; % find tire limit force
	params.wtf=0;
end

params.launchrpm=0.5*params.redline;

if(length(params.e)==5)
	params.eff=0.95;
else
	params.eff=0.90;
end

params.vmax=0.95*(params.redline*2*pi()/60*(params.rad)/params.ex)./params.e; %find redline speeds

disp('Speeds in each gear at redline (5% slip) [kph]:');
disp(params.vmax*3.6);
disp('Speeds range of each gear [kph]:');
disp(diff(params.vmax*3.6));

for i=1:(length(params.e)-1)
	at_bs=params.torque_max(end-1)*params.e(i); % axle torque before shift at redline
	at_as=interp1(params.revs,params.torque_max,params.revs(end-1)*params.e(i+1)/params.e(i))*params.e(i+1); % axle torque after shift at new engine speed
	if(at_as>at_bs)
		disp ('Short shift needed.  Calculating shift speed...'); % change shift speed
		dat=@(ws) interp1(params.revs,params.torque_max,ws,'spline')*params.e(i)-interp1(params.revs,params.torque_max,ws*params.e(i+1)/params.e(i),'spline')*params.e(i+1);
		shift_rpm=fzero(dat,params.revs(end-1));
		params.vmax(i)=0.95*shift_rpm*2*pi()/60*(params.rad)/params.ex/params.e(i);
		
	end
end

disp('Shift speeds for maximum acceleration [kph]:');
disp(params.vmax*3.6);
disp('Speeds range of each gear [kph]:');
disp(diff(params.vmax*3.6));

ww=linspace(params.revs(1),params.revs(end-1),100);
for i=1:100
	w=ww(i);
	tq=interp1(params.revs,params.torque_max,w);
	for j=1:(length(params.e))
		fts(i,j)=tq*params.e(j)*params.ex/params.rad*params.eff;
		vs(i,j)=3.6*0.95*w*2*pi()/60*params.rad/params.e(j)/params.ex;
	end
end

fig1=figure(1);
plot(vs,fts);
title('Steady State Traction Force vs. Speed');
xlabel('Speed [kph]');
ylabel('Traction Force [N]');
grid on
print(fig1,[writepath filesep() 'ftvv.pdf'],'-dpdf');
close(1);

string_simulating_msg=['Gathered data. Simulating ' num2str(params.std_id_number)];
disp(string_simulating_msg);
x0=zeros(1,13);
x0(5)=pi; % vehicle travels around the track clockwise
% start/finish line is vertical (track at this location is a straightaway in the global X
% direction)

t=[0:0.1:25]; % set time interval

flag_out=0;
[tout,xout]=ode45(@(t,x)ls(t,x,flag_out),t,x0); % ,vopt); % simulate, please

flag_out=1;
for i=1:length(tout)
	yout(i,:)=ls(tout(i), xout(i,:)',flag_out)';
end

out.dist=xout(:,1);
out.speed=xout(:,2)*3.6;  % convert from m/s to kph
out.accel=yout(:,2)/9.81; % convert from m/s^2 to g
out.faxle=xout(:,3); % front axle angular velocity
out.fslip=xout(:,4); % front axle slip
out.yaw=xout(:,5); % yaw angle
out.ydist=xout(:,7); % lateral displacement
out.X=xout(:,9); % global X position
out.Y=xout(:,10); % global Y position
out.delta_in=xout(:,11); % inner wheel steer angle
clear idx

% save data for animation
params.X=out.X;
params.Y=out.Y;
params.yaw=out.yaw;

% use for loops to extract additional data
for i=1:length(tout)
    if out.delta_in(i)>params.delta_in_max
        out.delta_in(i)=params.delta_in_max;
    elseif out.delta_in(i)<-params.delta_in_max
        out.delta_in(i)=-params.delta_in_max;
    end
    if out.delta_in(i)>=0
        out.delta_out(i)=fzero(@(delta_out2) delta_out_f(delta_out2,out.delta_in(i),params.gamma,params.L1,params.L2),out.delta_in(i));
    else
        out.delta_out(i)=-fzero(@(delta_out2) delta_out_f(delta_out2,abs(out.delta_in(i)),params.gamma,params.L1,params.L2),abs(out.delta_in(i)));
    end
end
out.raxle=xout(:,12); % front axle angular velocity
out.rslip=xout(:,13); % front axle slip
out.RPM=yout(:,14); % convert from rad/s to RPM
out.N1=yout(:,15); % vertical tire loads
out.N2=yout(:,16); % vertical tire loads
out.N3=yout(:,17); % vertical tire loads
out.N4=yout(:,18); % vertical tire loads
out.ft=yout(:,23); % traction force
out.gear=yout(:,24); % gear ratio vs time
out.throttle=yout(:,25); % throttle position
out.brake=yout(:,26); % braking
out.FSM=yout(:,27); % finite state machine (longitudinal driver model) state
out.tq=yout(:,28); % engine torque
out.tqfb=yout(:,29); % front axle braking torque
out.tqrb=yout(:,30); % rear axle braking torque
out.bff=yout(:,31); % front axle braking force
out.bfr=yout(:,32); % rear axle braking force
out.f=yout(:,33); % sum of longitudinal forces
out.t_long=yout(:,34); % longitudinal driver model (FSM) preview time [s]
out.lat_accel=yout(:,35)/params.g; % lateral acceleration
out.offset=yout(:,36); % offset error
out.tout=tout;
params.tout=out.tout; % save time for animation
%clear idx
for i=1:length(tout)
    [out.offset(i),out.yaw1(i)]=track_offset([xout(i,9); xout(i,10)],xout(i,5),xout(i,1));
end
out.yaw1b=interp1(out.dist,out.yaw1,params.course(:,3),'nearest','extrap');

for i=1:length(tout)
    out.dyaw(i)=out.yaw(i)-out.yaw1(i); % current - desired yaw angle
end

if strcmp(params.drive,'RearWheelDrive')
    out.mu=out.ft./(yout(:,17)+yout(:,18));
elseif strcmp(params.drive,'FrontWheelDrive')
    out.mu=out.ft./(yout(:,15)+yout(:,16));
elseif strcmp(params.drive,'AllWheelDrive')
    out.mu=out.ft./(yout(:,15)+yout(:,16)+yout(:,17)+yout(:,18));
end
out.dx_susp=0;
% ----------------- OUTPUT PLOTS -----------------------------------
disp('Ran simulation. Plotting results...');
% figure('visible','off');

fig1=figure(1);
plot(tout,out.speed);
title('Speed vs. Time');
xlabel('Time [s]');
ylabel('Speed [kph]');
grid on
print(fig1,[writepath filesep() 'Speed.pdf'],'-dpdf');
close(1);

fig2=figure(2);
plot(tout,out.dist);
title('Distance vs. Time');
xlabel('Time [s]');
ylabel('Distance [m]');
grid on
print(fig2,[writepath filesep() 'Distance_vs_time.pdf'],'-dpdf');
close(2);

fig3=figure(3);
plot(tout,out.accel);
title('Acceleration vs. Time');
xlabel('Time [s]');
ylabel('Acceleration [g]');
grid on
print(fig3,[writepath filesep() 'Acceleration_vs_time.pdf'],'-dpdf');
close(3);

fig4=figure(4);
plot(tout,out.gear);
title('Gear vs. Time');
xlabel('Time [s]');
ylabel('Gear');
grid on
print(fig4,[writepath filesep() 'Gear_vs_time.pdf'],'-dpdf');
close(4);

fig5=figure(5);
plot(tout,out.RPM);
title('Engine Speed vs. Time');
xlabel('Time [s]');
ylabel('Engine Speed [rpm]');
grid on
print(fig5,[writepath filesep() 'Engine_rpm_vs_time.pdf'],'-dpdf');
close(5);

fig6=figure(6);
plot(tout,out.faxle);
title('Front Axle Speed vs. Time');
xlabel('Time [s]');
ylabel('Front Axle Speed [rad/s]');
grid on
print(fig6,[writepath filesep() 'Front_axle_speed_vs_time.pdf'],'-dpdf');
close(6);

fig7=figure(7);
plot(tout,out.fslip);
title('Front Axle Slip vs. Time');
xlabel('Time [s]');
ylabel('Front Axle Tire Slip');
grid on
print(fig7,[writepath filesep() 'Front_slip_ratio_vs_time.pdf'],'-dpdf');
close(7);

fig8=figure(8);
plot(tout,out.ft);
title('Drive Axle Longitudinal Force vs. Time');
xlabel('Time [s]');
ylabel('Drive Axle Longitudinal Force [N]');
grid on
print(fig8,[writepath filesep() 'Drive_axle_longitudinal_force_vs_time.pdf'],'-dpdf');
close(8);

fig9=figure(9);
plot(tout,out.mu);
title('Tire Coefficient vs. Time');
xlabel('Time [s]');
ylabel('Tire Coefficient');
grid on
print(fig9,[writepath filesep() 'Tire_friction_coefficient_vs_time.pdf'],'-dpdf');
close(9);

fig10=figure(10);
plot(tout,out.N1,tout,out.N2,tout,out.N3,tout,out.N4)
title('Tire loads')
xlabel('Time [s]')
ylabel('Tire load [N]')
grid on
legend('Front, driver side','Front, passenger side','Rear, driver side','Rear, passenger side')
print(fig10,[writepath filesep() 'Tire_normal_loads_vs_time.pdf'],'-dpdf');
close(10);

%tire properties
slip=linspace(-1,1,200); % converted to % in tire_long.m
sideslip=pi/180*linspace(-12,12,200);
% longitudinal
N10=0.1*params.mass*9.807;
Fx10=tire_long(slip,N10);
N20=0.2*params.mass*9.807;
Fx20=tire_long(slip,N20);
N30=0.3*params.mass*9.807;
Fx30=tire_long(slip,N30);

fig11=figure(11);
plot(slip,Fx10,slip,Fx20,slip,Fx30);
title('Longitudinal tire force vs. slip');
xlabel('Slip');
ylabel('Longitudinal force (N)');
grid on;
legend('10% of vehicle weight','20%','30%','location','northwest');
print(fig11,[writepath filesep() 'Magic_tire_longitudinal_force_vs_slip_ratio.pdf'],'-dpdf');
close(11);

% lateral
camber=0;
Fy10=tire_lat(sideslip,N10,camber);
Fy20=tire_lat(sideslip,N20,camber);
Fy30=tire_lat(sideslip,N30,camber);

% restoring moment
camber=0;
Mz10=tire_rest_moment(sideslip,N10,camber);
Mz20=tire_rest_moment(sideslip,N20,camber);
Mz30=tire_rest_moment(sideslip,N30,camber);

fig13=figure(13);
plot(sideslip,Fy10,sideslip,Fy20,sideslip,Fy30);
title('Lateral tire force vs. sideslip');
xlabel('Sideslip (rad)');
ylabel('Lateral force (N)');
grid on;
legend('10% of vehicle weight','20%','30%','location','northeast');
print(fig13,[writepath filesep() 'Magic_tire_lateral_force_vs_sideslip_angle.pdf'],'-dpdf');
close(13);

fig14=figure(14);
plot(sideslip,Mz10,sideslip,Mz20,sideslip,Mz30);
title('Tire restoring moment vs. sideslip');
xlabel('Sideslip (rad)');
ylabel('Tire restoring moment (Nm)');
grid on;
legend('10% of vehicle weight','20%','30%','location','northeast');
print(fig14,[writepath filesep() 'Magic_tire_restoring_moment_vs_sideslip_angle.pdf'],'-dpdf');
close(14);

fig15=figure(15);
plot(tout,out.ydist)
title('Lateral displacement vs. time')
xlabel('Time [s]')
ylabel('Lateral displacement [m]')
grid on
print(fig15,[writepath filesep() 'Lateral_displacement_vs_time.pdf'],'-dpdf')
close(15)

fig16=figure(16);
plot(out.X,out.Y,'b',params.course(:,1),params.course(:,2),'k:')
title('Vehicle X-Y plot vs. track')
xlabel('X (m)')
ylabel('Y (m)')
legend('Vehicle Position','Track')
grid on
print(fig16,[writepath filesep() 'Position_track.pdf'],'-dpdf')
close(16)

fig17=figure(17);
plot(tout,out.FSM)
title('FSM State vs Time')
xlabel('Time [s]')
ylabel('FSM State')
grid on
print(fig17,[writepath filesep() 'FSM_state_vs_time.pdf'],'-dpdf')
close(17)

fig18=figure(18);
plot(tout,out.throttle)
title('Throttle vs Time')
xlabel('Time [s]')
ylabel('Throttle')
grid on
print(fig18,[writepath filesep() 'Throttle_vs_time.pdf'],'-dpdf')
close(18)

fig19=figure(19);
plot(tout,out.brake)
title('Braking vs Time')
xlabel('Time [s]')
ylabel('Braking')
grid on
print(fig19,[writepath filesep() 'Braking_vs_time.pdf'],'-dpdf')
close(19)

fig20=figure(20);
plot(tout,out.dyaw)
title('Current - Desired Yaw Angle vs Time')
xlabel('Time [s]')
ylabel('Current and Desired Yaw Angle Difference [rads]')
grid on
print(fig20,[writepath filesep() 'Yaw_difference_vs_time.pdf'],'-dpdf')
close(20);

fig21=figure(21);
plot(tout,out.delta_in,tout,out.delta_out)
title('Steer angles vs time')
xlabel('Time [s]')
ylabel('Steer angle (rad)')
grid on
legend('Inner wheel steer angle','Outer wheel steer angle','location','northwest')
print(fig21,[writepath filesep() 'Steer_angles_vs_time.pdf'],'-dpdf')
close(21);

fig22=figure(22);
plot(tout,out.tq)
title('Engine torque vs time')
xlabel('Time [s]')
ylabel('Engine Torque [Nm]')
grid on
print(fig22,[writepath filesep() 'Engine_torque_vs_time.pdf'],'-dpdf')
close(22);

fig23=figure(23);
plot(tout,out.tqfb,tout,out.tqrb)
title('Front and rear axle braking torques')
xlabel('Time [s]')
ylabel('Braking torque [Nm]')
grid on
legend('Front axle','Rear axle')
print(fig23,[writepath filesep() 'Braking_torques_vs_time.pdf'],'-dpdf')
close(23);

fig24=figure(24);
plot(tout,out.bff,tout,out.bfr)
title('Front and rear axle braking forces')
xlabel('Time [s]')
ylabel('Braking force [N]')
grid on
legend('Front axle','Rear axle')
print(fig24,[writepath filesep() 'Braking_forces_vs_time.pdf'],'-dpdf')
close(24);

fig25=figure(25);
plot(tout,out.raxle);
title('Rear Axle Speed vs. Time');
xlabel('Time [s]');
ylabel('Rear Axle Speed [rad/s]');
grid on
print(fig25,[writepath filesep() 'Rear_axle_speed_vs_time.pdf'],'-dpdf');
close(25);

fig26=figure(26);
plot(tout,out.rslip);
title('Rear Axle Slip vs. Time');
xlabel('Time [s]');
ylabel('Rear Axle Tire Slip');
grid on
print(fig26,[writepath filesep() 'Rear_slip_ratio_vs_time.pdf'],'-dpdf');
close(26);

fig27=figure(27);
plot(params.course(:,3),out.yaw1b)
title('Desired yaw angle vs longitudinal distance')
xlabel('Longitudinal distance (m)')
ylabel('Desired yaw angle [rad]')
grid on
print(fig27,[writepath filesep() 'Desired_yaw_vs_distance.pdf'],'-dpdf')
close(27);

fig28=figure(28);
plot(params.course(:,3),params.course(:,4))
title('Track curvature vs longitudinal distance')
xlabel('Longitudinal distance [m]')
ylabel('Curvature [1/m]')
grid on
print(fig28,[writepath filesep() 'Track_radius_vs_distance.pdf'],'-dpdf')
close(28);

fig29=figure(29);
plot(tout,out.f)
title('Sum of longitudinal forces vs time')
xlabel('Time [s]')
ylabel('Sum of longitudinal forces [N]')
grid on
print(fig29,[writepath filesep() 'Sum_longitudinal_forces_vs_time.pdf'],'-dpdf')
close(29)

fig30=figure(30);
plot(tout,out.yaw)
title('Vehicle yaw angle')
xlabel('Time [s]')
ylabel('Vehicle yaw angle [rad]')
grid on
print(fig30,[writepath filesep() 'Vehicle_yaw_angle_vs_time.pdf'],'-dpdf')
close(30)

fig31=figure(31);
plot(tout,out.t_long)
title('Longitudinal driver model preview time')
xlabel('Time [s]')
ylabel('Driver preview time (longitudinal) [s]')
grid on
print(fig31,[writepath filesep() 'Longitudinal_driver_preview_time.pdf'],'-dpdf')
close(31);

delta_in_vec=linspace(0,60*pi/180);
for i=1:length(delta_in_vec)
    if delta_in_vec(i)>=0
        delta_out_vec(i)=fzero(@(delta_out2)delta_out_f(delta_out2,delta_in_vec(i),params.gamma,params.L1,params.L2),delta_in_vec(i));
    else
        delta_out_vec(i)=-1*fzero(@(delta_out2)delta_out_f(delta_out2,abs(delta_in_vec(i)),params.gamma,params.L1,params.L2),abs(delta_in_vec(i)));
    end
end
delta_out_Ackerman=atan(1./(1./tan(delta_in_vec)+params.tw/params.wb));
fig32=figure(32);
plot(delta_in_vec,delta_out_vec,delta_in_vec,delta_out_Ackerman)
title('Inner and outer wheel steer angles vs Ackerman')
xlabel('Inner wheel steer angle (rad)')
ylabel('Outer wheel steer angle (rad)')
legend('Vehicle steering mechanism','Ackerman steering','location','northwest')
grid on
print(fig32,[writepath filesep() 'Steer_angles_vs_Ackerman.pdf'],'-dpdf')
close(32);

fig33=figure(33);
plot(out.dist,out.speed,params.course(:,3),params.course(:,6)*3.6)
title('Speed vs track position, desired and actual')
xlabel('Longitudinal position on track [m]')
ylabel('Vehicle speed [km/h]')
legend('Actual','Desired')
grid on
print(fig33,[writepath filesep() 'Desired_and_actual_speed_vs_position.pdf'],'-dpdf')
close(33);

fig34=figure(34);
plot(tout,out.yaw1)
title('Desired yaw angle vs time')
xlabel('Time [s]')
ylabel('Desired yaw angle [rad]')
grid on
print(fig34,[writepath filesep() 'Desired_yaw_vs_time.pdf'],'-dpdf')
close(34);

fig35=figure(35);
plot(tout,out.lat_accel)
title('Lateral acceleration vs time')
xlabel('Time [s]')
ylabel('Lateral acceleration [g]')
grid on
print(fig35,[writepath filesep() 'Lateral_acceleration_vs_time.pdf'],'-dpdf')
close(35);

fig36=figure(36);
plot(tout,out.offset)
title('Offset error')
xlabel('Time [s]')
ylabel('Offset error [m]')
grid on
print(fig36,[writepath filesep() 'Offset_error_vs_time.pdf'],'-dpdf')
close(36);

brake_impulse_f=cumtrapz(tout,out.bff);
brake_impulse_r=cumtrapz(tout,out.bfr);

fig37=figure(37);
plot(tout,brake_impulse_f,tout,brake_impulse_r)
title('Brake force impulse')
xlabel('Time [s]')
ylabel('Brake force impulse [Ns]')
legend('Front brakes','Rear brakes')
grid on
print(fig37,[writepath filesep() 'Brake_impulses_vs_time.pdf'],'-dpdf')
close(37);

% compute Oberkampf-Trucano error metric for deviation from the track
X_int=interp1(out.dist,out.X,params.course(:,3),'linear','extrap');
Y_int=interp1(out.dist,out.Y,params.course(:,3),'linear','extrap');
for i=1:length(params.course)
    if params.course(i,1)==0
        params.course(i,1)=0.00001;
    end
    if params.course(i,2)==0
        params.course(i,2)=0.00001;
    end
end
OT_metric=1-1/2/length(params.course(:,3))*sum(tanh(abs((X_int-params.course(:,1))./params.course(:,1))))-1/2/length(params.course(:,3))*sum(tanh(abs((Y_int-params.course(:,2))./params.course(:,2))));
disp('Oberkampf-Trucano error metric for global positions over time vs. the track. A value of 1 indicates the vehicle passed through all locations on the track with zero error. ');
OT_metric
filename_OT_metric_string=[writepath filesep() num2str(params.std_id_number) '_OT_metric.csv'];
dlmwrite(filename_OT_metric_string,[params.std_id_number OT_metric]);

out.tf=0;
out.tf=interp1(xout(:,1),tout,2235,'spline','extrap');
disp(['Lap time [s]:' num2str(out.tf)]);
filename_time_string=[writepath filesep() num2str(params.std_id_number) '_lap_time.csv'];
dlmwrite(filename_time_string,[params.std_id_number out.tf]);



end
