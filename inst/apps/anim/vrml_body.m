function result=vrml_body(result)

%% GPL here
% This function builds an vrml model

vrml_tags = {'ground','upright','strut','wheel','chassis','bell','rocker','rack','arm','rod','bar'};  %% Define significant body names

for i=1:result{1}.data.nbodys  %% Loop over each body
%	if(strfind(result{1}.data.bodys(i).vrml,'.wrl'))

%		disp('Inserting listed vrml file...');
%		vrml=[ 'Inline { url "' result{1}.data.bodys(i).vrml '" }\n'];

%		vrml_file=[fileparts(result{1}.config.infile) filesep() result{1}.data.bodys(i).vrml];

%		[status,msg]=copyfile(vrml_file,result{1}.config.dir.vrml);
%		if(~status)
%			disp(msg);
%		end  
%		result{1}.data.bodys(i).vrml='';

%	else
		vrml=vrml_points([0;0;0],'cubes','rad',[0.08;0.08;0.08],'col',[1 0 0],'tran',0.3,'emit',0);  %% Define default vrml string

		for j=1:length(vrml_tags)  %% Loop over each sig. name
			if(~isempty(strfind(lower(result{1}.data.bodys(i).name),vrml_tags{j})))  %% If the body name contains a sig. name, replace the default string

				lcn=result{1}.data.bodys(i).location;  %% Record that body's location

				switch (lower(vrml_tags{j}))  %% Which signame did we find?

					case 'ground'
						vrml=[vrml_cyl([[0;0;-0.02] [0;0;-0.01]],'rad',3,'col',[0 0.8 0],'tran',0.5) ...
						vrml_points([0;0;0],'cubes','rad',[3;1.5;0.01],'col',[0.5;0.5;0.5],'tran',0.5)];

					case 'upright'
						vrml=vrml_points([0;0;0],'balls','rad',0.03,'col',[1;0;0]);

					case 'strut'
						vrml=vrml_points([0;0;0],'balls','rad',0.03,'col',[1;0;0]);

					case 'arm'
						vrml=vrml_points([0;0;0],'balls','rad',0.03,'col',[1;0;0]);

					case 'wheel'
						%vrml=vrml_points([[0;0;0]],'cubes','rad',[2.2*lcn(3);0.001;2.2*lcn(3)],'tran',0.8,'col',[1;1;1]);
						vrml=[vrml_cyl([[0;abs(lcn(3))/4;0] [0;-abs(lcn(3))/4;0]],'rad',abs(lcn(3)),'col',0.1*[1;1;1],'tran',0.4) ...
						vrml_cyl([[0;abs(lcn(3))/3.9;0] [0;-abs(lcn(3))/3.9;0]],'rad',0.8*abs(lcn(3)),'col',[0.5;0.5;0.5],'tran',0.6)];
	%					vrml=[vrml vrml_points([[0;0.047;lcn(3)-0.05]],'rad',0.03,'col',[1;1;1],'tran',0.6)];
	%					vrml=[vrml vrml_points([[0;-0.047;lcn(3)-0.05]],'rad',0.03,'col',[1;1;1],'tran',0.6)];

					case 'chassis'
						%disp('Adding chassis...');
						vrml=vrml_points([0;0;0] ,'cubes','rad',[0.8;0.3;0.5],'tran',0.3,'col',[0;0;1]);

					case {'bell','rocker'}
						color=[0.3 0.3 0.6];
						vrml=vrml_points([0;0;0] ,'cubes','rad',[0.04;0.04;0.04],'col',color);

					case 'rack'
						color=rand(3,1);
						vrml=vrml_cyl([[0;-0.1;0] [0;0.1;0]],'rad',0.05,'col',color);

					case {'rod','bar'}
						vrml=vrml_points([0;0;0],'balls','rad',0.015,'col',[1;0;0]);
						
					end
			end
		end
	%end
	result{1}.data.bodys(i).vrml=[result{1}.data.bodys(i).vrml vrml];  %% Add the vrml to the body
end

end  %% Leave