function write_output(config,result,option,name)
%% Copyright (C) 2015, Bruce Minaker
%% This file is intended for use with Octave.
%% write_output.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% write_output.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

vpts=length(result);  %% Number of points to plot
wpts=length(result{1}.math.w);

cmplx=0; %% Creates variable for number of oscillatory modes
dmpd=0; %% Creates variable for number of non-oscillatory modes
nstbl=0; %% Creates variable for number of unstable modes
rgd=0;  %% Number of rigid body modes

n=size(result{1}.eom.state_space.a,1);
nin=result{1}.data.nin;
nout=result{1}.data.nout;

if(result{1}.data.nactuators>0)
	input_names={result{1}.data.actuators.name};
else
	input_names={};
end

if(result{1}.data.nsurfs>0)
	input_names=[input_names result{1}.data.surfs.name];
end

%% Initialize output strings
strs.eigen=['%%%%%% Eigenvalues\n' ...
	'num speed real imag realhz imaghz \n'];
strs.freq=['%%%%%% Natural Frequency\n' ...
	'num speed nfreq zeta tau lambda \n'];
strs.mode=['%%%%%% Modes '  num2str(1:n) '\n'];
strs.centre=['%%%%%% Speed, Mode, Body, Rotation centre, Axis of rotation\n' ...
	'speed num name rx rxi ry ryi rz rzi ux uxi uy uyi uz uzi\n'];

strs.bode=['%%%%%% Bode Mag Phase \n' ...
	'frequency speed '];
for i=1:nin*nout
	strs.bode=[strs.bode ' m' num2str(i)];
end
for i=1:nin*nout
	strs.bode=[strs.bode ' p' num2str(i)];
end
strs.bode=[strs.bode '\n'];

strs.zeros=['%%%%%% Zeros\n' ...
	'Speed \n'];

strs.sstf='%%%%%% Steady State Transfer Function\n';
if (vpts>1)
	strs.sstf=[strs.sstf 'speed ' num2str(1:nin*nout) '\n'];
end

strs.hsv=['%%%%%% Hankel SVD\n' ...
	'num speed hsv \n'];

for i=1:vpts

	for j=1:length(result{i}.math.val)
		realpt=real(result{i}.math.val(j));
		imagpt=imag(result{i}.math.val(j));

		if(exist('OCTAVE_VERSION','builtin'))
			warning('off','Octave:divide-by-zero');
		end
		
		tau=-1/realpt;
		lambda=2*pi/abs(imagpt);
	
		if(exist('OCTAVE_VERSION','builtin'))
			warning('on','Octave:divide-by-zero');
		end
	
		if(isreal(result{i}.math.val(j)))
			counter=1;		
			omegan=nan;
			zeta=nan;
			if (realpt==0)
				rgd=rgd+1;
			end
		else
			counter=1/2;
			cmplx=cmplx+1/2;
			omegan=abs(result{i}.math.val(j));
			zeta=-realpt/omegan;
		end

		if (realpt>0)
			nstbl=nstbl+counter;
		elseif (realpt<0)
			dmpd=dmpd+counter;
		end
			
		strs.eigen=[strs.eigen '{' num2str(j) '}'];  %% Write the number
		strs.eigen=[strs.eigen sprintf(' %4.12e',option.vector(i),realpt,imagpt,realpt/2/pi,imagpt/2/pi) '\n'];  %% Write the speed, then the eigenvalue
		strs.freq=[strs.freq '{' num2str(j) '}'];
		strs.freq=[strs.freq sprintf(' %4.12e',option.vector(i),omegan/2/pi,zeta,tau,lambda) '\n'];  %% Write nat freq, etc.
	end
	strs.eigen=[strs.eigen '\n'];
	strs.freq=[strs.freq  '\n'];
	for j=1:length(result{i}.math.val)
		for k=1:(result{1}.data.nbodys-1)
			strs.centre=[strs.centre sprintf('%4.12e ',option.vector(i))];
			strs.centre=[strs.centre num2str(j) ' '];
			strs.centre=[strs.centre result{i}.data.bodys(k).name];
			for m=1:3
				strs.centre=[strs.centre sprintf(' %4.12e', real(result{i}.centres(3*k+m-3,j)),imag(result{i}.centres(3*k+m-3,j)))];
			end
			for m=1:3
				strs.centre=[strs.centre sprintf(' %4.12e', real(result{i}.axis(3*k+m-3,j)),imag(result{i}.axis(3*k+m-3,j)))];
			end
			strs.centre=[strs.centre '\n'];
		end
		strs.centre=[strs.centre '\n'];
	end
	strs.centre=[strs.centre '\n'];

	for j=1:size(result{i}.eom.modes,1)
		for k=1:size(result{i}.eom.modes,2)
			strs.mode=[strs.mode sprintf('%4.12e ',real(result{i}.eom.modes(j,k)),imag(result{i}.eom.modes(j,k)))];
		end
		strs.mode=[strs.mode '\n'];
	end
	strs.mode=[strs.mode '\n'];
