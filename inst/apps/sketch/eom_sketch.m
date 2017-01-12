function s=eom_sketch(config,result,varargin)
%% Copyright (C) 2004, Bruce Minaker
%% This file is intended for use with Octave.
%% eom_draw.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% eom_draw.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% This function draws the sketch file of the system
verb=0;
if(nargin>1)
	if(strcmp(varargin(1),'verbose'))
		verb=1;
	end
end

if(verb), disp('Sketching ...'); end

s='';
s2='def system{';

for i=1:result.data.nbodys
	item=result.data.bodys(i);
	if(~strcmp(item.name,'ground') && isempty(strfind(lower(item.name),'wheel'))) 
		s2=[s2 '{body_' num2str(i) '} '];
		s=[s sketch_prim(['body_' num2str(i)],'sphere','rad',0.3,'loc',10*item.location)];
	elseif(~isempty(strfind(lower(item.name),'wheel')))
		s2=[s2 '{body_' num2str(i) '} '];
		type='wheel';
		if(~isempty(strfind(lower(item.name),'wheel, bike')))
			type='bwheel';
		end
		s=[s sketch_prim(['body_' num2str(i)],type,'loc',10*item.location,'axis',[0;1;0],'opc',0.5)];
	end
end

for i=1:result.data.nflex_points
	item=result.data.flex_points(i);
	s2=[s2 '{flex_point_' num2str(i) '} '];
	if((item.forces==3||item.forces==0)&&(item.moments==3||item.moments==0))
		s=[s sketch_prim(['flex_point_' num2str(i)],'sphere','loc',10*item.location,'rad',0.25)];
	else
		s=[s sketch_prim(['flex_point_' num2str(i)],'cyl','top',10*(item.location-0.025*item.unit),'bot',10*(item.location+0.025*item.unit),'rad',0.2)];
	end

	for j=1:2  %% For each body it attachs
		if(~strcmp(result.data.bodys(item.body_number(j)).name,'ground') && isempty(strfind(result.data.bodys(item.body_number(j)).name,'chassis')) && isempty(strfind(result.data.bodys(item.body_number(j)).name,'wheel')) &&  isempty(strfind(result.data.bodys(item.body_number(j)).name,'Chassis')) &&  isempty(strfind(result.data.bodys(item.body_number(j)).name,'Wheel')))  %% If it's not the ground
			body_lcn=result.data.bodys(item.body_number(j)).location;  %% Find the body location
			if(norm(item.location-body_lcn)>0)
				s2=[s2 '{flex_point_' num2str(i) '_' num2str(j) '} '];
				s=[s sketch_prim(['flex_point_' num2str(i) '_' num2str(j)],'cyl','top',10*item.location,'bot',10*body_lcn,'rad',0.18)];
			end
		end
	end
end

for i=1:result.data.nrigid_points
	item=result.data.rigid_points(i);
	s2=[s2 '{rigid_point_' num2str(i) '} '];
	if((item.forces==3||item.forces==0)&&(item.moments==3||item.moments==0))
		s=[s sketch_prim(['rigid_point_' num2str(i)],'sphere','loc',10*item.location,'rad',0.25)];
	elseif(item.forces==3 && item.moments==1)
		s=[s sketch_prim(['rigid_point_' num2str(i)],'cyl','top',10*(item.location-0.025*item.nu(:,1)),'bot',10*(item.location+0.025*item.nu(:,1)),'rad',0.2)];
		s=[s sketch_prim(['rigid_point_' num2str(i) 'b'],'cyl','top',10*(item.location-0.025*item.nu(:,2)),'bot',10*(item.location+0.025*item.nu(:,2)),'rad',0.2)];
		s2=[s2 '{rigid_point_' num2str(i) 'b} '];
	else
		s=[s sketch_prim(['rigid_point_' num2str(i)],'cyl','top',10*(item.location-0.025*item.unit),'bot',10*(item.location+0.025*item.unit),'rad',0.2)];
	end

	for j=1:2  %% For each body it attachs
		if(~strcmp(result.data.bodys(item.body_number(j)).name,'ground') && ~strcmpi(result.data.bodys(item.body_number(j)).name,'chassis') && ~strcmpi(result.data.bodys(item.body_number(j)).name,'wheel'))  %% If it's not the ground
			body_lcn=result.data.bodys(item.body_number(j)).location;  %% Find the body location
			if(norm(item.location-body_lcn)>0)
				s2=[s2 '{rigid_point_' num2str(i) '_' num2str(j) '} '];
				s=[s sketch_prim(['rigid_point_' num2str(i) '_' num2str(j)],'cyl','top',10*item.location,'bot',10*body_lcn,'rad',0.18)];
			end
		end
	end
end

link_rad=0.15;
for i=1:result.data.nsprings
	item=result.data.springs(i);
	len=item.length;
	frac=2*link_rad/len/10;

	s2=[s2 '{spring_t_' num2str(i) '} '];
	s2=[s2 '{spring_b_' num2str(i) '} '];
	s2=[s2 '{spring_i_' num2str(i) '} '];
	s2=[s2 '{spring_o_' num2str(i) '} '];

	s=[s sketch_prim(['spring_t_' num2str(i)],'sphere','loc',10*item.location(:,1),'rad',2*link_rad)];
	s=[s sketch_prim(['spring_b_' num2str(i)],'sphere','loc',10*item.location(:,2),'rad',2*link_rad)];
	
	temp1=(1-frac)*item.location(:,2)+frac*item.location(:,1);
	temp2=0.35*item.location(:,2)+0.65*item.location(:,1);

	s=[s sketch_prim(['spring_i_' num2str(i)],'cyl','top',10*temp1,'bot',10*temp2,'rad',2.5*link_rad)];

	temp1=0.65*item.location(:,2)+0.35*item.location(:,1);
	temp2=frac*item.location(:,2)+(1-frac)*item.location(:,1);
	s=[s sketch_prim(['spring_o_' num2str(i)],'cyl','top',10*temp1,'bot',10*temp2,'rad',3*link_rad)];

