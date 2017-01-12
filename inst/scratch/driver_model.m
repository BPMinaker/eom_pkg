function deltadot=driver_model(delta,path_error,heading_error,chass_vx);

if(abs(path_error(1))>5)
	disp('Off course!');
	%path_error=path_error*0;
	%heading_error=heading_error*0;
	%return
end

tau=0.1;  %% Driver time constant
k=[10 10 6 2 0.8 0.16 0.04 0.01]/15.5135;  %% Weights of preview points, normalized
k=k/4;  %%  Fixed gain
k=k*1.5/(chass_vx+0.5);  % yaw rate to steer ratio is a function of vx, so adjust gain
deltadot=(-delta+20*k*heading_error+k*path_error)/tau;  %% Driver model

end

