function out=elastic_connections(data,verb)
%% Copyright (C) 2009, Bruce Minaker, Rob Rieveley
%% This file is intended for use with Octave.
%% elastic_connections.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% elastic_connections.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% Check condition of deflection matrix
if(verb); disp('Checking flexible items...'); end

%% The form of the deflection matrix depends on the type of elastic item,
defln_mtx=[ ...
	point_line_jacobian(data.springs,data.nbodys); ...
	point_line_jacobian(data.flex_points,data.nbodys); ...
	line_bend_jacobian(data.beams,data.nbodys); ...
	triangle_3_jacobian(data.triangle_3s,data.nbodys); ...
	triangle_5_jacobian(data.triangle_5s,data.nbodys); ...
	point_line_jacobian(data.wings,data.nbodys) ...
];

s=size(defln_mtx,1); %% s=the number of rows in the deflection matrix
if(s>0) %% If the deflection matrix has more than zero rows (i.e. there are elastic items in the system)
	rk=rank(defln_mtx); %% rk=the rank (the number of linearly independent rows or columns) of the deflection matrix
	if (rk==s) %% If the rank equals the number of rows, the flexible connectors are statically determinate
		if(verb); disp('Flexible connectors are statically determinate. Good.'); end  %% Give success message
	else
		if(verb); disp('Warning: the flexible connectors are indeterminate.'); end %% Give warning
	end
	
	%% Gather all stiffness and damping coefficients into a vector
	if(data.nsprings>0)
		spring_stiff=[data.springs.stiffness];
		spring_dmpng=[data.springs.damping];
		preload_vec=[data.springs.preload]';
		spring_inertia=[data.springs.inertia];
	else
		spring_stiff=zeros(1,0); %% Creates empty vector for the spring stiffnesses, in case there are zero springs
		spring_dmpng=zeros(1,0);
		spring_inertia=zeros(1,0);
		preload_vec=zeros(0,1);
	end