end

rnd=1e-8;
if(nin*nout>0  && nin*nout<16)

	for i=1:vpts

		phs=angle(result{i}.math.freq_resp);  %% Search for where angle changes by almost 1 rotation
		phs(abs(diff(phs,1,3))>6)=Inf;  %% Replace with Inf to trigger plot skip

  		for j=1:length(result{i}.math.hankel_svd)
			strs.hsv=[strs.hsv '{' num2str(j) '}'];
			strs.hsv=[strs.hsv sprintf(' %4.12e',option.vector(i),result{i}.math.hankel_svd(j)) '\n'];  %% Write the vpoint (e.g. speed), then the hankel_sv
  		end
  		strs.hsv=[strs.hsv '\n'];

		if(vpts==1)
			strs.sstf=[strs.sstf 'num outputtoinput gain\n']; 
		
  			for j=1:nout
  				for k=1:nin
					strs.sstf=[strs.sstf '{' num2str((j-1)*nin+k) '}'];
					strs.sstf=[strs.sstf  sprintf(' {%s/%s}',result{1}.data.sensors(j).name,input_names{k})];
	  				strs.sstf=[strs.sstf  sprintf(' %4.12e',rnd*round(result{1}.math.ss_resp(j,k)/rnd)) '\n'];
  				end
  			end
		else
			strs.sstf=[strs.sstf sprintf('%4.12e ',option.vector(i))];  %% Each row starts with vpoint
			strs.sstf=[strs.sstf sprintf('%4.12e ',reshape(result{i}.math.ss_resp(:,:),1,nin*nout))];  %% Followed by first column, written as a row, then next column, as a row
			strs.sstf=[strs.sstf '\n'];
		end
		
		for j=1:wpts  %% Loop over frequency range
			strs.bode=[strs.bode sprintf('%4.12e ',result{i}.math.w(j)/2/pi,option.vector(i))];  %% Each row starts with freq in Hz, then speed
			strs.bode=[strs.bode sprintf('%4.12e ',reshape(20*log10(abs(result{i}.math.freq_resp(:,:,j))),1,nin*nout))];  %% Followed by first mag column, written as a row, then next column, as a row
			
			strs.bode=[strs.bode sprintf('%4.12e ',reshape(180/pi*phs(:,:,j),1,nin*nout))];  %% Followed by first phase column, written as a row, then next column, as a row

			strs.bode=[strs.bode '\n'];
		end
		strs.bode=[strs.bode '\n'];

		strs.zeros=[strs.zeros sprintf('%4.12e ',real(result{i}.math.zros),imag(result{i}.math.zros))];

	end
end


strs=syst_props(strs,result);
strs=load_defln(strs,result);

v_names={'e','f','m','c','bd','s','h','b','pt','ln','k','p','d','z'};
s_names={'eigen','freq','mode','centre','bode','sstf','hsv','bodydata','pointdata','linedata','stiffnessdata','preload','defln','zeros'};

%v_names={'e','f','m','c','bd','s','b','pt','ln','k','p','d','z'};
%s_names={'eigen','freq','mode','centre','bode','sstf','bodydata','pointdata','linedata','stiffnessdata','preload','defln','zeros'};


for i=1:length(v_names)
	config.(['name_' v_names{i}])=[s_names{i} '.out'];  %% Name and write output file
	file=fopen([config.dir.output filesep() config.(['name_' v_names{i}])], 'w');
	fprintf(file,strs.(s_names{i}));
	fclose(file);
end

if(n>0)
	nmin=size(result{1}.math.ss_min.a,1);  %% Size of minimal system
else
	nmin=0;
end

rprt_i=['\\chapter{Introduction}\n' ...
	'Replace this text with the introduction of your report.\n'];

if(result{1}.data.nitems<20 && isunix() && option.schematic==1)
	try
		rprt_i=[rprt_i make_schematic(config,result{1},'verbose')];  %% Draw the schematics using dot
	catch
		disp('Skipping schematic...');
	end
end

if(result{1}.data.nitems<100 && isunix() && option.sketch==1)
	try
		rprt_i=[rprt_i eom_sketch(config,result{1},'verbose')];
	catch
		disp('Skipping sketch...');
	end
end
rprt_i=[rprt_i tex_system_tables(config.name_b,config.name_pt,config.name_ln,config.name_k)];

rprt_b=['\\chapter{Analysis}\n' ...
	'Replace this text with the body of your report.  Add sections or subsections as appropriate.\n'];

rprt_c=['\\chapter{Conclusion}\n' ...
	'Replace this text with the conclusion to your report.\n'];

rprt_a='\\chapter{Equations of Motion}\n';

if(vpts>1)
	rprt_b=[rprt_b tex_eig_pgfplot(config.name_e)]; %% Plot the eigenvalues
	if(n*nin*nout>0 && nin*nout<16)
		rprt_b=[rprt_b tex_bode3_pgfplot(config.name_bd,input_names,{result{1}.data.sensors.name})];  %% Bode plots, but 3D
		rprt_b=[rprt_b tex_sstf_pgfplot(config.name_s,input_names,{result{1}.data.sensors.name})];  %% Plot the steady state results
	end
	rprt_b=[rprt_b tex_hsv_pgfplot(config.name_h)]; %% Plot the Hankel svd
