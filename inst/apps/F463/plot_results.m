function plot_results(t,z,zdot,out)

global params;

disp('Ran simulation. Plotting results...');
% figure('visible','off');

tf=t(end);

frame=z(:,1:13);  %% Pull out frame motions
s=z(:,14);
psi=z(:,15);
delta=z(:,16);
frm_acc=zdot(:,1:13);
extra=zdot(:,end-52:end);
 
z=z(:,17:end);
zdot=zdot(:,17:end-53);





x=z(:,1:end/2)*params.l_orth;  %% Convert locations back to physical coordinates
xd=z(:,end/2+1:end)*params.l_orth;  %% Convert velocities back to physical coordinates
for i=1:size(x,1)  %% For each output point
	for j=1:params.nbods  %% Over each body 
		x(i,6*j+(-5:-3))=x(i,6*j+(-5:-3))+params.rads(:,j)';  %% Add constant offsets
	end
end

v=zdot(:,1:end/2)*params.l_orth;  %% Convert velocities back to physical coordinates
vd=zdot(:,end/2+1:end)*params.l_orth;  %% Convert accelerations back to physical coordinates


throttle=extra(:,42);
brake=extra(:,43);
eng_rpm=extra(:,44);
gear=extra(:,45);
wheel_speed=extra(:,46:49);
camber=extra(:,50:53);


figure
plot(t,x(:,1:3));
title('Relative motion of the chassis vs time');
xlabel('Time [s]');
ylabel('Displacement [m]');
axis([0 tf -2 2]);

temp=[t x(:,1:3)];
filename=[out filesep() 'chassis_disp.out'];
save(filename,'temp','-ascii','-double');

figure
plot(t,x(:,4:6));
title('Relative orientation of the chassis vs time');
ylabel('Angle [rad]');
xlabel('Time [s]');
axis([0 tf -0.15 0.15]);

temp=[t x(:,4:6)];
filename=[out filesep() 'chassis_orntn.out'];
save(filename,'temp','-ascii','-double');

figure
plot(t,s)
title('Distance travelled vs time');
xlabel('Time [s]');
ylabel('Distance [m]');
axis([0 tf 0 3000]);

temp=[t s];
filename=[out filesep() 'dist_time.out'];
save(filename,'temp','-ascii','-double');

figure
plot(t,psi);
title('Orientation angle of the reference frame vs time');
xlabel('Time [s]');
ylabel('Angle [rad]');
axis([0 tf -3*pi 3*pi]);

temp=[t psi];
filename=[out filesep() 'psi_time.out'];
save(filename,'temp','-ascii','-double');

figure
plot(params.course(:,1),params.course(:,2),'k.');
hold on
theta=2*atan2(frame(:,7),frame(:,4));  %% only when we know rotation is only about z
plot([frame(:,1) frame(:,1)+cos(theta)],[frame(:,2) frame(:,2)+sin(theta)],'*','markersize',2);  %% Plot the frame global coordinate
title('Track, and 0,0 and 1,0 of moving frame');
axis equal
hold off

temp=[frame(:,1:2) frame(:,1)+cos(theta) frame(:,2)+sin(theta)];
filename=[out filesep() 'frame_path.out'];
save(filename,'temp','-ascii','-double');

temp=params.course(:,1:2);
filename=[out filesep() 'track.out'];
save(filename,'temp','-ascii','-double');

figure
plot(params.course(:,1),params.course(:,2),'k.');
hold on
plot(frame(:,1)+cos(theta).*x(:,6*params.chassnum-5)-sin(theta).*x(:,6*params.chassnum-4),frame(:,2)+cos(theta).*x(:,6*params.chassnum-4)+sin(theta).*x(:,6*params.chassnum-5),'*','markersize',2);
plot(frame(:,1)+cos(theta).*x(:,6*params.wheelnum(1)-5)-sin(theta).*x(:,6*params.wheelnum(1)-4),frame(:,2)+cos(theta).*x(:,6*params.wheelnum(1)-4)+sin(theta).*x(:,6*params.wheelnum(1)-5));
plot(frame(:,1)+cos(theta).*x(:,6*params.wheelnum(2)-5)-sin(theta).*x(:,6*params.wheelnum(2)-4),frame(:,2)+cos(theta).*x(:,6*params.wheelnum(2)-4)+sin(theta).*x(:,6*params.wheelnum(2)-5));
plot(frame(:,1)+cos(theta).*x(:,6*params.wheelnum(3)-5)-sin(theta).*x(:,6*params.wheelnum(3)-4),frame(:,2)+cos(theta).*x(:,6*params.wheelnum(3)-4)+sin(theta).*x(:,6*params.wheelnum(3)-5));
plot(frame(:,1)+cos(theta).*x(:,6*params.wheelnum(4)-5)-sin(theta).*x(:,6*params.wheelnum(4)-4),frame(:,2)+cos(theta).*x(:,6*params.wheelnum(4)-4)+sin(theta).*x(:,6*params.wheelnum(4)-5));
title('Track, and CG of chassis, next bodies');
axis equal
hold off