%%%	t=length([data.springs.preload])
	slct_mtx=zeros(data.nsprings,s);
	pre_k_mtx=zeros(data.nsprings);
	for i=1:data.nsprings  %% Check every spring
		if(~isempty(data.springs(i).preload));  %% If the preload is already known
			slct_mtx(i,i)=1;  %% Add the row to the select matrix
			pre_k_mtx(i,i)=data.springs(i).stiffness;  %% Record the stiffness of this spring
		end
	end
	%% Place the stiffness of those springs where the preload is given along a diagonal matrix
	fnd=(sum(slct_mtx,2)>0);
	slct_mtx=slct_mtx(fnd,:);  %% Throw away zero rows
	pre_k_mtx=pre_k_mtx(fnd,fnd);  %% Throw away zero rows, cols

	t=0;
	if(data.nflex_points>0)
		t=sum([data.flex_points.forces])+sum([data.flex_points.moments]);
	end;
	flex_point_stiff=zeros(1,t);
	flex_point_dmpng=zeros(1,t);
	ind=1;

	for i=1:data.nflex_points %% For each elastic point item
		flex_point_stiff(ind:ind+data.flex_points(i).forces-1)=data.flex_points(i).stiffness(1);
		flex_point_dmpng(ind:ind+data.flex_points(i).forces-1)=data.flex_points(i).damping(1);
		ind=ind+data.flex_points(i).forces;

		flex_point_stiff(ind:ind+data.flex_points(i).moments-1)=data.flex_points(i).stiffness(2);
		flex_point_dmpng(ind:ind+data.flex_points(i).moments-1)=data.flex_points(i).damping(2);
		ind=ind+data.flex_points(i).moments;
	end

	beam_stiff=zeros(1,4*data.nbeams);  %% Creates empty vector for the beam stiffnesses
	for i=1:data.nbeams
		beam_stiff(4*i-3:4*i)=[data.beams(i).stiffness 3*data.beams(i).stiffness data.beams(i).stiffness 3*data.beams(i).stiffness]; %% Creates a row vector of the beam stiffnesses, necessary to rebuild beam stiffness matrix from diagonalization
	end

	%% Assemble stiffness and damping of flexible items along diagonal matrix
	%% Converts stiffness row vector into diagonal matrix -> a column for each elastic item
	stiff=diag([spring_stiff flex_point_stiff beam_stiff]);

	if(data.ntriangle_3s>0)
        stiff=blkdiag(stiff,data.triangle_3s.mod_mtx);
	end

	T=0.5*eye(3)+(1/6)*ones(3);  %% Using a 3 point (2/3,1/6,1/6) integration, find integration points
	for i=1:data.ntriangle_5s
		gp=data.triangle_5s(i).local*T;
		D=zeros(5);
		B=zeros(3,5,3);
		for j=1:3
			%% Evaluate B at each integration point
			B(:,:,j)=[1 gp(2,j) 0 0 0; 0 0 1 gp(1,j) 0; 0 -gp(1,j) 0 -gp(2,j) 1];
			D=D+B(:,:,j)'*data.triangle_5s(i).mod_mtx*B(:,:,j);
		end
		D=D/3;
		stiff=blkdiag(stiff,D);
	end

	%% Convert damping row vector into diagonal matrix  -> a column for each elastic item
	dmpng=diag([spring_dmpng flex_point_dmpng zeros(size(beam_stiff)) zeros(1,3*data.ntriangle_3s) zeros(1,5*data.ntriangle_5s) ]); 

	%% Now deal with wings
	wing_inertia=[];
	for i=1:data.nwings
		stiff=blkdiag(stiff,zeros(6,6));  %% Wing has no stiffness, but many damping terms
		wing=data.wings(i);
		temp=zeros(6);
		temp(1,1)=wing.cxu;
		temp(1,3)=wing.cxw;
		temp(1,5)=wing.cxq*wing.chord/2;
		temp(2,2)=wing.cyv;
		temp(2,4)=wing.cyp*wing.span/2;
		temp(2,6)=wing.cyr*wing.span/2;
		temp(3,1)=wing.czu;
		temp(3,3)=wing.czw;
		temp(3,5)=wing.czq*wing.chord/2;
		temp(4,2)=wing.clv*wing.span;
		temp(4,4)=wing.clp*wing.span^2/2;
		temp(4,6)=wing.clr*wing.span^2/2;
		temp(5,1)=wing.cmu*wing.chord;
		temp(5,3)=wing.cmw*wing.chord;
		temp(5,5)=wing.cmq*wing.chord^2/2;
		temp(6,2)=wing.cnv*wing.span;
		temp(6,4)=wing.cnp*wing.span^2/2;
		temp(6,6)=wing.cnr*wing.span^2/2;

		dmpng=blkdiag(dmpng,-wing.qs/wing.airspeed*temp);

		temp=zeros(6);  %% Wing has effective inertia terms, actual mass and inertia included elsewhere
		temp(1,1)=wing.a_mass(1);
		temp(2,2)=wing.a_mass(2);
		temp(3,3)=wing.a_mass(3);
		
		temp(1,2)=wing.a_mass_products(1); % xy
		temp(2,1)=wing.a_mass_products(1);
		temp(2,3)=wing.a_mass_products(2); % yz
		temp(3,2)=wing.a_mass_products(2);
		temp(3,1)=wing.a_mass_products(3); % zx
		temp(1,3)=wing.a_mass_products(3);
	
		temp(4,4)=wing.a_momentsofinertia(1);
		temp(5,5)=wing.a_momentsofinertia(2);
		temp(6,6)=wing.a_momentsofinertia(3);

		temp(4,5)=wing.a_productsofinertia(1);
		temp(5,4)=wing.a_productsofinertia(1);
		temp(5,6)=wing.a_productsofinertia(2);
		temp(6,5)=wing.a_productsofinertia(2);
		temp(4,6)=wing.a_productsofinertia(3);
		temp(6,4)=wing.a_productsofinertia(3);

		wing_inertia=blkdiag(wing_inertia,temp);
	end



	%% Compute the diagonal inertia values, mostly zero except the inertance of the springs, wings
	inertia=blkdiag(diag([ ...
	spring_inertia ...
	zeros(size(flex_point_stiff)) ...
	zeros(size(beam_stiff)) ...
	zeros(1,3*data.ntriangle_3s) ...
	zeros(1,5*data.ntriangle_5s)]), ...
	wing_inertia);

	%% Build stiffness matrix
	k_defln=defln_mtx'*stiff*defln_mtx; %% Use the deflection matrices to determine the stiffness matrix that results from the deflection of the elastic items -> Combines delfn_mtx (row for each elastic item, six columns for each body) with 'stiff' (row, column for each elastic constraint) to give proper stiffness matrix
	dmpng_mtx=defln_mtx'*dmpng*defln_mtx; %% ...likewise for damping
	inertia_mtx=defln_mtx'*inertia*defln_mtx; %% ...likewise for inertia

