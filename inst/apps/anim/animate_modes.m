function animate_modes(config,result)
%% Copyright (C) 2004, Bruce Minaker
%% This file is intended for use with Octave.
%% animate_modes.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% animate_modes.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% This function computes the time history of the system from the mode vector, and passes it to the animator

lcns=[result{1}.data.bodys(1:end-1).location];

tout=[0:1/200:1];  %%  n point interpolation

modes=result{1}.eom.modes;
modes=1e-5*round(modes*1e5); %% Round off
val=1e-5*round(result{1}.math.val*1e5);

for i=1:size(modes,2)  %% For each mode
	modes(:,i)=modes(:,i)/2;  %% Scale motions back to reasonable size

%  	if(norm(modes(:,i))>0)  %% Check for non-zero displacement modes
%  	%	[j,k]=max(abs(modes(:,i)));  %% Find the dominant motion
%  	%	modes(:,i)=modes(:,i)*exp(-sqrt(-1)*angle(modes(k,i)));  %% Rotate the phase angle to the dominant motion
%  		if(max(modes(:,i))>0)
%  			modes(:,i)=modes(:,i)/(max(modes(:,i)))/2;  %% Scale motions back to reasonable size
%  		end
%  	end
	if(isfinite(val(i)))
		if(abs(imag(val(i)))>1e-3)  %% If the undamped oscillatory
			tau=abs(pi/imag(val(i)));  %% Find the time constant such that two constants gives one cycle
		elseif(abs(real(val(i)))>1e-3 )  %% If the system is damped
			tau=abs(1/real(val(i)));  %% Find the time constant (abs in case of unstable)
		else
			tau=1/pi;  %% Rigid body mode
		end
	
		pout=real(modes(:,i)*exp(val(i)*2*tout*tau));  %% Find the time history for two time constants

		for j=1:size(lcns,2)  %% For each body
			pout(6*j-5:6*j-3,:)=pout(6*j-5:6*j-3,:)+lcns(:,j)*ones(1,size(pout,2));  %% Add the static location to the displacement
		end

		pout=item_locations(result,pout);  %% Compute locations of the connecting items
		pout=pout';
		vrml_animate(result,tout,pout,[config.dir.output filesep() 'vrml' filesep() 'mode_' num2str(i,'%03i')]);
	end
end

end  %% Leave


%% *** MODIFIED TO DRAW GROUND PLANE AT -152.6mm FOR VEHICLE MODEL ***
%%st=[st vrml_surf([0;4],[-1.5,1.5],[-.1526 -.1526;-.1526 -.1526])];


