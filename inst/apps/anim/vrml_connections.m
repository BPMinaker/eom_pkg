function result=vrml_connections(result)

%% GPL here
% This function builds a vrml model

link_rad=0.018;
color=[0.5;0.5;0.5];

for i=1:result{1}.data.nrigid_points  %% For every rigid point
	joint_lcn=result{1}.data.rigid_points(i).location;  %% Find the location
	for j=1:2  %% For each body it attachs
		this_body_name=result{1}.data.bodys(result{1}.data.rigid_points(i).body_number(j)).name;
		if(~strcmp(this_body_name,'ground')&&~strcmp(lower(this_body_name),'chassis')&& ~length(strfind(lower(this_body_name),'wheel')))  %% If it's not the ground or the chassis or a wheel
			body_lcn=result{1}.data.bodys(result{1}.data.rigid_points(i).body_number(j)).location;  %% Find the body location
			vrml=[vrml_cyl([[joint_lcn-body_lcn] [0;0;0]],'rad',link_rad,'col',color)];  %% Draw the connection
			result{1}.data.bodys(result{1}.data.rigid_points(i).body_number(j)).vrml=[result{1}.data.bodys(result{1}.data.rigid_points(i).body_number(j)).vrml vrml];  %% Add the vrml to the body
		end
	end
end

for i=1:result{1}.data.nlinks  %% For every link
	for j=1:2  %% For each body it attachs
		joint_lcn=result{1}.data.links(i).location(:,j);  %% Find the location
		body_lcn=result{1}.data.bodys(result{1}.data.links(i).body_number(j)).location;  %% Find the body location
		vrml=vrml_points([joint_lcn-body_lcn],'balls','rad',link_rad+0.002,'col',[1;0;0]);
		this_body_name=result{1}.data.bodys(result{1}.data.links(i).body_number(j)).name;
		if(~strcmp(this_body_name,'ground')&&~strcmp(lower(this_body_name),'chassis')   )  %% If it's not the ground or the chassis
			vrml=[vrml vrml_cyl([[joint_lcn-body_lcn] [0;0;0]],'rad',link_rad,'col',color)];  %% Draw the link mount
 		end
		result{1}.data.bodys(result{1}.data.links(i).body_number(j)).vrml=[result{1}.data.bodys(result{1}.data.links(i).body_number(j)).vrml vrml];  %% Add the vrml to the body
	end
end

for i=1:result{1}.data.nsprings  %% For every spring
  	for j=1:2  %% For each body it attachs
		joint_lcn=result{1}.data.springs(i).location(:,j);  %% Find the location
		body_lcn=result{1}.data.bodys(result{1}.data.springs(i).body_number(j)).location;  %% Find the body location
		this_body_name=result{1}.data.bodys(result{1}.data.springs(i).body_number(j)).name;
		if(~strcmp(this_body_name,'ground')&&~strcmp(lower(this_body_name),'chassis')   )  %% If it's not the ground or the chassis
			vrml=[vrml_cyl([[joint_lcn-body_lcn] [0;0;0]],'rad',link_rad,'col',color)];  %% Draw the spring mount
			result{1}.data.bodys(result{1}.data.springs(i).body_number(j)).vrml=[result{1}.data.bodys(result{1}.data.springs(i).body_number(j)).vrml vrml];  %% Add the vrml to the body
		end
	end
end

end  %% Leave

