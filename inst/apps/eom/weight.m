function item=weight(body,varargin)
%% Copyright (C) 2013, Bruce Minaker
%% This file is intended for use with Octave.
%% weight.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% weight.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

g=[0;0;-9.81];

if(nargin()==2)
	if(isscalar(varargin{1}))
		g=varargin{1}*[0;0;-1];
	elseif(isvector(varargin{1}))
		g=varargin{1};
	end
end

%% describe
if(strcmp(body.type,'body'))

	item.name=[body.name ' weight'];
	item.type='load';
	item.body=body.name;
	item.force=body.mass*g;
	item.moment=[0;0;0];
	item.location=body.location;

	if(isfield(body,'group'))
		item.group=body.group;
	end

end




end  %% Leave
