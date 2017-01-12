function p_dot=d_state(syst,vel)

%% Copyright (C) 2017, Bruce Minaker, Rob Rieveley
%% This file is intended for use with Octave.
%% d_state.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% d_state.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%item_types.plane={'triangle_3','triangle_5'};

len_r=6*(syst.data.nbodys-1);
len_p=6*(syst.data.nrigid_points+syst.data.nflex_points)+3*syst.data.nloads;
len_l=6*(syst.data.nlinks+syst.data.nsprings+syst.data.nbeams);
p_dot=zeros(len_r+len_p+len_l,1);

p_dot(1:len_r,1)=vel; % velocities of the bodies

for j=1:syst.data.nbodys-1 %% For each free body
	syst.data.bodys(j).velocity=vel(6*j+[-5:-3]);  %% Find velocities
	syst.data.bodys(j).angular_velocity=vel(6*j+[-2:0]);  %% And angular velocities
end

count=len_r+1;
item_types.point={'rigid_points','flex_points'};

for i=1:length(item_types.point)  %% For each item type
	nitems=['n' item_types.point{i}];  %% Form a string to find number of items
	for j=1:syst.data.(nitems)  %% For each item
		body1=syst.data.bodys(syst.data.(item_types.point{i})(j).body_number(1));  %% Find the attached body (use body 1)
		
		p_dot(count:count+2)=body1.velocity+cross(body1.angular_velocity,syst.data.(item_types.point{i})(j).radius(:,1));  %% Find the velocity
		count=count+3;

		p_dot(count:count+2)=cross(body1.angular_velocity,syst.data.(item_types.point{i})(j).axis);    %% Find the unit vector change
		count=count+3;
	end
end


item_types.point={'loads'};

for i=1:length(item_types.point)  %% For each item type
	nitems=['n' item_types.point{i}];  %% Form a string to find number of items
	for j=1:syst.data.(nitems)  %% For each item
		body1=syst.data.bodys(syst.data.(item_types.point{i})(j).body_number(1));  %% Find the attached body (use body 1)
		
		p_dot(count:count+2)=body1.velocity+cross(body1.angular_velocity,syst.data.(item_types.point{i})(j).radius(:,1));  %% Find the velocity
		count=count+3;
	end
end


item_types.line={'links','springs','beams'};

for i=1:length(item_types.line)
	nitems=['n' item_types.line{i}];  %% Form a string to find number of items
	for j=1:syst.data.(nitems)
		body1=syst.data.bodys(syst.data.(item_types.line{i})(j).body_number(1));  %% FInd the attached bodys
		body2=syst.data.bodys(syst.data.(item_types.line{i})(j).body_number(2));

		p_dot(count:count+2)=body1.velocity+cross(body1.angular_velocity,syst.data.(item_types.line{i})(j).radius(:,1));  %% Find the velocity
		count=count+3;

		p_dot(count:count+2)=body2.velocity+cross(body2.angular_velocity,syst.data.(item_types.line{i})(j).radius(:,2));
		count=count+3;
	end
end


end  %% Leave
