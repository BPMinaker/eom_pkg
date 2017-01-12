function [tout,xout,yout]=ud_longls(writepath)

global params;


% max driver side front wheel steer angle, if student tries to set an unreasonably high
% value
% if(params.delta_in_max>60*pi/180)
% 	params.delta_in_max=60*pi/180;
% end

% backup longitudinal preview time
%params.t_long2=params.t_long;

disp('Computing shift speeds...');

if(strcmp(params.drive,'RearWheelDrive'))
%	params.drv_load=9.81*params.mass*(1-params.fwf);
	params.wtf=1;
elseif(strcmp(params.drive,'FrontWheelDrive'))
%	params.drv_load=9.81*params.mass*params.fwf;
	params.wtf=-1;
else
%	params.drv_load=9.81*params.mass; % find tire limit force
	params.wtf=0;
end

params.launchrpm=0.5*params.redline;

if(length(params.e)==5)
	params.eff=0.95;
else
	params.eff=0.90;
end

params.vmax=0.95*(params.redline*2*pi()/60*(params.rad)/params.ex)./params.e; %find redline speeds

format short;
disp('Speeds in each gear at redline (5% slip) [kph]:');
disp(params.vmax*3.6);
disp('Speeds range of each gear [kph]:');
disp(diff(params.vmax*3.6));

for i=1:(length(params.e)-1)
	at_bs=params.torque(end)*params.e(i); % axle torque before shift at redline
	at_as=interp1(params.revs,params.torque,params.revs(end)*params.e(i+1)/params.e(i))*params.e(i+1); % axle torque after shift at new engine speed
	if(at_as>at_bs)
		disp ('Short shift needed.  Calculating shift speed...'); % change shift speed
		dat=@(ws) interp1(params.revs,params.torque,ws,'spline')*params.e(i)-interp1(params.revs,params.torque,ws*params.e(i+1)/params.e(i),'spline')*params.e(i+1);
		shift_rpm=fzero(dat,params.revs(end-1));
		params.vmax(i)=0.95*shift_rpm*2*pi()/60*(params.rad)/params.ex/params.e(i);
		
	end
end

disp('Shift speeds for maximum acceleration [kph]:');
disp(params.vmax*3.6);
disp('Speeds range of each gear [kph]:');
disp(diff(params.vmax*3.6));
format long;

ww=linspace(params.revs(1),params.revs(end-1),100);
for i=1:100
	w=ww(i);
	tq=interp1(params.revs,params.torque,w);
	for j=1:(length(params.e))
		fts(i,j)=tq*params.e(j)*params.ex/params.rad*params.eff;
		vs(i,j)=3.6*0.95*w*2*pi()/60*params.rad/params.e(j)/params.ex;
	end
end

figure;
plot(vs,fts);
title('Steady State Traction Force vs. Speed');
xlabel('Speed [kph]');
ylabel('Traction Force [N]');
grid on
print([writepath filesep() 'ftvv.pdf'],'-dpdf');
close;

%tire properties
slip=linspace(-1,1,200); % converted to % in tire_long.m
sideslip=pi/180*linspace(-12,12,200);
% longitudinal

Fx2000=tire_long(slip,2000);
Fx4000=tire_long(slip,4000);
Fx6000=tire_long(slip,6000);

figure;
plot(slip,Fx2000,slip,Fx4000,slip,Fx6000);
title('Longitudinal tire force vs. slip');
xlabel('Slip');
ylabel('Longitudinal force (N)');
grid on;
legend('10% of vehicle weight','20%','30%','location','northwest');
print([writepath filesep() 'Magic_tire_longitudinal_force_vs_slip_ratio.pdf'],'-dpdf');
close;

% lateral
camber=0;
Fy2000=tire_lat(sideslip,2000,camber);
Fy4000=tire_lat(sideslip,4000,camber);
Fy6000=tire_lat(sideslip,6000,camber);


figure;
plot(sideslip,Fy2000,sideslip,Fy4000,sideslip,Fy6000);
title('Lateral tire force vs. sideslip');
xlabel('Sideslip (rad)');
ylabel('Lateral force (N)');
grid on;
legend('10% of vehicle weight','20%','30%','location','northeast');
print([writepath filesep() 'Magic_tire_lateral_force_vs_sideslip_angle.pdf'],'-dpdf');
close;

% % restoring moment
% camber=0;
% Mz10=tire_rest_moment(sideslip,N10,camber);
% Mz20=tire_rest_moment(sideslip,N20,camber);
% Mz30=tire_rest_moment(sideslip,N30,camber);
% 
% figure;
% plot(sideslip,Mz10,sideslip,Mz20,sideslip,Mz30);
% title('Tire restoring moment vs. sideslip');
% xlabel('Sideslip (rad)');
% ylabel('Tire restoring moment (Nm)');
% grid on;
% legend('10% of vehicle weight','20%','30%','location','northeast');
% print([writepath filesep() 'Magic_tire_restoring_moment_vs_sideslip_angle.pdf'],'-dpdf');
% close;