temp=[frame(:,1)+cos(theta).*x(:,6*params.chassnum-5)-sin(theta).*x(:,6*params.chassnum-4) frame(:,2)+cos(theta).*x(:,6*params.chassnum-4)+sin(theta).*x(:,6*params.chassnum-5)];
filename=[out filesep() 'chassis_path.out'];
save(filename,'temp','-ascii','-double');

figure
plot(t,frame(:,11:13));
title('Angular velocity of the reference frame vs time');
xlabel('Time [s]');
ylabel('Angular velocity [rad/s]');

figure
plot(t,frm_acc(:,9)+frame(:,8).*frame(:,13));
title('Lateral acceleration of reference frame vs time');
xlabel('Time [s]');
ylabel('Acceleration [m/s/s]');
axis([0 tf -8 8]);

figure
plot(t,delta);
title('Steer angle vs time');
xlabel('Time [s]');
ylabel('Angle [rad]');
axis([0 tf -0.1 0.1]);

temp=[t delta];
filename=[out filesep() 'delta_time.out'];
save(filename,'temp','-ascii','-double');

figure
plot(t,extra(:,1:3));
title('Inertial forces vs time');
xlabel('Time [s]');
ylabel('Force [N]');
axis([0 tf -10000 10000]);

figure
plot(t,extra(:,4:6));
title('Inertial moments vs time');
xlabel('Time [s]');
ylabel('Moments [Nm]');
axis([0 tf -200 200]);

figure
plot(t,extra(:,7));
title('Path error vs time');
xlabel('Time [s]');
ylabel('Offset [m]');
axis([0 tf -2 2]);

figure
plot(t,extra(:,8)); 
title('Heading error vs time');
xlabel('Time [s]');
ylabel('Angle [rad]');
axis([0 tf -0.1 0.1]);

temp=[t,extra(:,7:8)];
filename=[out filesep() 'path_heading_err_time.out'];
save(filename,'temp','-ascii','-double');

figure
plot(t,extra(:,9:12));
title('Combined slip vs time');
xlabel('Time [s]');
ylabel('Unitless');
axis([0 tf 0 1]);

figure
plot(t,extra(:,13:16));
title('Slip direction vs time');
xlabel('Time [s]');
ylabel('0=lateral, 1=longitudinal');
axis([0 tf 0 1]);

figure
plot(t,extra(:,17:20));
title('Normal forces vs time');
xlabel('Time [s]');
ylabel('Force [N]');
axis([0 tf 0 7000]);

temp=[t extra(:,17:20)];
filename=[out filesep() 'normal_time.out'];
save(filename,'temp','-ascii','-double');

figure
plot(t,extra(:,21:24));
title('Lateral forces vs time');
xlabel('Time [s]');
ylabel('Force [N]');
axis([0 tf -6000 6000]);

temp=[t extra(:,21:24)];
filename=[out filesep() 'lateral_time.out'];
save(filename,'temp','-ascii','-double');

figure
plot(t,extra(:,25:28));
title('Longitudinal forces vs time');
xlabel('Time [s]');
ylabel('Force [N]');
axis([0 tf -6000 6000]);

temp=[t extra(:,25:28)];
filename=[out filesep() 'long_time.out'];
save(filename,'temp','-ascii','-double');

figure
plot(t,[xd(:,6*params.chassnum+(-5:-3)) extra(:,41)]);
title('Chassis velocity vs time');
xlabel('Time [s]');
ylabel('Velocity [m/s]');
axis([0 tf -inf inf]);

temp=[t xd(:,6*params.chassnum+(-5:-3)) extra(:,41)];
filename=[out filesep() 'vel_time.out'];
save(filename,'temp','-ascii','-double');

figure
plot(t,xd(:,6*params.chassnum-4)./xd(:,6*params.chassnum-5));
title('Chassis slip angle vs time');
xlabel('Time [s]');
ylabel('Angle [rad]');
axis([0 tf -0.1 0.1]);

figure
plot(t,xd(:,6*params.chassnum+(-2:0)));
title('Chassis angular velocity');
xlabel('Time [s]');
ylabel('Angular velocity [rad/s]');
axis([0 tf -inf inf]);

figure
plot(t,extra(:,29:31));
title('Chassis stiffness force');
xlabel('Time [s]');
ylabel('Force [N]');
axis([0 tf -300 300]);

figure
plot(t,extra(:,32:34));
title('Chassis stiffness moment');
xlabel('Time [s]');
ylabel('Moments [Nm]');
axis([0 tf -200 200]);

