function s=tex_bode_pgfplot(filename,in,out)
%% Copyright (C) 2009, Bruce Minaker
%% This file is intended for use with Octave.
%% tex_bode_pgfplot.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% tex_bode_pgfplot.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

nin=length(in);
nout=length(out);
disp('Preparing plots...');
s='\\section{Frequency Response Plots}\n';

for i=1:nin  %% For each input
	s=[s '\\begin{figure}[hbtp]\n' ...
	'\\begin{center}\n' ...
	'\\begin{footnotesize}\n' ...
	'\\begin{tikzpicture}\n' ...
	'\\begin{semilogxaxis}[height=2in,width=5in,tick style={thin,black},extra y ticks={0},extra y tick style={grid=major},major y grid style={dotted,black},xlabel={Frequency [Hz]},ylabel={Transfer Function [dB]},enlarge x limits=false,legend style={at={(1.0,1.03)},anchor=south east},legend columns=1,legend cell align=left,cycle list name=linestyles*]\n'];
	for j=1:nout  %% For each output
		s=[s '\\addplot+[black,line width=1pt,mark=none] table[x=frequency,y=m' num2str((i-1)*nout+j) ']{' filename '};\n' ...
		'\\addlegendentry{' out{j} '/' in{i} '}\n'];
	end
	s=[s '\\end{semilogxaxis}\n' ...
	'\\end{tikzpicture}\n' ...
	'\\begin{tikzpicture}\n' ...
	'\\begin{semilogxaxis}[height=2in,width=5in,ymin=-180,ymax=180,ytick={-180,-90,0,90,180},tick style={thin,black},extra y ticks={0},extra y tick style={grid=major},major y grid style={dotted,black},xlabel={Frequency [Hz]},ylabel={Phase Angle [$^\\circ$]},enlargelimits=false,cycle list name=linestyles*,restrict y to domain= -180:180,unbounded coords=jump]\n'];
	for j=1:nout
		s=[s '\\addplot+[black,line width=1pt,mark=none] table[x=frequency,y=p' num2str((i-1)*nout+j) ']{' filename '};\n'];
	end
	s=[s '\\end{semilogxaxis}\n' ...
	'\\end{tikzpicture}\n' ...
	'\\end{footnotesize}\n' ...
	'\\caption{Frequency response: ' in{i} '}\n' ...
	'\\label{bode_plot_' num2str(i) '}\n' ...
	'\\end{center}\n' ...
	'\\end{figure}\n\n'];

end
s=[s '\\clearpage\n\n'];

end %% Leave

