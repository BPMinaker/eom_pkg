function out=force(in,num) 
%% Copyright (C) 2003, Bruce Minaker
%% This file is intended for use with Octave.
%% force.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% force.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------
%% function 'force' returns 'vec' (external loads), 'mtx' (stiffness matrix for angular motion resulting from applied forces) as a function of 'in' (the loads) and 'num' (the number of bodies)

vec=zeros(6*num,1); %% Vec (force vector) is defined as zero vector
mtx=zeros(6*num); %% mtx (stiffness matrix) is defined as zero matrix
 
for i=1:length(in) %% for i = 1 to 'number of external loads'

	pointer1=6*(in(i).body_number-1);  %% Row or column where this info is stored
	pointer2=6*(in(i).frame_number-1);
	rad=in(i).radius; %% Distance at which external force is applied (vector) <- Generated in connect.m
	frc=in(i).force; %% Applied force (vector) <- As defined in system input file
	mmt=in(i).moment; %% Applied moment (vector) <- As defined in system input file

	%% Total moment = applied moment + (r cross f) <-using skew symmetric matrix
	vec(pointer1+(1:3))=vec(pointer1+(1:3))+frc; %% Adds force vector to rows 1,2,3 (for mass 1) of column vector
	vec(pointer1+(4:6))=vec(pointer1+(4:6))+mmt+(skew(rad)*frc); %% Adds moment vector to rows 4,5,6 (for mass 1) of column vector
	
	ff=skew(frc);
	mtx(pointer1+(1:3),pointer1+(4:6))=mtx(pointer1+(1:3),pointer1+(4:6))-ff;
	mtx(pointer1+(1:3),pointer2+(4:6))=mtx(pointer1+(1:3),pointer2+(4:6))+ff;  %% Note same row, different column

	ff=skew(rad)*skew(frc)+skew(mmt); 
	mtx(pointer1+(4:6),pointer1+(4:6))=mtx(pointer1+(4:6),pointer1+(4:6))-ff;
	mtx(pointer1+(4:6),pointer2+(4:6))=mtx(pointer1+(4:6),pointer2+(4:6))+ff;  %% If 'body' = 'axes', then matrix terms will cancel

end

n=6*(num-1);
vec=vec(1:n);
mtx=mtx(1:n,1:n);

out.vec=vec;
out.k_app_frc=mtx;

end  %% Leave
