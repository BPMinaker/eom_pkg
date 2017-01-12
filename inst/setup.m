function [config,option]=setup(varargin)
%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% setup.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% setup.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%disp('Configuring eom...')

format short; %% Sets the terminal output displayed to short format with scientific notation
more off; %% Turn off pager

[~,n]=fileparts(pwd);
if(~strcmp(n,'inst'))
	disp('Executing in wrong folder? Try changing working folder to ''inst''!');
end

if(exist('OCTAVE_VERSION','builtin'))
	config.lang='octave';
else
	config.lang='matlab';
end
%disp(['Running in ' config.lang '...']);

%% Record the date and time for the output filenames, ISO format
config.dtstr=datestr(clock(),'yyyy-mm-dd');
config.tmstr=datestr(clock(),'HH-MM-SS');

%% Define data directories
config.dir.data='data';
config.dir.input=[config.dir.data filesep() 'input'];
config.dir.output=[config.dir.data filesep() 'output'];

if(~isdir([pwd filesep() config.dir.data]))  %% If no data folder exists
	[status,msg]=mkdir([pwd filesep() config.dir.data]);  %% create new empty one
	if(~status)
		disp(msg);
	end  
end

if(~isdir([pwd filesep() config.dir.input]))  %% If no input folder exists
	[status,msg]=mkdir([pwd filesep() config.dir.input]);  %% create new empty one
	if(~status)
		disp(msg);
	end
end

%% Add the input folder and all subfolders to path
addpath(genpath([pwd filesep() config.dir.input]));
%% Define application directories, and add apps subfolder to search path
addpath(genpath([pwd filesep() 'apps']));

if(~isdir([pwd filesep() config.dir.output]))  %% If no output folder exists
	[status,msg]=mkdir([pwd filesep() config.dir.output]);  %% Create new empty output folder
	if(~status)
		disp(msg);
	end  
end

option.report=1;  %% Set defaults
option.animate=1;
option.sketch=0;
option.schematic=0;
option.analyze=1;
option.vector=0;
option.params=struct();

for i=1:nargin %% Loop over them
	switch class(varargin{i})

		case 'function_handle'  %% If we get a function, good, call that
			infile=varargin{i};

		case 'char'
			switch varargin{i}  %% Otherwise, look for output control strings
				case 'noreport'
					option.report=0;
				case 'noanimate'
					option.animate=0;
				case 'sketch'
					option.sketch=1;
				case 'schematic'
					option.schematic=1;
				case 'quiet'
					option.analyze=0;
				otherwise
					infile=str2func(varargin{i});  %% Maybe it's the function name, so convert
			end

		case 'struct' 
			option.params=varargin{i};  %% Assume it's a parameter struct

		case 'double'
			option.vector=varargin{i};  %% Assume it's vector of some config variable, like speed

		otherwise
			error('%s\n','Invalid argument type.');  %% Don't know what to do
	end
end

if(~exist('infile','var'))  %% If we didn't define an input file
	infile=uigetfile('*.m');  %% Call the GUI
	infile=str2func(strtok(infile,'.m'));  %% Get the result
end
config.infile=infile;  %% Store our infile name for later

option.vpts=length(option.vector);  %% How many runs are there?
if(option.vpts>1)
	option.animate=0;  %% Prevent too many animations
end

if(~isdir([pwd filesep() config.dir.output filesep() config.dtstr ]) && option.analyze==1)  %% If no dated output folder exists
	[status,msg]=mkdir([pwd filesep() config.dir.output filesep() config.dtstr]);  %% Create new empty dated output folder
	if(~status)
		disp(msg);
	end
end

if(option.analyze==1)
	config.dir.output=[config.dir.output filesep() config.dtstr filesep() config.tmstr];
	[status,msg]=mkdir([pwd filesep() config.dir.output]);  %% Create new empty output folder date/time
	if(~status)
		disp(msg);
	end

	config.dir.vrml=[config.dir.output filesep() 'vrml'];
	[status,msg]=mkdir([pwd filesep() config.dir.vrml]);  %% Create vrml folder	
	if(~status)
		disp(msg);
	end

	config.dir.raw=[config.dir.output filesep() 'unformatted'];
	[status,msg]=mkdir([pwd filesep() config.dir.raw]);  %% Create unformatted folder	
	if(~status)
		disp(msg);
	end

	file=[config.dir.data filesep() 'tables' filesep() 'table_def.tex'];  %% Make a copy of the table defn for tex
	fout=[config.dir.output filesep() 'table_def.tex'];
	[status,msg]=copyfile(file,fout);
	if(~status)
		disp(msg);
	end

	file=[config.dir.data filesep() 'images' filesep() 'uwlogo.pdf'];  %% Make a copy of the logo pdf for tex
	fout=[config.dir.output filesep() 'uwlogo.pdf'];
	[status,msg]=copyfile(file,fout);
	if(~status)
		disp(msg);
	end

end

%disp('Starting eom...');
end  %% Leave



%filename='uwlogo.tex';  %% Use tikz format logo rather than pdf
%tmpstr=fileread(filename);  %% No copyfile on android
%tmpstr=strrep(tmpstr,'\','\\');
%tmpstr=strrep(tmpstr,'%','%%');

%fout=[config.dir.output filesep() filename];
%file=fopen(fout,'w');
%fprintf(file,tmpstr);
%fclose(file);

