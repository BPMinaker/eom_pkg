function mtx=triangle_3_jacobian(in,num) %% Function 'triangle_3_jacobian' returns 'mtx' (deflection matrix of triangle_3 items) as a function of 'in' (triangle_3 items in system) and 'num' (number of bodies) 
%% Copyright (C) 2010, Bruce Minaker
%% This file is intended for use with Octave.
%% triangle_3_jacobian.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% triangle_3_jacobian.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

mtx=zeros(3*length(in),6*num); %% Initially define deflection matrix as zero matrix

for i=1:length(in) %% Loop through each cst item
	nu=in(i).nu;
	pl=in(i).local;
	t=in(i).thickness;

	r1=in(i).radius(:,1); %% Radius from body1 cg to point of action of cst item on body1;
	r2=in(i).radius(:,2); %% Radius from body2 cg to point of action of cst item on body2;
	r3=in(i).radius(:,3); %% Radius from body3 cg to point of action of cst item on body3;

	bnum1=in(i).body_number(1); %% Number of first body acted on by cst item
	bnum2=in(i).body_number(2); %% Number of second body acted on by cst item
	bnum3=in(i).body_number(3); %% Number of third body acted on by cst item

	R1=skew(r1); %% Skew symmetric matrix of radius1
	R2=skew(r2); %% Skew symmetric matrix of radius2
	R3=skew(r3); %% Skew symmetric matrix of radius2

	pl(3,:)=[1 1 1];  %% Find the area of the element
	a=det(pl)/2;

	pl(:,4)=pl(:,1);  %% Duplicate column one to ease diff calcs
	d=diff(pl,1,2);
	d(2,:)=-d(2,:);
	d=circshift(d,[0,-1]);

	D=(1/2/a)*[d(2,1) 0 d(2,2) 0 d(2,3) 0; 0 d(1,1) 0 d(1,2) 0 d(1,3); d(1,1) d(2,1) d(1,2) d(2,2) d(1,3) d(2,3)];

	B=zeros(6,6*num);
	tmp=[nu' (R1*nu)'];  %% Relate motion of body motion to node motion
	B(1:2, bnum1*6-5:bnum1*6)=tmp(1:2,:);

	tmp=[nu' (R2*nu)'];  %% for each node
	B(3:4, bnum2*6-5:bnum2*6)=tmp(1:2,:);

	tmp=[nu' (R3*nu)'];  %% for each node
	B(5:6, bnum3*6-5:bnum3*6)=tmp(1:2,:);

	B=D*B;  %% Tie together shape functions and node deflections

	B=B*sqrt(a*t);

	%% Stack up the matrix
	mtx(3*i-2:3*i,:)=B;

end

n=6*(num-1); %% n = number of bodies -1 = number of bodies not including ground
mtx=mtx(:,1:n); %% mtx = jacobian / deflection matrix

end %% Leave
