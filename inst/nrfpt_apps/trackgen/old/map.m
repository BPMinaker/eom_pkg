function [xy,dxy]=map(st,pts)
%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% map.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% map.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%  xy is the location in physical space
%  st is the location in mapped space
%  pts are the four corners in physical space, arranged [(-1;-1), (-1;1), (1;-1) (1;1) ] 

s=st(1);
t=st(2);

N=0.25*[(1-s)*(1-t);(1-s)*(1+t);(1+s)*(1-t);(1+s)*(1+t)];
dN=0.25*[-(1-t) -(1-s);-(1+t) (1-s);(1-t) -(1+s);(1+t) (1+s)];

xy=pts*N; %% 2x4 * 4x1 = 2x1
dxy=pts*dN; %% 2x4 * 4x2 = 2x2
