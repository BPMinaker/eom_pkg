function the_system=mirror(the_system)

%% GPL here

for i=1:length(the_system.item)
	item=the_system.item{i};
	
	if(~isempty(strfind(item.name,'LF ')) || ~isempty(strfind(item.name,'LR ')));
		item.name=strrep(item.name,'LF','RF');
		item.name=strrep(item.name,'LR','RR');

		if(isfield(item,'body1'))
			item.body1=strrep(item.body1,'LF','RF');
			item.body1=strrep(item.body1,'LR','RR');
		end
		
		if(isfield(item,'body2'))
			item.body2=strrep(item.body2,'LF','RF');
			item.body2=strrep(item.body2,'LR','RR');
		end
		
		switch item.type
		
			case 'body'
		
				item.location(2)=-item.location(2);
				item.productsofinertia(1)=-item.productsofinertia(1);
				item.productsofinertia(2)=-item.productsofinertia(2);
				the_system.item{end+1}=item;
				
			case 'rigid_point'


				item.location(2)=-item.location(2);
				if(isfield(item,'axis'))
					item.axis(2)=-item.axis(2);
				end
				if(isfield(item,'rolling_axis'))
					item.rolling_axis(2)=-item.rolling_axis(2);
				end
				the_system.item{end+1}=item;
				
			case 'flex_point'

				item.location(2)=-item.location(2);
				if(isfield(item,'axis'))
					item.axis(2)=-item.axis(2);
				end
				if(isfield(item,'rolling_axis'))
					item.rolling_axis(2)=-item.rolling_axis(2);
				end
				the_system.item{end+1}=item;

			case 'link'
				
				item.location1(2)=-item.location1(2);
				item.location2(2)=-item.location2(2);
				the_system.item{end+1}=item;

			case 'spring'

				item.location1(2)=-item.location1(2);
				item.location2(2)=-item.location2(2);
				the_system.item{end+1}=item;

			case 'beam'
			
				item.location1(2)=-item.location1(2);
				item.location2(2)=-item.location2(2);
				the_system.item{end+1}=item;
			
			case 'load'

				item.body=strrep(item.body,'LF','RF');
				item.body=strrep(item.body,'LR','RR');
				item.location(2)=-item.location(2);
				item.force(2)=-item.force(2);
				item.moment(2)=-item.moment(2);
				the_system.item{end+1}=item;
				
			case 'sensor'
				
				item.location1(2)=-item.location1(2);
				item.location2(2)=-item.location2(2);
				the_system.item{end+1}=item;	
				
			case 'actuator'
				
				item.location1(2)=-item.location1(2);
				item.location2(2)=-item.location2(2);
				the_system.item{end+1}=item;
		end
	end
end

end %% Leave
