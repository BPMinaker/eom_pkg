function s=tex_kinematics_pgfplot(syst,result,path,verb)
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

if(verb) disp('Preparing plots...'); end

nsolid=syst.data.nbodys-1;
npoint=syst.data.nrigid_points+syst.data.nflex_points+syst.data.nloads+syst.data.nmarkers;
nline=syst.data.nlinks+syst.data.nsprings+syst.data.nbeams+syst.data.nsensors+syst.data.nactuators;

npoint2=syst.data.nrigid_points+syst.data.nflex_points+syst.data.nloads;
nline2=syst.data.nlinks+syst.data.nsprings+syst.data.nbeams;
nline3=syst.data.nlinks+syst.data.nsprings+syst.data.nbeams+syst.data.nsensors;

s=['\\section*{Kinematics Results Plots}\n'];
ii=0;
for i=1:syst.data.nactuators  %% For each actuator we get some results

	if(syst.data.actuators(i).travel>0)
		t=['%%%%%% Actuator ' num2str(i) ', ' num2str(syst.data.nsensors) ' sensors (1 column each), ' num2str(syst.data.nmarkers) ' markers (6 columns each)\n'];
		ii=ii+1;

		result{ii}.pout=result{ii}.pout*1e6;
		result{ii}.pout=round(result{ii}.pout);
		result{ii}.pout=result{ii}.pout*1e-6;

		for j=1:size(result{ii}.pout,1)  %% For each row of the data
			loc1=result{ii}.pout(j,6*i+[-5:-3]+6*nsolid+3*npoint+6*nline3);
			loc2=result{ii}.pout(j,6*i+[-2:0]+6*nsolid+3*npoint+6*nline3);
			if(syst.data.actuators(i).twist==0)
				len1(j)=norm(loc2-loc1);
			else
				bnum1=syst.data.actuators(i).body_number(1);
				if(bnum1<syst.data.nbodys)
					ort1=result{ii}.pout(j,6*bnum1+[-2:0]);
				else
					ort1=[0 0 0];
				end
				bnum2=syst.data.actuators(i).body_number(2);
				if(bnum2<syst.data.nbodys)
					ort2=result{ii}.pout(j,6*bnum2+[-2:0]);
				else
					ort2=[0 0 0];
				end
				len1(j)=180/pi*(ort2-ort1)*((loc2-loc1)/norm(loc2-loc1))';
			end
			t=[t sprintf('%4.8e  ',len1(j))];  %% Start with the current length of the actuator

			for k=1:syst.data.nsensors  %% Then add the current length of each sensor
				loc1=result{ii}.pout(j,6*k+[-5:-3]+6*nsolid+3*npoint+6*nline2);
				loc2=result{ii}.pout(j,6*k+[-2:0]+6*nsolid+3*npoint+6*nline2);
				len2=norm(loc2-loc1);
				t=[t sprintf('%4.8e  ',len2)];
			end

			for k=1:syst.data.nmarkers  %% Then add the location and orientation of each marker
				loc=result{ii}.pout(j,3*k+[-2:0]+6*nsolid+3*npoint2);
				bnum=syst.data.markers(k).body_number;
				ort=180/pi*result{ii}.pout(j,6*bnum+[-2:0]);
				t=[t sprintf('%4.8e  ',[loc ort])];
			end
			t=[t '\n'];
		end

		name=strrep(['kins_' num2str(i) '_' datestr(clock()) '.out'],' ','-');
		name=strrep(name,':','-');

		file=fopen([path filesep() name], 'w');
		fprintf(file,t);
		fclose(file);


		inname=syst.data.actuators(i).name;
		maxx=max(len1);
		minx=min(len1);

		for j=1:syst.data.nsensors%% For each output
			outname=syst.data.sensors(j).name;
			s=[s '\\begin{figure}[hbtp]\n'];  %% Insert the picture into a figure
			s=[s '\\begin{center}\n'];
			s=[s '\\begin{footnotesize}\n'];
			s=[s '\\begin{tikzpicture}\n'];
			s=[s '\\begin{axis}[height=2in,width=4in,tick style={thin,black},xlabel=' inname ',ylabel=' outname ',enlargelimits=false]\n'];
			s=[s '\\addplot+[black,only marks,mark options={scale=0.4},line width=0.5pt] table[x index=0,y index=' num2str(j) ']{' name '};\n'];
			s=[s '\\addplot [black,mark=none,line width=0.5pt,style={dotted}] coordinates {(' num2str(minx) ',0)(' num2str(maxx) ',0)};\n'];
			s=[s '\\end{axis}\n'];
			s=[s '\\end{tikzpicture}\n'];
			s=[s '\\end{footnotesize}\n'];
			s=[s '\\caption{ Kinematics: ' outname '/' inname '}\n'];
			s=[s '\\end{center}\n'];
			s=[s '\\end{figure}\n\\pagebreak\n'];
		end

		for j=1:syst.data.nmarkers%% For each output
			outname=syst.data.markers(j).name;

			for k=1:length(syst.data.markers(j).plot)
				s=[s '\\begin{figure}[hbtp]\n'];  %% Insert the picture into a figure
				s=[s '\\begin{center}\n'];
				s=[s '\\begin{footnotesize}\n'];
				s=[s '\\begin{tikzpicture}\n'];
				s=[s '\\begin{axis}[height=3in,width=5in,tick style={thin,black},xlabel=' inname ',ylabel=' outname ',enlargelimits=false]\n'];
				s=[s '\\addplot+[black,only marks,mark options={scale=0.4},line width=0.5pt] table[x index=0,y index=' num2str(syst.data.nsensors+6*(j-1)+syst.data.markers(j).plot(k)) ']{' name '};\n'];
			%	s=[s '\\addplot [black,mark=none,line width=0.5pt,style={dotted}] coordinates {(' num2str(minw/5) ',0)(' num2str(maxw*5) ',0)};\n'];
				s=[s '\\end{axis}\n'];
				s=[s '\\end{tikzpicture}\n'];
				s=[s '\\end{footnotesize}\n'];
				s=[s '\\caption{ Kinematics: ' outname '/' inname '}\n'];
				s=[s '\\end{center}\n'];
				s=[s '\\end{figure}\n\\pagebreak\n'];
			end
		end
	end
