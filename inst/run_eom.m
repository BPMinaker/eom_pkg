function varargout=run_eom(varargin)
%% Copyright (C) 2011, Bruce Minaker
%% This file is intended for use with Octave.
%% run_eom.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% run_eom.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

[config,option]=setup(varargin{:});  %% Clear screen, set pager, etc.

system=cell(1,option.vpts);  %% Preallocate
result=cell(option.vpts,1);  %% Preallocate

if(option.analyze)
	disp(['Calling ' func2str(config.infile) '...']);
end

for vpt=1:option.vpts
	system{vpt}=config.infile(option.vector(vpt),option.params);  %% Build all the input structs
	if(~isfield(system{vpt},'name'))
		system{vpt}.name='Unnamed System';
	end
end

if(option.analyze)
	disp(['Running analysis of ' system{1}.name '...']);
	disp(['Found ' num2str(length(system{1}.item)) ' items...']);
end

for vpt=1:option.vpts
	result{vpt}.data=sort_system(system{vpt});  %% Sort all the input structs
end

tic
for vpt=1:option.vpts
	result{vpt}=eom(result{vpt},(vpt<2)*option.analyze);  %% Build eom
end
toc

if(option.analyze)
	vrml_save([config.dir.output filesep() 'vrml' filesep() 'system.wrl'],eom_draw(result,'verbose'),'');  %% Draw x3d of static system
	disp('Drawing vrml done.');
	
	result=linear_analysis(result);  %% Do all the eigen, freqresp, etc.
	
	if(option.report);
		write_output(config,result,option,system{1}.name);  %% Write report
		disp('Writing report done.');
	end

	if(option.animate)
		disp('Animating mode shapes.  This may take some time...');
		animate_modes(config,result);  %% Draw animations
		disp('Animating done.');
	end
end

temp={result{1}.eom.state_space,result};  %% Build comma separated list
[varargout{1:nargout()}]=temp{:};  %% One argument, send state-space only, two args, send whole system 

if(option.analyze)
	result{1}.kde=kde_solve(result{1},config.dir.output);  %% Solve the kinematics
	disp('Done.');
end

end %% Leave




