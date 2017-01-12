function s=sketch_prim(varargin)
%% Copyright (C) 2009 Bruce Minaker
%%
%% This program is free software; you can distribute it and/or modify it
%% under the terms of the GNU General Public License as published by the
%% Free Software Foundation; either version 2, or (at your option) any
%% later version.
%%
%% This is distributed in the hope that it will be useful, but WITHOUT
%% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
%% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
%% for more details.
%%

if(nargin<2)
	disp('Insufficient arguments');
	s='';
	return
else
	
	name=varargin{1};

	switch varargin{2}

	case {'sphere' 'ball'}
		rad=0.01;
		loc=[0;0;0];
		col='gray';
		i=3;
		opc=0.8;
		while(i<nargin)
			switch varargin{i}

			case {'rad' 'radius'}
				rad=varargin{i+1};
				i=i+2;
			case {'loc' 'location'}
				loc=varargin{i+1};
				i=i+2;
			case {'col' 'color' 'colour'}
				col=varargin{i+1};
				i=i+2;
			case {'opc' 'opacity'}
				opc=varargin{i+1};
				i=i+2;
			otherwise 
				disp('Incorrect arguments');
				s='';
			return
			end
		end

		bot=loc-[0;0;rad];
		s='';
		s=[s 'def ' name '_loc (' vec2str(loc) ')\n'];
		s=[s 'def ' name '_bot (' vec2str(bot) ')\n'];
		s=[s 'def ' name ' {sweep[cull=false,fill opacity=' num2str(opc) ',fill=' col '!20]{n_sphere_segs,rotate(360/n_sphere_segs,(' name '_loc))} sweep {n_sphere_segs,rotate(180/n_sphere_segs,(' name '_loc),[0,1,0])}(' name '_bot)}\n'];

