function out=sort_system(the_system,varargin)
%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% sort_system.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% sort_system.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% Sort the system into a new structure

verb=0;
out=[];
if(nargin>1)
	if(strcmp(varargin{1},'verbose'))
		if(nargin>2)
			verb=varargin{2};
		else
			verb=1;
		end
	end
end
if(verb); disp('Sorting system...'); end 

%% First, ground is added to the system, becaue it is not in the user-defined system
%ground.name='ground';
the_system.item{end+1}=body('ground'); %% Ground body is added last (important!)

%default=items();  %% Get a list of all the default items
%item_types=fieldnames(default);

item_types={'body','link','spring','flex_point','rigid_point','actuator','sensor','beam','load','app_load','marker','nh_point','tire','triangle_3','triangle_5','wing'};

for i=1:length(the_system.item) %% Loop over items in system
	the_item=the_system.item{i};  %% Copy the item
	if(isstruct(the_item))
		if(~isfield(the_item,'type'))  %% Make sure the item type is defined
			error('%s\n','Found an item with no type defined in the input file!');
		elseif(~sum(strcmp(the_item.type,item_types)))
			error('%s\n','Found an item of unrecognized type in the input file!\n');
		else  %% The type is defined and recognized
			if(strcmp(the_item.type,'load'))
				the_item.type='app_load';
			end
			type=str2func(the_item.type);  %% Get the constructor function handle
%			the_item
			the_item=copy_parms(feval(type,the_item.name),the_item);  %% Call the constructor, copy the fields over from the struct to the obj, and overwrite the struct with an object
%			the_item
		end
	end

	if(isobject(the_item))  %% If the item is an object
		type=class(the_item);  %% Find the item type
%		props=properties(the_item);  %% Get the properties (broken in Octave)
		props=fieldnames(the_item);
		numprops=length(props);  %% Count the number of properties

		if(~sum(strcmp(type,item_types)))  %% If there are zero matches with list above
			disp(['Found a ' type]);
			error('%s\n','Found an item of unrecognized type in the input file!\n');
		else  %% The type is recognized
			for j=1:numprops  %% For each property
				if(ischar(the_item.(props{j})))  %% If the property is a character string
					the_item.(props{j})=strtrim(the_item.(props{j}));  %% Trim the spaces
				end
			end
			if(~isfield(out,[type 's']))  %% If there is no list of that type of item, create one
				out.([type 's'])=the_item;  %% Add a new default item of the same type to the array of items of that type
			else
				out.([type 's'])(end+1)=the_item;  %% Or use an existing list, and add to the end
			end
		end
	end
end

for i=1:length(item_types)  %% For each defined item types
	if(~isfield(out,[item_types{i} 's']))  %% If the item type is not present, create an empty one
		out.([item_types{i} 's'])=[];
	end
end

out_types=fieldnames(out);
for i=1:length(out_types)  %% For each item type
	out.(['n' out_types{i}])=length(out.(out_types{i}));  %% Set the number of the type present
end

nonbody_types=setdiff(out_types,{'bodys'});  %% Get list of all types except bodys
for i=1:length(nonbody_types)  %% For each item type
	if(out.(['n' nonbody_types{i}])>0)  %% If there is at least one item of that type
		out.(nonbody_types{i})=find_bodynum(out.(nonbody_types{i}),{out.bodys.name});  %% Call the function to find the body numbers of the bodys attached to the item
		out.(nonbody_types{i})=find_radius(out.(nonbody_types{i}),[out.bodys.location]);  %% Call the function to find the radius to the mass centre of the various connections
%		out.(out_types{i})=item_init(out.(out_types{i}));  %% Call the function to initialize the various items
	end
%    class(out.(out_types{i}))
end

for i=1:out.nsensors  %% For each item (for each sensor in the list)
	[~,out.sensors(i).actuator_number]=ismember(out.sensors(i).actuator,{out.actuators.name});
end



%class(the_system.item)
out.nitems=length(the_system.item);

if(verb); disp('System sorted.'); end
end  %% Leave

