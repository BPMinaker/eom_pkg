function s=tex_hsv_pgftable(filename)
%% Copyright (C) 2003, 2008 Bruce Minaker
%% This file is intended for use with Octave.
%% tex_hsv_table.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% tex_hsv_table.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

s='\\section{Hankel Singular Value Analysis}\n';

s=[s 'The Hankel singular values are given in Table~\\ref{svals}.\n\n'];

s=[s '\\begin{table}[ht]\n' ...
	'\\begin{center}\n' ...
	'\\begin{footnotesize}\n' ...
	'\\caption{Hankel Singular Values}\n' ...
	'\\label{svals}\n' ...
	'\\pgfplotstabletypeset'];
  	s=[s '[columns={num,hsv}]{' filename '}\n' ...
	'\\end{footnotesize}\n' ...
	'\\end{center}\n' ...
	'\\end{table}\n'];
