function mtx=line_bend_jacobian(in,num) %% Function 'line_bend_jacobian' returns 'mtx' (constraint or deflection matrix of directed items) as a function of 'in' (directed items in system) and 'num' (number of bodies) 
%% Copyright (C) 2003, Bruce Minaker
%% This file is intended for use with Octave.
%% line_bend_jacobian.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% line_bend_jacobian.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

mtx=zeros(4*length(in),6*num); %% Initially define deflection matrix as zero matrix

for i=1:length(in) %% Loop through each beam item
	l=in(i).length; %% Length of item
	rs=in(i).radius(:,1); %% Radius from body1 cg to point of action of directed item on body1; 's'=start
	re=in(i).radius(:,2); %% Radius from body2 cg to point of action of directed item on body2; 'e'=end
	pointer1=6*(in(i).body_number(1)-1);  %% Column number of the start body
	pointer2=6*(in(i).body_number(2)-1);  %% Column number of the end body

	B1=[in(i).b1;in(i).b2]*[eye(3) -skew(rs); zeros(3) eye(3)]; %% The skew rs makes 'theta'x'r'... 
	B2=[in(i).b1;in(i).b2]*[eye(3) -skew(re); zeros(3) eye(3)]; %% rotation of the body that creates a translation at the joint, i.e, x1-theta*r = 0

	B=zeros(8,6*num);
	B(1:4,pointer1+(1:6))=B1;
	B(5:8,pointer2+(1:6))=B2;

	D=[0 0 0 -1 0 0 0 1; 2/l 0 0 1 -2/l 0 0 1; 0 0 -1 0 0 0 1 0; 0 2/l -1 0 0 -2/l -1 0];  %% Relate the beam stiffness matrix to the deflection of the ends (diagonalize the typical beam stiffness matrix!)

	mtx(4*i+(-3:0),:)=D*B;
end

n=6*(num-1); %% n = number of bodies -1 = number of bodies not including ground
mtx=mtx(:,1:n); %% mtx = jacobian / deflection matrix

end %% Leave

%	nu=in(i).nu;
% 	bnum1=in(i).body_number(1); %% Number of first body acted on by directed item
% 	bnum2=in(i).body_number(2); %% Number of second body acted on by directed item

% 	Rs=skew(rs); %% Skew symmetric matrix of radius1
% 	Re=skew(re); %% Skew symmetric matrix of radius2

%   B=zeros(8,6*num);
%     
%   B(1:4, bnum1*6-5:bnum1*6)=[nu' (Rs*nu)'; zeros(2,3) nu'];  %% Relate motion of body to beam deflection and twist
% 	B(5:8, bnum2*6-5:bnum2*6)=[nu' (Re*nu)'; zeros(2,3) nu'];  %% for each end
  




