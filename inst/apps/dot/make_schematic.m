function s=make_schematic(syst,result,varargin)
%% Copyright (C) 2008 windsordynamics
%% This file is intended for use with Octave.
%% make_schematic.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% make_schematic.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% No boxes - remove the comments marked %box to get them back


verb=0;
if(nargin>1)
	if(strcmp(varargin(1),'verbose'))
		verb=1;
	end
end

if(verb) disp('Drawing model schematic...'); end


%%  Define the different item types and how they will look

params = {'bodys','\\\\begin{tabular}{ll} name: & %s \\\\\\\\ mass: & %g kg \\\\\\\\ Ixx: & %g kgm$^2$ \\\\\\\\ Iyy: & %g kgm$^2$ \\\\\\\\ Izz: & %g kgm$^2$ \\\\\\\\ Ixy: & %g kgm$^2$ \\\\\\\\ Iyz: & %g kgm$^2$ \\\\\\\\ Izx: & %g kgm$^2$  \\\\end{tabular}',{'name','mass','momentsofinertia','productsofinertia'};
'springs','\\\\begin{tabular}{ll} name: & %s \\\\\\\\ stiffness: & %g N/m \\\\\\\\ damping: & %g Ns/m \\\\end{tabular}',{'name','stiffness','damping'};
'links','\\\\begin{tabular}{ll} name: & %s \\\\end{tabular}',{'name'};
'rigid_points','\\\\begin{tabular}{ll} name: & %s \\\\end{tabular}',{'name'};
'flex_points','\\\\begin{tabular}{ll} name: & %s \\\\\\\\ stiffness: & %g N/m, %g Nm \\\\\\\\ damping: & %g Ns/m, %g Nms \\\\end{tabular}', {'name','stiffness','damping'};
'beams','\\\\begin{tabular}{ll} name: & %s \\\\\\\\ stiffness: & %g \\\\end{tabular}',{'name','stiffness'};
'loads','\\\\begin{tabular}{ll} name: & %s \\\\end{tabular}',{'name'};
'actuators','\\\\begin{tabular}{ll} name: & %s \\\\\\\\ gain: & %g \\\\end{tabular}',{'name','gain'};
'sensors','\\\\begin{tabular}{ll} name: & %s \\\\\\\\ gain: & %g \\\\end{tabular} ',{'name','gain'};
'nh_points','\\\\begin{tabular}{ll} name: & %s \\\\end{tabular}',{'name'};
'triangle_3s','%s',{'name'};
'triangle_5s','%s',{'name'}
};

%%  Setup the dot definitions
s=['digraph hierarchy{\nrankdir=LR;\n'];

s=[s '// Definitions\n'];
%s=[s 'subgraph cluster0{ \n'];
t='';

%%  If there is extra info in the system, include it in the schematic
%if(isfield(the_system,'meta')) 
%	s=[s 'label=" Model Name: ' the_system.meta.name '\\nDescription: ' the_system.meta.desc '\\nAuthor: ' the_system.meta.author '\\nDate: ' date '"'];
%end

for i=1:length(params)  %% Loop over over all the available types

	if(isfield(result.data.(params{i,1}),'name'))

		names{i}={result.data.(params{i,1}).name};  %% Get all the names of the type

		for j=1:length(result.data.(params{i,1}))  %% For each item of type
	
			tag_vars = '';
			for k=1:length(params{i,3})
				if(k==length(params{i,3}))
					add_end = '';
				else
					add_end = ',';
				end
				tag_vars=[tag_vars 'result.data.(params{i,1})(j).' params{i,3}{k} add_end];
			end
			str = ['''' params{i,2} ''',' tag_vars];
			item_tag = eval(['sprintf(' str ');']);
			s=[s '"' params{i,1} '_' num2str(j) '" [label="' result.data.(params{i,1})(j).name  '" texlbl="' item_tag '" shape=box]\n']; 

			%%  Sort out the connectivity info as well
			if(~strcmp(params{i,1},'bodys'))
				%if(isfield(result.data.(params{i,1}),'body'))  %% Find out if it is attached to a body
				for k=1:length(result.data.(params{i,1})(j).body)
					t=[t '"' params{i,1} '_' num2str(j)   '" -> "bodys_' num2str(result.data.(params{i,1})(j).body_number(k)) '" [arrowhead=none]\n'];
				end
				%end
% 				if(isfield(result.data.(params{i,1}),'body1')) %% Find if it is attached to a body1
% 					t=[t '"' params{i,1} '_' num2str(j) '" -> "bodys_' num2str(result.data.(params{i,1})(j).body_number(1,1)) '" [arrowhead=none]\n'];
% 				end
% 				if(isfield(result.data.(params{i,1}),'body2')) %% Find if it is attached to a body2
% 					t=[t '"' params{i,1} '_' num2str(j) '" -> "bodys_' num2str(result.data.(params{i,1})(j).body_number(2,1)) '" [arrowhead=none]\n'];
% 				end
% 				if(isfield(result.data.(params{i,1}),'body3')) %% Find if it is attached to a body3
% 					t=[t '"' params{i,1} '_' num2str(j) '" -> "bodys_' num2str(result.data.(params{i,1})(j).body_number(3,1)) '" [arrowhead=none]\n'];
% 				end
			end
		end
	end
end

u='';
%  for i=1:length(params)
%  	u=[u 'rank=same{'];
%  	for j=1:length(names{i})
%  		u=[u ' "' char(names{i}(j)) '"'];
%  	end
%  	u=[u '}\n'];
%  end

dotfile=[s '\n'];
dotfile=[dotfile t u 'overlap=false\n}\n'];

outfile=[syst.config.dir.output filesep() 'schematic.dot'];
fd=fopen(outfile,'w');
fprintf(fd,dotfile);
fclose(fd);

%% covert the dot output to tex
[status, output]=unix(['dot2tex -ftikz --preproc --usepdflatex ' outfile ' | dot2tex -ftikz --figonly >' syst.config.dir.output filesep() 'schematic.tex']);
%[status, output]=unix(['dot -Txdot ' outfile ' | dot2tex --preproc ' outfile ' | dot2tex --figonly >' filename filesep() 'schematic.tex']);

s=['\\section{Schematic Diagram}\n The system connections are shown in the following diagram.\n'];
s=[s '\\begin{figure}[hbtp]\n'];  %% Insert the picture into a figure
s=[s '\\begin{center}\n'];
s=[s '\\begin{footnotesize}\n'];
s=[s '\\input{schematic}\n'];
s=[s '\\end{footnotesize}\n'];
%s=[s '\\caption{' the_system.meta.name ': ' the_system.meta.desc '}\n'];
s=[s '\\label{schematic}\n'];
s=[s '\\end{center}\n'];
s=[s '\\end{figure}\n'];
s=[s '\n\n'];

if(verb) disp('Schematic drawn.'); end

end  %% Leave



%	s=[s '// New Group Definition \n'];
%	s=[s 'subgraph cluster' result.data.(params{i,1}(j){i}.group ' { label="' strrep(result.data.(params{i,1}(j){i}.group,'_',' ') '"\n'];
%	s=[s '}\n']; %%

