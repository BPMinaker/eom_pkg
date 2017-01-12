function s=tex_sstf_pgftable(filename,in,out)
%% Copyright (C) 2014, Bruce Minaker
%% This file is intended for use with Octave.
%% tex_sstf_pgfplot.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% tex_sstf_pgfplot.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------


nin=length(in);
nout=length(out);

s='\\section{Steady State Gains}\n';  %% Write the tex necessary to include the plots

s=[s 'The steady state gains are given in Table~\\ref{sstf}.\n'];

s=[s '\\begin{table}[ht]\n' ...
	'\\begin{center}\n' ...
	'\\begin{footnotesize}\n' ...
	'\\caption{Steady State Gains}\n' ...
	'\\label{sstf}\n' ...
	'\\pgfplotstabletypeset'];
  	s=[s '{' filename '}\n' ...
	'\\end{footnotesize}\n' ...
	'\\end{center}\n' ...
	'\\end{table}\n'];

end %% Leave
