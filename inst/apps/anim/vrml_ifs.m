function s=vrml_ifs(varargin)
%% Copyright (C) 2013 Bruce Minaker
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

%%       s=x3d_ifs(x,y...)
%%
%% Makes an indexed face set that links \
%% 
%% Options : 
%%
%% 'tran', transparency    : Transparency                  default=0
%% 'col' , col             : Color           default=[ 0.3 0.4 0.9 ]

%% A version of E. Grossmann's vrml_faces modifies to for Matlab compatability
%% Modification by Bruce Minaker, Sept 2013
%% Original Author:        Etienne Grossmann <etienne@cs.uky.edu>

tran=0;
col=[0.3;0.4;0.9];
%emit=0;

if(nargin<4)
	vert=[[0;0;0],[1;0;0],[1;1;0],[0;1;0]];
	faces=[0;1;2;3;-1];
else
	vert=varargin{1};
	faces=varargin{2};
end

i=1;
while(i<=nargin)
    tmp=varargin{i};
    i=i+1;
    if(strcmp(tmp,'col'))
        col=varargin{i};
        i=i+1;
    elseif(strcmp(tmp,'tran'))
        tran=varargin{i};
        i=i+1;
    end
end

s='';

color=sprintf('%f %f %f',col);
if(tran)
	tran_s=sprintf('          transparency %f',tran);
else
	tran_s='';
end

s=[s '    Shape {\n'];
s=[s '      appearance Appearance {\n'];
s=[s '        material Material {\n'];
s=[s '          emissiveColor ' color '\n'];
s=[s '          diffuseColor ' color '\n'];
s=[s tran_s '\n'];
s=[s '       }\n'];
s=[s '      }\n'];
s=[s '      geometry IndexedFaceSet {\n'];
s=[s '       solid FALSE \n'];
s=[s '       convex FALSE \n'];
s=[s '       coordIndex ['];
for j=1:size(faces,2)
	s=[s sprintf('%i, ',faces(:,j)-1)];
end
s=[s ' -1 ]\n'];
s=[s '   coord Coordinate {\n'];
s=[s '   point [\n'];
for j=1:size(vert,2)
	s=[s sprintf('%f %f %f ,\n',vert(:,j))];
end
s=[s ']\n'];

s=[s '   }\n'];
s=[s '  }\n'];
s=[s ' }\n'];

end %% Leave
