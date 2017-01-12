function vrml_animate(result,tout,pout,write_file)
%% Copyright (C) 2010, Bruce Minaker, Rob Rieveley
%% This file is intended for use with Octave.
%% vrml_animate.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% vrml_animate.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% This function draws the animated vrml file of the system

disp('Animating...');

result=vrml_body(result);  %% Fill in the default graphics data
result=vrml_connections(result);  %% Fill in the connection data

nbodys=result{1}.data.nbodys;
nsolid = result{1}.data.nbodys-1;
npoint = result{1}.data.nrigid_points+result{1}.data.nflex_points+result{1}.data.nloads;
nline = result{1}.data.nlinks+result{1}.data.nsprings+result{1}.data.nbeams+result{1}.data.nsensors+result{1}.data.nactuators;

ss1='';
rr1='';
for j=1:nbodys
	lcns=result{1}.data.bodys(j).location;
	name=result{1}.data.bodys(j).name;

	if (~strcmp(name,'ground'))  %% If we have a body that's not ground, cause the ground doesn't move

		trans=pout(:,6*j+[-5:-3]);  %% Pull coordinates from input
		rots=pout(:,6*j+[-2:0]);

		temp1=trans';
		temp2=rots';

		for k=1:size(pout,1)
			temp2(4,k)=norm(temp2(1:3,k)); % need to check the rotations plot
		end
		[s,r]=vrml_motion(tout,temp1,temp2,ones(3,size(pout,1)),[num2str(j) '_body'],result{1}.data.bodys(j).vrml); %% Add the vrml string for the motion indicated by the mode shape
		ss1=[ss1 s];
		rr1=[rr1 r];
	else
		ss1=[ss1 result{1}.data.bodys(j).vrml];  %% Ground doesn't move
	end
end

for j=1:result{1}.data.nrigid_points

	item=result{1}.data.rigid_points(j);

	ind=[6*nsolid+3*j+[-2:0]];
	lcn=pout(:,ind)';

	for k=1:size(pout,1)
		rot(:,k)=[0;0;1;0];
	end

	if((item.forces==3||item.forces==0)&&(item.moments==3||item.moments==0))
		vrml=vrml_points([0;0;0],'balls','rad',0.025,'col',[0 0 1]);
	elseif(item.forces==3 && item.moments==1)
		vrml=vrml_cyl([-0.025*item.nu(:,1),0.025*item.nu(:,1)],'rad',0.02,'col',[1 1 0]);
		vrml=[vrml vrml_cyl([-0.025*item.nu(:,2),0.025*item.nu(:,2)],'rad',0.02,'col',[1 1 0])];
	else
		vrml=vrml_cyl([-0.025*item.unit,0.025*item.unit],'rad',0.02,'col',[1 1 0]);
	end

	[s,r]=vrml_motion(tout,lcn,rot,ones(3,size(pout,1)),[num2str(j) '_rigid_point'],vrml); %% Add the vrml string for the motion indicated by the mode shape
	ss1=[ss1 s];
	rr1=[rr1 r];
end

for j=1:result{1}.data.nflex_points

	item=result{1}.data.flex_points(j);

	ind=[6*nsolid+3*result{1}.data.nrigid_points+3*(j)+[-2:0]];
	lcn=pout(:,ind)';

	for k=1:size(pout,1)
		rot(:,k)=[0;0;1;0];
	end

	if((item.forces==3||item.forces==0)&&(item.moments==3||item.moments==0))
		vrml=vrml_points([0;0;0],'balls','rad',0.025,'col',[0 0 1]);
	else
		vrml=vrml_cyl([-0.025*item.unit,0.025*item.unit],'rad',0.02,'col',[0 0 1]);
	end

	[s,r]=vrml_motion(tout,lcn,rot,ones(3,size(pout,1)),[num2str(j) '_flex_point'],vrml); %% Add the vrml string for the motion indicated by the mode shape
	ss1=[ss1 s];
	rr1=[rr1 r];
end

