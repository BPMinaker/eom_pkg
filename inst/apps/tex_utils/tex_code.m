function s=tex_code(infile)
%% Copyright (C) 2008, Bruce Minaker
%% This file is intended for use with Octave.
%% make_code.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% make_code.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------


s=['\\section*{System Definition File}\n'];
s=[s '\\lstset{basicstyle=\\small,tabsize=4,breaklines,morecomment=[l]\\%% }\n'];

if(ischar(infile))
	s=[s '\\lstinputlisting[firstline=15]{../input/' infile '.m}\n'];
elseif(iscell(infile))
	for i=1:length(infile)
		s=[s '\\lstinputlisting[firstline=15]{../input/' infile{i} '.m}\n'];
	end
end


