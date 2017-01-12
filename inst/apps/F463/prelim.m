function prelim(out)

global params;

disp('Computing shift speeds...');

if(strcmp(params.drive,'RearWheelDrive'))
	params.wtf=1;
elseif(strcmp(params.drive,'FrontWheelDrive'))
	params.wtf=-1;
else
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
	at_as=interp1(params.revs,params.torque,params.revs(end)*params.e(i+1)/params.e(i),'pchip',0)*params.e(i+1); % axle torque after shift at new engine speed
	if(at_as>at_bs)
		disp ('Short shift needed.  Calculating shift speed...'); % change shift speed
		dat=@(ws) interp1(params.revs,params.torque,ws,'pchip',0)*params.e(i)-interp1(params.revs,params.torque,ws*params.e(i+1)/params.e(i),'pchip',0)*params.e(i+1);
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
fts=zeros(100,length(params.e));
vs=zeros(100,length(params.e));

for i=1:100
	w=ww(i);
	tq=interp1(params.revs,params.torque,w,'pchip',0);
	for j=1:(length(params.e))
		fts(i,j)=tq*params.e(j)*params.ex/params.rad*params.eff;
		vs(i,j)=3.6*0.95*w*2*pi()/60*params.rad/params.e(j)/params.ex;
	end
end

figure
temp=[vs fts];
plot(vs,fts);
title('Steady State Traction Force vs Speed');
xlabel('Speed [kph]');
ylabel('Traction Force [N]');

%print([out filesep() 'Traction Force vs Speed.pdf'],'-dpdf');
filename=[out filesep() 'traction_speed.out'];
save(filename,'temp','-ascii','-double');


%tire properties
slip=linspace(-1,1,200)'; % converted to % in tire_long.m
sideslip=pi/180*linspace(-12,12,200)';
% longitudinal

Fx2000=tire_comb(slip,2000,0,0);
Fx4000=tire_comb(slip,4000,0,0);
Fx6000=tire_comb(slip,6000,0,0);

figure
temp=[slip Fx2000 Fx4000 Fx6000];
plot(temp(:,1),temp(:,2:4));
title('Longitudinal tire force vs slip');
xlabel('Slip');
ylabel('Longitudinal force (N)');
legend('Fz=2000 N ','Fz=4000 N','Fz=6000 N','location','northwest');
%print([out filesep() 'Magic Tire Longitudinal Force vs Slip Ratio.pdf'],'-dpdf');

filename=[out filesep() 'long_force_slip.out'];
save(filename,'temp','-ascii','-double');

% lateral
Fy2000=tire_comb(sideslip,2000,1,0);
Fy4000=tire_comb(sideslip,4000,1,0);
Fy6000=tire_comb(sideslip,6000,1,0);

figure
temp=[sideslip Fy2000 Fy4000 Fy6000];
plot(temp(:,1),temp(:,2:4));
title('Lateral tire force vs slip angle');
xlabel('Sideslip (rad)');
ylabel('Lateral force (N)');
legend('Fz=2000 N ','Fz=4000 N','Fz=6000 N','location','northwest');

%print([out filesep() 'Magic Tire Lateral Force vs Slip Angle.pdf'],'-dpdf');

filename=[out filesep() 'lateral_force_slip.out'];
save(filename,'temp','-ascii','-double');


% % comb
% Fy2000=tire_comb(sideslip,2000,0.7,0);
% Fy4000=tire_comb(sideslip,4000,0.7,0);
% Fy6000=tire_comb(sideslip,6000,0.7,0);
% 
% figure
% temp=[sideslip Fy2000 Fy4000 Fy6000];
% plot(temp(:,1),temp(:,2:4));
% title('Tire force vs slip');
% xlabel('Slip');
% ylabel('Force (N)');
% legend('Fz=2000 N ','Fz=4000 N','Fz=6000 N','location','northwest');
% 
% pause();


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
% print([out filesep() 'Magic_tire_restoring_moment_vs_sideslip_angle.pdf'],'-dpdf');
% close;


end

