eqns=run_eom('input_ex_smd','quiet');
tspan=(0:0.025:10);
u=10*sin(tspan)';
[y,t]=lsim(eqns,u,tspan);
figure(1)
plot(t,[y,u]);

% eqns=run_eom('input_ex_yaw_plane',20,'quiet');
% u=0.1*sin(2*2*pi*tspan)';
% [y,t]=lsim(eqns,u,tspan);
% figure(2)
% plot(t,[y,u]);
% 
% eqns=run_eom('input_ex_freqdamp','quiet');
% [y,t]=lsim(eqns,u,tspan);
% figure(3)
% plot(t,[y,u]);


%  my_sys=run_eom('input_ex_yaw_plane',20,item,'quiet') %% Yaw plane model
%  
%  t=0:0.1:15;
%  u=zeros(size(t));
%  
%  for i=1:length(t)
%  	if(t(i)<2)
%  		u(i)=0;
%  	elseif(t(i)<2.5)
%  		u(i)=(-0.75*cos(2*pi*(t(i)-2))+0.75);
%  	elseif(t(i)<4.5)
%  		u(i)=1.5;
%  	end
%  end
%  u=u*pi/180;
%  
%  lsim(my_sys,u,t)
