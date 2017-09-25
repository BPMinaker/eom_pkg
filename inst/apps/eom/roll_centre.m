function [centre,axis]=roll_centre(vect,bodys)
%% Copyright (C) 2012, Bruce Minaker
%% This file is intended for use with Octave.
%% roll_centre.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% roll_centre.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% This function calculates the location of the roll centre given an eigenvector

[nr,nc]=size(vect);
centre=zeros(nr/2,nc);
axis=zeros(nr/2,nc);

for i=1:nc  %% For each vector
	for j=1:nr/6  %% For each body
	
		trans=vect(6*j+(-5:-3),i);
		rots=vect(6*j+(-2:0),i);
		phi=angle(max([trans;rots]));

		trans=trans*exp(sqrt(-1)*-phi);  %% Remove unnecessary imag parts
		rots=rots*exp(sqrt(-1)*-phi);
		
		rad=pinv(skew(rots))*trans; %% Radius to the instantaneous center of rotation of the body (rad=omega\v)
		centre(3*j+(-2:0),i)=1e-5*round((bodys(j).location-rad)*1e5);

		axis(3*j+(-2:0),i)=rots/(norm(rots)+eps);
		axis=1e-5*round(axis/1e-5);  %% Round off to allow checks

	end
end

end  %% Leave


%		if(norm(imag(rad(:,j)))>1e-4)
%			flag=1;
%		end
%		rad(:,j)=real(rad(:,j));  %% This should be a real anyway, but drop the complex parts

%		if(norm(real(rots))>1e-4)  % Draw the instant axis of rotation (in phase)
%			w=real(rots);
%		end
%		if(norm(imag(rots))>1e-4)  % Draw the instant axis of rotation (out of phase)
%			w=imag(rots);
%		end
	
%		if(flag)
%			disp('Warning: discarding imaginary centre of rotation - likely pure translation.');
%		end

