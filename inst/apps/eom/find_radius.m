function in=find_radius(in,cg_locations)  %% Takes the key, i.e. springs and returns the key with new entries telling the attachement radii
%% Copyright (C) 2007, Bruce Minaker
%% This file is intended for use with Octave.
%% find_radius.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% find_radius.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% Find the radius of each connection from the centre of mass

for i=1:length(in)

	%% Find the distance from each location to the associated body center
	%% note in(i).body_number may be a vector

	if(size(in(i).location,2)==size(in(i).body_number,1))  %% If number of locations equals number of body_numbers
		in(i).radius=in(i).location-cg_locations(:,in(i).body_number);
	else
		in(i).radius(:,1)=in(i).location-cg_locations(:,in(i).body_number(1));
		in(i).radius(:,2)=in(i).location-cg_locations(:,in(i).body_number(2));
	end

end

end %% Leave
