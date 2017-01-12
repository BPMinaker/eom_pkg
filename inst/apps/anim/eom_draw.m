function s=eom_draw(result,varargin)
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

%% This function draws the VRML file of the system
verb=0;
if(nargin>1)
	if(strcmp(varargin{1},'verbose'))
		if(nargin>2)
			verb=varargin{2};
		else
			verb=1;
		end
	end
end
if(verb) disp('Drawing vrml...'); end

result=vrml_body(result);  %% Fill in the default graphics data
result=vrml_connections(result);  %% Fill in the connection data

s='';
for i=1:result{1}.data.nbodys
	item=result{1}.data.bodys(i);

%  	%% Add a viewpoint for each body, except ground
%  	lcns=[item.location(:,1)]+[0; 0; 2];
%  	pstn=sprintf('%f %f %f',lcns);
%  	s=[s  '<Viewpoint position="' pstn '"/>\n' ];

	pstn=sprintf('%f %f %f',item.location);
	s=[s 'Transform {\n'];
	s=[s '  translation ' pstn '\n'];
	s=[s '  children [\n'];
	s=[s item.vrml];
	s=[s ']}\n'];

end

for i=1:result{1}.data.nflex_points
	item=result{1}.data.flex_points(i);
	lcns=item.location(:,1);
	if((item.forces==3||item.forces==0)&&(item.moments==3||item.moments==0))
		s=[s vrml_points(lcns,'balls','rad',0.025,'col',[0 0 1])];
	else
		s=[s vrml_cyl([lcns-0.025*item.unit,lcns+0.025*item.unit],'rad',0.02,'col',[0 0 1])];
	end
end

for i=1:result{1}.data.nrigid_points
	item=result{1}.data.rigid_points(i);
	lcns=item.location(:,1);
	if((item.forces==3||item.forces==0)&&(item.moments==3||item.moments==0))
		s=[s vrml_points(lcns,'balls','rad',0.025,'col',[1 1 0])];
	elseif(item.forces==3 && item.moments==1)
		s=[s vrml_cyl([lcns-0.025*item.nu(:,1),lcns+0.025*item.nu(:,1)],'rad',0.02,'col',[1 1 0])];
		s=[s vrml_cyl([lcns-0.025*item.nu(:,2),lcns+0.025*item.nu(:,2)],'rad',0.02,'col',[1 1 0])];
	else
		s=[s vrml_cyl([lcns-0.025*item.unit,lcns+0.025*item.unit],'rad',0.02,'col',[1 1 0])];
	end
end

link_rad=0.015;
for i=1:result{1}.data.nsprings
	item=result{1}.data.springs(i);
	len=item.length;
	frac=2*link_rad/len;

	if(item.twist==0)
		temp1=(1-frac)*item.location(:,2)+frac*item.location(:,1);
		temp2=0.35*item.location(:,2)+0.65*item.location(:,1);
		vrml_spring=vrml_cyl([temp1 temp2],'rad',2.5*link_rad,'tran',0.3,'col',[1;1;0]);  %% shell inner
		vrml_spring=[vrml_spring vrml_points(item.location(:,2),'balls','rad',2*link_rad,'col',[1;1;0])  ];  %% ball inner

		temp1=0.65*item.location(:,2)+0.35*item.location(:,1);
		temp2=frac*item.location(:,2)+(1-frac)*item.location(:,1);
		vrml_spring_out=vrml_cyl([temp1 temp2],'rad',3*link_rad,'tran',0.3,'col',[1;1;0]);  %% shell outer

		frac=0.65-link_rad/len;
		temp1=frac*item.location(:,2)+(1-frac)*item.location(:,1);
		vrml_spring_out=[vrml_spring_out vrml_cyl([item.location(:,1) temp1],'rad',link_rad,'col',[1;1;1])]; %% shaft

		frac=0.65+link_rad/len;
		temp2=frac*item.location(:,2)+(1-frac)*item.location(:,1);
		vrml_spring_out=[vrml_spring_out vrml_cyl([temp1 temp2],'rad',2.3*link_rad,'col',[1;1;1])];  %% piston

		vrml_spring_out=[vrml_spring_out vrml_points(item.location(:,1),'balls','rad',2*link_rad,'col',[1;1;0])];  %% ball outer

		s=[s vrml_spring vrml_spring_out];
	else

		vrml_spring=vrml_cyl([item.location(:,1) item.location(:,2)],'rad',link_rad,'tran',0.3,'col',[1;1;0]);  %% shell outer
		s=[s vrml_spring];

	end
