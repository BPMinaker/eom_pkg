function in=find_bodynum(in,names,verb) %% Takes the key, i.e. springs and returns the key with new entries telling the attached body numbers -> reads the bodys which the items are attached to, and inserts the corresponding body numbers in .body1num and .body2num
%% Copyright (C) 2007, Bruce Minaker
%% This file is intended for use with Octave.
%% find_bodynum.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% find_bodynum.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% Find the body numbers of each connecting item
if(verb); disp('Looking for connection info...'); end

for i=1:length(in)  %% For each item (for each 'structure' (individual spring) in the array called 'springs' or 'actuators', etc.)
	[match,idx]=ismember(in(i).body,names);
	if(sum(match)<length(match))
		error('Found item "%s" that is not attached to a body.\n',in(i).name);
	end
	in(i).body_number=idx';

	if(isfield(in(i),'frame'))  %% If in(i) is a structure, and in(i).frame exists, and frame is a string
		if(ischar(in(i).frame))
			[match,idx]=ismember(in(i).frame,names);
			if(sum(match)<length(match))
				error('Found item "%s" with unknown reference frame.\n',in(i).name);
			end
			in(i).frame_number=idx';
		end
	end
end

end  %% Leave



%  	for j=1:length(in(i).body)  %% For each body that item is attached to
%  		k=1;
%  		while(k<=length(names))
%  			if(strcmp(in(i).body{j},names{k})) %% Stringcompare each connected body to current body
%  				in(i).body_number(j,1)=k;
%  				break;
%  			else
%  				k=k+1;
%  			end
%  		end
%  		if(k>length(names))
%  			error('Found item "%s" that is not attached to a body.\n',in(i).name);
%  		end
%  	end

%  		if(ischar(in(i).frame))
%  			j=1;
%  			while(j<=length(names))
%  				if(strcmp(in(i).frame,names{j})) %% If in(i).frame is name of the current body
%  					in(i).frame_number=j;
%  					break;
%  				else
%  					j=j+1;
%  				end
%  			end
%  			if(j>length(names))
%  				error('Found item "%s" that is not attached to a body.\n',in(i).name);
%  			end
%  		end
