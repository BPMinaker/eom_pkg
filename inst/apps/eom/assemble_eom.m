function [eqn_of_mtn,state_space,phys]=assemble_eom(syst,verb)
%% Copyright (C) 2010, Bruce Minaker, Robert Rieveley
%% This file is intended for use with Octave.
%% assemble_eom.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% assemble_eom.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% Build angular stiffness matrix from motion of items with preload, both rigid and flexible
if(verb); disp('Building equations of motion...'); end

k_geo=line_stretch_hessian(syst.data.links,syst.data.nbodys);
k_geo=k_geo+line_stretch_hessian(syst.data.springs,syst.data.nbodys);

k_geo=k_geo+point_hessian(syst.data.flex_points,syst.data.nbodys);
k_geo=k_geo+point_hessian(syst.data.rigid_points,syst.data.nbodys);

stiff_mtx=syst.eom.frc.k_app_frc+k_geo+syst.eom.elastic.k_defln;  %% Sum total system stiffness

%symmetric_stiffness=issymmetric(stiff_mtx,1.e-3);  %% Check symmetry of stiffness matrix, if 'stiff_mtx' is symmetric to the tolerance 1.e-3, return the dimension, otherwise return zero

dim=syst.data.dimension;

M=[eye(dim) zeros(dim,dim+syst.data.nin); zeros(dim) syst.eom.mass.mtx+syst.eom.elastic.inertia_mtx -syst.eom.forced.g_mtx; zeros(syst.data.nin,2*dim+syst.data.nin)];

KC=[syst.eom.rigid.v_mtx -eye(dim) zeros(dim,syst.data.nin);
stiff_mtx syst.eom.elastic.dmpng_mtx+syst.eom.rigid.mv_mtx -syst.eom.forced.f_mtx; 
zeros(syst.data.nin,2*dim) eye(syst.data.nin)];

s=size(syst.eom.rigid.J_r,1);  %% Compute size of J matrices

if(s>0)
	r_orth=null([syst.eom.rigid.J_r zeros(s,syst.data.nin)]);
	l_orth=null([syst.eom.rigid.J_l zeros(s,syst.data.nin)]);
else
	r_orth=eye(2*dim+syst.data.nin);
	l_orth=r_orth;
end

%% Pre and post multiply by orthogonal complements, and then cast in standard form

E=l_orth'*M*r_orth;
A=-l_orth'*KC*r_orth;

B=l_orth'*[zeros(2*dim,syst.data.nin); eye(syst.data.nin)];

%syst.eom.outputs.column

C=zeros(syst.data.nout,2*dim+syst.data.nin);

for i=1:syst.data.nout
	
	switch(syst.eom.outputs.column(i))
		
		case 1 %% p
			mask=[eye(dim) zeros(dim,dim+syst.data.nin)];
			
		case 2 %% w
			mask=[zeros(dim) eye(dim) zeros(dim,syst.data.nin)];
		
		case 3 %% p dot
			mask=-KC(1:dim,:);
		
		case 4 %% w dot
			mask=-pinv(M(dim+1:2*dim,dim+1:2*dim))*KC(dim+1:2*dim,:);
		
		case 5 %% p dot dot
			mask=[syst.eom.rigid.v_mtx^2 -syst.eom.rigid.v_mtx  zeros(dim,syst.data.nin)] - pinv(M(dim+1:2*dim,dim+1:2*dim))*KC(dim+1:2*dim,:);
		
		otherwise
			error('Matrix size error');
	end
	C(i,:)=syst.eom.outputs.sensor_mtx(i,:)*mask;

end

C=C*r_orth;
D=syst.eom.outputs.d_mtx;  %% Add the user defined feed forward

state_space=dss(A,B,C,D,E);
phys=r_orth(1:dim,:);  %% Relate the physical coordinates to the minimal ones

if(verb); disp('Okay, built equations of motion.'); end

eqn_of_mtn.M=M;
eqn_of_mtn.KC=KC;
eqn_of_mtn.stiff_mtx=stiff_mtx;
eqn_of_mtn.k_geo=k_geo;

end  %% Leave




%  M=[eye(dim) zeros(dim); zeros(dim) syst.eom.mass.mtx+syst.eom.elastic.inertia_mtx];
%  
%  KC=[syst.eom.rigid.v_mtx diag(-ones(dim,1));stiff_mtx syst.eom.elastic.dmpng_mtx+syst.eom.rigid.mv_mtx];
%  
%  B=[zeros(size(syst.eom.forced.f_mtx)); syst.eom.forced.f_mtx];