%	s=[s sketch_prim(['spring_' num2str(i)],'cyl','top',10*item.location(:,1),'bot',10*item.location(:,2),'rad',0.25)];
	for j=1:2  %% For each body it attachs
		if(~strcmp(result.data.bodys(item.body_number(j)).name,'ground') && ~strcmpi(result.data.bodys(item.body_number(j)).name,'chassis') && ~strcmpi(result.data.bodys(item.body_number(j)).name,'wheel'))  %% If it's not the ground
			body_lcn=result.data.bodys(item.body_number(j)).location;  %% Find the body location
			if(norm(item.location(:,j)-body_lcn)>0)
				s2=[s2 '{spring_' num2str(i) '_' num2str(j) '} '];
				s=[s sketch_prim(['spring_' num2str(i) '_' num2str(j)],'cyl','top',10*item.location(:,j),'bot',10*body_lcn,'rad',0.18)];
			end
	%		if(~strcmp(result.data.bodys(result.data.links(i).body_number(j)).name,'ground'))  %% If it's not the ground
	%			x3d=[x3d x3d_cyl([[joint_lcn-body_lcn] [0;0;0]],'rad',link_rad,'col',color)];  %% Draw the link mount
	%		end
		end
	end
end



for i=1:result.data.nlinks
	item=result.data.links(i);

	s2=[s2 '{link_' num2str(i) '} '];
	s2=[s2 '{link_t_' num2str(i) '} '];
	s2=[s2 '{link_b_' num2str(i) '} '];

	s=[s sketch_prim(['link_' num2str(i)],'cyl','top',10*item.location(:,1),'bot',10*item.location(:,2),'rad',0.1)];
	s=[s sketch_prim(['link_t_' num2str(i)],'sphere','loc',10*item.location(:,1),'rad',0.2)];
	s=[s sketch_prim(['link_b_' num2str(i)],'sphere','loc',10*item.location(:,2),'rad',0.2)];
	for j=1:2  %% For each body it attachs
		if(~strcmp(result.data.bodys(item.body_number(j)).name,'ground'))  %% If it's not the ground
			body_lcn=result.data.bodys(item.body_number(j)).location;  %% Find the body location
			if(norm(item.location(:,j)-body_lcn)>0)
				s2=[s2 '{link_' num2str(i) '_' num2str(j) '} '];
				s=[s sketch_prim(['link_' num2str(i) '_' num2str(j)],'cyl','top',10*item.location(:,j),'bot',10*body_lcn,'rad',0.18)];
			end
	%		if(~strcmp(result.data.bodys(result.data.links(i).body_number(j)).name,'ground'))  %% If it's not the ground
	%			x3d=[x3d x3d_cyl([[joint_lcn-body_lcn] [0;0;0]],'rad',link_rad,'col',color)];  %% Draw the link mount
	%		end
		end
	end
end

%  for i=1:result.data.nactuators
%  	item=result.data.actuators(i);
%  	s=[s sketch_prim(['actuator_' num2str(i) '_'],'cyl','top',10*item.location(:,1),'bot',10*item.location(:,2),'rad',0.1)];
%  end
%  
%  for i=1:result.data.nsensors
%  	item=result.data.sensors(i);
%  	s=[s sketch_prim(['sensor_' num2str(i) '_'],'cyl','top',10*item.location(:,1),'bot',10*item.location(:,2),'rad',0.1)];
%  end

for i=1:result.data.nbeams
	item=result.data.beams(i);
	s2=[s2 '{beam_' num2str(i) '} '];
	s=[s sketch_prim(['beam_' num2str(i)],'cyl','top',10*item.location(:,1),'bot',10*item.location(:,2),'rad',0.25)];
end

%  for i=1:result.data.nloads
%  	item=result.data.loads(i);
%  	dirn=2*item.force/norm(item.force);
%  
%  	s=[s sketch_prim(['load_' num2str(i) '_'],'cyl','top',10*item.location,'bot',10*item.location+dirn,'rad',0.125)];
%  end

s2=[s2 '}\n'];
sketch_save([s,s2],config.dir.output);

s=['\\section{Geometry Diagram}\n The system geometry is shown in the following diagram.\n'];
s=[s '\\begin{figure}[hbtp]\n'];  %% Insert the picture into a figure
s=[s '\\begin{center}\n'];
s=[s '\\input{sketch}\n'];
s=[s '\\caption{Geometry}\n'];
s=[s '\\label{geometry}\n'];
s=[s '\\end{center}\n'];
s=[s '\\end{figure}\n'];
s=[s '\n\n'];

if(verb) disp('Sketching done.'); end

%% *** MODIFIED TO DRAW GROUND PLANE AT -152.6mm FOR VEHICLE MODEL ***
%%st=[st vrml_surf([0;4],[-1.5,1.5],[-.1526 -.1526;-.1526 -.1526])];

end
