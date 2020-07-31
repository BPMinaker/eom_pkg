function plot_results(tout, xout,yout,writepath)

global params;

disp('Ran simulation. Plotting results...');
% figure('visible','off');

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


out.delta_out=out.delta_in;

out.raxle=xout(:,12); % front axle angular velocity
out.rslip=xout(:,13); % front axle slip

out.Z=xout(:,14);
out.Zdot=xout(:,15);
out.theta=xout(:,16);
out.thetadot=xout(:,17);
out.phi=xout(:,18);
out.phidot=xout(:,19);

out.RPM=yout(:,20); % convert from rad/s to RPM
out.N1=yout(:,21); % vertical tire loads
out.N2=yout(:,22); % vertical tire loads
out.N3=yout(:,23); % vertical tire loads
out.N4=yout(:,24); % vertical tire loads
out.ft=yout(:,25); % traction force
out.gear=yout(:,26); % gear ratio vs time
out.throttle=yout(:,27); % throttle position
out.brake=yout(:,28); % braking
out.FSM=yout(:,29); % finite state machine (longitudinal driver model) state
out.tq=yout(:,30); % engine torque
out.tqfb=yout(:,31); % front axle braking torque
out.tqrb=yout(:,32); % rear axle braking torque
out.bff=yout(:,33); % front axle braking force
out.bfr=yout(:,34); % rear axle braking force
out.f=yout(:,35); % sum of longitudinal forces
out.t_long=yout(:,36); % longitudinal driver model (FSM) preview time [s]
out.lat_accel=yout(:,37)/params.g; % lateral acceleration
out.offset=yout(:,38); % offset error
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


% fig37=figure(37);
% stem3(out.X,out.Y,out.throttle,'b');
% %,params.course(:,1),params.course(:,2),zeros(size(params.course(:,1))),'k:')
% title('Vehicle X-Y-throttle plot vs. track')
% xlabel('X (m)')
% ylabel('Y (m)')
% ylabel('Throttle')
% legend('Vehicle Position','Track')
% grid on
% print(fig37,[writepath filesep() 'Position_track_throttle.pdf'],'-dpdf')
% %savefig(fig37,[writepath filesep() 'Position_track_throttle.fig'])
% close(37)

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


fig38=figure(38);
plot(tout,out.Z)
title('Vertical Position')
xlabel('Time [s]')
ylabel('Vertical position [m]')
grid on
print(fig38,[writepath filesep() 'Vertical_Position_vs_time.pdf'],'-dpdf')
close(38);


fig39=figure(39);
plot(tout,out.theta)
title('Roll Angle')
xlabel('Time [s]')
ylabel('Roll Angle [rad]')
grid on
print(fig39,[writepath filesep() 'Roll_Angle_vs_time.pdf'],'-dpdf')
close(39);

fig40=figure(40);
plot(tout,out.phi)
title('Pitch Angle')
xlabel('Time [s]')
ylabel('Pitch Angle [rad]')
grid on
print(fig40,[writepath filesep() 'Pitch_Angle_vs_time.pdf'],'-dpdf')
close(40);


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


end %% Leave
