function s=tex_locus_pgfplot(name,n,v)
%% Copyright (C) 2009, Bruce Minaker
%% This file is intended for use with Octave.
%% tex_locus_pgfplot.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% tex_locus_pgfplot.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------


s=['\\section*{Root Locus Plot}\n'];  %% Write the tex necessary to include the plots
s=[s '\\begin{figure}[htbp]\n'];
s=[s '\\begin{center}\n'];
s=[s '\\begin{tikzpicture}\n'];
s=[s '\\begin{axis}[height=2.5in,width=4in,xlabel=Real,ylabel=Imaginary,tick style={thin,black},enlargelimits=false]\n'];
for i=1:n
	s=[s '\\addplot+[black,only marks,mark=*,mark options={scale=0.75}] table[x index=' num2str(2*i-1) ',y index=' num2str(2*i) ']{' name '};\n'];
end
%s=[s '\\pgfplotsextra{\\pgfpathmoveto{\\pgfplotspointaxisxy{0}{0}}\\pgfpathlineto{\\pgfplotspointaxisxy{' num2str(v) '}{0}}\\pgfusepath{stroke}};\n'];
s=[s '\\end{axis}\n'];
s=[s '\\end{tikzpicture}\n'];
s=[s '\\caption{Root Locus plot}\n'];
s=[s '\\label{root_locus_plot}\n'];
s=[s '\\end{center}\n'];
s=[s '\\end{figure}\n'];

s=[s '\n\\pagebreak\n'];

end

