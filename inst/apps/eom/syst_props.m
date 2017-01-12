function strs=syst_props(strs,result)
%% Copyright (C) 2015, Bruce Minaker
%% This file is intended for use with Octave.
%% syst_props.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% syst_props.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

strs.bodydata=['%%%%%% Body Data \n' 'num name mass rx ry rz ixx iyy izz ixy iyz ixz \n'];
strs.pointdata=['%%%%%% Connection Data \n' 'num name rx ry rz ux uy uz\n'];
strs.linedata=['%%%%%% Connection Data \n' 'num name rx ry rz ux uy uz\n'];
strs.stiffnessdata=['%%%%%% Connection Data \n' 'num name stiffness damping t_stiffness t_damping\n'];


%% Body data
for i=1:(result{1}.data.nbodys-1)
	item=result{1}.data.bodys(i);
	strs.bodydata=[strs.bodydata '{' num2str(i) '} {' item.name '}'];
	strs.bodydata=[strs.bodydata sprintf(' %4.8e',item.mass, item.location, item.momentsofinertia, item.productsofinertia) '\n'];
end

%% Connection data
j=0;
for i=1:result{1}.data.nrigid_points
	j=j+1;
	item=result{1}.data.rigid_points(i);
	strs.pointdata=[strs.pointdata '{' num2str(j) '} {' item.name '}'];
	strs.pointdata=[strs.pointdata sprintf(' %4.8e',item.location)];
	if(norm(item.axis)>0)
		strs.pointdata=[strs.pointdata sprintf(' %4.8e',item.unit)];
	else
		strs.pointdata=[strs.pointdata ' {} {} {}'];
	end
	strs.pointdata=[strs.pointdata '\n'];
	%	strs.pointdata=[strs.pointdata ' {} {} {} {}\n'];
end
  
for i=1:result{1}.data.nflex_points
	j=j+1;
	item=result{1}.data.flex_points(i);
	strs.pointdata=[strs.pointdata '{' num2str(j) '} {' item.name '}'];
	strs.pointdata=[strs.pointdata sprintf(' %4.8e',item.location)];
	if(norm(item.axis)>0)
		strs.pointdata=[strs.pointdata sprintf(' %4.8e',item.unit)];
	else
		strs.pointdata=[strs.pointdata ' {} {} {}'];
	end
	strs.pointdata=[strs.pointdata '\n'];

	strs.stiffnessdata=[strs.stiffnessdata '{' num2str(i) '} {' item.name '}'];
	strs.stiffnessdata=[strs.stiffnessdata sprintf(' %4.8e',item.stiffness(1),item.damping(1),item.stiffness(2),item.damping(2)) '\n'];
end

for i=1:result{1}.data.nnh_points
	j=j+1;
	item=result{1}.data.nh_points(i);
	strs.pointdata=[strs.pointdata '{' num2str(j) '} {' item.name '}'];
	strs.pointdata=[strs.pointdata sprintf(' %4.8e',item.location)];
	if(norm(item.axis)>0)
		strs.pointdata=[strs.pointdata sprintf(' %4.8e',item.unit)];
	else
		strs.pointdata=[strs.pointdata ' {} {} {}'];
	end
	strs.pointdata=[strs.pointdata '\n'];

%	strs.pointdata=[strs.pointdata ' {} {} {} {}\n'];
end

j=0;
for i=1:result{1}.data.nsprings
	j=j+1;
	item=result{1}.data.springs(i);
	strs.linedata=[strs.linedata '{' num2str(j) '} {' item.name '}'];
	strs.linedata=[strs.linedata sprintf(' %4.8e',item.location(:,1),item.location(:,2))];
	strs.linedata=[strs.linedata '\n'];

	strs.stiffnessdata=[strs.stiffnessdata '{' num2str(i) '} {' item.name '}'];
	strs.stiffnessdata=[strs.stiffnessdata sprintf(' %4.8e %4.8e {} {}\n',item.stiffness,item.damping)];
end

for i=1:result{1}.data.nlinks
	j=j+1;
	item=result{1}.data.links(i);
	strs.linedata=[strs.linedata '{' num2str(j) '} {' item.name '}'];
	strs.linedata=[strs.linedata sprintf(' %4.8e',item.location(:,1),item.location(:,2))];
	strs.linedata=[strs.linedata '\n'];
end

for i=1:result{1}.data.nbeams
	j=j+1;
	item=result{1}.data.beams(i);
	strs.linedata=[strs.linedata '{' num2str(j) '} {' item.name '}'];
	strs.linedata=[strs.linedata sprintf(' %4.8e',item.location(:,1),item.location(:,2))];
	strs.linedata=[strs.linedata '\n'];

	strs.stiffnessdata=[strs.stiffnessdata '{' num2str(i) '} {' item.name '}'];
	strs.stiffnessdata=[strs.stiffnessdata sprintf(' %4.8e {} {} {}\n',item.stiffness)];
end

end  %% Leave


%  for i=1:result{1}.data.nsprings
%  	j=j+1;
%  	item=result{1}.data.springs(i);
%  	strs.linedata=[strs.linedata '{' num2str(j) '} {' item.name '}'];
%  	strs.linedata=[strs.linedata sprintf(' %4.8e',item.location(:,1))];
%  	strs.linedata=[strs.linedata ' {} {} {}'];
%  	strs.linedata=[strs.linedata sprintf(' %4.8e %4.8e {} {}\n',item.stiffness,item.damping)];
%  	strs.linedata=[strs.linedata '{} {' item.name '}'];
%  	strs.linedata=[strs.linedata sprintf(' %4.8e',item.location(:,2))];
%  	strs.linedata=[strs.linedata ' {} {} {}'];
%  	strs.linedata=[strs.linedata ' {} {} {} {}\n'];
%  end

