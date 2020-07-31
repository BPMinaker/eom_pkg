function write_raw(dest,result)
%% Copyright (C) 2015, Bruce Minaker
%% This file is intended for use with Octave.
%% write_raw.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% write_raw.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

out_data_path={'mass','elastic','rigid','eqn_of_mtn','forced','forced','rigid','rigid'};
out_data={'mtx','dmpng_mtx','mv_mtx','stiff_mtx','f_mtx','g_mtx','v_mtx','J_r'};
file_name={'mass_matrix','damping_matrix','cent_gyro_matrix','stiffness_matrix','forcing_matrix','forcing_rate_matrix','velocity_matrix','jacobian_matrix'};

for k=1:length(out_data)
	tmp=result{1}.eom.(out_data_path{k}).(out_data{k});
	[m,n]=size(tmp);  %% Get size of matrix
	if(m>6||n>6)  %% If it's too big
%		mm=max(max(abs(tmp)));
%		val=tmp(abs(tmp)>1e-6*mm);
%		[i,j]=find(abs(tmp)>1e-6*mm);
		val=tmp(abs(tmp)>0);
		[i,j]=find(abs(tmp)>0);
		if(isempty(val))
			i=1;
			j=1;
			val=0;
		end
		file=fopen([dest filesep() file_name{k} '.out'], 'w');  %% Write them
		fprintf(file,'%i %i %4.12e\n',[i,j,val]');
		fclose(file);
	else  
		str='';  %% Otherwise, build string with each entry
		for i=1:m
			for j=1:n
				str=[str sprintf('%4.12e ',tmp(i,j))];
			end
			str=[str '\n'];
		end
		file=fopen([dest filesep() file_name{k} '.out'], 'w');  %% Write
		fprintf(file,str);
		fclose(file);
	end
end

str='';
temp=[result{1}.eom.state_space.a result{1}.eom.state_space.b; result{1}.eom.state_space.c result{1}.eom.state_space.d];
[m,n]=size(temp);  %% Get size of matrix

for i=1:m
	for j=1:n
		str=[str sprintf('%4.12e ',temp(i,j))];
	end
str=[str '\n'];
end
file=fopen([dest filesep() 'ABCD.out'], 'w');  %% Write
fprintf(file,str);
fclose(file);


str='';
temp=result{1}.eom.state_space.e;
[m,n]=size(temp);  %% Get size of matrix

for i=1:m
	for j=1:n
		str=[str sprintf('%4.12e ',temp(i,j))];
	end
str=[str '\n'];
end
file=fopen([dest filesep() 'E.out'], 'w');  %% Write
fprintf(file,str);
fclose(file);

str='';
temp=[round(1e12*result{1}.math.ss_min.a)*1e-12 round(1e12*result{1}.math.ss_min.b)*1e-12; round(1e12*result{1}.math.ss_min.c)*1e-12 round(1e12*result{1}.math.ss_min.d)*1e-12];
[m,n]=size(temp);  %% Get size of matrix

for i=1:m
	for j=1:n
		str=[str sprintf('%4.12e ',temp(i,j))];
	end
str=[str '\n'];
end
file=fopen([dest filesep() 'ABCDmin.out'], 'w');  %% Write
fprintf(file,str);
fclose(file);


%  str='';
%  temp=result{1}.math.ss_min.e;
%  [m,n]=size(temp);  %% Get size of matrix
%  
%  for i=1:m
%  	for j=1:n
%  		str=[str sprintf('%4.8e ',temp(i,j))];
%  	end
%  str=[str '\n'];
%  end
%  file=fopen([dest filesep() 'Emin.out'], 'w');  %% Write
%  fprintf(file,str);
%  fclose(file);

end  %% Leave