end

if(isfield(result{1},'rc'))

	t='%%%%%% Roll Centre Path\n';

	for i=1:size(result{1}.rc,1)  %% For each row of the data
		t=[t sprintf('%4.8e  %4.8e\n',result{1}.rc(i,2),result{1}.rc(i,3)) ];
	end

	name=strrep(['rc_' num2str(i) '_' datestr(clock()) '.out'],' ','-');
	name=strrep(name,':','-');

	file=fopen([path filesep() name], 'w');
	fprintf(file,t);
	fclose(file);

	s=[s '\\begin{figure}[hbtp]\n'];  %% Insert the picture into a figure
	s=[s '\\begin{center}\n'];
	s=[s '\\begin{footnotesize}\n'];
	s=[s '\\begin{tikzpicture}\n'];
	s=[s '\\begin{axis}[height=2.5in,width=4in,tick style={thin,black},xlabel={Lateral [m]},ylabel={Vertical [m]},enlargelimits=false]\n'];
	s=[s '\\addplot+[black,only marks,mark options={scale=0.4},line width=0.5pt] table[x index=0,y index=1 ]{' name '};\n'];
	s=[s '\\end{axis}\n'];
	s=[s '\\end{tikzpicture}\n'];
	s=[s '\\end{footnotesize}\n'];
	s=[s '\\caption{ Roll Centre Path }\n'];
	s=[s '\\end{center}\n'];
	s=[s '\\end{figure}\n\\pagebreak\n'];

end

end %% Leave
