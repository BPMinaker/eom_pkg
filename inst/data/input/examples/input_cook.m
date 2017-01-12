function the_system=input_cook(n,varargin)
the_system.item={};

% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% input_cook.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% input_cook.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

xdivs=n;
ydivs=n;

cst.type='triangle_3';
cst.thickness=1;
cst.modulus=1;
cst.psn_ratio=1/3;

body.type='body';
body.mass=1;
body.momentsofinertia=[1;1;1];
body.productsofinertia=[0;0;0];

point.type='rigid_point';
point.body2='ground';
point.forces=1;
point.moments=3;
point.axis=[0;0;1];

load.type='load';
load.force=[0;1/2/ydivs;0];
load.moment=[0;0;0];

for i=0:xdivs
	for j=0:ydivs
		x(i+1,j+1)=.48/xdivs*i;
		yl=44/48*x(i+1,j+1);
		yu=16/48*x(i+1,j+1)+.44;
		y(i+1,j+1)=j/ydivs*yu+(1-j/ydivs)*yl;

		body.location=[x(i+1,j+1);y(i+1,j+1);0.1];
		body.name=['body-' num2str(i) num2str(j)];
		the_system.item{end+1}=body;

		point.location=[x(i+1,j+1);y(i+1,j+1);0.1];
		point.body1=['body-' num2str(i) num2str(j)];
		point.name=['point-' num2str(i) num2str(j)];
		the_system.item{end+1}=point;
	end
end

plot(x,y)

for i=1:xdivs
	for j=1:ydivs
		pt1=[x(i,j);y(i,j);0.1];
		pt2=[x(i+1,j);y(i+1,j);0.1];
		pt3=[x(i,j+1);y(i,j+1);0.1];
		pt4=[x(i+1,j+1);y(i+1,j+1);0.1];
		
		cst.name=['element-lower-' num2str(i) num2str(j)];
		cst.body1=['body-' num2str(i-1) num2str(j-1)];
		cst.body2=['body-' num2str(i) num2str(j-1)];
		cst.body3=['body-' num2str(i-1) num2str(j)];

		cst.location1=pt1;
		cst.location2=pt2;
		cst.location3=pt3;	

		the_system.item{end+1}=cst;

		cst.name=['element-upper-' num2str(i) num2str(j)];
		cst.body1=['body-' num2str(i-1) num2str(j)];
		cst.body2=['body-' num2str(i) num2str(j-1)];
		cst.body3=['body-' num2str(i) num2str(j)];

		cst.location1=pt3;
		cst.location2=pt2;
		cst.location3=pt4;	

		the_system.item{end+1}=cst;
	end
end


point.forces=2;
point.moments=0;

for j=0:ydivs

		point.location=[x(1,j+1);y(1,j+1);0.1];
		point.body1=['body-' num2str(0) num2str(j)];
		point.name=['point-' num2str(0) num2str(j)];
		the_system.item{end+1}=point;

end

for j=1:ydivs

		load.location=[x(xdivs+1,j);y(xdivs+1,j);0.1];
		load.body=['body-' num2str(xdivs) num2str(j-1)];
		load.name=['load-upper-'  num2str(j)];
		the_system.item{end+1}=load;

		load.location=[x(xdivs+1,j+1);y(xdivs+1,j+1);0.1];
		load.body=['body-' num2str(xdivs) num2str(j)];
		load.name=['load-lower' num2str(j)];
		the_system.item{end+1}=load;

end

disp('Cooked.');
%the_system
