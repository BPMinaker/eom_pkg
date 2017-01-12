function sketch_save(frag,path,varargin)
%% Copyright (C) 2009, Bruce Minaker
%% This file is intended for use with Octave.
%% This program is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% This program is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%viewpt=[1;0;0];
%lookat=[0;0;0];

%if(nargin>2)
%	viewpt=varargin{1};
%end
s='';
%s='def o (0,0,0) def i (1,0,0) def j (0,1,0) def k (0,0,1)\n';
%  s=[s 'def origin {\n'];
%  s=[s 'special | \\footnotesize \\draw[arrows=->] #1 -- #2 node[pos=1.2] {$x$}; | (o)(i) \n'];
%  s=[s 'special | \\footnotesize \\draw[arrows=->] #1 -- #2 node[pos=1.2] {$y$}; | (o)(j) \n'];
%  s=[s 'special | \\footnotesize \\draw[arrows=->] #1 -- #2 node[pos=1.2] {$z$}; | (o)(k) \n'];
%  s=[s '}\n'];
%s=[s 'def vwpt (' num2str(viewpt(1)) ',' num2str(viewpt(2)) ',' num2str(viewpt(3)) ')\n'];
%s=[s 'def lkat (' num2str(lookat(1)) ',' num2str(lookat(2)) ',' num2str(lookat(3)) ')\n'];
%s=[s 'put {view((vwpt),(lkat),[0,0,1])}{origin}\n'];

s=[s 'def n_sphere_segs 12\n'];
s=[s 'def n_cyl_segs 16\n'];
s=[s 'def n_whl_segs 24\n'];
s=[s 'def n_segs 4\n'];
%s=[s sketch_prim('origin_ball','sphere','loc',[0;0;0],'rad',0.15,'col','blue')];
s=[s frag];  %% Insert the incoming content

%s=[s 'special |\\tikzstyle{ann} = [fill=white,font=\\footnotesize,inner sep=1pt]|[lay=under]\n'];
%s=[s 'special |\\tikzstyle{ghost} = [draw=lightgray]|[lay=under]\n'];
%s=[s 'special |\\tikzstyle{transparent cone} = [fill=blue!20,fill opacity=0.8]|[lay=under]\n'];

%s=[s 'put {scale(0.75) then view((1,0,0),(0,0,0),[0,0,1])}{system}\n'];
%s=[s 'put {scale(0.75) then view((0,1,0),(0,0,0),[0,0,1])}{system}\n'];
s=[s 'put {scale(0.75) then view((1,1,0.5),(0,0,0),[0,0,1])}{system}\n'];

s=[s 'global {language tikz }\n'];


fd=fopen([path filesep() 'sketch.sk'],'w');  %% Open, write, and close the file
if(fd<=0)
	error('Error opening file "%s"\n', flnm);
end

fprintf(fd,s);
fclose(fd);

status=unix(['sketch ' path filesep() 'sketch.sk -o ' path filesep() 'sketch.tex']);
if(status~=0)
	error('Error running sketch!');
end

