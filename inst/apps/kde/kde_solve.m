function result=kde_solve(syst_nominal,output,varargin)

%% Copyright (C) 2017, Bruce Minaker, Rob Rieveley
%% This file is intended for use with Octave.
%% kde_solve.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% kde_solve.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

test=[syst_nominal.eom.rigid.cnsrt_mtx;point_line_jacobian(syst_nominal.data.actuators,syst_nominal.data.nbodys)];

result={};

if(size(null(test),2)==0 && size(test,1)==size(test,2))
	disp('Solving kinematics...')

	vopt=odeset('RelTol',1e-6,'AbsTol',1e-6,'InitialStep',0.04,'MaxStep',0.04);
	[p_o,str]=init_p(syst_nominal); % Build the initial position vector for bodies,links,constraints

	for i=1:syst_nominal.data.nactuators  %% For each actuator
		if(syst_nominal.data.actuators(i).travel>0)
			for j=1:2  %% For each direction
				tic;
				[temp_result{j}.tout,temp_result{j}.pout]=ode45(@w_solve,[0 1],p_o,vopt,syst_nominal,i,(-1)^j);  %% Run the solution
				toc
				temp_result{j}.pout=strip_axis(syst_nominal,temp_result{j}.pout);
%  				for k=1:size(temp_result{j}.pout,1)
%  					temp_result{j}.pdot(k,:)=dpkins(temp_result{j}.tout(k),(temp_result{j}.pout(k,:))',syst_nominal,i,(-1)^j);
%  				end
				disp('');
			end
			result{end+1}.tout=[-flipud(temp_result{1}.tout(2:end));temp_result{2}.tout]+1;  %% -1...0,0...1 -> 0...2
			result{end}.pout=[flipud(temp_result{1}.pout(2:end,:));temp_result{2}.pout];
%  			result{end}.pdot=[flipud(temp_result{1}.pdot(2:end,:));temp_result{2}.pdot];

			animate.tout=[result{end}.tout;-flipud(result{end}.tout(1:end-1))+4]./4;  %% 0...2,-2...0 -> 0...1
			animate.pout=[result{end}.pout;flipud(result{end}.pout(1:end-1,:))];

			temp{1}=syst_nominal;

			vrml_animate(temp,animate.tout',animate.pout,[output filesep() 'vrml' filesep() 'kinanim_' num2str(i)]);
			outdata=[animate.tout(1:(end+1)/2,1),animate.pout(1:(end+1)/2,:)];

			for j=1:size(outdata,1)
				for k=1:size(outdata,2)
					str=[str sprintf('%4.12e ',outdata(j,k))];
				end
				str=[str '\n'];
			end

			flnm=[output filesep() 'kinematics_' num2str(i) '.out'];

			fd=fopen(flnm,'w');
			if(fd<=0)
				error('Error opening file "%s"\n', flnm);
			end
			fprintf(fd,str);
			fclose(fd);
		end
	end
else
	disp('Actuators don''t properly control the kinematics.  Skipping...')
end

end  %% Leave





%  	ch_num=0;
%  	for i=1:syst_nominal.data.nbodys  %% Find which body is the chassis
%  		if(strfind(syst_nominal.data.bodys(i).name,'chassis'))
%  			ch_num=i;
%  		end
%  	end
%  
%  	if(ch_num>0)
%  		trans=result{1}.pdot(:,6*ch_num+[-5:-3]);  %% Find the linear and angular speed of the chassis
%  		rots=result{1}.pdot(:,6*ch_num+[-2:0]);
%  
%  		for i=1:size(trans,1)
%  			result{1}.rad(i,:)=(pinv(skew(rots(i,:)))*trans(i,:)')';  %% Find the instant center of the chassis
%  			result{1}.rc(i,:)=-result{1}.rad(i,:)+result{1}.pout(i,6*ch_num+[-5:-3]);
%  		end
%  	end

%%	plot(result{1}.rc(:,2),result{1}.rc(:,3));








