function s=vrml_cyl(x,varargin)
%%
%%
%% This program is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by the
%% Free Software Foundation; either version 2, or (at your option) any
%% later version.
%%
%% This is distributed in the hope that it will be useful, but WITHOUT
%% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
%% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
%% for more details.
%%

%%       s=x3d_cyl(x,...)
%%
%% Makes a cylinder that links x(:,1) to x(:,2) 
%% 
%% Options : 
%%
%% 'rad' , radius          : Radius of segments         default=0.05
%% 'cone'          : Make a cone rather than cyl
%% 'tran', transparency    : Transparency                  default=0
%% 'col' , col             : Color           default=[ 0.3 0.4 0.9 ]
%% 'emit'          : Use or not emissiveColor default=false

%% A version of E. Grossmann's vrml_cyl
%% Modification by Bruce Minaker, Jan. 2006, Aug. 2011
%% Original Author:        Etienne Grossmann <etienne@cs.uky.edu>

rad=0.005;
cone=0;
tran=0;
col=[0.3;0.4;0.9];

i = 1;
while(i <= nargin-1)
	tmp=varargin{i};
	i=i+1;
	if(strcmp(tmp,'cone'))
		cone=1;
	elseif(strcmp(tmp,'rad'))
		rad=varargin{i};
		i=i+1;
	elseif(strcmp(tmp,'col'))
		col=varargin{i};
		i=i+1;
	elseif(strcmp(tmp,'tran'))
		tran=varargin{i};
		i=i+1;
	end
end

s='';
n=size(x,2);

% Make col 3xn
if(numel(col)==3)
	col=col(:);
	col=col(:, ones(1,n));
end

col=col*0.5;

if(numel(tran)==1)
	tran=tran(ones(1,n));
end

if(cone)
	shptype='Cone ';
	radtype='bottomRadius ';
else
	shptype='Cylinder ';
	radtype='radius ';
end

for i=2:n

  	d=x(:,i)-x(:,i-1);
  	nd=norm(d);
	if(nd>0)

		t=mean(x(:,[i,i-1]),2);
		aa=axisang(x(:,i),x(:,i-1));

		pstn=sprintf('%f %f %f',t);
		rtn=sprintf('%f %f %f %f',aa);
		radius=sprintf('%f',rad);
		height=sprintf('%f',nd);
		color=sprintf('%f %f %f',col(:,i));
		if(tran(i))
			trans=sprintf('          transparency %f\n',tran(i)');
		else
			trans='';
		end

		s=[s 'Transform {\n' ...
			 '  translation ' pstn '\n' ...
			 '  rotation ' rtn '\n' ...
			 '  children [\n' ...
			 '    Shape {\n' ...
			 '      appearance Appearance {\n' ...
			 '        material Material {\n' ...
			 '          emissiveColor ' color '\n' ...
			 '          diffuseColor ' color '\n' ...
			 trans ...
			 '        }\n' ...
			 '      }\n' ...
			 '      geometry ' shptype '{\n' ...
			 '        height ' height '\n' ...
			 '        ' radtype radius '\n' ...
			 '      }\n' ...
			 '    }\n' ...
			 '  ]\n' ...
			 '}\n'];
	end
end

end %% Leave
