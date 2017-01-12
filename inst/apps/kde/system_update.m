function syst=system_update(syst,p)

% system_update.m
% 2009 R. Rieveley and B. Minaker
% GPL
% this function updates the locations of the bodys, and other items
% must add functionality for nhpoints
%---------------------------------------------------------------------------------------------------------------

len_r=6*(syst.data.nbodys-1);
len_p=6*(syst.data.nrigid_points+syst.data.nflex_points)+3*syst.data.nloads;
len_l=6*(syst.data.nlinks+syst.data.nsprings+syst.data.nbeams);

temp.solid=p(1:len_r); %% Pull locations from vector for each type of item
temp.point=p([1:len_p]+len_r);
temp.line=p([1:len_l]+len_p+len_r);

for i=1:syst.data.nbodys-1 %% For each body
	syst.data.bodys(i).location=temp.solid(6*i+[-5:-3]);  %% Set location
	syst.data.bodys(i).orientation=temp.solid(6*i+[-2:0]);  %% Set orientation (small angle)
end

item_types.point={'rigid_points','flex_points'};

for i=1:length(item_types.point)  %% For each item type
	nitems=['n' item_types.point{i}];  %% Form a string to find number of items
	items=syst.data.(item_types.point{i});
	for j=1:syst.data.(nitems)  %% For each item
		items(j).location=temp.point(6*j+[-5:-3]);  % Update the item locations using the state vector
		items(j).axis=temp.point(6*j+[-2:0]);  % Update the item locations using the state vector
	end
	items=find_radius(items,[syst.data.bodys.location]); % Update the item radii
	syst.data.(item_types.point{i})=items;
	temp.point=temp.point(syst.data.(nitems)*6+1:end);  %% Remove item data from vector
end

item_types.point={'loads'};

for i=1:length(item_types.point)  %% For each item type
	nitems=['n' item_types.point{i}];  %% Form a string to find number of items
	items=syst.data.(item_types.point{i});
	for j=1:syst.data.(nitems)  %% For each item
		items(j).location=temp.point(3*j+[-2:0]);  % Update the item locations using the state vector
	end
	items=find_radius(items,[syst.data.bodys.location]); % Update the item radii
	syst.data.(item_types.point{i})=items;
	temp.point=temp.point(syst.data.(nitems)*3+1:end);  %% Remove item data from vector
end

item_types.line={'links','springs','beams'};

for i=1:length(item_types.line)  %% For each item type
	nitems=['n' item_types.line{i}];  %% Form a string to find number of items
	items=syst.data.(item_types.line{i});
	for j=1:syst.data.(nitems)  %% For each item
		items(j).location(:,1)=temp.line(6*j+[-5:-3]); %% Update the link end locations with given state vector
		items(j).location(:,2)=temp.line(6*j+[-2:0]);
	end
	items=find_radius(items,[syst.data.bodys.location]); %% Update the link info
	syst.data.(item_types.line{i})=items;
	temp.line=temp.line((syst.data.(nitems))*6+1:end);  %% Remove item data from vec

end

