function syst=eom(syst,verb)
%% Copyright (C) 2003, Bruce Minaker, Rob Rieveley
%% This file is intended for use with Octave.
%% eom.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% eom.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% Generate the linearized equations of motion for a multibody system
option.debug=0;
option.verbose=verb;
option.run_type=ones(1,10);

%% Begin construction of equations of motion
%syst.status=1; %% System status initialized as good
if(option.verbose); disp('Okay, got the system info, building equations of motion...'); end

%% Build the mass matrix
if(option.run_type(1)) 
	syst.data.dimension=6*(syst.data.nbodys-1); %% Find the dimension of the system from number of bodies, subtract one for ground body

%	syst.data.bodys=mass(syst.data.bodys);  %% Build mass matrix from body info
%	syst.eom.mass.mtx=blkdiag(syst.data.bodys.mass_mtx);
    syst.eom.mass.mtx=syst.data.bodys(1:end-1).mass_mtx;
end

%% Sum external forces and cast into vector
%% Determine stiffness matrix for angular motion resulting from applied forces
if(option.run_type(2))
	syst.eom.frc=force(syst.data.app_loads,syst.data.nbodys);
end

%% Build the stiffness matrix due to deflections of elastic elements
if(option.run_type(3))
	syst.eom.elastic=elastic_connections(syst.data,option.verbose);
end

%% Build the matrices describing the rigid constraints
if(option.run_type(4))
	syst.eom.rigid=rigid_constraint(syst.data,option.verbose);
end

%% Solve for the internal and reaction forces and distribute
if(option.run_type(5))
	syst.eom.preloads=preload(syst.eom,option.verbose);
	syst.data=const_frc_deal(syst,option.verbose);
end 

%% Build the input matrix
if(option.run_type(6))
	syst.eom.forced=actuators(syst,option.verbose);
end

%% Build the output matrix
if(option.run_type(7))
	syst.eom.outputs=sensors(syst,option.verbose);
% 	for i=1:length(syst.data.sensors) % mark the user defined sensors
% 		syst.data.sensors(i).user=1; 
% 	end 
end

%% Assemble the system equations of motion
if(option.run_type(8))
	syst.eom.eqn_of_mtn=assemble_eom(syst,option.verbose);
end

%% Cast system into first order form
if(option.run_type(9))
	[syst.eom.state_space,syst.eom.phys]=cast_fof(syst,option.verbose);
end

%% End of routine
end


