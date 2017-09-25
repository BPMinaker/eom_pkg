function out=tangent(syst,verb)
%% Copyright (C) 2017, Bruce Minaker
%% This file is intended for use with Octave.
%% tangent.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% tangent.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------


k_geo=line_stretch_hessian(syst.data.links,syst.data.nbodys);
k_geo=k_geo+line_stretch_hessian(syst.data.springs,syst.data.nbodys);

k_geo=k_geo+point_hessian(syst.data.flex_points,syst.data.nbodys);
k_geo=k_geo+point_hessian(syst.data.rigid_points,syst.data.nbodys);

out.k_geo=k_geo;