end

for i=1:result{1}.data.nlinks
	item=result{1}.data.links(i);
	lcns=[item.location(:,1) item.location(:,2)];
	s=[s vrml_cyl(lcns,'rad',0.015,'col',[0 1 0])];
end

for i=1:result{1}.data.nactuators
	item=result{1}.data.actuators(i);
	lcns=[item.location(:,1) item.location(:,2)];
	s=[s vrml_cyl(lcns,'rad',0.01,'col',[0 1 0.5])];
end

for i=1:result{1}.data.nsensors
	item=result{1}.data.sensors(i);
	lcns=[item.location(:,1) item.location(:,2)];
	s=[s vrml_cyl(lcns,'rad',0.01,'col',[0 0.5 1])];
end

for i=1:result{1}.data.nbeams
	item=result{1}.data.beams(i);
	lcns=[item.location(:,1) item.location(:,2)];
	s=[s vrml_cyl(lcns,'rad',0.02,'col',[1 0.5 0])];
end

for i=1:result{1}.data.nloads
	item=result{1}.data.loads(i);
	lcns=[item.location];
	if(norm(item.force)>0)
		dirn=0.2*item.force/norm(item.force);
	else
		dirn=[0;0;0];
	end
	s=[s vrml_cyl([lcns,lcns+dirn],'rad',0.01,'col',[0 1 1],'arrow')];
%	s=[s vrml_cyl([lcns+dirn,lcns+1.5*dirn],'rad',0.015,'cone','col',[0 1 1])];

	if(norm(item.moment)>0)
		dirn=0.2*item.moment/norm(item.moment);
	else
		dirn=[0;0;0];
	end
	s=[s vrml_cyl([lcns,lcns+dirn],'rad',0.01,'col',[0 1 1],'arrow')];
	s=[s vrml_cyl([lcns+dirn,lcns+1.5*dirn],'rad',0.01,'col',[0 1 1],'arrow')];
	%	s=[s vrml_cyl([lcns+dirn,lcns+1.5*dirn],'rad',0.015,'cone','col',[0 1 1])];
%	s=[s vrml_cyl([lcns+1.3*dirn,lcns+1.8*dirn],'rad',0.015,'cone','col',[0 1 1])];
end

for i=1:result{1}.data.nnh_points
	item=result{1}.data.nh_points(i);
	lcns=item.location(:,1);
	if((item.forces==3||item.forces==0)&&(item.moments==3||item.moments==0))
		s=[s vrml_points(lcns,'balls','rad',0.025,'col',[1 1 0.5])];
	else
		s=[s vrml_cyl([lcns-0.03*item.unit,lcns+0.03*item.unit],'rad',0.015,'col',[1 1 0.5])];
	end
end

for i=1:result{1}.data.ntriangle_3s
	item=result{1}.data.triangle_3s(i);
	lcns=item.location;
	s=[s vrml_ifs(lcns,[1;2;3],'col',[1 0 0.5],'tran',0.5)];
	avg=(lcns(:,1)+lcns(:,2)+lcns(:,3))/3;
	s=[s vrml_cyl([avg  avg+0.05*item.unit],'rad',0.005,'col',[1 0 0.5],'arrow')];
	s=[s vrml_cyl([avg  avg+0.05*item.nu(:,1)],'rad',0.005,'col',[1 0 0.5],'arrow')];
	s=[s vrml_cyl([avg  avg+0.05*item.nu(:,2)],'rad',0.005,'col',[1 0 0.5],'arrow')];
end

for i=1:result{1}.data.ntriangle_5s
	item=result{1}.data.triangle_5s(i);
	lcns=item.location;
	s=[s vrml_ifs(lcns,[1;2;3],'col',[1 0 0.5],'tran',0.5)];
	avg=(lcns(:,1)+lcns(:,2)+lcns(:,3))/3;
	s=[s vrml_cyl([avg  avg+0.05*item.unit],'rad',0.005,'col',[1 0 0.5],'arrow')];
	s=[s vrml_cyl([avg  avg+0.05*item.nu(:,1)],'rad',0.005,'col',[1 0 0.5],'arrow')];
	s=[s vrml_cyl([avg  avg+0.05*item.nu(:,2)],'rad',0.005,'col',[1 0 0.5],'arrow')];
end


%% *** MODIFIED TO DRAW GROUND PLANE AT -152.6mm FOR VEHICLE MODEL ***
%%st=[st vrml_surf([0;4],[-1.5,1.5],[-.1526 -.1526;-.1526 -.1526])];

end
