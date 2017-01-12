function out=rigid_constraint(data,verb)
%% Copyright (C) 2009, Bruce Minaker, Rob Rieveley
%% This file is intended for use with Octave.
%% rigid_constraint.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% rigid_constraint.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% Form the constraint Jacobian - the form is dependant on the type of constraints
%% Build constraint matrix by setting deflections of rigid items to zero
if(verb); disp('Checking rigid items...'); end

cnsrt_mtx=[point_line_jacobian(data.links,data.nbodys);point_line_jacobian(data.rigid_points,data.nbodys)];
q=size(cnsrt_mtx,1);  %% q = the number of rows in the constraint matrix

nhcnsrt_mtx=point_line_jacobian(data.nh_points,data.nbodys);
t=size(nhcnsrt_mtx,1);  %% t = the number of rows in the nh-constraint matrix

%% still need to build v vector and check that it makes constraints happy 
%% Build skew symmetric velocity matrix, and the centripetal and gyroscopic terms
[v_mtx,mv_mtx]=centngyro(data.bodys);
negjv_mtx=-cnsrt_mtx*v_mtx;  %% Build transformation - constraint matrix

%% Check condition of constraint matrix
if(verb); disp('Checking constraint items...'); end
if(q+t>0) %% If the jacobian matrix has more than zero rows (i.e. there are rigid constraint items in the system)
	rkr=rank([cnsrt_mtx;nhcnsrt_mtx]);  %% rk = the rank (the maximum number of linearly independent rows or columns) of the constraint matrix
	if (rkr==(q+t))  %% If the rank = the number of rows, then there are no redundant constraints (the constraints are all linearly independent)
		if(verb); disp('No redundant constraints in the system. Good.'); end
	else
		disp('Warning: there are redundant constraints in the system!');
	end

	%% Assemble the individual constraint matrices to system constraint matrix
	J_r=[cnsrt_mtx zeros(q,data.dimension); negjv_mtx cnsrt_mtx; zeros(t,data.dimension) nhcnsrt_mtx];
	J_l=[cnsrt_mtx zeros(q,data.dimension); zeros(q,data.dimension) cnsrt_mtx; zeros(t,data.dimension) nhcnsrt_mtx];

else
	rkr=0;
	J_l=[];
	J_r=[];
end

out.cnsrt_mtx=cnsrt_mtx;
out.nhcnsrt_mtx=nhcnsrt_mtx;
out.J_r=J_r;
out.J_l=J_l;
out.mv_mtx=mv_mtx;
out.v_mtx=v_mtx;
out.rkr=rkr;

end
