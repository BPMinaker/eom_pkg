function s=tex_hsv_pgfplot(name)
%% Copyright (C) 2011, Bruce Minaker
%% This file is intended for use with Octave.
%% tex_hsvd_pgfplot.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% tex_hsvd_pgfplot.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% Write the tex necessary to include the plots
s=['\\section{Hankel Singular Values Plot}\n' ... 
	'\\begin{figure}[htbp]\n' ...
	'\\begin{center}\n' ...
	'\\begin{tikzpicture}\n' ...
	'\\begin{axis}[height=3in,width=5in,restrict y to domain=0:100000,xlabel={Speed [m/s]},ylabel={Hankel Singular Value []},tick style={thin,black},extra y ticks={0},extra y tick style={grid=major},major y grid style={dotted,black},enlarge x limits=false,legend style={at={(1.0,1.03)},anchor=south east},legend columns=-1]\n' ...
	'\\addplot+[black,only marks,mark=*,mark options={scale=0.6}] table[x=speed,y=hsv]{' name '};\n' ...
	'\\end{axis}\n' ...
	'\\end{tikzpicture}\n' ...
	'\\caption{Hankel Singular Values vs. Speed}\n' ...
	'\\label{hsvd_plot}\n' ...
	'\\end{center}\n' ...
	'\\end{figure}\n' ...
	'\\clearpage\n' ...
	'\n'];

end %% Leave
