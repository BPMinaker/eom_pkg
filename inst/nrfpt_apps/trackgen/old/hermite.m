function coeff=hermite(cond)
%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% hermite.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% hermite.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%  Conditions is a vector of offset at -1, slope at -1, offset at 1, slope at 1
%  Coefficients are the resulting polynomial

h=zeros(4);
h(:,1)=[0.25; 0; -0.75; 0.5];  %% y(-1)=1, coefficients are [cube square linear constant]
h(:,2)=[0.25; -0.25; -0.25; 0.25];  %% dy(-1)=1
h(:,3)=[-0.25; 0; 0.75; 0.5];  %% y(1)=1
h(:,4)=[0.25; 0.25; -0.25; -0.25];  %% dy(1)=1

coeff=h*cond;