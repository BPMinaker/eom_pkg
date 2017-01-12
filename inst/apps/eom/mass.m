function in=mass(in) %% function 'mass' returns 'mtx' as a function of 'bodys' [from eom.m]
%% Copyright (C) 2003, Bruce Minaker
%% This file is intended for use with Octave.
%% mass.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% mass.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% For each mass the loop prepares the diagonal items of its part of the mass matrix: 3 instances of the mass, followed by the 3 mass moments of inertia, followed by the products of inertia on the off-diagonals

n=length(in)-1; %% Length of in is the number of bodies

for i=1:n 

	in(i).inertia=diag(in(i).momentsofinertia);  %% Put inertia on diagonal
	in(i).inertia(1,2)=-in(i).productsofinertia(1);  %% Put -ve cross products in
	in(i).inertia(2,1)=-in(i).productsofinertia(1);
	in(i).inertia(2,3)=-in(i).productsofinertia(2);
	in(i).inertia(3,2)=-in(i).productsofinertia(2);
	in(i).inertia(1,3)=-in(i).productsofinertia(3);
	in(i).inertia(3,1)=-in(i).productsofinertia(3);

	in(i).mass_mtx=blkdiag(in(i).mass*eye(3),in(i).inertia);  %% Stack mass and inertia terms

end

end  %% Leave