%		s=[s 'put {view((vwpt),(lkat),[0,0,1])}{sweep[cull=false,fill opacity=' num2str(opc) ',fill=' col '!20]{n_sphere_segs,rotate(360/n_sphere_segs,(' name 'loc))} sweep {n_sphere_segs,rotate(180/n_sphere_segs,(' name 'loc),[0,1,0])}(' name 'bot)}\n'];


	case {'cyl' 'cylinder'}
		r=0.01;
		top=[0;0;0.1];
		bot=[0;0;0];
		col='gray';
		i=3;
		opc=0.8;
		while(i<nargin)
			switch varargin{i}

			case {'rad' 'radius'}
				r=varargin{i+1};
				i=i+2;
			case {'top'}
				top=varargin{i+1};
				i=i+2;
			case {'bottom' 'bot'}
				bot=varargin{i+1};
				i=i+2;
			case {'col' 'color' 'colour'}
				col=varargin{i+1};
				i=i+2;
			case {'opc' 'opacity'}
				opc=varargin{i+1};
				i=i+2;
			otherwise 
				disp('Incorrect arguments');
				s='';
			return
			end
		end

		axis=top-bot;
		temp=null(axis');
		rad=r*temp(:,1);
		p2=top+rad;
		p1=bot+rad;

		s='';
		s=[s 'def ' name '_top (' vec2str(top) ')\n'];
		s=[s 'def ' name '_axis [' vec2str(axis) ']\n'];
		s=[s 'def ' name '_p1 (' vec2str(p1) ')\n'];
		s=[s 'def ' name '_p2 (' vec2str(p2) ')\n'];
		s=[s 'def ' name '_l1 line(' name '_p1)(' name '_p2)\n'];
		s=[s 'def ' name ' {sweep[cull=false,fill opacity=' num2str(opc) ',fill=' col '!20]{n_cyl_segs<>,rotate(360/n_cyl_segs,(' name '_top),[' name '_axis]) }{' name '_l1}}\n'];

%		s=[s 'put {view((vwpt),(lkat),[0,0,1])}{sweep[cull=false,fill opacity=' num2str(opc) ',fill=' col '!20]{n_cyl_segs<>,rotate(360/n_cyl_segs,(' name 'top),[' name 'axis]) }{' name 'l1}}\n'];


	case {'box' 'cube'}
		l=0.016;
		loc=[0;0;0];
		col='gray';
		i=3;
		opc=0.8;
		while(i<nargin)
			switch varargin{i}

			case {'len' 'length'}
				l=varargin{i+1};
				i=i+2;
			case {'loc' 'location'}
				loc=varargin{i+1};
				i=i+2;
			case {'col' 'color' 'colour'}
				col=varargin{i+1};
				i=i+2;
			case {'opc' 'opacity'}
				opc=varargin{i+1};
				i=i+2;
			otherwise 
				disp('Incorrect arguments');
				s='';
			return
			end
		end

		p2=loc+l/2*[1;1;1];
		p1=loc+l/2*[1;1;-1];

		s='';
		s=[s 'def ' name '_loc (' vec2str(loc) ')\n'];
		s=[s 'def ' name '_p1 (' vec2str(p1) ')\n'];
		s=[s 'def ' name '_p2 (' vec2str(p2) ')\n'];
		s=[s 'def ' name '_l1 line(' name '_p1)(' name '_p2)\n'];
		s=[s 'def ' name ' {sweep[cull=false,fill opacity=' num2str(opc) ',fill=' col '!20]{n_segs<>,rotate(360/n_segs,(' name '_loc))}{' name '_l1}}\n'];

%		s=[s 'put {view((vwpt),(lkat),[0,0,1])}{sweep[cull=false,fill opacity=' num2str(opc) ',fill=' col '!20]{n_segs<>,rotate(360/n_segs,(' name 'loc))}{' name 'l1}}\n'];

	case {'wheel'}
		loc=[0;0;3];
		axis=[0;1;0];
		col='gray';
		i=3;
		opc=0.8;
		while(i<nargin)
			switch varargin{i}

			case {'loc'}
				loc=varargin{i+1};
				i=i+2;
			case {'axis'}
				axis=varargin{i+1};
				i=i+2;
			case {'col' 'color' 'colour'}
				col=varargin{i+1};
				i=i+2;
			case {'opc' 'opacity'}
				opc=varargin{i+1};
				i=i+2;
			otherwise 
				disp('Incorrect arguments');
				s='';
			return
			end
		end

		temp=null(axis');
		r=loc(3);
		rad=r*temp(:,1);
		srt_rad=0.8*rad;
		
		p1=loc+rad+r/4*axis;
		p2=loc+rad-r/4*axis;
		p3=loc+srt_rad+r/4*axis;
		p4=loc+srt_rad-r/4*axis;
		p5=p3-3*r/16*axis;
		p6=p4+3*r/16*axis;

		s='';
		s=[s 'def ' name '_loc (' vec2str(loc) ')\n'];
		s=[s 'def ' name '_axis [' vec2str(axis) ']\n'];
		s=[s 'def ' name '_p1 (' vec2str(p1) ')\n'];
		s=[s 'def ' name '_p2 (' vec2str(p2) ')\n'];
		s=[s 'def ' name '_p3 (' vec2str(p3) ')\n'];
		s=[s 'def ' name '_p4 (' vec2str(p4) ')\n'];
		s=[s 'def ' name '_p5 (' vec2str(p5) ')\n'];
		s=[s 'def ' name '_p6 (' vec2str(p6) ')\n'];

		s=[s 'def ' name '_l1 line(' name '_p6)(' name '_p4)(' name '_p2)(' name '_p1)(' name '_p3)(' name '_p5)\n'];
		s=[s 'def ' name ' sweep[cull=false,fill opacity=' num2str(opc) ',fill=' col '!20]{n_whl_segs<>,rotate(360/n_whl_segs,(' name '_loc),[' name '_axis]) }{' name '_l1}\n'];

%		s=[s 'put {view((vwpt),(lkat),[0,0,1])}{sweep[cull=false,fill opacity=' num2str(opc) ',fill=' col '!20]{n_whl_segs<>,rotate(360/n_whl_segs,(' name 'top),[' name 'axis]) }{' name 'l1}}\n'];

	case {'bwheel'}
		loc=[0;0;3];
		axis=[0;1;0];
		col='gray';
		i=3;
		opc=0.8;
		while(i<nargin)
			switch varargin{i}

			case {'loc'}
				loc=varargin{i+1};
				i=i+2;
			case {'axis'}
				axis=varargin{i+1};
				i=i+2;
			case {'col' 'color' 'colour'}
				col=varargin{i+1};
				i=i+2;
			case {'opc' 'opacity'}
				opc=varargin{i+1};
				i=i+2;
			otherwise 
				disp('Incorrect arguments');
				s='';
			return
			end
		end

		temp=null(axis');
		r=loc(3);
		rad=r*temp(:,1);
				
		p1=loc+0.8*rad+r/16*axis;
		p2=loc+0.8*rad-r/16*axis;
		p3=loc+0.8*rad+r/4*axis;
		p4=loc+0.8*rad-r/4*axis;
		p5=loc+0.9*rad+r/4*axis;
		p6=loc+0.9*rad-r/4*axis;
		p7=loc+0.6375*rad;
		tang=temp(:,2);
		
		s='';
		s=[s 'def ' name '_loc (' vec2str(loc) ')\n'];
		s=[s 'def ' name '_axis [' vec2str(axis) ']\n'];
		s=[s 'def ' name '_tang [' vec2str(tang) ']\n'];
		s=[s 'def ' name '_p1 (' vec2str(p1) ')\n'];
		s=[s 'def ' name '_p2 (' vec2str(p2) ')\n'];
		s=[s 'def ' name '_p3 (' vec2str(p3) ')\n'];
		s=[s 'def ' name '_p4 (' vec2str(p4) ')\n'];
		s=[s 'def ' name '_p5 (' vec2str(p5) ')\n'];
		s=[s 'def ' name '_p6 (' vec2str(p6) ')\n'];
		s=[s 'def ' name '_p7 (' vec2str(p7) ')\n'];

		s=[s 'def ' name '_l1 line (' name '_p1)(' name '_p3)(' name '_p5)(' name '_p6)(' name '_p4)(' name '_p2)\n'];
		s=[s 'def ' name '_l2 sweep{n_cyl_segs/2,rotate(2*87.2/n_cyl_segs,(' name '_p7),[' name '_tang])}(' name '_p5)\n'];
		s=[s 'def ' name '_s1 sweep[cull=false,fill opacity=' num2str(opc) ',fill=' col '!20]{n_whl_segs<>,rotate(360/n_whl_segs,(' name '_loc),[' name '_axis]) }{' name '_l1}\n'];
		s=[s 'def ' name '_s2 sweep[cull=false,fill opacity=' num2str(opc) ',fill=' col '!20]{n_whl_segs,rotate(360/n_whl_segs,(' name '_loc),[' name '_axis]) }{' name '_l2}\n'];
		s=[s 'def ' name ' {{'  name '_s1}{' name '_s2}}\n'];
			
%		s=[s 'put {view((vwpt),(lkat),[0,0,1])}{sweep[cull=false,fill opacity=' num2str(opc) ',fill=' col '!20]{n_whl_segs<>,rotate(360/n_whl_segs,(' name 'top),[' name 'axis]) }{' name 'l1}}\n'];

	otherwise 
		disp('Incorrect arguments');
		s='';
		return
	end
end


end  %% Leave

