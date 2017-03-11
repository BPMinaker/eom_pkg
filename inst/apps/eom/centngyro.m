function [v_mtx,mv_mtx]=centngyro(in)
%% Copyright (C) 2003, Bruce Minaker
%% This file is intended for use with Octave.
%% centngyro.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% centngyro.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% For each mass the loop prepares the items of its part of the matrix

n=length(in)-1; %% Length of in is the number of bodies
v_mtx=zeros(6*n);  %% Set up initial empty matrix
mv_mtx=zeros(6*n);

for i=1:n  %% For each body coming in

	h=in(i).inertia*in(i).angular_velocity;
	
	if(norm(cross(in(i).angular_velocity,h))>1e-6)
		error('Body "%s" is not rotating about axis of symmetry.\n',in(i).name);
	end
	
	mv_mtx(6*i+(-2:0),6*i+(-2:0))=-skew(h);
	mv_mtx(6*i+(-5:-3),6*i+(-2:0))=-skew(in(i).velocity*in(i).mass);
	v_mtx(6*i+(-5:-3),6*i+(-2:0))=skew(in(i).velocity);

end

end  %% Leave


%  	[pd,pm]=eig(in(i).inertia);  %% Find the principal moments and directions
%  	pm=diag(pm);  %% Gather the moments into a vector
%  	diffpm=[abs(pm(2)-pm(3)); abs(pm(3)-pm(1));abs(pm(1)-pm(2))];  %% Find the differences between principal moments
%  	symtest=diffpm(1)*diffpm(2)*diffpm(3);  %% If two moments are the same, one diff should be zero, so the symtest should be zero 
%  	[~,j]=min(diffpm);  %% Find which two are the same
%  	%% If pm(1) and pm(2) are the same, the  body should rotate around pd(:,3), etc.
%  	%% Note that if all pm are the same, the j might be wrong!!
%  
%  	if(symtest>1e-4 && norm(in(i).angular_velocity)>1e-4)  %% If body is not symmetric and rotating
%  		error('Rotating body "%s" is not axisymmetric.\n',in(i).name);
%  	end
%  
%  	if(norm(cross(pd(:,j),in(i).angular_velocity))>1e-4 && norm(diffpm)>1e-4)  %% If body is rotating around non pd axis, and all pm are not same
%  		error('Body "%s" is not rotating about axis of symmetry.\n',in(i).name);
%  	end
%  
%  	%skew(in(i).angvel)*in(i).inertia-in(i).inertia*skew(in(i).angvel);  %% These should be equal for axisymmetric rotation
