function [positions,str]=init_p(syst)

% position_vector.m
% 2009 R. Rieveley
% 2010 B. Minaker
% GPL
% Build the positions vector using important components
%-------------------------------------------------------------------------------------------------------------------------

temp=[];
list={};

str='%%%%%% Location Data %%%%%%\n{Time} ';

% develop the position vector for the integration and system update
item_types.solid = {'bodys'};
for i=1:length(item_types.solid)
	nitems=['n' item_types.solid{i}];  %% Form a string to find number of items
	items=syst.data.(item_types.solid{i});
	for j=1:syst.data.(nitems)-1
		item=items(j);
		temp=[temp;item.location;item.orientation];
		str=[str  '{' item.name '_x} {'  item.name '_y} {' item.name '_z} {' item.name '_phi} {' item.name '_theta} {' item.name '_psi} '];
	end
	list{end+1}=item_types.solid{i};
end

% point items
item_types.point={'rigid_points','flex_points'};
for i=1:length(item_types.point)
	nitems=['n' item_types.point{i}];  %% Form a string to find number of items
	items=syst.data.(item_types.point{i});
	for j=1:syst.data.(nitems)
		item=items(j);
		temp=[temp;item.location;item.axis];
		str=[str  '{' item.name '_x} {'  item.name '_y} {' item.name '_z} '];
	end
	list{end+1}=item_types.point{i};
end

% point items
item_types.point={'loads'};
for i=1:length(item_types.point)
	nitems=['n' item_types.point{i}];  %% Form a string to find number of items
	items=syst.data.(item_types.point{i});
	for j=1:syst.data.(nitems)
		item=items(j);
		temp=[temp;item.location];
		str=[str  '{' item.name '_x} {'  item.name '_y} {' item.name '_z} '];
	end
	list{end+1}=item_types.point{i};
end

% line items
item_types.line = {'links','springs','beams'};
for i=1:length(item_types.line)
	nitems=['n' item_types.line{i}];  %% Form a string to find number of items
	items=syst.data.(item_types.line{i});
	for j=1:syst.data.(nitems)
		item=items(j);
		temp=[temp;item.location(:,1);item.location(:,2)];
		str=[str  '{' item.name '_x1} {'  item.name '_y1} {' item.name '_z1} {' item.name '_x2} {'  item.name '_y2} {' item.name '_z2} '];
	end
	list{end+1}=item_types.line{i};
end

str=[str '\n'];
positions=temp;

end %% Leave

