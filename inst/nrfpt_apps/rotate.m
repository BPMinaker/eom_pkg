function mtx=rotate(gamma)
%% Copyright (C) 2003, Bruce Minaker
%% This file is intended for use with Octave.
%% rotate.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% rotate.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% This function forms the rotation transformation matrices for the vector orientation argument

	theta=norm(gamma);
	R=eye(3);
	T=eye(3);

	if(theta~=0)
		su=skew(gamma/theta)^2;
		R=R+sin(theta)*su+(1-cos(theta))*su2;
		T=T+0.5*skew(gamma)+(1-0.5*theta*cot(0.5*theta))*su2;
	end
	
	mtx=[R zeros(3);zeros(3) T];

end  %% Leave


%	R=expm(-skew(gamma));

%  	sum=0
%  	for i=1:20000
%  	sum=sum+1/((theta/2)^2-(i*pi)^2);
%  	end
%  	sum=-0.5*sum;



