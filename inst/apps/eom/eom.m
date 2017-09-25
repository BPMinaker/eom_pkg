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

%% Begin construction of equations of motion
%syst.status=1; %% System status initialized as good
if(option.verbose); disp('Okay, got the system info, building equations of motion...'); end

%% Build the mass matrix
syst.data.dimension=6*(syst.data.nbodys-1); %% Find the dimension of the system from number of bodies, subtract one for ground body
syst.data.bodys=mass(syst.data.bodys);  %% Build mass matrix from body info
syst.eom.mass.mtx=blkdiag(syst.data.bodys.mass_mtx);

%% Sum external forces and cast into vector
%% Determine stiffness matrix for angular motion resulting from applied forces
syst.eom.frc=force(syst.data.loads,syst.data.nbodys);

%% Build the stiffness matrix due to deflections of elastic elements
syst.eom.elastic=elastic_connections(syst.data,option.verbose);

%% Build the matrices describing the rigid constraints
syst.eom.rigid=rigid_constraint(syst.data,option.verbose);

%% Solve for the internal and reaction forces and distribute
syst.eom.preloads=preload(syst.eom,option.verbose);
syst.data=const_frc_deal(syst,option.verbose);

%% Build the tangent stiffness matrix from the computed preloads
syst.eom.tangent=tangent(syst,option.verbose);

%% Build the input matrix
syst.data.nin=syst.data.nactuators+syst.data.nsurfs;
syst.eom.forced=actuators(syst,option.verbose);

%% Build the output matrix
syst.data.nout=syst.data.nsensors;
syst.eom.outputs=sensors(syst,option.verbose);

% Assemble the system equations of motion
[syst.eom.eqn_of_mtn,syst.eom.state_space,syst.eom.phys]=assemble_eom(syst,option.verbose);

%% End of routine
end


