 
clear variables;
close all;
clc;
format long;

global params;
more off;

addpath(genpath([pwd filesep() 'apps' filesep() 'F463']));
addpath(genpath([pwd filesep() 'sdnt']));

% If a plot is open when MATLAB tries to save a new copy, the code will
% stop with an error. Seek and destroy all open PDF viewers.
if(ispc()) % only kills these processes on Windows
  system('taskkill /f /im AcroRd32.exe');
  system('taskkill /f /im FoxitReader.exe');
end 

flist=dir('sdnt');  %% Get all files in the sdnt folder
result=cell(length(flist));  %% Preallocate for results

for i=3:length(flist)  %% Loop over them, skipping the first two, . and ..
	fname=flist(i).name;  %% Get only the names, ignoring dates, size, etc
	[pathstr,name,ext]=fileparts(fname);  %% break in to path, name and extention
	if(strcmp(ext,'.m'))  %% If the file is a script
		handle=str2func(name);
		handle();
	end

	vehicle_specs();  %% Load rest of specs
	track();  %% Load the track
	
	out=['data' filesep() 'output' filesep() 'results' filesep() params.std_id_number{1}];  %% Create name of output folder
	sts=mkdir(out);  %% Make output folder
	if(~sts)
		error('Can''t create output folder');
	end
	disp(['Running ' params.std_name]);
	disp(['EoM file ' params.eom_model]);

	[result{i}.data.tout,result{i}.data.xout,result{i}.data.yout]=solver(out);

	plot_results(result{i}.data.tout,result{i}.data.xout,result{i}.data.yout,out);

end

%save result.out result;


% 		sts=copyfile(q['sdnt' filesep() fname], 'my_specs.m');  %% Copy it as my_specs.m
% 		if(~sts)
% 			error('File copy error.');
% 		end

%  	% create vrml animation
%  	vrml_write(out);
%  	copyfile('83_camaro_V2.wrl',out);
%  
%  	result{i}.id=params.std_id_number;
%  	result{i}.name=params.std_name;