else
	rprt_a=[rprt_a eom_2_latex(result{1},1)];  %% Add the system matrices to the report
	rprt_a=[rprt_a '\\noindent The full state space equations:\n' tex_partn_eqn(result{1}.eom.state_space,0)];
	if(nmin<n && nmin>0)
		rprt_a=[rprt_a '\\noindent The reduced state space equations:\n' tex_partn_eqn(result{1}.math.ss_min,1)];
	end

	rprt_b=[rprt_b tex_eig_pgftable(config.name_e,config.name_f)];

	rprt_b=[rprt_b 'There are ' num2str(result{1}.data.dimension-result{1}.eom.rigid.rkr) ' degrees of freedom.  '];
	rprt_b=[rprt_b 'There are ' num2str(cmplx) ' oscillatory modes, ' num2str(dmpd) ' damped modes, ' num2str(nstbl) ' unstable modes, and ' num2str(rgd) ' rigid body modes.\n\\pagebreak\n'];
	
	if(n*nin*nout>0 && nin*nout<16)
		rprt_b=[rprt_b tex_bode_pgfplot(config.name_bd,input_names,{result{1}.data.sensors.name})];  %% Bode plots
	end

	rprt_b=[rprt_b tex_sstf_pgftable(config.name_s,input_names,{result{1}.data.sensors.name})];  %% Print the steady state results
	rprt_b=[rprt_b tex_hsv_pgftable(config.name_h)];

end
rprt_b=[rprt_b tex_lambda_defln(result,config.name_d,config.name_p)];


tp=['\\begin{titlingpage}\n' ...
	'\\vspace*{-0.35in}\n' ...
	'\\hspace{-1.05in}\n' ...
	'\\includegraphics[height=1.1in]{uwlogo}\n' ...
	'\\begin{center}\n' ...
	'\\vspace{1.5in}\n' ...
	'\\LARGE\n' ...
	'\\thetitle\n' ...
	'\\vspace{2in}\n' ...
	'\\large\n' ...
	'\\theauthor\n' ...
	'\\vspace{1in}\n' ...
	'\\today\n' ...
	'\\vfill\n' ...
	'\\end{center}\n' ...
	'\\end{titlingpage}\n'];

file=fopen([config.dir.output filesep() 'titlingpage.tex'],'w');
fprintf(file,tp);
fclose(file);


tp=['\\title{\n' ...
	'EoM Analysis\n' ...
	'\\\\\n' ...
	' ' name ' '...
	'\n' ...
	'\\\\\n'...
	'}\n' ...
	'\\author{\n' ...
	'John Smith: ID 12345678\n' ...
	'\\\\\n' ...
	'Jane Smith: ID 87654321\n' ...
	'\\\\\n' ...
	'}\n'];
	
file=fopen([config.dir.output filesep() 'titlepage.tex'],'w');
fprintf(file,tp);
fclose(file);


%% Add report intro, body, appendix
file=fopen([config.dir.output filesep() 'introduction.tex'],'w');
fprintf(file,rprt_i);
fclose(file);
file=fopen([config.dir.output filesep() 'analysis.tex'],'w');
fprintf(file,rprt_b);
fclose(file);
file=fopen([config.dir.output filesep() 'conclusion.tex'],'w');
fprintf(file,rprt_c);
fclose(file);
file=fopen([config.dir.output filesep() 'appendix.tex'],'w');
fprintf(file,rprt_a);
fclose(file);

write_raw(config.dir.raw,result);

make_tex([config.dir.output filesep() 'report.tex']);

if(isunix() && option.report==1)
	disp('Running LaTeX...');
%	unix(['cd ' config.dir.output '; /usr/bin/xelatex -interaction batchmode report.tex']);
%	unix(['cd ' config.dir.output '; /usr/bin/xelatex -interaction batchmode report.tex']);
unix(['cd ' config.dir.output '; /usr/bin/pdflatex -interaction batchmode report.tex']);
unix(['cd ' config.dir.output '; /usr/bin/pdflatex -interaction batchmode report.tex']);
end


end %% Leave



%	if(isfield(result,'kins'))
%		if(~isempty(result.kins))
%			rprt=[rprt tex_kinematics_pgfplot(config,result.kins,config.dir.output,1)];  %% Add the kinematics results to the report
%		end
%	end


%  		for j=1:nout
%  			for k=1:nin
%  	  			strs.zeros=[strs.zeros sprintf('{%s/%s}',result{1}.data.sensors(j).name,input_names{k})];
%  				strs.zeros=[strs.zeros sprintf(' %4.8e %4.8e',real(result{i}.math.zros(j,k,:)),imag(result{i}.math.zros(j,k,:)))];
%  				strs.zeros=[strs.zeros '\n'];
%  			end
%    		end