link_rad=0.01;
for j=1:result{1}.data.nlinks
	len=norm(result{1}.data.links(j).location(:,2)-result{1}.data.links(j).location(:,1));  %% build vrml link
	vrml_link=vrml_cyl([[0;0;0] [0;len;0]],'rad',link_rad,'col',[0;1;0]);

	ind1=[6*nsolid+3*npoint+6*(j)+[-5:-3]];
	ind2=[6*nsolid+3*npoint+6*(j)+[-2:0]];

	lcn1=pout(:,ind1)';
	lcn2=pout(:,ind2)';

	for i=1:size(pout,1)
		scale(:,i)=[1;norm(lcn2(:,i)-lcn1(:,i))/len;1];
		aa(1:4,i)=axisang(lcn2(:,i),lcn1(:,i))'; % change each column from end points to axis and angle form for vrml standard
	end

	[s,r]=vrml_motion(tout,lcn1,aa,scale,[num2str(j) '_link'],vrml_link);
	ss1=[ss1 s];
	rr1=[rr1 r];
end

ss2='';
rr2='';
ss3='';
rr3='';

link_rad=0.015;
for j=1:result{1}.data.nsprings
	len=result{1}.data.springs(j).length;

	ind1 = [6*nsolid+3*npoint+6*result{1}.data.nlinks+6*j+[-5:-3]];
	ind2 = [6*nsolid+3*npoint+6*result{1}.data.nlinks+6*j+[-2:0]];

	lcn1=pout(:,ind1)';
	lcn2=pout(:,ind2)';

	if(result{1}.data.springs(j).twist==0)
		vrml_spring=vrml_cyl([[0;2*link_rad;0] [0;0.65*len;0]],'rad',2.5*link_rad,'tran',0.3,'col',[1;1;0]);
		vrml_spring=[vrml_spring vrml_points([0;0;0],'balls','rad',2*link_rad,'col',[1;1;0])  ];

		len=len*.65;
		vrml_spring_out=vrml_cyl([[0;2*link_rad;0] [0;len;0]],'rad',3*link_rad,'tran',0.3,'col',[1;1;0]);
		vrml_spring_out=[vrml_spring_out vrml_cyl([[0;0;0] [0;len+link_rad;0]],'rad',link_rad,'col',[1;1;1])];
		vrml_spring_out=[vrml_spring_out vrml_cyl([[0;len-link_rad;0] [0;len+link_rad;0]],'rad',2.3*link_rad,'col',[1;1;1])];
		vrml_spring_out=[vrml_spring_out vrml_points([0;0;0],'balls','rad',2*link_rad,'col',[1;1;0])];

		
		for i=1:size(pout,1)
			aa1(1:4,i)=axisang(lcn2(:,i),lcn1(:,i))'; % change each column from end points to axis and angle form for vrml standard
			aa2(1:4,i)=axisang(lcn1(:,i),lcn2(:,i))';
		end

		[s,r]=vrml_motion(tout,lcn1,aa1,ones(3,size(pout,1)),[num2str(j) '_spring'],[vrml_spring_out]); % insert the picture of the arm into the animation data
		ss2=[ss2 s];
		rr2=[rr2 r];
		
		[s,r]=vrml_motion(tout,lcn2,aa2,ones(3,size(pout,1)),[num2str(j) '_spring_out'],vrml_spring);
		ss3=[ss3 s];
		rr3=[rr3 r];

	else
		vrml_spring=vrml_cyl([[0;0;0] [0;len;0]],'rad',link_rad,'col',[1;1;0]);

		for i=1:size(pout,1)
			scale(:,i)=[1;norm(lcn2(:,i)-lcn1(:,i))/len;1];
			aa(1:4,i)=axisang(lcn2(:,i),lcn1(:,i))'; % change each column from end points to axis and angle form for vrml standard
		end

		[s,r]=vrml_motion(tout,lcn1,aa,scale,[num2str(j) '_spring'],vrml_spring);
		ss1=[ss1 s];
		rr1=[rr1 r];
	end

end

s=['DEF IDtimer TimeSensor {\n'];
s=[s '  loop TRUE\n'];
s=[s '  cycleInterval 5.0\n'];  %% Add the loop timer for the animations
s=[s '}\n'];

s=[s ss1 ss2 ss3];
r=[rr1 rr2 rr3];

vrml_save([write_file '.wrl'],s,r);

end  %% Leave


%			str=['vrml=''' result{1}.data.bodys(j).vrml ''';']  %% and this body has an vrml description
%			eval(str);
