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

%% First, ground is added to the system, because it is not in the user-defined system
ground.type='body';
ground.name='ground';
ground.group='body';
ground.location=[0;0;0];
ground.mass=0;
ground.momentsofinertia=[0;0;0];
ground.productsofinertia=[0;0;0];
ground.velocity=[0;0;0];
ground.angular_velocity=[0;0;0];
the_system.item{end+1}=ground; %% Ground body is added last (important!)

default=items();  %% Get a list of all the default items
item_types=fieldnames(default);

deprecated={'location1','location2','location3','body','body1','body2','body3','actuator'};  %% List of deprecated fields
replacement={'location','location','location','body','body','body','body','actuator'};  %% New fieldnames to replace them with
ind=[1 2 3 1 1 2 3 1];  %% The index where they now should be stored


for i=1:length(the_system.item) %% Loop over items in system

	if(isstruct(the_system.item{i}))  %% If the item is a structured variable
		fields=fieldnames(the_system.item{i});  %% Get the attributes
		numfields=length(fields);  %% And the number of attributes
		for j=1:numfields  %% For each attribute
			if(ischar(the_system.item{i}.(fields{j})))  %% If the attribute is a character string
				the_system.item{i}.(fields{j})=strtrim(the_system.item{i}.(fields{j}));  %% Trim the spaces
			end
		end

		if(~isfield(the_system.item{i},'type'))  % Make sure the item type is defined
			error(['Found an item (' the_system.item{i}.name ') with no type defined in the input file!']);
		elseif(~isfield(default,the_system.item{i}.type))  %% Make sure the type is recognized
			disp(the_system.item{i}.type)
			error('Found an item of unrecognized type in the input file!');
		else  %% The type is defined and recognized

			type=[the_system.item{i}.type]; %% Get the type of the each item, e.g. type='body'				
			if(~isfield(out,[type 's']))  %% If there is no list of that type of item, create one
				out.([type 's'])=default.(type);  %% Add a new default item of the same type to the array of items of that type
			else
				out.([type 's'])(end+1)=default.(type);  %% Or use an existing list, and add to the end
			end

			[deplist,depidx]=ismember(fields,deprecated);  %% Find which attributes are deprecated
			for j=1:numfields  %% For each attribute
				deprec=deplist(j);
				idx=depidx(j);
				if(isfield(default.(type),fields{j}) && ~deprec)   %% If the default item has this type of attribute and its viable
					out.([type 's'])(end).(fields{j})=the_system.item{i}.(fields{j});  %% Copy the attribute to the new item
				elseif(deprec)  %% If the attribute is deprecated
					switch class(the_system.item{i}.(fields{j}))  %% Check what type of data was stored in the field
						case 'double'  %% For doubles, use a matrix
							out.([type 's'])(end).(replacement{idx})(:,ind(idx))=the_system.item{i}.(fields{j});  %% Copy into replacement attribute
						case 'char'  %% For characters, use a cell
							out.([type 's'])(end).(replacement{idx}){ind(idx)}=the_system.item{i}.(fields{j});
						otherwise
							error('Invalid argument type.');  %% Don't know what to do
					end
				elseif(~sum(strcmp([deprecated 'type'],fields{j})))  %% If the default item does not have this attribute, and it is not deprecated  -- not sure this is working as expected
					disp(['Warning: "' the_system.item{i}.name '" has an unexpected attribute "' fields{j} '"!']);
					disp('Ignoring attribute and attempting to continue...');
				end
			end
		end
	end
end

for i=1:length(item_types)  %% For each defined item types
	if(~isfield(out,[item_types{i} 's']))  %% If the item type is not present, create an empty one
		out.([item_types{i} 's'])=[];
	end
end

out_types=fieldnames(out);  %% Get the list of all types
for i=1:length(out_types)  %% For each item type
	out.(['n' out_types{i}])=length(out.(out_types{i}));  %% Set the number of the type present
end

nonbody_types=setdiff(out_types,{'bodys'});  %% Get list of all types except bodys
for i=1:length(nonbody_types)  %% For each item type
	if(out.(['n' nonbody_types{i}])>0)  %% If there is at least one item of that type
		out.(nonbody_types{i})=find_bodynum(out.(nonbody_types{i}),{out.bodys.name},verb);  %% Call the function to find the body numbers of the bodys attached to the item
		out.(nonbody_types{i})=find_radius(out.(nonbody_types{i}),[out.bodys.location]);  %% Call the function to find the radius to the mass centre of the various connections
		out.(nonbody_types{i})=item_init(out.(nonbody_types{i}),nonbody_types{i});  %% Call the function to initialize the various items
	end
end

for i=1:out.nsensors  %% For each item (for each sensor in the list)
	[~,out.sensors(i).actuator_number]=ismember(out.sensors(i).actuator,{out.actuators.name});
end

out.nitems=length(the_system.item);

if(verb); disp('System sorted.'); end
end  %% Leave




%% old code

%%	if(~strcmp(out_types{i},'bodys') && ~isempty(out.(out_types{i})))  %% If it's not the list of bodys, and there more than zero items

%%				odf=strcmp(deprecated,fields{j})  %% Check against list of deprecated attributes
%%				deprec=sum(odf)  %% Find if attribute matched any 
%%				idx=find(odf)  %% Find which one

%out.sensors=find_actuatornum(out.sensors,{out.actuators.name},verb);  %% why not this ???????

%	if(strcmp(out_types{i},'sensors') && ~isempty(out.(out_types{i})))  %% If it's the list of sensors, and there more than zero items
%		out.(out_types{i})=find_actuatornum(out.(out_types{i}),{out.actuators.name},verb);  %% Call the function to find the actuator number attached to the item
%	end

%for i=1:length(item_types)  %% For each defined item types
%	%% Create a structure array using the default item; order the fields first for matlab
%	out.([item_types{i} 's'])(1)=orderfields(default.(item_types{i}));
%	%% Now erase the default item, leaving a 1x0 structure array with the correct default attributes defined
%	out.([item_types{i} 's'])(1)=[];
%end


% 		for j=1:length(deprecated)  %% For each deprecated field
% 			if(isfield(the_system.item{i},deprecated{j}))  %% If this field exists in this item
% 				temp=the_system.item{i}.(deprecated{j});  %% Save the value of the field
% 				the_system.item{i}=rmfield(the_system.item{i},deprecated{j});  %% Remove the field
%                 
% 				switch class(temp)  %% Check what type of data was stored in the field
% 
% 					case 'double'  %% For doubles, use a matrix
% 						the_system.item{i}.(replacement{j})(:,ind(j))=temp;  %% Replace it
% 
% 					case 'char'  %% For characters, use a cell
% 						the_system.item{i}.(replacement{j}){ind(j)}=temp;  %% Replace it
% 
% 					otherwise
% 					error('%s\n','Invalid argument type.');  %% Don't know what to do
% 				end
% 		
% 			end
% 		end