figure
plot(t,extra(:,35:37));
title('Chassis damping force');
xlabel('Time [s]');
ylabel('Force [N]');
axis([0 tf -50 50]);

figure
plot(t,extra(:,38:40));
title('Chassis damping moment');
xlabel('Time [s]');
ylabel('Moments [Nm]');
axis([0 tf -50 50]);

% for i=7:3:size(x,2)
% figure(22+i)
% plot(t,x(:,i:i+2));
% title('all locations');
% axis([0 tf -2 2]);
% end

figure
plot(t,[throttle brake]);
title('Throttle, brake vs time');
xlabel('Time [s]');
ylabel('Throttle, Brake []');
axis([0 tf -0.1 1.1]);

temp=[t throttle brake];
filename=[out filesep() 'throttle_brake_time.out'];
save(filename,'temp','-ascii','-double');

figure
plot(t,eng_rpm);
title('Engine speed vs time');
xlabel('Time [s]');
ylabel('Engine speed [rpm]');
axis([0 tf 0 10000]);

figure
plot(t,gear);
title('Gear vs time');
xlabel('Time [s]');
ylabel('Gear');
axis([0 tf 0 7]);

figure
plot(t,wheel_speed);
title('Wheel speed vs time');
xlabel('Time [s]');
ylabel('Wheel speed [rad/s]');
axis([0 tf -inf inf]);

figure
plot(t,camber);
title('Camber vs time');
xlabel('Time [s]');
ylabel('Camber [rad]');
axis([0 tf -0.1 0.1]);

%figure
%plot(t,v(:,6*params.chassnum+(-5:-3)));

%figure
%plot(t,v(:,6*params.chassnum+(-2:0)));

temp=zeros(length(t),3);
for i=1:length(t)
	temp(i,1:3)=cross(xd(i,6*params.chassnum+(-2:0)),xd(i,6*params.chassnum+(-5:-3)));
end

figure
plot(t,vd(:,6*params.chassnum+(-5:-3))+temp(:,1:3));
title('Linear acceleration vs time');
xlabel('Time [s]');
ylabel('Acceleration [m/s^2]');
axis([0 tf -10 10]);

temp=[t vd(:,6*params.chassnum+(-5:-3))+temp(:,1:3)];
filename=[out filesep() 'accln_time.out'];
save(filename,'temp','-ascii','-double');

% figure
% plot(t,vd(:,6*params.chassnum+(-2:0)));
% title('Angular acceleration vs time');
% xlabel('Time [s]');
% ylabel('Angular acceleration [rad/s^2]');
% axis([0 tf -1 1]);
% 
% temp=[t vd(:,6*params.chassnum+(-2:0))];
% filename=[out filesep() 'ang_accln_time.out'];
% save(filename,'temp','-ascii','-double');


end %% Leave


