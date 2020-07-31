function item=weight(in,varargin)
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

g=9.81;

if(nargin()==2)
    if(isnumeric(varargin{1}));
        g=varargin{1};
    end
end

err=0;
if(~isa(in,'body'))
    if(isfield(in,'type'))
        if(~strcmp(in.type,'body'))
            err=1;
            disp('Input struct is not body.');
        end
    else
        disp('No type field.');
        err=1;    
    end
end

if(err)
    error('%s\n','Finding weight, but no body!')
end
item=app_load([in.name 'weight']);
item.body{1}=in.name;
item.force=[0;0;-g*in.mass];
item.moment=[0;0;0];
item.location=in.location;
if(isfield(in,'group'))
	item.group=in.group;
end    

end  %% Leave