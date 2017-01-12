function s=tex_sstf_pgfplot(filename,in,out)
%% Copyright (C) 2009, Bruce Minaker
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
s='\\section{Steady State Transfer Functions Plot}\n';  %% Write the tex necessary to include the plots

for i=1:nin
	s=[s '\\begin{figure}[htbp]\n' ...
	'\\begin{center}\n' ...
	'\\begin{tikzpicture}\n' ...
	'\\begin{axis}[height=3in,width=5in,xmin=0,tick style={thin,black},extra y ticks={0},extra y tick style={grid=major},major y grid style={dotted,black},xlabel=Speed,ylabel=Steady State Transfer Functions,enlarge x limits=false,restrict y to domain=-10:10,legend style={at={(1.0,1.03)},anchor=south east},legend columns=-1,cycle list name=linestyles*]\n'];
	for j=1:nout
		s=[s '\\addplot+[black,line width=1pt,mark=none] table[x=speed,y=' num2str((i-1)*nout+j) ']{' filename '};\n' ...
		'\\addlegendentry{' out{j} '/' in{i} '}\n'];
	end
	s=[s '\\end{axis}\n' ...
	'\\end{tikzpicture}\n' ...
	'\\caption{Steady State Transfer Functions}\n' ...
	'\\label{sstf_plot_' num2str(i) '}\n' ...
	'\\end{center}\n' ...
	'\\end{figure}\n\n'];
end
s=[s '\\clearpage\n\n'];

end %% Leave


%	in=ceil(i/nout);  %% Loop over inputs
%	out=i-(in-1)*nout;  %% Loop over outputs