string_simulating_msg=['Gathered data. Simulating ' num2str(params.std_id_number)];
disp(string_simulating_msg);

%  x0=zeros(19,1);
%  x0(5)=pi; % vehicle travels around the track clockwise
%  % start/finish line is vertical (track at this location is a straightaway in the global X
%  % direction)

xout_i=build_model()';  % get IC as row, because we transpose back to column it later
flag_out=0;
n=25; % number of intervals
ti=5; % interval length
ts=0.1; % output step
xout=zeros(n*ti/ts+1,length(xout_i)); % preallocate
tout=zeros(n*ti/ts+1,1);

for i=1:n;
	t=(i-1)*ti:ts:i*ti; % set time interval
	x0=xout_i(end,:)';
	try
		[tout_i,xout_i]=ode45(@(t,x) eqn_of_motion(t,x,flag_out),t,x0); % ,vopt); % simulate, please
		xout(ti/ts*(i-1)+1:ti/ts*i+1,:)=xout_i;
		tout(ti/ts*(i-1)+1:ti/ts*i+1)=tout_i;
	catch
		warning('Integration failed.  Stopping...');
		break;
	end
	disp(['t=' num2str(tout_i(end))]);
end

flag_out=1;
yout=zeros(n*ti/ts+1,size(xout,2)+32);
for i=1:length(tout)
	yout(i,:)=eqn_of_motion(tout(i), xout(i,:)',flag_out)';
end

end  %% Leave





solver


%  tf=3*145;
%  
%  %z0=[-161.88;-137.05;0;sqrt(0.5);0;0;sqrt(0.5) ;vfi; 1495 ;0;z0];
%  
%  if(exist('OCTAVE_VERSION','builtin'))
%      tspan=[0 tf];
%      solver=@ode54;
%  else
%      tspan=0:tf/600:tf; % set the simulation interval
%      solver=@ode45;
%  end
%  
%  vopt=odeset('RelTol',1e-5,'AbsTol',1e-5,'InitialStep',1e-5);
%  handle=@(t,z) eqn_of_motion(t,z,0);
%  [t,z]=solver(handle,tspan,z0,vopt);  % simulate
%  
%  if(exist('OCTAVE_VERSION','builtin'))
%      z=interp1(t,z,[0:tf/300:tf]','pchip');
%  	t=[0:tf/300:tf]';
%  end






% use for loops to extract additional data
% for i=1:length(tout)
%     if out.delta_in(i)>params.delta_in_max
%         out.delta_in(i)=params.delta_in_max;
%     elseif out.delta_in(i)<-params.delta_in_max
%         out.delta_in(i)=-params.delta_in_max;
%     end
%     if out.delta_in(i)>=0
%         out.delta_out(i)=fzero(@(delta_out2) delta_out_f(delta_out2,out.delta_in(i),params.gamma,params.L1,params.L2),out.delta_in(i));
%     else
%         out.delta_out(i)=-fzero(@(delta_out2) delta_out_f(delta_out2,abs(out.delta_in(i)),params.gamma,params.L1,params.L2),abs(out.delta_in(i)));
%     end
% end


%figure(101)
%plot(params.course(:,6));


%hold off;
%error('dffsf');


% for i=1:length(params.course)
% %    if params.course(i,4)>1/params.rho_limit % if this is a corner, compute speed using max lat acceleration
% 
% 	if(params.course(i,6)>params.maxv)  % straightaway, use maximum vehicle speed, not really used
% 		params.course(i,6)=params.maxv;
% 	end
% end

% br_idx=0;
% while(~isempty(br_idx))
% %%% Divide by 5 because that's the ds.  Make this better!!!
% params.course(:,7)= [diff(params.course(:,6))/5;0];
% 
% % v * dv/ds = a
% params.course(:,8)=params.course(:,6).*params.course(:,7);
% 
% %%% using 8 m/s/s but maybe make this input dependant
% br_idx=find(params.course(:,8)<-8); 
% 
% params.course(br_idx,6)=  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
% end



%for i=1:length(params.course)
% 	params.course(i,6)=sqrt(params.acc_lat_max*params.g/params.course(i,4));
% 	if(params.course(i,6)>params.maxv)  % straightaway, use maximum vehicle speed, not really used
% 		params.course(i,6)=params.maxv;
% 	end
%   params.course(:,7)= [diff(params.course(:,6))/5;0];
%   params.course(:,8)=params.course(:,6).*params.course(:,7);
% end

% br_idx=find(params.course(:,8)<-8); 
% params.course(br_idx,6)=((params.course(br_idx-1,6))^2+4 )/(params.course(br_idx-1,6);










