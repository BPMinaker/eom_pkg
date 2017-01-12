function out=sensors(syst,verb)
%% Copyright (C) 2009, Bruce Minaker, Rob Rieveley
%% This file is intended for use with Octave.
%% sensors.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% sensors.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% Generates the Jacobian output matrix for the sensors
if(verb); disp('Building output matrix...'); end

nin=syst.data.nactuators;
nout=syst.data.nsensors;

d_mtx=zeros(nout,nin);

if(nout>0) 
	gain=[syst.data.sensors.gain];  %% Get vector of gains for deflection sensors
	sensor_mtx=-diag(gain)*point_line_jacobian(syst.data.sensors,syst.data.nbodys);

	order=[syst.data.sensors.order];  %% Get the vector of orders
	frame=[syst.data.sensors.frame];  %% Get the vector of frames of reference

	column=2*order+frame-2;  %% Global psn,vel,acc=1,3,5, local vel,acc=2,4 

  	for j=1:nout 
		if(syst.data.sensors(j).actuator_number>0)
			d_mtx(j,syst.data.sensors(j).actuator_number)=-syst.data.sensors(j).gain;
		end
  	end
else % no sensors, make set of zero

	sensor_mtx=[];
	column=0;
end

% Define the output

out.sensor_mtx=sensor_mtx;
out.d_mtx=d_mtx;
out.column=column;

end %% Leave


% old code





%	max_col=max(column);
%	cols=2*round(max_col/2);  %% Columns must come by twos, either 2,4, or 6

%  	sc_mtx=zeros(syst.data.nout,cols*syst.data.dimension+cols/2*syst.data.nin);  %%  To distribute the g_matrix as appropriate
%  	sd_mtx=zeros(syst.data.nout,cols*syst.data.dimension+cols/2*syst.data.nin);
%  
%  		st=1+(column(j)-1)*syst.data.dimension+(round(column(j)/2)-1)*syst.data.nin;
%  		nd=st+syst.data.dimension-1;
%  		
%  		sc_mtx(j,st:nd)=g_mtx(j,:);
%  		if(column(j)>2)
%  			sd_mtx(j,st:nd)=g_mtx(j,:);
%  		end
%  		

%	cols=2;
%  	sc_mtx=zeros(0,2*syst.data.dimension+syst.data.nin);
%  	sd_mtx=zeros(0,2*syst.data.dimension+syst.data.nin);

%out.cols=cols;
%  out.s_mtx=sc_mtx;
%  out.d_mtx=sd_mtx;





%  	sc_mtx=zeros(syst.data.nout,cols*syst.data.dimension);  %%  To distribute the g_matrix as appropriate
%  	sd_mtx=zeros(syst.data.nout,cols*syst.data.dimension);

%	if(isfield(syst.data.sensors(j),'actuator_number'))  %% The user defined feed forward

%  	twist=[syst.data.sensors.twist];  %% Get the vector of twist or not
%  
%  	twst_ind=find(twist);
%  	strch_ind=find(~twist);
%  
%  	twst_g_mtx=-diag(gain(twst_ind))*line_twist_jacobian(syst.data.sensors(twst_ind),syst.data.nbodys);
%  	strch_g_mtx=-diag(gain(strch_ind))*line_stretch_jacobian(syst.data.sensors(strch_ind),syst.data.nbodys);
%  
%  	if(length(twst_ind)>0)
%  		g_mtx(twst_ind,:)=twst_g_mtx;
%  	end
%  	if(length(strch_ind)>0)
%  		g_mtx(strch_ind,:)=strch_g_mtx;
%  	end

%	blank=zeros(1,syst.data.dimension);

% 		tmp_sc_mtx=[];
% 		tmp_sd_mtx=[];
% 		for k=1:cols  %% 
% 			if(k==column(j)); % build the mask for the C matrix for motion sensor
% 				sc_elmnt=g_mtx(j,:);
% 				if(column(j)>2);
% 					sd_elmnt=g_mtx(j,:);
% 				else
% 					sd_elmnt=blank;
% 				end
% 			else
% 				sc_elmnt=blank;
% 				sd_elmnt=blank;
% 			end
% 			tmp_sc_mtx=[tmp_sc_mtx sc_elmnt]; % current sensor state vector
% 			tmp_sd_mtx=[tmp_sd_mtx sd_elmnt]; % current sensor input vector
% 		end


%		sc_mtx=[sc_mtx;tmp_sc_mtx];
%		sd_mtx=[sd_mtx;tmp_sd_mtx];

