function out=preload(eom,verbose)
%% Copyright (C) 2010, Bruce Minaker
%% This file is intended for use with Octave.
%% preload.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% preload.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------
%% Use the Jacobian and deflection matrices to determine the forces of constraint and the preload reactions in the elastic items.  The assumption of equilibrium is necessary.

defln=[];
if(verbose)
	disp('Checking whether the system is determinate...');
end

p=length(eom.elastic.preload_vec);  %% p=the number of preloads known
[q,r]=size(eom.rigid.cnsrt_mtx); %% q=the number of rows in the constraint matrix

% [B' D']{lam}={f}      rigid constraint force plus elastic force equals total applied force
% [0  S]{f}    {fp}     subset of the elastic preloads are known

test_mtx=[ eom.rigid.cnsrt_mtx' eom.elastic.defln_mtx'; zeros(p,q) eom.elastic.slct_mtx ];
s=size(test_mtx,2); %% s=number of columns of test_mtx

% [ 0    B     0 ]{lam}  {0}    defln satisfies constraints
% [ B'   K  D'S'P]{x} ={-f}   forces sum to zero
% [ 0   PSD    P ]{d} {fp}   some of the elastic preloads are known

ind_test_mtx=[ zeros(q) eom.rigid.cnsrt_mtx zeros(q,p); eom.rigid.cnsrt_mtx' eom.elastic.k_defln eom.elastic.defln_mtx'*eom.elastic.slct_mtx'*eom.elastic.pre_k_mtx; zeros(p,q) eom.elastic.pre_k_mtx*eom.elastic.slct_mtx*eom.elastic.defln_mtx eom.elastic.pre_k_mtx ];
t=size(ind_test_mtx,1);  %% note square

if(s>0)

	[uu,ww,vv]=svd(test_mtx);  %% Use the singular value decomposition, computationally expensive
	wd=diag(ww);

	tol=max(size(test_mtx))*eps(max(wd));
	rk=sum(wd>tol);  %% From the SVD, find the rank

	if(rk==s)  %% If rank = number of cols -> statically determinate [full rank]
		if(verbose)
			disp('Statically determinate system.  Good.');
			disp('Finding all forces of constraint and flexible item preloads...');
		end
		%% lambda=test_mtx\[-eom.frc.vec; eom.elastic.preload_vec]; %% lambda (constraint forces)=-inverse(test_mtx)*frcvec
		wwinv=zeros(size(ww'));
		for i=1:length(wd)
			wwinv(i,i)=1/wd(i);
		end
		mpinv=vv*wwinv*uu';  %% Use the SVD to find the pseudo inv
		lambda=mpinv*[-eom.frc.vec; eom.elastic.preload_vec];

		% [B    0 ]      {0}         satisfies constraints
		% [K  D'S'P]{x}={-f-B'lam}   elastic force due to motion and initial deflection = total applied force less rigid constraint force
		% [PSD  P ]{d}  {fp}         the known elastic preloads result from motion of the system plus initial deflection before motion

		if(verbose)
			disp('Finding deflections...');
		end

		temp_mtx=ind_test_mtx(:,q+1:end);
		defln=pinv(temp_mtx)*[zeros(q,1);-eom.frc.vec-eom.rigid.cnsrt_mtx'*lambda(1:q);eom.elastic.preload_vec];
		defln=-defln(1:r);

		sumf=test_mtx(1:end-p,:)*lambda+eom.frc.vec;
		if((sumf'*sumf)<1e-5)  %% If magnitude squared of sumf < small  i.e., equals ~zero
			if(verbose)
				disp('System is in equilibrium. Good.');
			end
		else
			disp(['The squared force error is '  num2str(sumf'*sumf) '.']);
			error('System is not in equilibrium.');  %% Equilibrium cannot be found, thus the system cannot be analyzed
		end
	else
		if(verbose)
			disp('Warning: this is a statically indeterminate system!');
			disp('Trying to use item stiffness to determine preloads...');
		end

		[uu,ww,vv]=svd(ind_test_mtx);  %% Use the singular value decomposition, computationally expensive
		wd=diag(ww);

		tol=max(size(ind_test_mtx))*eps(max(wd));
		rk=sum(wd>tol);  %% From the SVD, find the rank

		if(rk==t)	%% Elastically determinate
			if(verbose)
				disp('Finding all forces of constraint, flexible item preloads, and deflections...');
			end
			%temp=pinv(ind_test_mtx)*[zeros(q,1);-eom.frc.vec;eom.elastic.preload_vec];

			mpinv=vv*diag(1./wd)*uu';  %% Use the SVD to find the pseudo inv
			temp=mpinv*[zeros(q,1);-eom.frc.vec;eom.elastic.preload_vec];

			defln=-temp(q+1:q+r);
			lambda=[ temp(1:q); [eom.elastic.stiff*eom.elastic.defln_mtx eom.elastic.slct_mtx'*eom.elastic.pre_k_mtx]*temp(q+1:end) ];

		else
			if(verbose)
				disp('Warning: some preloads cannot be found uniquely!');
				disp('Attempting a trial solution anyway, checking whether the system is in equilibrium...');
			end			

			wdm=wd(wd>tol);
			mpinv=vv(:,wd>tol)*diag(1./wdm)*uu(:,wd>tol)';  %% Use the SVD to find the pseudo inv
			temp=mpinv*[zeros(q,1);-eom.frc.vec;eom.elastic.preload_vec];

			defln=-temp(q+1:q+r);
			lambda=[ temp(1:q); [eom.elastic.stiff*eom.elastic.defln_mtx eom.elastic.slct_mtx'*eom.elastic.pre_k_mtx]*temp(q+1:end) ];

			sumf=test_mtx(1:r,:)*lambda+eom.frc.vec; %% test matrix*lambda+f <- should be zero
			if((sumf'*sumf)<1e-5*length(sumf))  %% If magnitude squared of sumf < small  i.e., equals ~zero
				if(verbose)
					disp('System is in equilibrium. Good.');
				end
			else
				disp(['The squared force error is '  num2str(sumf'*sumf) '.']);
				error('System is not in equilibrium.');  %% Equilibrium cannot be found, thus the system cannot be analyzed
			end
		end
	end
else
	lambda=[];  %% If there are no constraints or elastic items (odd, but possible)
	sumf=eom.frc.vec;
	if((sumf'*sumf)<1e-5)  %% If magnitude squared of sumf < small  i.e., equals ~zero
		if(verbose)
			disp('System is in equilibrium. Good.');
		end
	else
		disp(['The squared force error is '  num2str(sumf'*sumf) '.']);
		error('System is not in equilibrium.');  %% Equilibrium cannot be found, thus the system cannot be analyzed
	end
end

out.lambda=lambda;
out.defln=defln;

end  %% Leave


%% test_mtx=[eom.rigid.cnsrt_mtx;eom.elastic.defln_mtx]; old method
%temp=-[zeros(q) eom.rigid.cnsrt_mtx;
%eom.rigid.cnsrt_mtx' eom.elastic.k_defln];  old method
%if(norm(ind_test_mtx*temp-[zeros(q,1);-eom.frc.vec;eom.elastic.preload_vec]) /norm(ind_test_mtx*temp)>1e-6)
%	error('Error: some flexible item preloads are incompatible with equilibrium.');
%end