else
	if(verb); disp('No flexible connectors.'); end  %% If there are no springs or flex point items, define empty matrices
	stiff=[];
	dmpng=[];	
	k_defln=zeros(data.dimension);
	dmpng_mtx=zeros(data.dimension);
	inertia=[];
	inertia_mtx=zeros(data.dimension);

	pre_k_mtx=[];
	slct_mtx=[];
	preload_vec=[];
end

out.defln_mtx=defln_mtx;  %% The deflection of each elastic item as a linear function of each body motion 
out.k_defln=k_defln;  %% The stiffness matrix due to elastic deflections
out.stiff=stiff;  %% The vector of individual spring stiffnesses
out.dmpng_mtx=dmpng_mtx;  %% The damping matrix
out.dmpng=dmpng;  %% The vector of individual spring dampings
out.inertia_mtx=inertia_mtx;  %% The spring inertia matrix
out.inertia=inertia;  %% The vector of spring inertias

out.pre_k_mtx=pre_k_mtx;  %% A diagonal matrix of stiffnesses of those individual springs where preload is known
out.slct_mtx=slct_mtx;  %% A selection matrix with a rows equal to number of flexible motions, columns number of motions, ones where spring preload is known, zeros elsewhere
out.preload_vec=preload_vec;  %% The vector of known spring preloads

end  %% Leave


%  		temp=[
%  		wing.cdu+2*wing.cd0/wing.airspeed (wing.cda-wing.cl0)/wing.airspeed 0; ...
%  		wing.clu+2*wing.cl0/wing.airspeed (wing.cd0+wing.cla)/wing.airspeed 0; ...
%  		wing.chord*[wing.cmu+2*wing.cm0/wing.airspeed wing.cma/wing.airspeed] wing.cmq ...
%  		];



%	flex_point_stiff=[]; %% Creates empty vector for the flex-point stiffnesses
%	flex_point_dmpng=[]; %% Creates empty vector for the flex-point damping coefficients
%		for j=1:data.flex_points(i).forces
%			flex_point_stiff=[flex_point_stiff  data.flex_points(i).stiffness(1)]; %% Creates a row vector of the flex-point deflection stiffnesses
%			flex_point_dmpng=[flex_point_dmpng data.flex_points(i).damping(1)]; %% Creates a row vector of the flex-point deflection damping coefficients
%		end
%		for j=1:data.flex_points(i).moments
%			flex_point_stiff=[flex_point_stiff  data.flex_points(i).stiffness(2)]; %% Creates a row vector of the flex-point twist stiffnesses
%			flex_point_dmpng=[flex_point_dmpng data.flex_points(i).damping(2)]; %% Creates a row vector of the flex-point twist damping coefficients
%		end

%  	for i=1:data.ntires
%  		stiff=blkdiag(stiff, diag([0 data.tires(i).kz]));  %% Stiffness only in z
%  		dmpng=blkdiag(dmpng, diag([data.tires(i).cy/data.tires(i).roadspeed 0]));  %% Damping only in y
%  	end