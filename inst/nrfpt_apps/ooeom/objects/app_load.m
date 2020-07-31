classdef app_load < connect
	properties
		frame='ground';
		frame_number=0;
		force=[0;0;0];
		moment=[0;0;0];
	end
	methods  %% Constructor using structure input
		function obj=app_load(varargin)
%		disp('app_load constructor');
%		varargin
			obj@connect(varargin{:});
		end
	end
end
