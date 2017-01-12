function out=actuators(syst,verb)
%% Copyright (C) 2009, Bruce Minaker, Rob Rieveley
%% This file is intended for use with Octave.
%% actuators.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% actuators.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% Generate the Jacobian input matrix for the actuators
if(verb); disp('Building input matrix...'); end

nrows=syst.data.nactuators+syst.data.nsurfs;
ncols=6*(syst.data.nbodys-1);

if(nrows>0)

	f_mtx=zeros(nrows,ncols);
	g_mtx=zeros(nrows,ncols);
	
	if(syst.data.nactuators>0)
		temp=point_line_jacobian(syst.data.actuators,syst.data.nbodys);  %% Build input matrix
		f_mtx(1:syst.data.nactuators,:)=-diag([syst.data.actuators.gain])*temp;
		g_mtx(1:syst.data.nactuators,:)=-diag([syst.data.actuators.rategain])*temp;
	end

	for i=1:syst.data.nsurfs
		f_mtx(syst.data.nactuators+i,6*(syst.data.surfs(i).body_number-1)+1:6)=syst.data.surfs(i).qs*[syst.data.surfs(i).cx syst.data.surfs(i).cy syst.data.surfs(i).cz syst.data.surfs(i).cl*syst.data.surfs(i).span syst.data.surfs(i).cm*syst.data.surfs(i).chord syst.data.surfs(i).cn*syst.data.surfs(i).span];
	end

%  	if(syst.data.ntires>0)
%  		temp=point_line_jacobian(syst.data.tires,syst.data.nbodys);
%  		gain=zeros(1,3*syst.data.ntires)
%  		for i=1:syst.data.ntires
%  			gain(1,3*i+[-2:0])=[1 1 syst.data.ntires(i).stiffness];
%  		end
%  		f_mtx(syst.data.nactuators+syst.data.nsurfs+1:nrows,:)=-diag(gain)*temp;
%  	end

else
	f_mtx=zeros(1,syst.data.dimension);
	g_mtx=zeros(1,syst.data.dimension);

end

out.f_mtx=f_mtx';  %% Transpose
out.g_mtx=g_mtx';  %% Transpose

end

%% old code

%	twist=[syst.data.actuators.twist];  %% Get the vector of twist or not

%	twst_ind=find(twist);  %% Find the twist sensors
%	strch_ind=find(~twist);  %% and the stretch


	
	%% Get the appropriate Jacobians for each type, times gains
%  	twst_f_mtx=-diag(gain(twst_ind))*line_twist_jacobian(syst.data.actuators(twst_ind),syst.data.nbodys);
%  	strch_f_mtx=-diag(gain(strch_ind))*line_stretch_jacobian(syst.data.actuators(strch_ind),syst.data.nbodys);
%  
%  	if(~isempty(twst_ind))
%  		f_mtx(twst_ind,:)=twst_f_mtx;  %% Assemble the Jacobian
%  	end
%  	if(~isempty(strch_ind))
%  		f_mtx(strch_ind,:)=strch_f_mtx;
%  	end