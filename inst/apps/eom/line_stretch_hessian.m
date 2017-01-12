function mtx=line_stretch_hessian(in,num) %% In = links or springs, num = no. of bodies in system... Outputs mtx = stiffness matrix from directon change of linear items with preload
%% Copyright (C) 2003, Bruce Minaker
%% This file is intended for use with Octave.
%% line_stretch_hessian.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% line_stretch_hessian.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

mtx=zeros(6*num); %% Create empty matrix 

for i=1:length(in)  %% For each link or spring

	temp=zeros(3,6*num);
	u=in(i).unit; %% Unit vector defining axis of action of directed item
	rs=in(i).radius(:,1); %% Radius from body1 cg to point of action of directed item on body1; 's'=start
	re=in(i).radius(:,2); %% Radius from body2 cg to point of action of directed item on body2; 'e'=end

	pointer1=6*(in(i).body_number(1)-1);
	pointer2=6*(in(i).body_number(2)-1);

	t1=[-skew(u) skew(u)*skew(rs)];
	t2=[skew(u) -skew(u)*skew(re)];
	
	temp(:,pointer1+(1:6))=t1;
	temp(:,pointer2+(1:6))=t2;

	mtx=mtx+temp'*temp*(in(i).preload/in(i).length);

	mtx(pointer1+(1:6),pointer1+(4:6))=mtx(pointer1+(1:6),pointer1+(4:6))-in(i).preload*t1';
	mtx(pointer2+(1:6),pointer2+(4:6))=mtx(pointer2+(1:6),pointer2+(4:6))-in(i).preload*t2';

end

n=6*(num-1); %% Eliminates ground body from n
mtx=mtx(1:n,1:n); %% Builds k for links or for springs

end  %% Leave
