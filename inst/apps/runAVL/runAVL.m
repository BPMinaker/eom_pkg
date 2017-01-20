function item=runAVL()

%% Joseph Moster DEC 2011
%% BP Minaker, 2016
%runAVL.m
%This script creates an avl batch script and then executes it.
%Requires the following files to be in the same directory:
%  ag35.dat
%  ag36.dat
%  ag37.dat
%  ag38.dat
%  allegro.avl
%  allegro.mass

%% INPUT variables
filename = 'allegro';
velocity = 10;%m/s
%Define a base file name to save 
basename = 'newData1';

%% Directory Preparation
%Purge Directory of interfering files
delete([basename '.st'],[basename '.sb'],[basename '.run'],[basename '.eig']);

%% Create run file
%Open the file with write permission
fid=fopen([basename '.run'],'w');

%Load the AVL definition of the aircraft
fprintf(fid, 'LOAD %s\n',[filename '.avl']);

%Load mass parameters
fprintf(fid, 'MASS %s\n',[filename,'.mass']);
fprintf(fid, 'MSET\n');
%Change this parameter to set which run cases to apply 
fprintf(fid, '%i\n',   0); 

%Disable Graphics
fprintf(fid, 'PLOP\ng\n\n'); 

%Open the OPER menu
fprintf(fid, '%s\n',   'OPER');   

%Define the run case
fprintf(fid, 'c1\n',   'c1');       
fprintf(fid, 'v %6.4f\n',velocity);
fprintf(fid, '\n');

%Options for trimming
%fprintf(fid, '%s\n',   'd1 rm 0'); %Set surface 1 so rolling moment is 0
%fprintf(fid, '%s\n',   'd2 pm 0'); %Set surface 2 so pitching moment is 0

%Run the Case
fprintf(fid, '%s\n',   'x'); 

%Save the st data
fprintf(fid, '%s\n',   'st'); 
fprintf(fid, '%s%s\n',basename,'.st');   
%Save the sb data
fprintf(fid, '%s\n',   'sb');
fprintf(fid, '%s%s\n',basename,'.sb');

%Drop out of OPER menu
fprintf(fid, '%s\n',   '');

%Switch to MODE menu
fprintf(fid, '%s\n',   'MODE');
fprintf(fid, '%s\n',   'n');
%Save the eigenvalue data
fprintf(fid, '%s\n',   'w');
fprintf(fid, '%s%s\n', basename,'.eig');   %File to save to

%Exit MODE Menu
fprintf(fid, '\n');     
%Quit Program
fprintf(fid, 'Quit\n'); 

%Close File
fclose(fid);

disp(['Wrote file' basename '.run']);

%% Execute Run
%Run AVL using 
[status,result] = system(['..' filesep() '..' filesep() 'avl' filesep() 'build' filesep() 'src' filesep() 'avl <' basename '.run']);

disp(['Ran file' basename '.run']);

strs=textread('newData1.sb', '%s');

props={'CXu' 'CXw' 'CXq' 'CYv' 'CYp' 'CYr' 'CZu' 'CZw' 'CZq' 'Clv' 'Clp' 'Clr' 'Cmu' 'Cmw' 'Cmq' 'Cnv' 'Cnp' 'Cnr'};

for i=1:length(props)

	ind=find(strcmp(strs,props{i}));
	item.(lower(props{i}))=str2num(strs{ind+2});

end