% 
% fig3=figure(3);
% plot(tout,out.accel);
% title('Acceleration vs. Time');
% xlabel('Time [s]');
% ylabel('Acceleration [g]');
% grid on
% print(fig3,[writepath filesep() 'Acceleration_vs_time.pdf'],'-dpdf');
% close(3);
% 
% 
% fig6=figure(6);
% plot(tout,out.faxle);
% title('Front Axle Speed vs. Time');
% xlabel('Time [s]');
% ylabel('Front Axle Speed [rad/s]');
% grid on
% print(fig6,[writepath filesep() 'Front_axle_speed_vs_time.pdf'],'-dpdf');
% close(6);
% 
% fig7=figure(7);
% plot(tout,out.fslip);
% title('Front Axle Slip vs. Time');
% xlabel('Time [s]');
% ylabel('Front Axle Tire Slip');
% grid on
% print(fig7,[writepath filesep() 'Front_slip_ratio_vs_time.pdf'],'-dpdf');
% close(7);
% 
% fig8=figure(8);
% plot(tout,out.ft);
% title('Drive Axle Longitudinal Force vs. Time');
% xlabel('Time [s]');
% ylabel('Drive Axle Longitudinal Force [N]');
% grid on
% print(fig8,[writepath filesep() 'Drive_axle_longitudinal_force_vs_time.pdf'],'-dpdf');
% close(8);
% 
% fig9=figure(9);
% plot(tout,out.mu);
% title('Tire Coefficient vs. Time');
% xlabel('Time [s]');
% ylabel('Tire Coefficient');
% grid on
% print(fig9,[writepath filesep() 'Tire_friction_coefficient_vs_time.pdf'],'-dpdf');
% close(9);
% 
% fig20=figure(20);
% plot(tout,out.dyaw)
% title('Current - Desired Yaw Angle vs Time')
% xlabel('Time [s]')
% ylabel('Current and Desired Yaw Angle Difference [rads]')
% grid on
% print(fig20,[writepath filesep() 'Yaw_difference_vs_time.pdf'],'-dpdf')
% close(20);
% 
% fig21=figure(21);
% plot(tout,out.delta_in,tout,out.delta_out)
% title('Steer angles vs time')
% xlabel('Time [s]')
% ylabel('Steer angle (rad)')
% grid on
% legend('Inner wheel steer angle','Outer wheel steer angle','location','northwest')
% print(fig21,[writepath filesep() 'Steer_angles_vs_time.pdf'],'-dpdf')
% close(21);
% 
% fig22=figure(22);
% plot(tout,out.tq)
% title('Engine torque vs time')
% xlabel('Time [s]')
% ylabel('Engine Torque [Nm]')
% grid on
% print(fig22,[writepath filesep() 'Engine_torque_vs_time.pdf'],'-dpdf')
% close(22);
% 
% fig23=figure(23);
% plot(tout,out.tqfb,tout,out.tqrb)
% title('Front and rear axle braking torques')
% xlabel('Time [s]')
% ylabel('Braking torque [Nm]')
% grid on
% legend('Front axle','Rear axle')
% print(fig23,[writepath filesep() 'Braking_torques_vs_time.pdf'],'-dpdf')
% close(23);
% 
% fig24=figure(24);
% plot(tout,out.bff,tout,out.bfr)
% title('Front and rear axle braking forces')
% xlabel('Time [s]')
% ylabel('Braking force [N]')
% grid on
% legend('Front axle','Rear axle')
% print(fig24,[writepath filesep() 'Braking_forces_vs_time.pdf'],'-dpdf')
% close(24);
% 
% fig25=figure(25);
% plot(tout,out.raxle);
% title('Rear Axle Speed vs. Time');
% xlabel('Time [s]');
% ylabel('Rear Axle Speed [rad/s]');
% grid on
% print(fig25,[writepath filesep() 'Rear_axle_speed_vs_time.pdf'],'-dpdf');
% close(25);
% 
% fig26=figure(26);
% plot(tout,out.rslip);
% title('Rear Axle Slip vs. Time');
% xlabel('Time [s]');
% ylabel('Rear Axle Tire Slip');
% grid on
% print(fig26,[writepath filesep() 'Rear_slip_ratio_vs_time.pdf'],'-dpdf');
% close(26);
% 
% fig27=figure(27);
% plot(params.course(:,3),out.yaw1b)
% title('Desired yaw angle vs longitudinal distance')
% xlabel('Longitudinal distance (m)')
% ylabel('Desired yaw angle [rad]')
% grid on
% print(fig27,[writepath filesep() 'Desired_yaw_vs_distance.pdf'],'-dpdf')
% close(27);
% 
% fig28=figure(28);
% plot(params.course(:,3),params.course(:,4))
% title('Track curvature vs longitudinal distance')
% xlabel('Longitudinal distance [m]')
% ylabel('Curvature [1/m]')
% grid on
% print(fig28,[writepath filesep() 'Track_radius_vs_distance.pdf'],'-dpdf')
% close(28);
% 
% fig29=figure(29);
% plot(tout,out.f)
% title('Sum of longitudinal forces vs time')
% xlabel('Time [s]')
% ylabel('Sum of longitudinal forces [N]')
% grid on
% print(fig29,[writepath filesep() 'Sum_longitudinal_forces_vs_time.pdf'],'-dpdf')
% close(29)
% 
% 
% % compute Oberkampf-Trucano error metric for deviation from the track
% X_int=interp1(out.dist,out.X,params.course(:,3),'linear','extrap');
% Y_int=interp1(out.dist,out.Y,params.course(:,3),'linear','extrap');
% for i=1:length(params.course)
%     if params.course(i,1)==0
%         params.course(i,1)=0.00001;
%     end
%     if params.course(i,2)==0
%         params.course(i,2)=0.00001;
%     end
% end
% OT_metric=1-1/2/length(params.course(:,3))*sum(tanh(abs((X_int-params.course(:,1))./params.course(:,1))))-1/2/length(params.course(:,3))*sum(tanh(abs((Y_int-params.course(:,2))./params.course(:,2))));
% disp('Oberkampf-Trucano error metric for global positions over time vs. the track. A value of 1 indicates the vehicle passed through all locations on the track with zero error. ');
% OT_metric
% filename_OT_metric_string=[writepath filesep() num2str(params.std_id_number) '_OT_metric.csv'];
% dlmwrite(filename_OT_metric_string,[params.std_id_number OT_metric]);
% 
% out.tf=0;
% out.tf=interp1(xout(:,1),tout,2235,'spline','extrap');
% disp(['Lap time [s]:' num2str(out.tf)]);
% filename_time_string=[writepath filesep() num2str(params.std_id_number) '_lap_time.csv'];
% dlmwrite(filename_time_string,[params.std_id_number out.tf]);
% 
% 
% end %% Leave
